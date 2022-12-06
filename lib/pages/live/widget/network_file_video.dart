import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:recook/widgets/play_widget/PlayerControls.dart';
import 'package:video_player/video_player.dart';


class NetworkFileVideo extends StatefulWidget {
  final String? path;
  final double? aspectRatio;
  final PageController? pageController;
  final int? page;
  NetworkFileVideo({
    Key? key,
    required this.path,
    this.aspectRatio,
    this.pageController,
    this.page,
  }) : super(key: key);

  @override
  _NetworkFileVideoState createState() => _NetworkFileVideoState();
}

class _NetworkFileVideoState extends State<NetworkFileVideo> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.path??'');
    _videoPlayerController.initialize().then((value) {
      _chewieController = ChewieController(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: true,
        //showControls: true,
        looping: true,
        placeholder: new Container(color: Colors.black),
        videoPlayerController: _videoPlayerController,
        customControls: ShortVideoController(_videoPlayerController),
      );
      setState(() {});
      widget.pageController!.addListener(pageControllerListener);
    });
  }

  pageControllerListener() {
    if (widget.pageController?.page?.round() == widget.page) {
      _chewieController.play();
    }
    ;
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController == null
        ? Center(child: CircularProgressIndicator())
        : Chewie(
      controller: _chewieController,
    );
  }
}