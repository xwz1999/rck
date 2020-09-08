

import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/business/focus/mvp/focus_mvp_contact.dart';


class FocusModelImpl extends FocusModelI{
  @override
  Future<ResultData> fetchList(int userId, int page) async {
    String url = AttentionApi.attention_list;
    Map<String, dynamic> params = {
      "page": page,
      "userId": userId,
    };
    ResultData resultData =  await HttpManager.post(url, params);
    return resultData;
  }
}
