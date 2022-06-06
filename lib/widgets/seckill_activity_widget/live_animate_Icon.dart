import 'package:flutter/material.dart';

class LiveAnimateIcon extends CustomPainter {
  final double strokeWidth;
  final double value;
  final int palce;

  LiveAnimateIcon(
    this.value,
    this.strokeWidth,
    this.palce,
  );

  @override
  void paint(Canvas canvas, Size size) {
    double offset = size.height * (value * 0.3 + 0.2);
    Paint paint = Paint()
      ..strokeWidth = this.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;
    Path path = Path();
    path.moveTo(
        this.palce == 0
            ? size.width * 0.8
            : this.palce == 2
                ? size.width * 0.2
                : size.width / 2,
        offset);
    path.lineTo(
        this.palce == 0
            ? size.width * 0.8
            : this.palce == 2
                ? size.width * 0.2
                : size.width / 2,
        size.height - offset);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) {
    return true;
  }
}