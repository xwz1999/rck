import 'dart:math';

import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';

class PieProgressPainter extends CustomPainter {
  final List<PieDataStructure> values;

  ///起始位置
  static const double startAngle = -pi / 2;
  static const double circleAngle = 2 * pi;
  PieProgressPainter({this.values});
  @override
  void paint(Canvas canvas, Size size) {
    values.forEach((element) {
      double _startAngle = startAngle;
      double angleWidth = 0;
      angleWidth = element.value * circleAngle;
      for (int i = 0; i < values.indexOf(element); i++) {
        _startAngle += values[i].value * circleAngle;
      }
      Paint paint = Paint()
        ..color = element.color
        ..strokeWidth = rSize(15)
        ..style = PaintingStyle.stroke;
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(
            size.width / 2,
            size.height / 2,
          ),
          radius: rSize(50 - 15 / 2.0),
        ),
        _startAngle,
        angleWidth - circleAngle / 360,
        false,
        paint,
      );
    });
  }

  @override
  bool shouldRepaint(PieProgressPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(PieProgressPainter oldDelegate) => false;
}

class PieDataStructure {
  ///数值
  ///
  ///example 0.5 same as 50%
  final double value;

  ///颜色
  final Color color;
  PieDataStructure({this.value, this.color});
}
