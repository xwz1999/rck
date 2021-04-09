import 'package:flutter/material.dart';

import 'package:recook/constants/constants.dart';

class RoundBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xFF16182B);

    canvas.drawCircle(Offset(size.width / 2, -100.w), 300.w, paint);
  }

  @override
  bool shouldRepaint(RoundBackgroundPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(RoundBackgroundPainter oldDelegate) => false;
}
