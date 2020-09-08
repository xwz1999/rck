/*
 * ====================================================
 * package   : pages.welcome
 * author    : Created by nansi.
 * time      : 2019/5/5  4:47 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/utils/app_router.dart';
import 'package:sprintf/sprintf.dart';


class LaunchWidget extends StatefulWidget {
  @override
  _LaunchWidgetState createState() => _LaunchWidgetState();
}

class _LaunchWidgetState extends BaseStoreState<LaunchWidget> with SingleTickerProviderStateMixin {

  Map<int,Image> _imageMap = {}; 
  // GifController _gifController;

  @override
  void dispose() {

    super.dispose();
  }

  @override
  void initState() {
    // _gifController = GifController(vsync: this);
    
    super.initState();
    //0-59
    for (var i = 0; i <= 104; i++) {
      _imageMap.putIfAbsent(i, (){
        return Image.asset("assets/recook_launch_image/recook_launch_image_$i.png");
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((callback){
      // _gifController.repeat(min: 0, max:59, period: Duration(milliseconds: 1500));
      Future.delayed(Duration(milliseconds: 3500), () {
        AppRouter.fadeAndReplaced(globalContext, RouteName.WELCOME_PAGE);
      });
    });
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    Constants.initial(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Container(
        child: ImagesAnimation(w: width, h: height, milliseconds: 3500, entry: ImagesAnimationEntry(0, 104, "assets/recook_launch_image/recook_launch_image_%s.png")),
      ),
    );
  }
}


class ImagesAnimation extends StatefulWidget {

  final double w;
  final double h;
  final ImagesAnimationEntry entry;
  final int milliseconds;
  
  ImagesAnimation({Key key, this.w : 80, this.h : 80, this.entry, this.milliseconds : 1000}):super(key:key);

  @override
  _InState createState() {
    return _InState();
  }
}

class _InState extends State<ImagesAnimation> with TickerProviderStateMixin{

  AnimationController _controller;
  Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this, duration: Duration(milliseconds: widget.milliseconds));
    _animation = new IntTween(begin: widget.entry.lowIndex, end: widget.entry.highIndex).animate(_controller)
      ..addListener((){
        setState(() {});
      });
    _controller.forward();
//widget.entry.lowIndex 表示从第几下标开始，如0；widget.entry.highIndex表示最大下标：如7
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return new AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        String frame = _animation.value.toString();
        return new Image.asset(
          sprintf(widget.entry.basePath, [frame]), //根据传进来的参数拼接路径
          gaplessPlayback: true, //避免图片闪烁
          width: widget.w,
          height: widget.h,
        );
      },
    );
  }

}

class ImagesAnimationEntry {
  int lowIndex = 0;
  int highIndex = 0;
  String basePath;
  ImagesAnimationEntry(this.lowIndex, this.highIndex, this.basePath);
}