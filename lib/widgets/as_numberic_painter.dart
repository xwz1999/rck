import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ASNUmericPainter extends CustomPainter {
  final bool plus;

  ASNUmericPainter.minus() : this.plus = false;

  ASNUmericPainter.plus() : this.plus = true;

  @override
  void paint(Canvas canvas, Size size) {
    double halfWidth = size.width / 2;
    double halfHeight = size.height / 2;
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.w;
    canvas.drawCircle(Offset(halfWidth, halfHeight), 16.w / 2, paint);
    canvas.drawLine(
      Offset(halfWidth - 3, halfHeight),
      Offset(halfWidth + 3, halfHeight),
      paint,
    );
    if (plus) {
      canvas.drawLine(
        Offset(halfWidth, halfHeight - 3),
        Offset(halfWidth, halfHeight + 3),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ASNUmericPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(ASNUmericPainter oldDelegate) => false;
}
