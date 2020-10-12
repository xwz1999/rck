import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:tencent_live_fluttify/tencent_live_fluttify.dart';
import 'package:image_picker/image_picker.dart';

class LivePage extends StatefulWidget {
  LivePage({Key key}) : super(key: key);

  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  LivePusher _livePusher;
  File _imageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _livePusher?.stopPush();
    _livePusher?.stopPreview();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          CloudVideo(
            onCloudVideoCreated: (controller) async {
              _livePusher = await LivePusher.create();
              _livePusher.startPreview(controller);
            },
          ),
          Positioned(
            right: rSize(85),
            left: rSize(85),
            bottom: rSize(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                      height: rSize(68),
                      minWidth: rSize(68),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      child: _imageFile == null
                          ? Icon(Icons.camera_alt)
                          : Image.file(
                              _imageFile,
                              height: rSize(68),
                              width: rSize(68),
                              fit: BoxFit.cover,
                            ),
                      color: Colors.black.withOpacity(0.25),
                      onPressed: () {
                        ActionSheet.show(
                          context,
                          items: ['相机', '相册'],
                          listener: (index) {
                            Future<PickedFile> getImage() {
                              if (index == 0)
                                return ImagePicker()
                                    .getImage(source: ImageSource.camera);
                              if (index == 1)
                                return ImagePicker()
                                    .getImage(source: ImageSource.gallery);
                              return null;
                            }

                            getImage().then((pickedFile) {
                              if (pickedFile != null)
                                _imageFile = File(pickedFile.path);
                              setState(() {});
                            });
                          },
                        );
                      },
                    ),
                    rWBox(15),
                    Column(
                      children: [
                        Text(''),
                        MaterialButton(
                          color: Colors.transparent,
                          child: Text('选择话题'),
                          onPressed: () {},
                          elevation: 0,
                        ),
                      ],
                    ),
                  ],
                ),
                rHBox(28),
                FlatButton(
                  height: rSize(40),
                  onPressed: () {
                    _livePusher.startPush(
                        'rtmp://livepush.reecook.cn/live/recook_1?txSecret=9eab277c32fd7a1d8e1d7867dda0740b&txTime=5F83F127');
                  },
                  child: Text(
                    '开始直播',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: rSP(18),
                    ),
                  ),
                  color: Color(0xFFDB2D2D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(rSize(20)),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: FlatButton(
              onPressed: () {
                _livePusher.switchCamera();
              },
              child: Text('test'),
            ),
          ),
        ],
      ),
    );
  }
}
