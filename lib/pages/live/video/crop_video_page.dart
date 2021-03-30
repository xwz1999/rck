import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:video_trimmer/trim_editor.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:video_trimmer/video_viewer.dart';

import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/live/video/video_advance_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/recook_back_button.dart';

class CropVideoPage extends StatefulWidget {
  final File file;
  CropVideoPage({Key key, @required this.file}) : super(key: key);

  @override
  _CropVideoPageState createState() => _CropVideoPageState();
}

class _CropVideoPageState extends State<CropVideoPage> {
  Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;

  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _trimmer.loadVideo(videoFile: widget.file).then((_) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF232323),
      appBar: CustomAppBar(
        elevation: 0,
        appBackground: Color(0xFF232323),
        leading: RecookBackButton(white: true),
        actions: [
          Center(
            child: SizedBox(
              width: rSize(72),
              height: rSize(28),
              child: MaterialButton(
                child: Text('确定'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(rSize(14)),
                ),
                onPressed: () {
                  final cropLoadingCancel = ReToast.loading(text: '保存视频中');
                  _trimmer
                      .saveTrimmedVideo(
                    startValue: _startValue,
                    endValue: _endValue,
                    customVideoFormat: '.mp4',
                    ffmpegCommand: '-qscale "0"',
                  )
                      .then((path) {
                    cropLoadingCancel();
                    Get.to(VideoAdvancePage(file: File(path)));
                  });
                },
                color: Color(0xFFFA3B3E),
              ),
            ),
          ),
          SizedBox(width: rSize(15)),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: VideoViewer(),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: rSize(35)),
                  child: TrimEditor(
                    viewerWidth: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    viewerHeight: rSize(68),
                    onChangeStart: (value) {
                      _startValue = value;
                    },
                    onChangeEnd: (value) {
                      _endValue = value;
                    },
                    onChangePlaybackState: (value) {
                      setState(() {
                        _isPlaying = value;
                      });
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
