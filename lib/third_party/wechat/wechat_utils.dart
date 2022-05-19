/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/7/1  5:08 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:core';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:fluwx/fluwx.dart';
import 'package:recook/constants/config.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/utils/user_Authority_util.dart';
import 'package:recook/widgets/toast.dart';

typedef WXLoginListener = Function(WXLoginResult result);

class WXLoginResult {
  final int type;
  final int errCode;
  final String errStr;
  final String androidOpenId;
  final String iOSDescription;
  final String country;
  final String lang;
  final String code;
  final String androidUrl;
  final String state;
  final String androidTransaction;

  WXLoginResult(
      {this.errStr,
      this.type,
      this.errCode,
      this.androidOpenId,
      this.iOSDescription,
      this.country,
      this.lang,
      this.code,
      this.androidUrl,
      this.state,
      this.androidTransaction});
}

class WXPayResult {
  final String errStr;
  final int type;
  final int errCode;
  final String androidOpenId;
  final String iOSDescription;
  final String androidPrepayId;
  final String extData;
  final String androidTransaction;

  WXPayResult(
      {this.errStr,
      this.type,
      this.errCode,
      this.androidOpenId,
      this.iOSDescription,
      this.androidPrepayId,
      this.extData,
      this.androidTransaction});
}

class WeChatUtils {
  static bool isInstall = false;

  static initial() async {
    await fluwx
        .registerWxApi(
            appId: AppConfig.WX_APP_ID,
            doOnAndroid: true,
            doOnIOS: true,
            universalLink: "https://reecook.cn/recook/")
        .then((onValue) {
      DPrint.printf("微信registr $onValue");
    });
    var result = await fluwx.isWeChatInstalled;
    isInstall = result;
    DPrint.printf("wechat install $result");
  }

  static shareUrl({
    String url,
    String title,
    String assetsThumbnail,
    String netWorkThumbnail,
    String description,
    fluwx.WeChatScene scene = fluwx.WeChatScene.SESSION,
  }) {
    //2.0
    var model = fluwx.WeChatShareWebPageModel(
      url,
      thumbnail: !TextUtils.isEmpty(netWorkThumbnail)
          ? fluwx.WeChatImage.network(netWorkThumbnail)
          : !TextUtils.isEmpty(assetsThumbnail)
              ? fluwx.WeChatImage.asset(assetsThumbnail)
              : null,
      title: title,
      scene: scene,
      description: description,
    );
    fluwx.shareToWeChat(model);
  }

  static Future<Uint8List> compressList(Uint8List list) async {
    ///小程序分享的图片限制在128kb
    int quality = 100;
    if(list.lengthInBytes/1024 <128){
      return list;
    }else {
      quality =  (128/(list.lengthInBytes/1024)*100).toInt();

      print(quality);

      var result = await FlutterImageCompress.compressWithList(
        list,
        minHeight: 400,
        minWidth: 500,
        quality: quality,
      );
      print(list.length);
      print(result.length);
      return Uint8List.fromList(result)  ;
    }
  }


  static miniProgramShare({
    String userName,
    String id,
    String netWorkThumbnail,
    String des,
  }) async {



      ///专程
      var response = await Dio().get(
          netWorkThumbnail,
          options: Options(responseType: ResponseType.bytes));


      Uint8List list = await compressList(Uint8List.fromList(response.data));



    var model = fluwx.WeChatShareMiniProgramModel(
      userName: 'gh_530bd0866836',
      webPageUrl: 'https://mallh5.reecook.cn/',
        miniProgramType: AppConfig.debug ? WXMiniProgramType.PREVIEW:fluwx.WXMiniProgramType.RELEASE,
      path:
          'pages/goodsDetail/goodsDetail?type=share&id=$id&invite=${UserManager.instance.user.info.invitationNo}',
      thumbnail: fluwx.WeChatImage.binary(list),
      compressThumbnail:false,
      title: des,
    );
    print('${UserManager.instance.user.info.invitationNo}'+'-----$id');
    fluwx.shareToWeChat(model);
  }



  static miniProgramBugCard({
    String userName,
    String id,
    String netWorkThumbnail,
    String des,
  }) {
    // String qrCode =
    //     "${AppConfig.debug ? WebApi.testGoodsDetail : WebApi.goodsDetail}$id/${UserManager.instance.user.info.invitationNo}";
    var model = fluwx.WeChatShareMiniProgramModel(
      userName: AppConfig.WX_APP_MINIPRO_USERNAME,
      webPageUrl: 'https://mallh5.reecook.cn/',
      path:
      'pages/vip/vipBuy?type=share&invite=${UserManager.instance.user.info.invitationNo}',
      thumbnail: fluwx.WeChatImage.network(netWorkThumbnail),
      title: des,
      compressThumbnail: false,
      miniProgramType: WXMiniProgramType.RELEASE,
    );
    print('${UserManager.instance.user.info.invitationNo}');
    fluwx.shareToWeChat(model);
  }





  static miniProgramShareLive({
    String userName,
    int id,
    String netWorkThumbnail,
    String des,
    int isLive,
  }) {
    // String qrCode =
    //     "${AppConfig.debug ? WebApi.testGoodsDetail : WebApi.goodsDetail}$id/${UserManager.instance.user.info.invitationNo}";

    var model = fluwx.WeChatShareMiniProgramModel(
      userName: 'gh_530bd0866836',
      webPageUrl: 'https://mallh5.reecook.cn/',
      path:
      '/packageA/livePlayback/livePlayback?id=' + '$id' + "&isLive=1",
      thumbnail: fluwx.WeChatImage.network(netWorkThumbnail),
      title: des,
    );
    fluwx.shareToWeChat(model);
  }

  static shareGoodsForMiniProgram({
    int goodsId,
    String title,
    String thumbnail,
  }) {
    if (UserAuthorityUtil().showNeedLoginToast()) {
      return;
    }

    var invitationNo = UserManager.instance.user.info.invitationNo ?? '';
    fluwx.WXMiniProgramType _wxType = fluwx.WXMiniProgramType.PREVIEW;
    if (!AppConfig.debug) {
      _wxType = fluwx.WXMiniProgramType.RELEASE;
    }
    var userId = UserManager.instance.user.info.id;
    var model = fluwx.WeChatShareMiniProgramModel(
      path:
          "pages/goods/detail?goods_id=$goodsId&code=$invitationNo&userId=$userId",
      webPageUrl: "reecook.cn",
      miniProgramType: _wxType,
      userName: AppConfig.WX_APP_MINIPRO_USERNAME,
      // scene: fluWX.WeChatScene.SESSION,
      title: title,
      description: "",
      thumbnail: fluwx.WeChatImage.network(thumbnail),
      // thumbnail: thumbnail,
    );
    fluwx.shareToWeChat(model);
    // fluWX.share(model);
  }

  static shareMiniProgram({
    String path,
    String webPageUrl,
    String title,
    String description,
    String thumbnail,
  }) {
    fluwx.WXMiniProgramType _wxType = fluwx.WXMiniProgramType.PREVIEW;
    if (!AppConfig.debug) {
      _wxType = fluwx.WXMiniProgramType.RELEASE;
    }
    var model = fluwx.WeChatShareMiniProgramModel(
      path: path,
      webPageUrl: webPageUrl,
      miniProgramType: _wxType,
      userName: AppConfig.WX_APP_MINIPRO_USERNAME,
      // scene: fluWX.WeChatScene.SESSION,
      title: title,
      description: description,
      thumbnail: fluwx.WeChatImage.network(thumbnail),
      // thumbnail: thumbnail,
    );
    // fluWX.share(model);
    fluwx.shareToWeChat(model);
  }

  static wxLogin(Function(WXLoginResult result) listener) {
    // 会调用多次
    fluwx.weChatResponseEventHandler.distinct((a, b) => a == b).listen((data) {
      if (data is fluwx.WeChatAuthResponse) {
        DPrint.printf(
            "微信登录 errCode------------- ${data.errCode} - ${data.errStr}");
        WXLoginResult result = WXLoginResult(
          type: data.type,
          errCode: data.errCode,
          errStr: data.errStr,
          // androidOpenId: data.androidOpenId,
          // iOSDescription: data.iOSDescription,
          country: data.country,
          lang: data.lang,
          code: data.code,
          // androidUrl: data.androidUrl,
          // androidTransaction: data.androidTransaction,
          state: data.state,
        );
        listener(result);
      }
    });

    fluwx
        .sendWeChatAuth(
            scope: "snsapi_userinfo", state: "wechat_sdk_demo_reecook")
        .then((data) {});
  }

  static pay(
      {@required String appId,
      @required String partnerId,
      @required String prepayId,
      @required String packageValue,
      @required String nonceStr,
      @required int timeStamp,
      @required String sign,
      String signType,
      String extData,
      Function(WXPayResult result) listener}) {
    print("appId-------- $appId");
    print("-partnerId------- $partnerId");
    print("prepayId-------- $prepayId");
    print("packageValue-------- $packageValue");
    print("nonceStr-------- $nonceStr");
    print("timeStamp-------- $timeStamp");
    print("signType-------- $signType");
    print("extData-------- $extData");
    print("sign-------- $sign");

    fluwx.weChatResponseEventHandler.distinct((a, b) => a == b).listen((data) {
      if (data is fluwx.WeChatPaymentResponse) {
        if (listener == null) return;
        listener(WXPayResult(
          errCode: data.errCode,
          errStr: data.errStr,
          type: data.type,
        ));
      }
    });
    fluwx.isWeChatInstalled.then((install) {
      if (!install) {
        Toast.showInfo("未安装微信");
        return;
      }
      fluwx.payWithWeChat(
          appId: appId,
          partnerId: partnerId,
          prepayId: prepayId,
          packageValue: packageValue,
          nonceStr: nonceStr,
          timeStamp: timeStamp,
          signType: "MD5",
          sign: sign);
    });
  }
}
