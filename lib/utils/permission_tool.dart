import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

class PermissionTool {
  static Future<bool> haveCameraPermission() async {
    bool permission = await Permission.camera.isGranted;
    if (!permission) {
      Permission.camera.request().then((value) => permission = value.isGranted);
    }
    return permission;
  }

  static Future<bool> havePhotoPermission() async {
    bool permission = await Permission.photos.isGranted;
    if (!permission) {
      Permission.photos.request().then((value) => permission = value.isGranted);
    }
    return permission;
  }

  static Future<bool> haveAudioPermission() async {
    bool permission = await Permission.microphone.isGranted;
    if (!permission) {
      Permission.microphone.request().then((value) => permission = value.isGranted);
    }
    return permission;
  }

  static showOpenPermissionDialog(BuildContext context, String message,
      {Function open}) {
    showCupertinoDialog<int>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("权限"),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("去开启"),
                onPressed: () async {
                  if (open != null) {
                    open();
                  } else {
                    bool isOpened = await openAppSettings();
                  }
                },
              ),
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {},
              ),
            ],
          );
        });
  }
}
