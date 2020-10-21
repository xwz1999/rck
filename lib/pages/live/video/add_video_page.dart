import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/main.dart';
import 'package:recook/pages/live/video/crop_video_page.dart';
import 'package:recook/pages/live/video/video_advance_page.dart';
import 'package:recook/pages/live/widget/local_file_video.dart';
import 'package:recook/pages/live/widget/video_record_button.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/custom_image_button.dart';

class AddVideoPage extends StatefulWidget {
  AddVideoPage({Key key}) : super(key: key);

  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  bool frontCam = false;
  CameraController _cameraController;
  File _tempFile;
  bool _videoDone = false;
  int _startDate = 0;

  @override
  void initState() {
    super.initState();
    getTemporaryDirectory().then((dirPath) {
      _tempFile = File(join(dirPath.path, 'tempRecord.mp4'));
      print(_tempFile.path);
      if (_tempFile.existsSync()) {
        _tempFile.deleteSync();
      }
    });
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: true,
    );
    _cameraController.initialize().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF232323),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            child: !_cameraController.value.isInitialized
                ? Container(
                    child: Text('相机加载中'),
                  )
                : _videoDone
                    ? LocalFileVideo(
                        file: _tempFile,
                        aspectRatio: _cameraController.value.aspectRatio,
                      )
                    : AspectRatio(
                        aspectRatio: _cameraController.value.aspectRatio,
                        child: CameraPreview(_cameraController),
                      ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            child: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            right: 0,
            top: MediaQuery.of(context).padding.top + rSize(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MaterialButton(
                  minWidth: rSize(60),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _flipCamera();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        R.ASSETS_LIVE_FLIP_CAM_PNG,
                        height: rSize(24),
                        width: rSize(24),
                      ),
                      SizedBox(height: rSize(6)),
                      Text(
                        '翻转',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: rSP(11),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: rSize(30)),
                MaterialButton(
                  minWidth: rSize(60),
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        R.ASSETS_LIVE_COUNT_DOWN_PNG,
                        height: rSize(24),
                        width: rSize(24),
                      ),
                      SizedBox(height: rSize(6)),
                      Text(
                        '倒计时',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: rSP(11),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: rSize(52),
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: rSize(72),
                  child: _videoDone
                      ? MaterialButton(
                          child: Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _tempFile.deleteSync();
                            setState(() {
                              _videoDone = false;
                            });
                          },
                        )
                      : SizedBox(),
                ),
                VideoRecordButton(
                  disabled: _videoDone,
                  onEnd: () {
                    if ((DateTime.now().millisecondsSinceEpoch - _startDate) >
                        1000) {
                      _cameraController.stopVideoRecording();
                      setState(() {
                        _videoDone = true;
                      });
                    } else {
                      Future.delayed(Duration(seconds: 1), () {
                        _cameraController.stopVideoRecording();
                      });
                    }
                  },
                  onStart: () {
                    _startDate = DateTime.now().millisecondsSinceEpoch;
                    _cameraController.startVideoRecording(_tempFile.path);
                  },
                ),
                SizedBox(
                  width: rSize(72),
                  child: _videoDone
                      ? MaterialButton(
                          color: Color(0xFFFA3B3E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(rSize(17)),
                          ),
                          onPressed: () {
                            CRoute.pushReplace(
                                context, VideoAdvancePage(file: _tempFile));
                          },
                          child: Text('确定'),
                        )
                      : CustomImageButton(
                          onPressed: () {
                            ImagePicker()
                                .getVideo(source: ImageSource.gallery)
                                .then((file) {
                              if (file == null ||
                                  TextUtils.isEmpty(file.path)) {
                                showToast('没有选择文件');
                              } else {
                                CRoute.pushReplace(
                                  context,
                                  CropVideoPage(file: File(file.path)),
                                );
                              }
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                R.ASSETS_LIVE_VIDEO_UPLOAD_PNG,
                                height: rSize(40),
                                width: rSize(40),
                              ),
                              Text(
                                '上传',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: rSP(11),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _flipCamera() {
    _cameraController?.dispose()?.then((value) {
      _cameraController = CameraController(
        frontCam ? cameras[1] : cameras[0],
        ResolutionPreset.medium,
        enableAudio: true,
      );
      _cameraController.initialize().then((_) {
        if (mounted) setState(() {});
        frontCam = !frontCam;
      });
    });
  }
}
