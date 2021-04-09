import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

// import 'package:fijkplayer/fijkplayer.dart';
// import 'package:recook/constants/app_image_resources.dart';
// import 'package:recook/constants/constants.dart';
// import 'package:recook/widgets/custom_cache_image.dart';
// import 'package:recook/widgets/custom_image_button.dart';
// import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final String videoUrl;
  VideoView({Key key, this.videoUrl}) : assert(videoUrl != null && videoUrl.length > 0, "video url 不能为空");
  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  // final FijkPlayer player = FijkPlayer();
  VideoPlayerController _videoController;
  ChewieController _chewieController;

  @override
  void initState() {
    _videoController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      aspectRatio: 16 / 9,
      autoPlay: !true,
      showControls: true,
      // 占位图
      placeholder: new Container(
          color: Colors.grey,
      ),
      // 是否在 UI 构建的时候就加载视频
      autoInitialize: true,
      // looping: true,
    );
    // player.setDataSource(widget.videoUrl, autoPlay: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _videoView();
  }
  _videoView(){
    _chewieController.pause();
    return Container(
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.width/16*10,
      width: double.infinity,
      height: double.infinity,
      child: Chewie(controller: _chewieController,),
    );
  }

  // @override
  // void deactivate() { 
  //   super.deactivate();
  //   if (player.state != FijkState.stopped && player.state != FijkState.completed) {
  //     player.pause();
  //   }
  // }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
