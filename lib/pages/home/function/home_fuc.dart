import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/home/model/aku_video_list_model.dart';

class HomeFuc {
  //视频列表
  static Future<AkuVideoListModel> getAkuVideoList(
      String title, int page) async {
    ResultData result = await HttpManager.post(APIV2.userAPI.getAkuVideoList, {
      'title': title,
      'page': {
        'limit': 10,
        'page': page,
      }
    });

    if (result.data != null) {
      if (result.data['data'] != null) {
        return AkuVideoListModel.fromJson(result.data['data']);
      }
    }
  }

  //视频列表
  static Future<String> addHits(int id) async {
    ResultData result = await HttpManager.post(APIV2.userAPI.addHits, {
      'id': id,
    });

    if (result.data != null) {
      return result.data['code'];
    }
  }
}
