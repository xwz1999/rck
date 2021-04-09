import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

class PermissionTool {
  static Future<bool> haveCameraPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    if (permissions[PermissionGroup.camera] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> havePhotoPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.photos]);
    if (permissions[PermissionGroup.photos] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> haveAudioPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.microphone]);
    if (permissions[PermissionGroup.microphone] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
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
                    bool isOpened = await PermissionHandler().openAppSettings();
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
