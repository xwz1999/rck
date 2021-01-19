import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/user/model/user_common_model.dart';

enum UsersMode {
  MY_GROUP,
  MY_RECOMMEND,
  MY_REWARD,
}

class UserFunc {
  static Future<List<UserCommonModel>> usersList(UsersMode mode,
      {String keyword}) async {
    String path = '';
    switch (mode) {
      case UsersMode.MY_GROUP:
        path = APIV2.userAPI.myGroup;
        break;
      case UsersMode.MY_RECOMMEND:
        path = APIV2.userAPI.myRecommend;
        break;
      case UsersMode.MY_REWARD:
        path = APIV2.userAPI.myReward;
        break;
    }
    Map<String, dynamic> params = {'keyword':''};
    // if (keyword != null) params.putIfAbsent('keyword', () => keyword);
    ResultData result = await HttpManager.post(path, params);
    if (result?.data['data'] == null) return [];
    return (result.data['data'] as List)
        .map((e) => UserCommonModel.fromJson(e))
        .toList();
  }
}
