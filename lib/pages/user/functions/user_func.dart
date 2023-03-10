import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/home/model/king_coin_list_model.dart';
import 'package:jingyaoyun/pages/user/model/user_common_model.dart';

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
    Map<String, dynamic> params = {};
    if (keyword != null) params.putIfAbsent('keyword', () => keyword);
    ResultData result = await HttpManager.post(path, params);
    if (result?.data['data'] == null) return [];
    return (result.data['data'] as List)
        .map((e) => UserCommonModel.fromJson(e))
        .toList();
  }

  //获取金刚区图标
  static Future<List<KingCoin>> getKingCoinList() async {//new
    ResultData result = await HttpManager.post(APIV2.userAPI.getKingCion, {
      'user_id': UserManager.instance.user.info.id != null
          ? UserManager.instance.user.info.id
          : 0,
    });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => KingCoin.fromJson(e))
            .toList();
      }
    }
  }

  //解绑微信
  static Future<String> wechatUnboundhandle() async {
    ResultData result =
        await HttpManager.post(APIV2.userAPI.wechatUnboundhandle, {
      'userId': UserManager.instance.user.info.id,
    });
    if (result.data != null) {
      return result.data['code'];
    }
  }
}
