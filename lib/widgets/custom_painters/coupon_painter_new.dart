import 'dart:math';

import 'package:flutter/material.dart';

import 'package:recook/pages/goods/small_coupon_widget.dart'
    show SmallCouponType;

class CouponPainterNew extends CustomPainter {
  final SmallCouponType type;

  CouponPainterNew({this.type = SmallCouponType.red});
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    //solid red background paint
    Paint backgroundPaint = Paint()
      ..color = Color(0xFFCC1B4F)
      ..style = PaintingStyle.fill;

    //white border paint
    Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    Path backgroundPath = Path();
    backgroundPath.lineTo(width, 0);
    backgroundPath.arcTo(Rect.fromCircle(center: Offset(width, height/2), radius: 3),
        -pi / 2, -pi, false);
    backgroundPath.lineTo(width, height);
    backgroundPath.lineTo(0, height);
    backgroundPath.arcTo(
        Rect.fromCircle(center: Offset(0, height/2), radius: 3), pi / 2, -pi, false);
    backgroundPath.close();

    if (type == SmallCouponType.red){
      canvas.drawPath(backgroundPath, backgroundPaint);
      {
        Path white100PaintPath = Path();
        Paint white100Paint = Paint()
          ..color = Colors.white.withAlpha(60)
          ..style = PaintingStyle.fill;
        Path backgroundPath = Path();
        white100PaintPath.lineTo(width*0.4, 0);
        // backgroundPath.arcTo(Rect.fromCircle(center: Offset(width, 8), radius: 3),
        //     -pi / 2, -pi, false);
        white100PaintPath.lineTo(width, height);
        white100PaintPath.lineTo(width*0.4, height);
        white100PaintPath.lineTo(0, 4);
        // backgroundPath.arcTo(
        //     Rect.fromCircle(center: Offset(0, 8), radius: 3), pi / 2, -pi, false);
        white100PaintPath.close();
        canvas.drawPath(white100PaintPath, white100Paint);
      }
    }else
      canvas.drawPath(backgroundPath, whitePaint);
  }

  @override
  bool shouldRepaint(CouponPainterNew oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CouponPainterNew oldDelegate) => false;
}
