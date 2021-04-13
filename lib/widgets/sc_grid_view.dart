/*
 * ====================================================
 * package   : widgets
 * author    : Created by nansi.
 * time      : 2019/5/10  2:18 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

typedef HeaderBuilder = Widget Function(BuildContext context, int index);
typedef ItemBuilder = Widget Function(BuildContext context, int index);
typedef ItemCountBuilder = int Function(int section);

class SCGridView<T> extends StatefulWidget {
  /// 区头创建
  final HeaderBuilder headerBuilder;

  /// item创建
  final ItemBuilder itemBuilder;

  /// 每一个区的item个数
  final ItemCountBuilder itemCount;

  /// 每行item 个数
  final int crossAxisCount;

  /// 区数
  final int sectionCount;

  /// 主轴间距
  final double mainAxisSpacing;

  /// 交叉轴间距
  final double crossAxisSpacing;

  /// 内间距
  final EdgeInsetsGeometry insetPadding;

  /// 外边距
  final EdgeInsetsGeometry margin;

  final double viewportHeight;

  final double childAspectRatio;

  final List<T> data;

  SCGridView(
      {@required this.itemCount,
      @required this.itemBuilder,
      this.data,
      this.crossAxisCount,
      this.headerBuilder,
      this.sectionCount = 1,
      this.mainAxisSpacing = 5,
      this.crossAxisSpacing = 5,
      this.insetPadding = const EdgeInsets.all(5),
      this.margin = const EdgeInsets.all(0),
      this.viewportHeight = 0,
      this.childAspectRatio = 1});

  @override
  State<StatefulWidget> createState() {
    return _SCGridViewState();
  }
}

class _SCGridViewState extends State<SCGridView>
    with AutomaticKeepAliveClientMixin {
  ScrollController _controller;

  @override
  void initState() {
//    print("创建了");
    super.initState();

    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> stackViews = [];
    List<Widget> gridViews = [];

    for (int i = 0; i < widget.sectionCount; i++) {
      Widget sectionView = _buildSection(context, i);
      gridViews.add(sectionView);
    }

    stackViews.add(ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: gridViews,
    ));

    if (widget.viewportHeight > 0) {
      stackViews.add(Container(
        height: widget.viewportHeight,
      ));
    }

    return Container(
      margin: widget.margin,
      child: ListView(
        controller: _controller,
        physics: BouncingScrollPhysics(),
        children: [Stack(children: stackViews)],
      ),
    );
  }

  Widget _buildSection(BuildContext context, int section) {
    Widget header = widget.headerBuilder != null
        ? widget.headerBuilder(context, section)
        : null;

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Offstage(
          offstage: header == null,
          child: header,
        ),
        GridView.builder(
            padding: widget.insetPadding,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.itemCount(section),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: widget.childAspectRatio,
                mainAxisSpacing: widget.mainAxisSpacing,
                crossAxisSpacing: widget.crossAxisSpacing,
                crossAxisCount: widget.crossAxisCount),
            itemBuilder: (context, index) {
              return widget.itemBuilder(context, index);
            })
      ],
    );
  }

  @override
  bool get wantKeepAlive => false;
}
