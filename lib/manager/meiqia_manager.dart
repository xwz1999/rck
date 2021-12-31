/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-09  15:29 
 * remark    : 
 * ====================================================
 */


// import 'package:meiqia_flutter/meiqia_flutter.dart';
import 'package:jingyaoyun/constants/header.dart';

class MQManager {
  static const String appKey = "0aff2f19280aa0c2dfa2cc12425a71fd";

  static initial() {
    // MeiqiaFlutter.initMeiqia(
    //   appKey
    // );
    // MeiqiaPlugin.initMeiQia
    //   (appKey,success: (code,msg) {
    //   DPrint.printf("美洽注册成功");
    //
    // },failure: (code,msg) {
    //   DPrint.printf("美洽注册失败 --- $msg");
    // });
  }

  static goToChat({String userId, Map userInfo,String goodsName,String goodsUrl}) {
    // MeiqiaFlutter.chat(customId: userId,clientInfo: userInfo,preTxt:goodsName,prePicPath: goodsUrl);
    //MeiqiaPlugin.chat(userInfo: userInfo,userID: userId);
  }
}
