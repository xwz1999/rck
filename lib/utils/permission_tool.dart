import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recook/widgets/alert.dart';


class PermissionTool {
  static Future<bool> haveLocationPermission() async {
    bool permission = await Permission.location.isGranted;
    if (!permission) {
      await Permission.location.request();
      permission = await Permission.location.isGranted;
    }
    return permission;
  }

  static Future<bool> haveCameraPermission() async {
    bool permission = await Permission.camera.isGranted;
    if (!permission) {
      await Permission.camera.request();
      permission = await Permission.camera.isGranted;
    }
    return permission;
  }

  static Future<bool> haveStoragePermission() async {
    bool permission = await Permission.storage.isGranted;
    if (!permission) {
      await Permission.storage.request();
      permission = await Permission.storage.isGranted;
    }
    return permission;
  }

  static Future<bool> haveNotificationPermission() async {
    bool permission = await Permission.notification.isGranted;
    if (!permission) {
      await Permission.notification.request();
      permission = await Permission.notification.isGranted;
    }
    return permission;
  }

  static Future<bool> havePhotoPermission() async {
    bool permission = await Permission.storage.isGranted;
    if (!permission) {
      await Permission.storage.request();
      permission = await Permission.storage.isGranted;
    }
    return permission;
  }

  static Future<bool> haveAudioPermission() async {
    bool permission = await Permission.microphone.isGranted;
    if (!permission) {
      await Permission.microphone.request();
      permission = await Permission.microphone.isGranted;
    }
    return permission;
  }

  static Future<bool> haveContactPermission() async {
    bool permission = await Permission.contacts.isGranted;
    if (!permission) {
      await Permission.contacts.request();
      permission = await Permission.contacts.isGranted;
    }
    return permission;
  }

  static showOpenPermissionDialog(BuildContext context, String message,
      {Function? open ,String? title}) {
    Alert.show(
        context,
        NormalTextDialog(
          title: title!=null?title:'权限申请',
          type: NormalTextDialogType.delete,
          content: message,
          items: ["取消"],
          listener: (index) {
            Alert.dismiss(context);
            //Toast.showInfo('如果您后续需要接收消息通知，可在设置里打开');
          },
          deleteItem: "去开启",
          deleteListener: () async {
            Alert.dismiss(context);
            await openAppSettings();
          },
        ));

    // showCupertinoDialog<int>(
    //     context: context,
    //     builder: (context) {
    //       return CupertinoAlertDialog(
    //         title: Text("权限"),
    //         content: Text(message),
    //         actions: <Widget>[
    //           CupertinoDialogAction(
    //             child: Text("去开启"),
    //             onPressed: () async {
    //               if (open != null) {
    //                 open();
    //               } else {
    //                 bool isOpened = await openAppSettings();
    //               }
    //             },
    //           ),
    //           CupertinoDialogAction(
    //             child: Text("取消"),
    //             onPressed: () {
    //               Get.back();
    //             },
    //           ),
    //         ],
    //       );
    //     });
  }
}
