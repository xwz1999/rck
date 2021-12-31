import 'dart:convert';

import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/utils/storage/hive_store.dart';

class UserLiveFunc {


  //删除图文或者视频
  static Future<String> delImageOrVideo(
    int id
  ) async {
    ResultData result = await HttpManager.post(APIV2.userAPI.deleteImageOrVideo, {
      "id": id
    });

    if (result.data != null) {
      return result.data['code'];
    }
  }


}
