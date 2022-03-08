import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tencentplayer/controller/tencent_player_controller.dart';
import 'package:flutter_tencentplayer/view/tencent_player.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/gen/assets.gen.dart';
import 'package:jingyaoyun/pages/home/function/home_fuc.dart';
import 'package:jingyaoyun/pages/home/model/aku_video_list_model.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/full_video_page.dart';
import 'package:jingyaoyun/widgets/tencent_player_bottom_widget.dart';
import 'package:jingyaoyun/widgets/tencent_player_gesture_cover.dart';
import 'package:jingyaoyun/widgets/tencent_player_loading.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';

class AkuCollegeDetailPage extends StatefulWidget {
  final AkuVideo akuVideo;

  const AkuCollegeDetailPage({Key key, @required this.akuVideo})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AkuCollegeDetailPageState();
  }
}

class _AkuCollegeDetailPageState extends BaseStoreState<AkuCollegeDetailPage> {
  //final FijkPlayer player = FijkPlayer();

  // VideoPlayerController _videoPlayerController;
  // ChewieController _chewieController;

  TencentPlayerController _controller;
  VoidCallback listener;
  bool showCover = false;
  Timer timer;
  bool isLock = false;
  _AkuCollegeDetailPageState() {
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
    Future.delayed(Duration.zero, () async {
      String code = await HomeFuc.addHits(widget.akuVideo.id);
      print(code);
    });


    // ForbidShotUtil.initForbid(context);
    // Screen.keepOn(true);

    if (widget.akuVideo.type == 1) {
      //SystemChrome.setEnabledSystemUIOverlays([]);
      _controller = TencentPlayerController.network(Api.getImgUrl(widget.akuVideo.videoUrl));
      _controller.initialize();
      _controller.addListener(listener);
      hideCover();
    } else {
      if (widget.akuVideo.textBody != null) {}
    }

    // player.setDataSource(Api.getImgUrl(widget.akuVideo.videoUrl),
    //     autoPlay: false);
  }

  @override
  void dispose() {
    // _videoPlayerController?.dispose();
    // _chewieController?.dispose();
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _controller.removeListener(listener);
    _controller.dispose();
    super.dispose();
    //player.dispose();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: CustomAppBar(
        title: "".text.bold.size(18.rsp).make(),
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: _bodyWidget(),
    );
  }

  hideCover() {
    if (!mounted) return;
    setState(() {
      showCover = !showCover;
    });
    delayHideCover();
  }

  _bodyWidget() {
    return SingleChildScrollView(
        child: Column(
      children: [
        40.hb,
        Row(
          children: [
            30.wb,
            Text(
              widget.akuVideo.title,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 20.rsp,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold),
            ).expand(),
            30.wb,
          ],
        ),
        20.hb,
        Row(
          children: [
            30.wb,
            Text(
              widget.akuVideo.subTitle,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.rsp,
                color: Color(0xFF333333),
              ),
            ),
            40.wb,
            Container(
              padding: EdgeInsets.only(top: 3.rw),
              child: Text(
                _getDateTime(widget.akuVideo.createDTime),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.rsp,
                  color: Color(0xFF999999),
                ),
              ),
            ),
            40.wb,
            Text(
              widget.akuVideo.numberOfHits.toString() + '人已学习',
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.rsp,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
        20.hb,
        widget.akuVideo.type == 1 ? _playVideo() : _playImagText()
      ],
    ));
  }

  _getDateTime(String date) {
    if (date.isEmpty) {
      return date;
    } else {
      DateTime dateTime = DateUtil.getDateTime(date);
      return DateUtil.formatDate(dateTime, format: 'yyyy-MM-dd');
    }
  }

  _playVideo() {
    return Container(
      child: Hero(
        tag: 'play',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            hideCover();
          },
          onDoubleTap: () {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
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
                _controller.value.initialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: TencentPlayer(_controller),
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
                      TencentPlayerController newController = await Navigator.of(context).push(CupertinoPageRoute(builder: (_) => FullVideoPage(controller: _controller, playType: PlayType.network), fullscreenDialog: true));

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

  _playImagText() {
    return HtmlWidget(
      widget.akuVideo.textBody,
      textStyle: TextStyle(color: Color(0xFF333333)),
    );
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


}
