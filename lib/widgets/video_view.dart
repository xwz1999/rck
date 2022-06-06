
import 'package:flutter/material.dart';
import 'package:recook/widgets/play_widget/video_player.dart';

class VideoView extends StatefulWidget {
  final String? videoUrl;
  VideoView({Key? key, this.videoUrl}) : assert(videoUrl != null && videoUrl.length > 0, "video url 不能为空");
  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {

  @override
  void initState() {

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
      child: VideoPlayer(url:widget.videoUrl ,isNetWork: true,),
    );
  }


  @override
  void dispose() {

    super.dispose();
  }
}
