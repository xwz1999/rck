import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'circle_chart_painter.dart';

class CircleChart extends StatelessWidget {
  final double size;

  ///角度
  final double aspectRato;

  ///底部圆圈的宽度
  final double underStrokeWidth;

  ///弧的宽度
  final double aboveStrokeWidth;

  ///弧的颜色
  final Color color;

  ///圆圈中间显示的组件
  final Widget core;

  const CircleChart(
      {Key key,
      this.size,
      @required this.aspectRato,
      this.underStrokeWidth,
      this.aboveStrokeWidth,
      @required this.color,
      @required this.core})
      : super(key: key);

  double get customSize => size ?? 100.w;

  double get customUnderWidth => underStrokeWidth ?? 5.w;

  double get customAboveWidth => aboveStrokeWidth ?? 15.w;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: customSize,
      height: customSize,
      child: CustomPaint(
          painter: CircleChartPainter(
              underStrokeWidth: customUnderWidth,
              aboveStrokeWidth: customAboveWidth,
              radius: aspectRato,
              aboveColor: color),
          child: Align(
            alignment: Alignment.center,
            child: core,
          )),
    );
  }
}
