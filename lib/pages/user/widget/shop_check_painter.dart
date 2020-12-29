import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ShopCheckPainter extends CustomPainter {
  ///圆环开始颜色
  final Color beginColor;

  ///圆环结束颜色
  final Color endColor;

  ///边框颜色
  final Color themeColor;

  ///进度
  final double percentage;

  ///圆环开始颜色
  /// final Color beginColor;
  ///
  ///圆环结束颜色
  ///final Color endColor;
  ///
  ///边框颜色
  ///final Color themeColor;
  ///
  ///进度
  ///final double percentage;
  ShopCheckPainter({
    @required this.beginColor,
    @required this.endColor,
    @required this.themeColor,
    this.percentage = 0,
  });

  double get percentValue => percentage / 100.0;

  bool get done => percentage == 100.0;

  _drawCircle(Canvas canvas, double radius) {
    Paint paint = Paint()
      ..color = themeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    //Circle Inner Painter
    Paint innerPaint = Paint()
      ..color = Color(0xFFF8F9FB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(Offset(radius, radius), radius - 2.5, innerPaint);
    canvas.drawCircle(Offset(radius, radius), radius - 5, paint);
    canvas.drawCircle(Offset(radius, radius), radius, paint);
  }

  _drawProgress(Canvas canvas, double radius) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4
      ..shader = SweepGradient(
        colors: [
          beginColor,
          endColor,
        ],
        stops: [0, percentValue],
        transform: GradientRotation(-pi / 2),
      ).createShader(Rect.fromCircle(
        center: Offset(radius, radius),
        radius: radius - 2.5,
      ));
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(radius, radius),
        radius: radius - 2.5,
      ),
      -pi / 2,
      2 * pi * percentValue,
      false,
      paint,
    );
  }

  _drawTagBackground(Canvas canvas, double radius) {
    Paint paint = Paint()
      ..color = endColor
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawPoints(PointMode.points, [Offset(radius, 2.5)], paint);
  }

  _buildUpgradeTag(Canvas canvas, double radius) {
    Paint iconPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(radius, 5), Offset(radius, 0.5), iconPaint);
    canvas.drawLine(Offset(radius - 2, 2.7), Offset(radius, 0.5), iconPaint);
    canvas.drawLine(Offset(radius + 2, 2.7), Offset(radius, 0.5), iconPaint);
  }

  _buildDownTag(Canvas canvas, double radius) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(radius - 2.5, 2.5), Offset(radius + 2.5, 2.5), paint);
  }

  _drawArrow(Canvas canvas, double radius, double rotate) {
    Paint paint = Paint()
      ..color = endColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    var headlen = 7; // length of head in pixels
    double pointX = radius - (radius - 2.5) * cos(pi);
    double pointY = radius + (radius - 2.5) * sin(pi);
    Path path = Path();
    path.moveTo(pointX, pointY);
    path.lineTo(pointX - headlen * cos(rotate - pi / 4),
        pointY - headlen * sin(rotate - pi / 4));
    path.moveTo(pointX, pointY);
    path.lineTo(pointX - headlen * cos(rotate + pi / 4),
        pointY - headlen * sin(rotate + pi / 4));
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    // Circle Border Painter
    _drawCircle(canvas, radius);
    _drawProgress(canvas, radius);
    _drawTagBackground(canvas, radius);
    done ? _buildDownTag(canvas, radius) : _buildUpgradeTag(canvas, radius);
    _drawArrow(canvas, radius, percentValue * 2 * pi);
  }

  @override
  bool shouldRepaint(ShopCheckPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(ShopCheckPainter oldDelegate) => false;
}
