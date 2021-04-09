/*
 * ====================================================
 * package   : widgets
 * author    : Created by nansi.
 * time      : 2019/5/27  4:45 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';

typedef GridItemBuilder = Widget Function(BuildContext context, int index);

enum GridType { normal, weChat }

class NineGridView extends StatefulWidget {
  final int crossAxisCount;
  final GridType type;
  final GridItemBuilder builder;
  final int itemCount;

  NineGridView(
      {@required this.builder,
      this.crossAxisCount = 3,
      this.type = GridType.normal,
      this.itemCount})
      : assert(builder != null, "builder 不能为空"),
        assert(itemCount != null && itemCount > 0, "itemCount 必填");

  @override
  State<StatefulWidget> createState() {
    return _NineGridViewState();
  }
}

class _NineGridViewState extends State<NineGridView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (widget.type == GridType.normal) {
      child = _buildNormalImages();
    } else {
      if (widget.itemCount == 1) {
        child = _buildOneImage(context);
      } else if (widget.itemCount == 4) {
        child = _buildFourImages();
      } else {
        child = _buildNormalImages();
      }
    }

    return Container(
      child: child,
    );
  }

  // 单张图片
  _buildOneImage(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: rSize(200),
          maxWidth: rSize(180),
          minHeight: rSize(100),
          minWidth: rSize(100)),
      child: widget.builder(context, 0),
    );
  }

  _buildFourImages() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: GridView.builder(
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.itemCount,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: rSize(5),
                  mainAxisSpacing: rSize(5),
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return widget.builder(context, index);
              }),
        ),
        Expanded(flex: 1, child: Container())
      ],
    );
  }

  // 多张
  _buildNormalImages() {
    return GridView.builder(
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.itemCount,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: rSize(5),
            mainAxisSpacing: rSize(5),
            crossAxisCount: widget.crossAxisCount),
        itemBuilder: (context, index) {
          return widget.builder(context, index);
        });
  }
}
