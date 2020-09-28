import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/main.dart';
import 'package:recook/pages/live/widget/video_record_button.dart';

class AddVideoPage extends StatefulWidget {
  AddVideoPage({Key key}) : super(key: key);

  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  bool frontCam = false;
  CameraController _cameraController;

  @override
  void initState() {
    super.initState();
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VideoRecordButton(),
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
