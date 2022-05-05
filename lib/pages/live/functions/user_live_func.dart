
import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';

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
