/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-13  09:18 
 * remark    : 
 * ====================================================
 */

// import 'package:flutter_bugly/flutter_bugly.dart';

// import 'package:recook/constants/header.dart';
// import 'package:recook/manager/user_manager.dart';
//
// class BuglyHelper {
//   // static const String appid_ios = "b7f6f8aee0";
//   static const String appid_ios = "0cd2144148";
//   // static const String appid_android = "c1c7069a32";
//   static const String appid_android = "706b9847d9";
//   static String platformVersion;
//   static initialSDK() async {
//     FlutterBugly.init(
//             androidAppId: appid_android,
//             iOSAppId: appid_ios,
//             initDelay: 1,
//             autoDownloadOnWifi: true)
//         .then((result) {
//       if (result.isSuccess) {
//         DPrint.printf("bugly 初始化成功");
//         platformVersion = result.message;
//         return;
//       }
//       DPrint.printf("bugly 初始化失败, ${result.message}");
//     });
//   }
//
//   static setUserInfo() {
//     if (UserManager.instance.user == null) DPrint.printf("请先登录再设置buglyID");
//     if (UserManager.instance.haveLogin) {
//       FlutterBugly.setUserId(UserManager.instance.user.info.id.toString());
//       FlutterBugly.putUserData(
//         key: "nickname",
//         value: TextUtils.isEmpty(UserManager.instance.user.info.nickname)
//           ? UserManager.instance.user.info.mobile
//           : UserManager.instance.user.info.nickname
//       );
//     }
//     // FlutterBugly.setUserTag(AppConfig.debug ? 0:1111);
//     // FlutterBugly.setUserId(UserManager.instance.user.info.id.toString());
//     // FlutterBugly.putUserData(
//     //     key: "nickname",
//     //     value: TextUtils.isEmpty(UserManager.instance.user.info.nickname)
//     //         ? UserManager.instance.user.info.mobile
//     //         : UserManager.instance.user.info.nickname);
//   }
// }
