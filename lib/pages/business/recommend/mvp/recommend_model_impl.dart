

import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/business/recommend/mvp/recommend_mvp_contact.dart';

class RecommendModelImpl extends RecommendModelI{
  @override
  Future<ResultData> fetchList(int? userId, int page) async {
    String url = AttentionApi.attention_recommend_list;
    Map<String, dynamic> params = {
      "page": page,
      "userId": userId,
    };
    ResultData resultData =  await HttpManager.post(url, params);
    return resultData;
  }
}
