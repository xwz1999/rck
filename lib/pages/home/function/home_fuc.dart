import 'package:recook/constants/api.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/home/model/aku_video_list_model.dart';

class HomeFuc {
  //视频列表
  static Future<AkuVideoListModel?> getAkuVideoList(
      String? title, int page) async {
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
    return null;
  }

  //视频列表
  static Future<String?> addHits(int? id) async {
    ResultData result = await HttpManager.post(APIV2.userAPI.addHits, {
      'id': id,
    });

    if (result.data != null) {
      return result.data['code'];
    }
    return null;
  }

  //推荐分词列表
  static Future<List<KeyWordModel>> recommendWords(String? keywords) async {
    ResultData result = await HttpManager.post(GoodsApi.keyWords, {
      'keyword': keywords,
    });

    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => KeyWordModel.fromJson(e))
            .toList();
      }
      else
        return [];
    }
    else
      return [];
  }
}
class KeyWordModel {
  String? token;

  KeyWordModel({this.token});

  KeyWordModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }
}
