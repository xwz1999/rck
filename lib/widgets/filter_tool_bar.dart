/*
 * ====================================================
 * package   : widgets
 * author    : Created by nansi.
 * time      : 2019/5/13  1:44 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

/// 自筛选列表点击监听
typedef SelectedListener = Function(int? selectedIndex, FilterItemModel? item);

/// 下拉列表状态变更
typedef PopOptionHandle = Function(OptionListStatus status);

/// filterBar 标题点击、变更等监听
typedef FilterToolBarListener = Function(bool update);

class FilterToolBarController {
  FilterResultContainerHelper? helper;
  int? selectedIndex;
  FilterItemModel? item;
  GlobalKey? _containerKey;
  GlobalKey? _toolBarKey;

  /// [update] 是否需要通知外层  sublist 点击的index 和上次一致时，不通知外层
  FilterToolBarListener updateToolBarState = (bool update) {};

  close() {
    helper?.changeOptionListStatus(OptionListStatus.close);
  }

  get toolBarDx {
    RenderBox box = _toolBarKey!.currentContext!.findRenderObject() as RenderBox;
    Offset offset = box.localToGlobal(Offset.zero);
    return offset.dx;
  }

  double get toolBarDy {
    /// toolbar 距离top 的间距 - container外层距离top的间距
    RenderBox containerBox = _containerKey!.currentContext!.findRenderObject() as RenderBox;
    RenderBox box = _toolBarKey!.currentContext!.findRenderObject() as RenderBox;
    Offset containerTopOffset = containerBox.localToGlobal(Offset.zero);
    Offset toolBarTopOffset = box.localToGlobal(Offset.zero);
    return toolBarTopOffset.dy - containerTopOffset.dy;
  }

////获取position
//            RenderBox box = _key.currentContext.findRenderObject();
//            Offset offset = box.localToGlobal(Offset.zero);
//
////获取size
//            Size size = box.size;

//            print(" ---- $offset ------- $size");

}

enum OptionListStatus { open, close }

/// 筛选子列表操作
class FilterResultContainerHelper {
  final PopOptionHandle handle;

  /// 字筛选列表弹出状态
  OptionListStatus? status;

  FilterResultContainerHelper({required this.handle});

  changeOptionListStatus(OptionListStatus status) {
    this.status = status;
    this.handle(status);
  }
}

/// 筛选下拉列表容器  与 FilterToolBar 一起使用
class FilterToolBarResultContainer extends StatefulWidget {
  final FilterToolBarController controller;
  final Widget? body;

  const FilterToolBarResultContainer(
      {GlobalKey? key, required this.controller, this.body});

  @override
  State<StatefulWidget> createState() {
    return _FilterToolBarResultContainerState();
  }
}

class _FilterToolBarResultContainerState
    extends State<FilterToolBarResultContainer> with TickerProviderStateMixin {
  /// 子列表行数
  late int _lines;

  int maxLines = 3;

  /// 子列表单行高度
  double _lineHeight = 35.0;

  /// 底部内边距
  double _bottomSpacing = 8.0;

  /// 顶部边距
  double _topSpacing = 8.0;

  /// 未选中颜色
  Color? _unselectedColor = Colors.grey[700];

  /// toolbar 字体大小
  // double _toolBarTitleFont = 14.0;

  /// 子列表字体大小
  double _subTitleFont = 13.0;

  /// 子列表单行内边距  因为点击要整行选中，所以在row上设置左右边距
  EdgeInsetsGeometry _subtitleRowPadding = EdgeInsets.only(left: 15, right: 15);

  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    _lines = maxLines;

    widget.controller.helper = FilterResultContainerHelper(handle: (status) {
      if (status == OptionListStatus.open) {
        _buildAnimation(widget.controller.item!);
        _animationController!.forward();
      } else {
        _animationController!.reset();
      }
    });

    if (widget.key == null) {
      widget.controller._containerKey = GlobalKey();
    } else {
      widget.controller._containerKey = widget.key as GlobalKey<State<StatefulWidget>>?;
    }

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.controller._containerKey,
      child: _buildBody(context),
    );
  }

  Stack _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        /// body内容
        Container(
          height: double.infinity,
          child: widget.body,
        ),

        /// 蒙版
        _maskView(),

        widget.controller._toolBarKey == null
            ? Container()
            : Positioned(
                top: widget.controller.toolBarDy + 40,
                left: 0,
                right: 0,
                bottom: 0,
                child: Stack(children: [
                  widget.controller.item?.type == FilterItemType.list
                      ? _buildList(context)
                      : Container(),
                ]))
      ],
    );
  }

  Widget _maskView() {
    return widget.controller._toolBarKey == null
        ? Container()
        : Positioned(
            top: widget.controller.toolBarDy + 40,
            left: 0,
            right: 0,
            bottom: 0,
            child: Offstage(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  widget.controller.helper!.changeOptionListStatus(
                    OptionListStatus.close,
                  );
                  widget.controller.updateToolBarState(false);
                  _animationController!.reset();
                },
                child: Opacity(
                  opacity: 0.3,
                  child: Container(
                    color: Colors.black,
                  ),
                ),
              ),
              offstage: _animation == null ||
                  (_animation!.status == AnimationStatus.dismissed),
            ),
          );
  }

  /// 有多个子列表时 因为有设置最大行数，小于最大行数[widget.maxLines]时，以子列表个数为准，
  /// 否则以最大行数为准，选中时切换动画,
  _buildAnimation(FilterItemModel item) {
    _lines =
        item.subtitles!.length > maxLines ? maxLines : item.subtitles!.length;

    _animation = new Tween(
            begin: 0.0 - _lines * _lineHeight - _bottomSpacing - _topSpacing,
            end: 0.0)
        .animate(_animationController!)
          ..addListener(() {
            setState(() {
              // the state that has changed here is the animation object’s value
            });
          });
  }

  /// 筛选子列表
  Positioned _buildList(context) {
    FilterItemModel item = widget.controller.item!;
    return Positioned(
      top: _animation!.value,
      left: 0,
      right: 0,
      child: LimitedBox(
        maxHeight: _lineHeight * _lines + _topSpacing + _bottomSpacing,
        child: Container(
          padding: EdgeInsets.only(bottom: _bottomSpacing, top: 5),
          height: _lineHeight * item.subtitles!.length +
              _bottomSpacing +
              _topSpacing,
          decoration: BoxDecoration(
              color: Color.fromARGB(240, 255, 255, 255),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: PrimaryScrollController.of(context),
                itemCount: item.subtitles!.length,
                itemBuilder: (context, index) {
                  bool subTitleSelected = item.selectedSubIndex == index;
                  return Container(
                    height: _lineHeight,
                    child: RawMaterialButton(
                      onPressed: () {
                        widget.controller.helper!
                            .changeOptionListStatus(OptionListStatus.close);
                        widget.controller.updateToolBarState(false);
                        if (item.selectedSubIndex == index) return;

                        item.selectedSubIndex = index;
                        String title = item.subtitleShort == null ||
                                TextUtils.isEmpty(item.subtitleShort![index])
                            ? item.subtitles![index]
                            : item.subtitleShort![index];
                        item.title = title;

                        widget.controller.updateToolBarState(true);
                      },
                      child: _sublistItem(index, item, subTitleSelected),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  /// 子列表item
  Container _sublistItem(
      int index, FilterItemModel item, bool subTitleSelected) {
    return Container(
      padding: _subtitleRowPadding,
      child: Row(
        children: <Widget>[
          Offstage(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.check,
                size: 17,
                color: Colors.red,
              ),
            ),
            offstage: index != item.selectedSubIndex,
          ),
          Expanded(
              child: Text(
            item.subtitles![index],
            style: AppTextStyle.generate(_subTitleFont,
                color: _unselectedColor,
                fontWeight:
                    (subTitleSelected ? FontWeight.w600 : FontWeight.w400)),
          )),
        ],
      ),
    );
  }
}

class FilterToolBar extends StatefulWidget {

  FilterToolBar({
    required this.titles,
    required this.listener,
    required this.controller,
    this.selectedColor,
    this.maxLines = 4,
    this.trialing,
    this.startWidget,
    this.fontSize = 15.0,
    this.height = 40,
  });

  final List<FilterItemModel> titles;
  final Color? selectedColor;
  final int maxLines;
  final SelectedListener listener;
  final Widget? trialing;
  final Widget? startWidget;
  final FilterToolBarController controller;
  final double fontSize;
  final double height;

  @override
  State<StatefulWidget> createState() {
    return _FilterToolBarState();
  }
}

class _FilterToolBarState extends State<FilterToolBar>
    with TickerProviderStateMixin {
  Color? _unselectedColor = Colors.grey[700];

  GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    widget.controller.selectedIndex = widget.controller.selectedIndex != null
        ? widget.controller.selectedIndex
        : 0;

    widget.controller._toolBarKey = _key;

    widget.controller.updateToolBarState = (bool update) {
//      print("----- ${widget.controller.selectedIndex}");
      if (update) {
        widget.listener(
            widget.controller.selectedIndex, widget.controller.item);
      }
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      child: _buildToolBar(),
    );
  }

  Container _buildToolBar() {
    List<Widget> items = <Widget>[];
    if (widget.startWidget != null) {
      items.add(SizedBox(width: 30.rw,));
      items.add(widget.startWidget!);
      items.add(SizedBox(width: 10.rw,));
    }
    items.addAll(_buildToolBarItem());
    if (widget.trialing != null) {
      items.add(widget.trialing!);
    }

    return Container(
      key: _key,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: Colors.grey[200]!, width: 0.5),
              bottom: BorderSide(color: Colors.grey[200]!, width: 0.5))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items,
      ),
    );
  }

  List<Expanded> _buildToolBarItem() {
    return widget.titles.map((item) {
      int index = widget.titles.indexOf(item);
      bool selected = index == widget.controller.selectedIndex;
      Color? color = selected ? widget.selectedColor : _unselectedColor;
      return Expanded(
        child: GestureDetector(
          onTap: () {
            widget.controller.item = item;

            /// 列表弹出后直接点击toolbar上按钮  列表消失
            if (widget.controller.helper != null &&
                widget.controller.helper!.status == OptionListStatus.open) {
              widget.controller.helper!.changeOptionListStatus(
                OptionListStatus.close,
              );
            } else {
              if (item.type == FilterItemType.list) {
                /// 当前已选中，再次点击弹出列表
                if (widget.controller.selectedIndex == index) {
                  if (widget.controller.helper != null) {
                    widget.controller.helper!.changeOptionListStatus(
                      OptionListStatus.open,
                    );
                  } else {
                    FlutterError("列表类型需要与 FilterToolBarResultContainer 一起使用");
                  }
                } else {
                  /// 点击其他列表项时，把当前列表项之前选中的状态返回
                  widget.listener(index, item);
                }
              }
            }

            /// 上下箭头选项点击
            if (item.type == FilterItemType.double) {
              if (widget.controller.selectedIndex != index) {
               item.selectedList![index] = true;
                item.topSelected = item.selectedList![index];
              } else {
                 //print(item.topSelected);
                 //item.topSelected = !item.topSelected;
                // print(widget.titles[index].topSelected);
                 item.selectedList![index] = ! item.selectedList![index];
                 item.topSelected = item.selectedList![index];
              }
              widget.listener(index, item);
            }

            /// 普通
            else if (item.type == FilterItemType.normal) {
              if (widget.controller.selectedIndex == index) return;
              widget.listener(index, item);
            }

            widget.controller.selectedIndex = index;

            setState(() {});
          },
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  item.title,
                  style: AppTextStyle.generate(widget.fontSize,
                      color: color, fontWeight: FontWeight.w400),
                ),
                _buildArrow(item, color, selected,index)
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  _buildArrow(FilterItemModel item, color, bool selected,int index) {
    if (item.type == FilterItemType.list) {
      return Icon(
        selected
            ? (widget.controller.helper != null &&
                    widget.controller.helper!.status == OptionListStatus.open
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down)
            : Icons.arrow_drop_down,
        color: color,
        size: 19,
      );
    } else if (item.type == FilterItemType.double) {
      if (selected) {
        return Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Icon(
            item.selectedList![index] ? AppIcons.icon_top : AppIcons.icon_down,
            size: 7,
            color: color,
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                AppIcons.icon_top,
                size: 7,
                color: _unselectedColor,
              ),
              Icon(
                AppIcons.icon_down,
                size: 7,
                color: _unselectedColor,
              ),
            ],
          ),
        );
      }
    } else {
      return Container();
    }
  }
}

enum FilterItemType {
  /// 列表形式
  list,

  /// 价格等上下箭头
  double,

  /// 普通
  normal
}

class FilterItemModel {
  final FilterItemType type;
  String title;
  final List<String>? subtitles;

  /// 列表下拉时的子标题
  final List<String>? subtitleShort;
  List<bool>? selectedList;
  bool topSelected;
  int selectedSubIndex = 0;

  FilterItemModel({
    required this.type,
    required this.title,
    this.selectedList,
    this.subtitles,
    this.subtitleShort,
    this.topSelected  = true,
  }) : assert(
            type == FilterItemType.list
                ? (subtitles != null && subtitles.length > 0)
                : true,
            "type为list，列表项不能为空");
}
