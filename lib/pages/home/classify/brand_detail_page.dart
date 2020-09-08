/*
 * ====================================================
 * package   : pages.home.classify
 * author    : Created by nansi.
 * time      : 2019/5/18  1:39 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/pages/home/items/item_brand_detail_grid.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/home/items/item_tag_widget.dart';
import 'package:recook/widgets/filter_tool_bar.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/pages/home/items/item_brand_detail_list.dart';

class BrandDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BrandDetailPageState();
  }
}

class _BrandDetailPageState extends BaseStoreState<BrandDetailPage>
    with TickerProviderStateMixin {
  GSRefreshController _controller = GSRefreshController(initialRefresh: false);
  FilterToolBarController filterController;

  /// 下拉放大效果
  double _topInset = 0;

  /// title 颜色
  Color _titleColor = Colors.white;

  /// Appbar背景透明度
  double _appBarBgOpacity = 0;

  /// 顶部总高度  出去底部filterBar
  double _topTotalHeight = 210;

  /// 切换展示形式  true 为 List， false 为grid
  bool _displayList = true;

  @override
  void initState() {
    filterController = FilterToolBarController();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
        backgroundColor: _displayList ? Colors.white : Color(0xFFF8F7F8),
        body: FilterToolBarResultContainer(
          controller: filterController,
          body: NotificationListener<ScrollUpdateNotification>(
            onNotification: (updateDetail) {
              double offset = updateDetail.metrics.pixels;
//            print("- --------- $offset --------- $_topInset");
              double opacityScale = offset / (_topTotalHeight - 80);

              setState(() {
                _appBarBgOpacity = opacityScale.clamp(0.0, 1.0);
                if (_appBarBgOpacity > 0.4) {
                  _titleColor =
                      Color.fromARGB((255 * _appBarBgOpacity).toInt(), 0, 0, 0);
                } else {
                  _titleColor = Colors.white;
                }
              });
            },
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    brightness: Brightness.light,
                    title: Offstage(
                      offstage: _appBarBgOpacity < 0.4,
                      child: Text(
                        "左家右厨",
                        style: TextStyle(color: _titleColor),
                      ),
                    ),
                    leading: _backButton(context),

                    /// 40 是底部filterBar高度
                    expandedHeight: _topTotalHeight + 40 + _topInset,
                    pinned: true,
                    floating: false,
                    flexibleSpace: _header(),
                    bottom: PreferredSize(
                        child: _filterToolBar(context),
                        preferredSize: Size.fromHeight(40)),
                  )
                ];
              },
              body: _notificationList(),
            ),
          ),
        ));
  }

  Stack _header() {
    return Stack(children: [
      /// 背景图
      Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Image.asset(
            'assets/meizi.JPG',
            fit: BoxFit.cover,
          )),

      /// 蒙版
      Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: 0.3,
            child: Container(
              color: Colors.black,
            ),
          )),

      /// 品牌信息
      Positioned(
        bottom: 40,
        left: 0,
        right: 0,
        child: Container(
          height: 85,
          padding: EdgeInsets.only(left: 110, bottom: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "左家右厨",
                style: AppTextStyle.generate(18, fontWeight: FontWeight.w500),
              ),
              Text(
                "全部商品： 12",
                style: AppTextStyle.generate(14, color: Colors.grey[700]),
              )
            ],
          ),
        ),
      ),

      /// 品牌icon
      Positioned(
          left: 15,
          bottom: 60,
          child: Image.asset(
            'assets/meizi.JPG',
            height: 80,
            width: 80,
            fit: BoxFit.cover,
          )),

      /// appBar 背景色
      Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: DeviceInfo.statusBarHeight + DeviceInfo.appBarHeight,
          child: Opacity(
            opacity: _appBarBgOpacity,
            child: Container(
              color: Colors.white,
            ),
          )),
    ]);
  }

  _backButton(context) {
    return Container(
      padding: EdgeInsets.all(13),
      child: GestureDetector(
        onTap: () {
          Navigator.maybePop(context);
        },
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(_appBarBgOpacity < 0.4 ? 100 : 0, 0, 0, 0),
              borderRadius: BorderRadius.all(Radius.circular(28))),
          child: Center(
              child: IconButton(
            iconSize: 17,
            padding: EdgeInsets.zero,
            icon: Icon(
              AppIcons.icon_back,
              color: _titleColor,
            ),
            onPressed: null,
          )),
        ),
      ),
    );
  }

  _filterToolBar(BuildContext context) {
    return FilterToolBar(
      controller: filterController,
      titles: [
        FilterItemModel(
            type: FilterItemType.list,
            subtitles: ["综合排序", "新品优先"],
            subtitleShort: ["综合", "新品"],
            title: "综合"),
        FilterItemModel(type: FilterItemType.double, title: "价格"),
        FilterItemModel(
          type: FilterItemType.normal,
          title: "销量",
        ),
        FilterItemModel(type: FilterItemType.normal, title: "特卖优先")
      ],
      trialing: _displayIcon(),
      selectedColor: Theme.of(context).primaryColor,
      listener: (index, item) {
        switch (index) {
          case 0:
            print("当前选了第 ${item.selectedSubIndex} 个");
            break;
          case 1:
            print("当前是按价格 ${!item.topSelected ? "降序" : "升序"} ");
            break;
          case 2:
            print("销量");
            break;
          case 3:
            print("特卖优先");
            break;
        }
      },
    );
  }

  /// 切换排列按钮
  Container _displayIcon() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _displayList = !_displayList;
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 1,
              height: 15,
              margin: EdgeInsets.only(right: 8),
              color: Colors.grey[700],
            ),
            Text(
              "排列",
              style: AppTextStyle.generate(14,
                  color: Colors.grey[700], fontWeight: FontWeight.w300),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Icon(
                _displayList
                    ? AppIcons.icon_list_collection
                    : AppIcons.icon_list_normal,
                color: Colors.grey[700],
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 监听滑动
  NotificationListener<ScrollEndNotification> _notificationList() {
    return NotificationListener<ScrollEndNotification>(
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (detail) {
          return true;
        },
        child: NotificationListener<OverscrollNotification>(
          onNotification: (OverscrollNotification notify) {
            double scale = 0.3;
            if (notify.dragDetails != null &&
                notify.dragDetails.delta != null) {
//              print("$_topInset ------- ${notify.metrics.pixels}");
              if (notify.dragDetails.delta.dy >= 0) {
                if (_topInset > 100) {
                  scale = 0.1;
                } else {
                  scale = 0.3;
                }
                setState(() {
                  _topInset += notify.dragDetails.delta.dy * scale;
                });
              }
            }
            return true;
          },
          child: _buildList(),
        ),
      ),
      onNotification: (endDetail) {
        AnimationController controller = AnimationController(
            vsync: this, duration: Duration(milliseconds: 150));
        Animation<double> animation =
            new Tween(begin: _topInset, end: 0.0).animate(controller);
        animation.addListener(() {
          setState(() {
            // the state that has changed here is the animation object’s value
            _topInset = animation.value;
          });
        });
        controller.forward();
        return true;
      },
    );
  }

  _buildList() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: RefreshWidget(
            isInNest: true,
            enableOverScroll: false,
            controller: _controller,
            onLoadMore: () {
              Future.delayed(Duration(seconds: 2), () {
                _controller.loadNoData();
              });
            },
            body: GridView.builder(
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.all(_displayList ? 0 : 8.0),
                itemCount: 20,
                gridDelegate: ItemTagWidget.getSliverGridDelegate(_displayList, context),
                itemBuilder: (context, index) {
                  return MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        AppRouter.push(context, RouteName.COMMODITY_PAGE);
                      },
                      child: _displayList
                          ? BrandDetailListItem()
                          : BrandDetailGridItem());
                })));
  }
}
