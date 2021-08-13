import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/pages/home/function/home_fuc.dart';
import 'package:recook/pages/home/model/aku_video_list_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/widgets/webView.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flustars/flustars.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  WebViewController _webViewController;
  @override
  void initState() {
    super.initState();
    if (widget.akuVideo.type == 1) {
      _videoPlayerController = VideoPlayerController.network(
          Api.getImgUrl(widget.akuVideo.videoUrl));
      _videoPlayerController.initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          aspectRatio: _videoPlayerController.value.aspectRatio,
          autoPlay: false,
          showControls: true,
        );

        setState(() {});
      });
    }

    // player.setDataSource(Api.getImgUrl(widget.akuVideo.videoUrl),
    //     autoPlay: false);
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
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

  _bodyWidget() {
    return ListView(
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
        widget.akuVideo.type == 1 ? _playVideo() : _playImagText()
      ],
    );
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
      padding: EdgeInsets.only(top: 20.rw, left: 15.rw, right: 15.rw),
      height: 230.rw,
      child: _chewieController != null
          ? Chewie(
              controller: _chewieController,
            )
          : SizedBox(),
    );
  }

  // _playImagText() {
  //   return Container(
  //     height: 300.rw,
  //     width: 500.rw,
  //     child: HtmlWidget(),
  //   );
  // }

}
