import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/widgets/custom_painters/coupon_painter_new.dart';

enum SmallCouponType { white, red }

class SmallCouponWidget extends StatefulWidget {
  final num number;
  final double height;
  final SmallCouponType couponType;
  SmallCouponWidget(
      {Key key,
      this.height = 16,
      this.couponType = SmallCouponType.red,
      this.number = 0})
      : super(key: key);

  @override
  _SmallCouponWidgetState createState() => _SmallCouponWidgetState();
}

class _SmallCouponWidgetState extends State<SmallCouponWidget> {
  double _height;
  double _width;
  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = widget.height;
    _width = _height * (45 / 16) - 5;
    return Container(
      constraints: BoxConstraints(minHeight: _height, minWidth: _width),
      child: CustomPaint(
        painter: CouponPainterNew(type: widget.couponType),
        child: RepaintBoundary(
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    "${(widget.number).toString()}元券",
                    style: TextStyle(fontSize: ScreenAdapterUtils.setSp(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Container(
      constraints: BoxConstraints(minHeight: _height, minWidth: _width),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
          widget.couponType == SmallCouponType.red
              ? "assets/small_coupon_red_9patch_15.png"
              : "assets/small_coupon_white_9patch_15.png",
        ),
//          centerSlice: Rect.fromLTWH(10, 10, 80, 300)
        centerSlice: Rect.fromLTWH(2, 2, 28, 10),
      )),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                widget.number.toString(),
                style: TextStyle(fontSize: 8),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 3),
              child: Text(
                "元券",
                style: TextStyle(fontSize: 8),
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      width: _width,
      height: _height,
      child: Stack(
        children: <Widget>[
          Image.asset(
            widget.couponType == SmallCouponType.red
                ? "assets/small_coupon_red_9patch_15.png"
                : "assets/small_coupon_white_9patch.png",
            centerSlice: Rect.fromLTWH(2, 2, 16, 10),
          ),
          Text(
            widget.number.toString(),
          ),
        ],
      ),
    );
  }
}
