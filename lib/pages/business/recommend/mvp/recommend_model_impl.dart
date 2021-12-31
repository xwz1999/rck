

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/pages/business/recommend/mvp/recommend_mvp_contact.dart';

class RecommendModelImpl extends RecommendModelI{
  @override
  Future<ResultData> fetchList(int userId, int page) async {
    String url = AttentionApi.attention_recommend_list;
    Map<String, dynamic> params = {
      "page": page,
      "userId": userId,
    };
    ResultData resultData =  await HttpManager.post(url, params);
    return resultData;
  }
}
