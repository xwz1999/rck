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
    this.aspectRatio,
  }) : super(key: key);

  @override
  _LocalFileVideoState createState() => _LocalFileVideoState();
}

class _LocalFileVideoState extends State<LocalFileVideo> {
  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(widget.file);
    _videoPlayerController.initialize().then((value) {
      _chewieController = ChewieController(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: true,
        showControls: false,
        looping: true,
        placeholder: new Container(color: Colors.black),
        videoPlayerController: _videoPlayerController,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
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
