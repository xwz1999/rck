import 'dart:io';

import 'package:flutter/material.dart';

import 'package:recook/pages/live/widget/local_file_video.dart';
import 'package:recook/pages/live/widget/network_file_video.dart';

class VideoPreviewPage extends StatefulWidget {
  final File file;
  final String path;
  VideoPreviewPage({Key key, @required this.file, this.path}) : super(key: key);
  VideoPreviewPage.network({Key key, this.file, @required this.path})
      : super(key: key);
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
          child: widget.file == null
              ? NetworkFileVideo(path: widget.path)
              : LocalFileVideo(file: widget.file),
          tag: 'preview_video',
        ),
      ),
    );
  }
}
