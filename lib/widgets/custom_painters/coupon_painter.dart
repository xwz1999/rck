import "dart:math";

import 'package:flutter/material.dart';

import 'package:jingyaoyun/pages/goods/small_coupon_widget.dart';

class CouponPainter extends CustomPainter {
  final SmallCouponType type;
  CouponPainter({this.type});
  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint;
    if (this.type == SmallCouponType.red) {
      backgroundPaint = Paint()
        ..color = Color(0xFFCC1B4F)
        ..style = PaintingStyle.fill;
    } else {
      backgroundPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke;
    }
    //coupon outter path
    Path couponPath = Path();
    num pathMidWay = size.width - 24;
    couponPath.lineTo(pathMidWay - 2, 0);
    couponPath.arcTo(Rect.fromCircle(center: Offset(pathMidWay, 0), radius: 2),
        pi, -pi, false);
    couponPath.lineTo(size.width, 0);
    couponPath.lineTo(size.width, 16);
    couponPath.arcTo(Rect.fromCircle(center: Offset(pathMidWay, 16), radius: 2),
        0, -pi, false);
    couponPath.lineTo(0, 16);
    couponPath.close();

    /**Draw Shadow */
    if(this.type==SmallCouponType.red){
      canvas.drawPath(
      couponPath,
      Paint()
        ..color = Colors.black.withAlpha(100)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3),
    );
    }

    /**Draw background */
    canvas.drawPath(couponPath, backgroundPaint);

    /**Draw Dash */
    Paint dashPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;
    double startPoint = 3;

    for (int i = 0; i < 3; i++) {
      canvas.drawLine(Offset(pathMidWay, startPoint),
          Offset(pathMidWay, startPoint + 2), dashPaint);
      startPoint += 4;
    }
  }

  @override
  bool shouldRepaint(CouponPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CouponPainter oldDelegate) => false;
}
