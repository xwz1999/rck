import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recook/models/goods_simple_list_model.dart';
import 'package:recook/pages/live/live_stream/live_stream_view_page.dart';
import 'package:recook/widgets/toast.dart';

import 'package:recook/constants/header.dart';

class OverlayLivingBtnWidget extends StatefulWidget {
  final Living living;


  OverlayLivingBtnWidget({Key key, this.living}) : super(key: key);

  @override
  _OverlayLivingBtnWidgetState createState() => _OverlayLivingBtnWidgetState();
}

class _OverlayLivingBtnWidgetState extends State<OverlayLivingBtnWidget> with TickerProviderStateMixin{
  double _topPos = 0;
  double _leftPos = 0;
  bool _isMoving = false;
  double _width = 50;
  double get _subWidth => _width / 2;
  double _height = 70;
  double get _subHeight => _height / 2;
  bool _isHide = false;
  GifController _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this)
      ..repeat(
        min: 0,
        max: 20,
        period: Duration(milliseconds: 700),
      );
    _topPos = ScreenUtil().screenHeight - 20 - _height -200;
    _leftPos = _leftPos = ScreenUtil().screenWidth-50 - _width;
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: _isHide ? -_width : _leftPos,
      top: _topPos,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent,width: rSize(1)),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                  width: 50.rw,
                  height: 69.rw,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFDBDBDB),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(7.rw)),
                      color: Colors.white),
                  child: Column(
                    children: [
                      10.hb,
                      Container(

                        alignment: Alignment.center,
                        //color: Colors.blue,
                        // decoration: BoxDecoration(
                        //     color: Color(0xFFFF0000),
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(40.rw))),
                        child: GifImage(
                          controller: _gifController,
                          image: AssetImage(R.ASSETS_LIVE_PLAY_GIF),
                          height: 40.rw,
                          width: 40.rw,
                        ),
                      ),

                      Text(
                        '直播中',
                        style: TextStyle(
                            fontSize: 10.rsp, color: Color(0xFF333333)),
                      )
                    ],
                  ),

              ),

            ),
            GestureDetector(
              onTap: widget.living.roomId != 0
                  ? () {
                Get.to(
                    LiveStreamViewPage(id: widget.living.roomId));
              }
                  : () {
                Toast.showError('找不到该直播间！');

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
            // Positioned(
            //   right: 5,
            //   top: 5,
            //   child: GestureDetector(
            //     onTap: () {
            //       setState(() {
            //         _isHide = true;
            //       });
            //     },
            //     child: Container(
            //       height: 20,
            //       width: 20,
            //       child: Icon(
            //         Icons.clear,
            //         size: 16,
            //         color: Colors.black,
            //       ),
            //       decoration: BoxDecoration(
            //         color: Colors.white.withOpacity(0.3),
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      curve: Curves.easeInOutCubic,
      duration: _isMoving ? Duration.zero : Duration(milliseconds: 300),
    );
  }
}
