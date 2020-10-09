import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recook/pages/live/widget/local_file_video.dart';

class VideoPreviewPage extends StatefulWidget {
  final File file;
  VideoPreviewPage({Key key, @required this.file}) : super(key: key);

  @override
  _VideoPreviewPageState createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF232323),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Hero(
          child: LocalFileVideo(file: widget.file),
          tag: 'preview_video',
        ),
      ),
    );
  }
}
