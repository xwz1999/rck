/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-19  10:03 
 * remark    : 
 * ====================================================
 */

import 'package:recook/utils/print_util.dart';
import 'package:recook/widgets/toast.dart';
import 'package:tobias/tobias.dart' as tobias;

enum AliPayResultCode {
  success, // 9000 订单支付成功
  cancel, // 6001 用户中途取消
  fail, // 4000 订单支付失败
  repeat, // 5000 重复请求
  processing, // 8000 正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
  error, // 6002 网络连接出错
  unknown, // 6004  支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
  other, // 其它支付错误
  exception // 自己try catch 中出错
}

class AliPayResult {
  AliPayResultCode code;
  String msg;
  String platform;

  AliPayResult({this.platform, int code, this.msg}) {
    switch (code) {
      case 9000:
        this.code = AliPayResultCode.success;
        break;
      case 6001:
        this.code = AliPayResultCode.cancel;
        break;
      case 4000:
        this.code = AliPayResultCode.fail;
        break;
      case 5000:
        this.code = AliPayResultCode.repeat;
        break;
      case 8000:
        this.code = AliPayResultCode.processing;
        break;
      case 6002:
        this.code = AliPayResultCode.error;
        break;
      case 6004:
        this.code = AliPayResultCode.unknown;
        break;
      case -1:
        this.code = AliPayResultCode.exception;
        break;
      default:
        this.code = AliPayResultCode.other;
    }
  }
}

class AliPayUtils {
  static Future<AliPayResult> callAliPay(String payInfo,
      {tobias.AliPayEvn evn = tobias.AliPayEvn.ONLINE}) async {
    var install = await tobias.isAliPayInstalled();
    DPrint.printf("支付宝是否安装 ----- $install");
    if (!install) {
      Toast.showInfo("未安装支付宝");
      return null;
    }

    AliPayResult payResult;
    try {
      print("The pay info is : " + payInfo);
      Map result = await tobias.aliPay(payInfo, evn: evn);
      print(result.toString());
      payResult = _result(result);
    } on Exception catch (e) {
//      payResult = false;
      Toast.showError(e.toString());
      payResult = AliPayResult(code: -1, msg: e.toString(), platform: "");
    }
    return payResult;
  }

  static _result(Map resultMap) {
    print("The pay result is : $resultMap");

    return AliPayResult(
        code: int.parse(resultMap["resultStatus"]),
        msg: resultMap["memo"],
        platform: resultMap["platform"]);
  }
}
