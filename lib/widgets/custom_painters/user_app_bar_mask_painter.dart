import 'package:flutter/material.dart';
import 'dart:math';
import 'package:recook/constants/styles.dart';

class UserAppBarMaskPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColor.frenchColor
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.arcTo(Rect.fromCircle(center: Offset(30, -45), radius: 60), pi / 2,
        pi / 4, false);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.arcTo(
        Rect.fromCircle(center: Offset(size.width - 30, -45), radius: 60),
        0,
        pi / 2,
        false);
    path.close();
    Paint shadow = Paint()
      ..color = Colors.black.withAlpha(80)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawPath(path, shadow);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(UserAppBarMaskPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(UserAppBarMaskPainter oldDelegate) => false;
}
