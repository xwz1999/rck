import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tencentplayer/controller/tencent_player_controller.dart';
import 'package:flutter_tencentplayer/view/tencent_player.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/widgets/play_widget/tencent_player_bottom_widget.dart';
import 'package:recook/widgets/play_widget/tencent_player_gesture_cover.dart';
import 'package:recook/widgets/play_widget/tencent_player_loading.dart';

import 'full_video_page.dart';

class VideoPlayer extends StatefulWidget {
  final String? url;
  final bool isNetWork;
  const VideoPlayer({Key? key,required this.url, required this.isNetWork }) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {


  TencentPlayerController? _controller;
  late VoidCallback listener;
  bool showCover = false;
  Timer? timer;
  bool isLock = false;
  _VideoPlayerState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };

  }
  @override
  void initState() {
    super.initState();
    if(widget.isNetWork){
      _controller = TencentPlayerController.network(Api.getImgUrl(widget.url));
    }else{
      _controller = TencentPlayerController.file(widget.url!);
    }


      _controller!.initialize();
      _controller!.addListener(listener);
      hideCover();

  }

  @override
  void dispose() {
    _controller!.removeListener(listener);
    _controller!.dispose();
    super.dispose();
  }
  hideCover() {
    if (!mounted) return;
    setState(() {
      showCover = !showCover;
    });
    delayHideCover();
  }

  delayHideCover() {
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }
    if (showCover) {
      timer = new Timer(Duration(seconds: 6), () {
        if (!mounted) return;
        setState(() {
          showCover = false;
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Hero(
        tag: 'play',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            hideCover();
          },
          onDoubleTap: () {
            if (_controller!.value.isPlaying) {
              _controller!.pause();
            } else {
              _controller!.play();
            }
          },
          child:Container(
            color: Colors.black,
            height: 240,
            child: Stack(
              // overflow: Overflow.visible,
              alignment: Alignment.center,
              children: <Widget>[
                /// 视频
                _controller!.value.initialized
                    ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: TencentPlayer(_controller!),
                ) : Image.asset(Assets.static.placeNodata.path),
                /// 支撑全屏
                Container(),
                /// 半透明浮层
                showCover ?Container(color: Color(0x7f000000)) : SizedBox(),
                /// 处理滑动手势
                Offstage(
                  offstage: isLock,
                  child: TencentPlayerGestureCover(
                    controller: _controller,
                    showBottomWidget: true,
                    behavingCallBack: delayHideCover,
                  ),
                ),
                /// 加载loading
                TencentPlayerLoading(controller: _controller, iconW: 53,),
                /// 进度、清晰度、速度
                Offstage(
                  offstage: false,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w, right: MediaQuery.of(context).padding.bottom),
                    child: TencentPlayerBottomWidget(
                      showSpeedBtn: false,
                      isShow: !isLock && showCover,
                      controller: _controller,
                      showClearBtn: false,
                      behavingCallBack: () {
                        delayHideCover();
                      },

                    ),
                  ),
                ),
                /// 全屏按钮
                showCover ? Positioned(
                  right: 0,
                  bottom: 20,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      TencentPlayerController? newController = await Navigator.of(context).push(CupertinoPageRoute(builder: (_) => FullVideoPage(controller: _controller, playType: PlayType.network), fullscreenDialog: true));

                      setState(() {
                        _controller = newController;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Image.asset(Assets.static.fullScreenOn.path, width: 20, height: 20),
                    ),
                  ),
                ) : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
