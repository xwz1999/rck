import 'package:flutter/material.dart';

class ArcPainter extends CustomPainter {
  late Paint _mPaint;
  double? _height;

  ArcPainter({Color color = Colors.blue, double height = -1}) {
    _mPaint = new Paint();
    _mPaint.color = color;
    _mPaint.isAntiAlias = true;
    _height = height;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    double fp = size.width / 24;
    var ry = _height;
    if (_height == -1) {
      ry = size.height * 3 / 4;
    }
    var startX = -5 * fp;
    var endX = 29 * fp;
    var rx = 17 * fp;

//    print("sx:$startX;ex:$endX;rx:$rx;ry:$ry");
    path.moveTo(startX, 0);
    path.arcToPoint(Offset(endX, 0),
        radius: Radius.elliptical(rx, ry!), clockwise: false);
    canvas.drawPath(path, _mPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void setColor(Color bgColor) {
    _mPaint.color = bgColor;
  }

  void setArcHeight(double height) {
    this._height = height;
  }
}
