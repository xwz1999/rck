import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/utils/print_util.dart';

class HomeColorAnimationWidget extends StatefulWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  HomeColorAnimationWidget({Key key, this.width, this.height, this.backgroundColor}) : super(key: key);

  @override
  HomeColorAnimationWidgetState createState() => HomeColorAnimationWidgetState();
}

class HomeColorAnimationWidgetState extends State<HomeColorAnimationWidget> with TickerProviderStateMixin {
  Color _backgroundColor;
  AnimationController _controller;
  Animation<Color> color;
  Color beginColor;
  @override
  void initState() {
    _backgroundColor = widget.backgroundColor==null? AppColor.themeColor:widget.backgroundColor;
    beginColor = _backgroundColor;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Color showColor = color!=null&&color.value!=null?color.value:_backgroundColor;
    return Container(
      // color: _backgroundColor,
      child: Container(
        width: widget.width!=null?widget.width:MediaQuery.of(context).size.width , 
        height: widget.height!=null?widget.height:100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [showColor, showColor, AppColor.frenchColor]),
          color: showColor,
        ),
        // color: color!=null&&color.value!=null?color.value:Colors.white.withAlpha(0),
      ),
    );
  }

  void changeBackgroundColor(Color endColor){
    Color _beginColor = beginColor;
    beginColor = endColor;
    if (_controller!=null) _controller.dispose();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    color = ColorTween(
      begin: _beginColor,
      end: endColor,
    ).animate(
      _controller
    )
    ..addListener(() {
      setState(() {});
    })
    ..addStatusListener((AnimationStatus status) {
      // DPrint.printf(status);
    });
    try {
      _controller.forward();
    } catch (e) {}
  }

  @override
  void dispose() {
    if (_controller!=null) {
      _controller.dispose();
    }
    super.dispose();
  }

}