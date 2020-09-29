import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LocalFileVideo extends StatefulWidget {
  final File file;
  final double aspectRatio;
  LocalFileVideo({
    Key key,
    @required this.file,
    @required this.aspectRatio,
  }) : super(key: key);

  @override
  _LocalFileVideoState createState() => _LocalFileVideoState();
}

class _LocalFileVideoState extends State<LocalFileVideo> {
  ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      aspectRatio: widget.aspectRatio,
      autoPlay: true,
      showControls: false,
      looping: true,
      placeholder: new Container(color: Colors.black),
      videoPlayerController: VideoPlayerController.file(widget.file),
    );
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}
