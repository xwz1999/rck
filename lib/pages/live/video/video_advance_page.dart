import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/live/video/upload_video_page.dart';
import 'package:recook/pages/live/widget/local_file_video.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:image_picker/image_picker.dart';

class VideoAdvancePage extends StatefulWidget {
  final File file;
  VideoAdvancePage({Key key, @required this.file}) : super(key: key);

  @override
  _VideoAdvancePageState createState() => _VideoAdvancePageState();
}

class _VideoAdvancePageState extends State<VideoAdvancePage> {
  File _coverFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF232323),
      appBar: AppBar(
        leading: RecookBackButton(white: true),
        backgroundColor: Color(0xFF232323),
        actions: [
          Center(
            child: MaterialButton(
              child: Text('确定'),
              height: rSize(28),
              minWidth: rSize(72),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(rSize(14)),
              ),
              onPressed: () {
                if (_coverFile == null) {
                  GSDialog.of(context).showError(context, '未选择封面');
                } else {
                  CRoute.pushReplace(
                    context,
                    UploadVideoPage(
                      videoFile: widget.file,
                      coverImageFile: _coverFile,
                    ),
                  );
                }
              },
              color: Color(0xFFFA3B3E),
            ),
          ),
          SizedBox(width: rSize(15)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: LocalFileVideo(file: widget.file),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: rSize(45),
              vertical: rSize(35),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  '封面',
                  () {
                    ImagePicker()
                        .getImage(source: ImageSource.gallery)
                        .then((file) {
                      if (file != null) {
                        _coverFile = File(file.path);
                      }
                    });
                  },
                  icon: Image.asset(
                    R.ASSETS_LIVE_COVER_PNG,
                    height: rSize(24),
                    width: rSize(24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildButton(
    String title,
    VoidCallback onTap, {
    String path,
    Widget icon,
  }) {
    return CustomImageButton(
      onPressed: onTap,
      child: Column(
        children: [
          icon ??
              Image.asset(
                path,
                height: rSize(24),
                width: rSize(24),
              ),
          SizedBox(height: rSize(10)),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: rSP(11),
            ),
          ),
        ],
      ),
    );
  }
}
