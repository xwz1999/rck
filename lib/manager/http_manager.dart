/*
 * ====================================================
 * package   : manager
 * author    : Created by nansi.
 * time      : 2019/5/20  10:23 AM 
 * remark    : 
 * ====================================================
 */

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:power_logger/power_logger.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/config.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/image_upload_model.dart';
import 'package:recook/models/media_model.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/utils/print_util.dart';
import 'package:recook/utils/sc_encrypt_util.dart';

typedef OnSuccess<T> = Function(T data, String code, String msg);
typedef OnFailure = Function(String code, String msg);

class HttpCode {
  static const SUCCESS = 1000;
  static const FAILURE = 999;
  static const ERROR = -1;
}

class HttpStatus {
  static const SUCCESS = "SUCCESS";
  static const FAILURE = "FAIL";
  static const UNAUTHORIZED = "UNAUTHORIZED"; //登录失效
  static const ERROR = "ERROR";
}

class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
  static Map optionParams = {
    "timeoutMs": 15000,
    "token": null,
    "authorizationCode": null,
  };

  static Future<Null> uploadFiles(
      {url = CommonApi.upload, List<MediaModel> medias, key = "photo"}) async {
    FutureGroup group = FutureGroup();
    medias.forEach((media) {
      group.add(uploadFile(url: url, file: media.file, key: key).then((result) {
        media.result = result;
      }));
    });
    group.close();
    await group.future;
    return null;
  }

  static Future<UploadResult> uploadFile({url, File file, key}) async {
    Map<String, dynamic> header = Map();
    if (UserManager.instance.user.auth != null) {
      header.putIfAbsent(
          "X-Recook-ID", () => UserManager.instance.user.auth.id.toString());
      header.putIfAbsent(
          "X-Recook-Token", () => UserManager.instance.user.auth.token);
    }
    Dio dio = new Dio();
    dio.options.baseUrl = Api.host;
    dio.options.headers = header;

    var result = await ImageUtils.compressImageWithBytes(
      file.absolute.path,
      quality: 60,
    );
    print("原大小: " +
        file.lengthSync().toString() +
        "------- 压缩后大小: " +
        result.length.toString());

    // FormData formData =
    //     new FormData.from({key: new UploadFileInfo.fromBytes(result, basename(file.path))});
    FormData formData = new FormData.fromMap({
      key: new MultipartFile.fromBytes(result, filename: basename(file.path))
    });
    Response response = await dio.post(url, data: formData);
    DPrint.printf("上传返回 ==== ${response.toString()}");

    ResultData resultData = _handleResponse(response.toString());
    if (!resultData.result) {
      return UploadResult(false, resultData.msg, "");
    }
    ImageUploadModel model = ImageUploadModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      return UploadResult(false, model.msg, "");
    }
    return UploadResult(true, resultData.msg, model.data.url);
  }

  static Future<ResultData> post(url, params,
      {Map<String, String> header, Options option, noTip = false}) async {
    if (option != null) {
      option.method = "post";
    } else {
      // option = new Options(method: "post", connectTimeout: 5000);
      option =
          new Options(method: "post", sendTimeout: 5000, receiveTimeout: 5000);
    }

    if (header == null) {
      header = Map<String, String>();
    }
    header.putIfAbsent(
        "X-Recook-System", () => Platform.isIOS ? "ios" : "android");
    header.putIfAbsent("X-Recook-version", () => "${AppConfig.versionNumber}");
    if (UserManager.instance.user.auth != null) {
      header.putIfAbsent(
          "X-Recook-ID", () => UserManager.instance.user.auth.id.toString());
      header.putIfAbsent(
          "X-Recook-Token", () => UserManager.instance.user.auth.token);
    }
    header.putIfAbsent('Device-Type', () => Platform.isIOS ? "ios" : "android");
    DPrint.printf(header);
    return await netFetch(url, params, header, option);
  }

  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  ///[ option] 配置
  static Future<ResultData> netFetch(
      url, params, Map<String, String> header, Options option,
      {noTip = false}) async {
    Map<String, String> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    if (option != null) {
      option.headers = headers;
    } else {
      option = new Options(
        method: "post",
        receiveTimeout: 5000,
        sendTimeout: 5000,
      );
      option.headers = headers;
    }

    Dio dio = new Dio();

    dio.options.baseUrl = Api.host;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    dio.options.method = "POST";

    // https 关闭证书验证
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };

    Response response;
    Map encryptParams = params;
//    if (AppConfig.needEncrypt) {
    encryptParams = await paramsEncrypt(params: params);
//    }
    DPrint.printf(params);
    DPrint.printf(encryptParams);
    try {
      response =
          await dio.request<String>(url, data: encryptParams, options: option);
    } on DioError catch (e) {
      LoggerData.addData(e);
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(
            statusCode: 666, requestOptions: RequestOptions(path: ''));
      }
      if (e.type == DioErrorType.connectTimeout) {
        errorResponse.statusCode = HttpCode.ERROR;
      }
      if (AppConfig.debug) {
        print('❌❌❌❌请求异常: ' + e.toString());
        print('请求异常url: ' + Api.host + url);
      }
      return new ResultData(null, false, HttpStatus.ERROR, "您的网络出小差了，\n请稍后再试");
      // return new ResultData(null, false, HttpStatus.ERROR, "网络崩溃了");
//      return new ResultData(null, false, HttpStatus.ERROR, "请求出错，请稍后再试");
    }
    LoggerData.addData((response)..requestOptions.data = params);
    String responseStr = response.data;
    if (AppConfig.needEncrypt) {
      responseStr = await responseDecrypt(response.data);
    }

    if (AppConfig.debug) {
      DPrint.printf('请求url: ---- ' + Api.host + url);
      DPrint.printf('请求头: ---- ' + option.headers.toString());
      if (params != null) {
        DPrint.printf('请求参数: ' + json.encode(params));
        DPrint.printf('请求加密参数: ' + json.encode(encryptParams));
      }
      if (response != null) {
        DPrint.printf('返回reponse: ---- ' + response.data);
        if (AppConfig.needEncrypt) {
          DPrint.printLongJson('解密返回reponse: ---- ' + responseStr);
        }
      }
      if (optionParams["authorizationCode"] != null) {
        DPrint.printf(
            'authorizationCode: ' + optionParams["authorizationCode"]);
      }
    }

    return _handleResponse(responseStr);
  }

  static ResultData _handleResponse(String responseStr) {
    Map<String, dynamic> map = json.decode(responseStr);
    if (map != null) {
      if (map["code"] == HttpStatus.SUCCESS) {
        DPrint.printf("🍎🍎🍎🍎 data ---  ${json.encode(map["data"])}");
        return new ResultData(map["data"], true, map["code"], map["msg"]);
      } else if (map["code"] == HttpStatus.UNAUTHORIZED) {
        Future.delayed(Duration(milliseconds: 300), () {
          UserManager.logout();
        });
        return new ResultData(map["data"], false, map["code"], "登录失效，请重新登录");
      } else {
        print("❎❎❎❎ --- 服务器错误 --- ${map["msg"]}");
        return new ResultData(map["data"], false, map["code"], "${map["msg"]}");
      }
    }

    return new ResultData(responseStr, true, map["code"], map["msg"]);
  }

  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  ///[ option] 配置
  static Future<Response> netFetchNormal(
      url, params, Map<String, String> header, Options option,
      {noTip = false}) async {
    Map<String, String> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    if (option != null) {
      option.headers = headers;
    } else {
      option = new Options(method: "get");
      option.headers = headers;
    }

    Dio dio = new Dio();

    Response response;
    try {
      response = await dio.request<String>(url, data: params, options: option);
    } on DioError catch (e) {
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(
            statusCode: 666, requestOptions: RequestOptions(path: ''));
      }
      if (e.type == DioErrorType.connectTimeout) {
        errorResponse.statusCode = HttpCode.ERROR;
      }
      if (AppConfig.debug) {
        print('请求异常: ' + e.toString());
        print('请求异常url: ' + url);
      }
      return response;
    }

    if (AppConfig.debug) {
      print('请求url: ' + Api.host + url);
      print('请求头: ' + option.headers.toString());
      if (params != null) {
        print('请求参数: ' + params.toString());
      }
      if (response != null) {
        print('返回参数: ' + response.toString());
      }
      if (optionParams["authorizationCode"] != null) {
        print('authorizationCode: ' + optionParams["authorizationCode"]);
      }
    }

    return response;
  }

  /// 参数加密
  static paramsEncrypt({Map params}) async {
    int timestamp = DateTime.now().second;
    String md5Str = SCEncryptUtil.md5Encrypt(timestamp.toString());
    String aesEncryptStr = await SCEncryptUtil.aesEncrypt(
        key: md5Str, encryptString: json.encode(params));
    String rsaKey = await SCEncryptUtil.rsaEncrypt(encryptString: md5Str);
    return {"key": rsaKey, "body": aesEncryptStr};
  }

  /// response 解密
  static responseDecrypt(String responseJson) async {
    Map response = json.decode(responseJson);
    String rsaDecryptKey =
        await SCEncryptUtil.rsaDecrypt(decryptString: response["key"]);
    String decryptStr = await SCEncryptUtil.aesDecrypt(
        key: rsaDecryptKey, decryptString: response["body"]);
    return decryptStr;
  }
}

class ResultData {
  var data;

  /// 网络请求错误或者服务器返回错误时 为false
  bool result;
  String code;
  var headers;
  String msg;

  ResultData(this.data, this.result, this.code, this.msg, {this.headers});
}
