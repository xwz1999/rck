
import 'package:flutter/material.dart';
import 'package:recook/widgets/play_widget/video_player.dart';


class NetworkFileVideo extends StatefulWidget {
  final String path;
  final double aspectRatio;
  final PageController pageController;
  final int page;
  NetworkFileVideo({
    Key key,
    @required this.path,
    this.aspectRatio,
    this.pageController,
    this.page,
  }) : super(key: key);

  @override
  _NetworkFileVideoState createState() => _NetworkFileVideoState();
}

class _NetworkFileVideoState extends State<NetworkFileVideo> {

  @override
  void initState() {
    super.initState();
  }



  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  VideoPlayer(
           url: widget.path,isNetWork: true,
          );
  }
}
