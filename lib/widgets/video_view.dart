import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final String? videoUrl;
  VideoView({Key? key, this.videoUrl}) : assert(videoUrl != null && videoUrl.length > 0, "video url 不能为空");
  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  @override
  void initState() {
    _videoController = VideoPlayerController.network(widget.videoUrl??"");
    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _videoView();
  }
  _videoView(){

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Chewie(controller: _chewieController!,),
    );
  }


  @override
  void dispose() {

    super.dispose();
  }
}
