import 'dart:io';

// import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:recook/widgets/play_widget/video_player.dart';
// import 'package:video_player/video_player.dart';

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
            isNetWork: false,url: widget.file.path,
          );
  }
}
