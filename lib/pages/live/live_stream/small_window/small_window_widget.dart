import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmallWindowWidget extends StatefulWidget {
  SmallWindowWidget({Key key}) : super(key: key);

  @override
  _SmallWindowWidgetState createState() => _SmallWindowWidgetState();
}

class _SmallWindowWidgetState extends State<SmallWindowWidget> {
  double get _bottomSafe => 55 + ScreenUtil.statusBarHeight;
  double _topPos = 0;
  double _leftPos = 0;
  bool _isMoving = false;
  double _width = 90;
  double get _subWidth => _width / 2;
  double _height = 160;
  double get _subHeight => _height / 2;
  bool _isHide = false;
  @override
  void initState() {
    super.initState();
    _topPos = ScreenUtil.statusBarHeight + 20;
    _leftPos = 20;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: _isHide ? -_width : _leftPos,
      top: _topPos,
      child: Stack(
        children: [
          GestureDetector(
            onPanUpdate: (detail) {
              setState(() {
                _topPos = detail.globalPosition.dy - _subHeight;
                _leftPos = detail.globalPosition.dx - _subWidth;
              });
            },
            onPanStart: (detail) {
              setState(() {
                _isMoving = true;
              });
            },
            onPanEnd: (detail) {
              _isMoving = false;
              if (_leftPos < 20) _leftPos = 20;
              if (_topPos < ScreenUtil.statusBarHeight + 20)
                _topPos = (20 + ScreenUtil.statusBarHeight);
              if ((_leftPos + _width + 20) > ScreenUtil.screenWidthDp)
                _leftPos = ScreenUtil.screenWidthDp - 20 - _width;
              if ((_topPos + _height + 55 + 20) > ScreenUtil.screenHeightDp)
                _topPos = ScreenUtil.screenHeightDp - 20 - _height - 55;
              setState(() {});
            },
            child: Container(
              height: _height,
              width: _width,
              color: Colors.blueAccent,
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isHide = true;
                });
              },
              child: Container(
                height: 20,
                width: 20,
                child: Icon(
                  Icons.clear,
                  size: 16,
                  color: Colors.black,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
      curve: Curves.easeInOutCubic,
      duration: _isMoving ? Duration.zero : Duration(milliseconds: 300),
    );
  }
}
