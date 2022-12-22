/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/4  2:19 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';

class TransparentAppBar extends StatelessWidget {
  final String? title;
  final PreferredSize? bottom;
  final double bottomHeight;
  final double topTotalHeight;
  final Widget? header;
  final Widget? body;
  final Color appBarBackgroundColor;
  final Color itemColor;
  final Color titleColor;
  final SliverAppBarController? controller;

  const TransparentAppBar({
    Key? key,
    this.title,
    this.bottom,
    this.bottomHeight = 0,
    this.header,
    this.body,
    this.controller,
    this.appBarBackgroundColor = Colors.white,
    this.itemColor = Colors.black,
    this.topTotalHeight = 210,
    this.titleColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (updateDetail) {
        double offset = updateDetail.metrics.pixels;
        controller!.offset.value = offset;
        return;
      } as bool Function(ScrollUpdateNotification)?,
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              _SliverAppBar(
                title: title,
                controller: controller,
                header: header,
                bottom: bottom,
                bottomHeight: bottomHeight,
                appBarBackgroundColor: appBarBackgroundColor,
                itemColor: itemColor,
                topTotalHeight: topTotalHeight,
                titleColor: titleColor,
              )
            ];
          },
          body: NotificationListener<ScrollEndNotification>(
            child: NotificationListener<ScrollUpdateNotification>(
              onNotification: (detail) {
                return true;
              },
              child: NotificationListener<OverscrollNotification>(
                onNotification: (OverscrollNotification notify) {
                  if (notify.dragDetails != null) {
                    if (notify.dragDetails!.delta.dy >= 0) {
                      controller!.overScrollOffset.value =
                          notify.dragDetails!.delta.dy;
                    }
                  }
                  return true;
                },
                child: body!,
              ),
            ),
            onNotification: (endDetail) {
              controller!.dragEnd.value = true;
              return true;
            },
          )),
    );
  }
}

class _SliverAppBar extends StatefulWidget {
  final String? title;
  final PreferredSize? bottom;
  final double bottomHeight;
  final double? topTotalHeight;
  final Widget? header;
  final Color? appBarBackgroundColor;
  final Color? itemColor;
  final Color titleColor;
  final SliverAppBarController? controller;

  const _SliverAppBar(
      {Key? key,
      this.bottom,
      this.bottomHeight = 0,
      this.header,
      this.controller,
      this.appBarBackgroundColor,
      this.itemColor,
      this.topTotalHeight,
      this.title,
      this.titleColor = Colors.black})
      : super(key: key);

  @override
  __SliverAppBarState createState() => __SliverAppBarState();
}

class __SliverAppBarState extends State<_SliverAppBar>
    with TickerProviderStateMixin {
  /// 下拉放大效果
  double _topInset = 0;

  // appBar上 item 的颜色
  Color _itemColor = Colors.white;

  // appbar item 背景色
  Color _itemBgColor = Color.fromARGB(100, 0, 0, 0);

  double _tabBarOpacity = 0;

  @override
  void initState() {
    super.initState();
    widget.controller!.offset.addListener(() {
      double scale =
          widget.controller!.offsetValue / (widget.topTotalHeight! - 80);
      scale = scale.clamp(0.0, 1.0);

      if (scale < 0.5) {
        _itemColor =
            widget.itemColor!.withAlpha((255 * (1 - scale * 2)).toInt());
      } else {
        _itemColor = Colors.black.withAlpha((255 * scale * 2).toInt());
      }
      _itemBgColor = Colors.black.withAlpha((80 * (1 - scale)).toInt());
      _tabBarOpacity = scale;
      setState(() {});
    });

    widget.controller!.overScrollOffset.addListener(() {
      double scale = 0.3;
      if (_topInset > 100) {
        scale = 0.1;
      } else {
        scale = 0.5;
      }
      setState(() {
        _topInset += widget.controller!.overScrollOffsetValue * scale;
      });
    });

    widget.controller!.dragEnd.addListener(() {
      if (!widget.controller!.dragEnd.value) return;
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
      widget.controller!.dragEnd.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        elevation: 2,
        centerTitle: true,
        titleSpacing: 20,
        backgroundColor: Colors.transparent,
        title: Opacity(
          opacity: _tabBarOpacity,
          child: Text(
            widget.title!,
            style: TextStyle(color: widget.titleColor),
          ),
        ),
        leading: Navigator.canPop(context) ? _backButton(context) : null,

        /// 40 是底部filterBar高度
        expandedHeight: widget.topTotalHeight! + widget.bottomHeight + _topInset,
        pinned: true,
        floating: false,
        flexibleSpace: Stack(
          children: <Widget>[
            widget.header!,

            /// appBar 背景色
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: DeviceInfo.statusBarHeight! + DeviceInfo.appBarHeight,
                child: Opacity(
                  opacity: _tabBarOpacity,
                  child: Container(
                    color: widget.appBarBackgroundColor,
                  ),
                )),
          ],
        ),
        bottom: widget.bottom, systemOverlayStyle: SystemUiOverlayStyle.light);
  }

  Center _backButton(BuildContext context) {
    return Center(
      child: CustomImageButton(
        icon: Icon(
          AppIcons.icon_back,
          size: 16,
          color: _itemColor,
        ),
        buttonSize: 30,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        backgroundColor: _itemBgColor,
        onPressed: () {
          Navigator.maybePop(context);
        },
      ),
    );
  }
}

class SliverAppBarController {
  ValueNotifier<double> offset = ValueNotifier(0);
  ValueNotifier<double> overScrollOffset = ValueNotifier(0);
  ValueNotifier<bool> dragEnd = ValueNotifier(false);

  get offsetValue => offset.value;

  get overScrollOffsetValue => overScrollOffset.value;

  void dispose() {
    offset.dispose();
    overScrollOffset.dispose();
    dragEnd.dispose();
  }
}
