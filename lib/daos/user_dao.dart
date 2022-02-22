/*
 * ====================================================
 * package   : daos
 * author    : Created by nansi.
 * time      : 2019/5/22  1:18 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/constants/config.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/user_model.dart';

class UserDao {
  static final String openIdUrl =
      "https://api.weixin.qq.com/sns/oauth2/access_token";

  /*
    获取access_token 和 openid
   */
  static Future<Map> getOpenId(code) async {
    String url =
        "$openIdUrl?appid=${AppConfig.WX_APP_ID}&secret=${AppConfig.WX_APP_SECRET}&code=$code&grant_type=authorization_code";
    Response res = await HttpManager.netFetchNormal(url, null, null, null);
    Map map = json.decode(res.toString());
    return map;
  }

  /*
    微信登录
   */
  static weChatLogin(String code,
      {@required OnSuccess<User> success, @required OnFailure failure}) async {
    ResultData res = await HttpManager.post(UserApi.wx_login, {"code": code});
    if (!res.result) {
      failure(res.code, res.msg);
    } else {
      UserModel model = UserModel.fromJson(res.data);
      if (model.code == HttpStatus.SUCCESS) {
        success(model.data, model.code, model.msg);
      } else {
        failure(model.code, model.msg);
      }
    }
  }

  /*
    微信注册
   */
  static weChatRegister(String wxUnionId, String mobile, String sms,
      {@required OnSuccess<User> success, @required OnFailure failure}) async {
    // ResultData res = await HttpManager.post(
    //     UserApi.wx_register, {"wxUnionId":wxUnionId,"mobile":mobile,"sms":sms,"invitationNo":invitationNo.toUpperCase()});
    ResultData res = await HttpManager.post(UserApi.wx_register,
        {"wxUnionId": wxUnionId, "mobile": mobile, "sms": sms});
    if (!res.result) {
      failure(res.code, res.msg);
    } else {
      UserModel model = UserModel.fromJson(res.data);
      if (model.code == HttpStatus.SUCCESS) {
        success(model.data, model.code, model.msg);
      } else {
        failure(model.code, model.msg);
      }
    }
  }

  /*
    微信注册
   */
  static weChatInvitation(String wxUnionId, String invitationNo,
      {@required OnSuccess<User> success, @required OnFailure failure}) async {
    // ResultData res = await HttpManager.post(
    //     UserApi.wx_register, {"wxUnionId":wxUnionId,"mobile":mobile,"sms":sms,"invitationNo":invitationNo.toUpperCase()});
    ResultData res = await HttpManager.post(UserApi.wx_invitation,
        {"wxUnionId": wxUnionId, });
    if (!res.result) {
      failure(res.code, res.msg);
    } else {
      UserModel model = UserModel.fromJson(res.data);
      if (model.code == HttpStatus.SUCCESS) {
        success(model.data, model.code, model.msg);
      } else {
        failure(model.code, model.msg);
      }
    }
  }

  /*
    获取验证码
   */
  static sendSmsCode(String phone,
      {@required OnSuccess<BaseModel> success,
      @required OnFailure failure}) async {
    ResultData res =
        await HttpManager.post(UserApi.phone_login_send_sms, {"mobile": phone});

    if (!res.result) {
      failure(res.code, res.msg);
    } else {
      BaseModel model = BaseModel.fromJson(res.data);
      if (model.code == HttpStatus.SUCCESS) {
        success(model, model.code, model.msg);
      } else {
        failure(HttpStatus.FAILURE, model.msg);
      }
    }
  }

  /*
    获取验证码 升级
   */
  static sendCode(String phone,
      {@required OnSuccess<BaseModel> success,
        @required OnFailure failure}) async {
    ResultData res =
    await HttpManager.post(APIV2.userAPI.sendRecommendCode, {"mobile": phone});

    if (!res.result) {
      failure(res.code, res.msg);
    } else {
      BaseModel model = BaseModel.fromJson(res.data);
      if (model.code == HttpStatus.SUCCESS) {
        success(model, model.code, model.msg);
      } else {
        failure(HttpStatus.FAILURE, model.msg);
      }
    }
  }

  /*
   * 手机登录
   */
  static phoneLogin(String phone, String smsCode,
      {@required OnSuccess<User> success, @required OnFailure failure}) async {
    ResultData res = await HttpManager.post(
        UserApi.phone_login, {"mobile": phone, "sms": smsCode});

    if (!res.result) {
      failure(res.code, res.msg);
    } else {
      UserModel model = UserModel.fromJson(res.data);
      if (model.code == HttpStatus.SUCCESS) {
        success(model.data, model.code, model.msg);
      } else {
        failure(model.code, model.msg);
      }
    }
  }


  /*
   * 账号
   */
  static accountLogin(String name, String password,
      {@required OnSuccess<User> success, @required OnFailure failure}) async {
    ResultData res = await HttpManager.post(
        UserApi.account_login, {"name": name, "password": password});

    if (!res.result) {
      failure(res.code, res.msg);
    } else {
      UserModel model = UserModel.fromJson(res.data);
      if (model.code == HttpStatus.SUCCESS) {
        success(model.data, model.code, model.msg);
      } else {
        failure(model.code, model.msg);
      }
    }
  }

  /*
    自动登录
   */
  // static autoLogin(Map<String, String> header,
  //     {@required OnSuccess<User> success, @required OnFailure failure}) async {
  //   ResultData res =
  //       await HttpManager.post(UserApi.auto_login, {}, header: header);
  /*无效代码*/
  // static autoLogin(Map<String, dynamic> params,
  //     {@required OnSuccess<User> success, @required OnFailure failure}) async {
  //   ResultData res = await HttpManager.post(
  //     UserApi.auto_login,
  //     params,
  //   );
  //   if (!res.result) {
  //     failure(res.code, res.msg);
  //   } else {
  //     UserModel model = UserModel.fromJson(res.data);
  //     if (model.code == HttpStatus.SUCCESS) {
  //       success(model.data, model.code, model.msg);
  //     } else {
  //       failure(model.code, model.msg);
  //     }
  //   }
  // }

  /*
    自动登录
   */
  // static autoLogin(Map<String, String> header,
  //     {@required OnSuccess<User> success, @required OnFailure failure}) async {
  //   ResultData res =
  //       await HttpManager.post(UserApi.auto_login, {}, header: header);
  static launch(Map<String, dynamic> params,
      {@required OnSuccess success, @required OnFailure failure}) async {
    ResultData res = await HttpManager.post(
      UserApi.launch,
      params,
    );
    if (!res.result) {
      failure(res.code, res.msg);
    } else {
      BaseModel model = BaseModel.fromJson(res.data);
      if (model.code == HttpStatus.SUCCESS) {
        success(res.data['data'], model.code, model.msg);
      } else {
        failure(model.code, model.msg);
      }
    }
  }

  /*
    手机注册
   */
  static phoneRegister(String phone, String invitationNo,
      {@required OnSuccess<User> success, @required OnFailure failure}) async {
    ResultData res = await HttpManager.post(UserApi.phone_register,
        {"mobile": phone, });

    if (!res.result) {
      failure(res.code, "网络错误");
    } else {
      UserModel model = UserModel.fromJson(res.data);
      if (model.code == HttpStatus.SUCCESS) {
        success(model.data, model.code, model.msg);
      } else {
        failure(model.code, model.msg);
      }
    }
  }
}
