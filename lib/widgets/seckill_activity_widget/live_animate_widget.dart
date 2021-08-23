import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'live_animate.dart';

class LiveAnimateWidget extends StatefulWidget {
  final double size;
  final double strokeWidth;

  const LiveAnimateWidget({Key key, this.size, this.strokeWidth})
      : super(key: key);

  @override
  _LiveAnimateWidgetState createState() => _LiveAnimateWidgetState();
}

class _LiveAnimateWidgetState extends State<LiveAnimateWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.size ?? 50.w,
        height: widget.size ?? 50.w,
        color: Colors.transparent,
        // decoration: BoxDecoration(
        //   color: Colors.red,
        //   borderRadius: BorderRadius.circular((widget.size ?? 50.w) / 2),
        // ),
        child: Row(
          children: [
            LiveAnimate(
                size: widget.size ?? 50.w,
                duration: Duration(milliseconds: 800),
                strokeWidth: widget.strokeWidth ?? 5.w,
                place: 0,
                delay: Duration(milliseconds: 0)),
            LiveAnimate(
                size: widget.size ?? 50.w,
                duration: Duration(milliseconds: 800),
                strokeWidth: widget.strokeWidth ?? 5.w,
                place: 1,
                delay: Duration(milliseconds: 200)),
            LiveAnimate(
                size: widget.size ?? 50.w,
                duration: Duration(milliseconds: 800),
                strokeWidth: widget.strokeWidth ?? 5.w,
                place: 2,
                delay: Duration(milliseconds: 400)),
          ],
        ));
  }
}
