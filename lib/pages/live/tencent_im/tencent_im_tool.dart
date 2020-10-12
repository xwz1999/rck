import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/models/tencent_im_user_model.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';

class TencentIMTool {
  static TencentIMUserModel model;
  static int loginCount = 0;
  static Future login() async {
    if (model == null) model = await getTencentImUser();
    await TencentImPlugin.initStorage(identifier: model.identifier);
    await TencentImPlugin.login(
      identifier: model.identifier,
      userSig: model.sign,
    ).catchError((e) {
      loginCount++;
      model = null;
      if (loginCount < 20) login();
    });
  }

  static Future<TencentIMUserModel> getTencentImUser() async {
    final bool isLogin = UserManager.instance.haveLogin;
    ResultData resultData = await HttpManager.post(
      isLogin ? LiveAPI.tencentUser : LiveAPI.tencentUserNotLogin,
      {},
    );
    if (resultData?.data['data'] == null)
      return TencentIMUserModel.empty();
    else
      return TencentIMUserModel.fromJson(resultData?.data['data']);
  }
}
