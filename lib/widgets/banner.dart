import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:banner_view/banner_view.dart';

///广告banner
///author: yinbiao
///time:2018-12-5
///

typedef BannerBuilder = Widget Function(BuildContext context, dynamic item);

class BannerListView<T> extends StatefulWidget {
  final int delayTime; //间隔时间秒
  final int scrollTime; //滑动耗时毫秒
  final double height; //banner高度
  final List<T> data; //banner内容
  final BannerBuilder builder;
  final Color backgroundColor;
  final double radius;
  final EdgeInsets margin;
  final Function(int) onPageChanged;
  BannerListView(
      {Key key,
      @required this.data,
      this.delayTime = 4,
      this.scrollTime = 400,
      this.height = 200.0,
      this.margin = const EdgeInsets.all(8),
      this.radius = 0,
      this.backgroundColor = Colors.transparent,
      this.onPageChanged,
      @required this.builder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new BannerListViewState<T>(builder);
  }
}

class BannerListViewState<T> extends State<BannerListView> {
  PageController _controller;
  Timer timer;

  final BannerBuilder builder;

  BannerListViewState(this.builder);

  @override
  void initState() {
    super.initState();
    _controller = new PageController(initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      height: widget.height,
      color: widget.backgroundColor,
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          child: widget.data == null || widget.data.length == 0
              ? Container()
              : BannerView(
                  _buildBanners(context),
                  onPageChanged: (index) {
                    print(index);
                    if (widget.onPageChanged != null) {
                      widget.onPageChanged(index);
                    }
                  },
                  initIndex: 1,
                  log: false,
                  controller: _controller,
                  intervalDuration: Duration(seconds: 2),
                  indicatorNormal: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(2))),
                    width: 4,
                    height: 4,
                  ),
                  indicatorSelected: Container(
                    decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(2))),
                    width: 4,
                    height: 4,
                  ),
                  indicatorBuilder: (context, widget) {
                    return new Align(
                      alignment: Alignment.bottomCenter,
                      child: new Opacity(
                        opacity: 0.3,
                        child: new Container(
                          height: rSize(30),
                          padding: new EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          child: widget,
                        ),
                      ),
                    );
                  },
                )),
    );
  }

  List<Widget> _buildBanners(BuildContext context) {
    List<Widget> banners = [];
    widget.data.forEach((data) {
      banners.add(widget.builder(context, data));
    });
    return banners;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
