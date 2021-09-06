import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_live_fluttify/tencent_live_fluttify.dart';

import 'package:recook/constants/header.dart';

class SmallWindowWidget extends StatefulWidget {
  final String url;
  SmallWindowWidget({Key key, @required this.url}) : super(key: key);

  @override
  _SmallWindowWidgetState createState() => _SmallWindowWidgetState();
}

class _SmallWindowWidgetState extends State<SmallWindowWidget> {
  double _topPos = 0;
  double _leftPos = 0;
  bool _isMoving = false;
  double _width = 90;
  double get _subWidth => _width / 2;
  double _height = 160;
  double get _subHeight => _height / 2;
  bool _isHide = false;

  LivePlayer _livePlayer;
  @override
  void initState() {
    super.initState();
    _topPos = ScreenUtil().screenHeight - 20 - _height - 55;
    _leftPos = _leftPos = ScreenUtil().screenWidth- 20 - _width;
  }

  @override
  void dispose() {
    _livePlayer?.stopPlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: _isHide ? -_width : _leftPos,
      top: _topPos,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white,width: rSize(1)),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child:
              CloudVideo(
                onCloudVideoCreated: (controller) async {
                  _livePlayer = await LivePlayer.create();
                  await _livePlayer.setPlayerView(controller);
                  _livePlayer.startPlay(widget.url, type: PlayType.RTMP);
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
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
                if (_topPos < ScreenUtil().statusBarHeight + 20)
                  _topPos = (20 + ScreenUtil().statusBarHeight);
                if ((_leftPos + _width + 20) > ScreenUtil().screenWidth)
                  _leftPos = ScreenUtil().screenWidth - 20 - _width;
                if ((_topPos + _height + 55 + 20) > ScreenUtil().screenHeight)
                  _topPos = ScreenUtil().screenHeight- 20 - _height - 55;
                setState(() {});
              },
              child: Container(
                height: _height,
                width: _width,
                color: Colors.transparent,
              ),
            ),
            Positioned(
              right: 5,
              top: 5,
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
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      curve: Curves.easeInOutCubic,
      duration: _isMoving ? Duration.zero : Duration(milliseconds: 300),
    );
  }
}
