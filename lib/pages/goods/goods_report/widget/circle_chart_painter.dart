import 'dart:math';

import 'package:flutter/material.dart';

class CircleChartPainter extends CustomPainter {
  final double underStrokeWidth;
  final double aboveStrokeWidth;
  final double radius;
  final Color aboveColor;

  CircleChartPainter(
      {@required this.underStrokeWidth,
      @required this.aboveStrokeWidth,
      @required this.radius,
      @required this.aboveColor});

  @override
  void paint(Canvas canvas, Size size) {
    var offset = Offset(size.width / 2, size.height / 2);
    var paint = Paint()
      ..strokeWidth = underStrokeWidth
      ..style = PaintingStyle.stroke
      ..color = Color(0xFFCECECE);
    canvas.drawCircle(offset, size.width / 2, paint);
    paint
      ..strokeWidth = aboveStrokeWidth
      ..strokeCap = StrokeCap.round
      ..color = aboveColor;
    var rect = Rect.fromCircle(center: offset, radius: size.width / 2);
    canvas.drawArc(rect, -pi / 2, 2 * pi * radius, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}