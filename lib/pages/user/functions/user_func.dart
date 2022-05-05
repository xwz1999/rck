import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/home/model/king_coin_list_model.dart';
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
    Map<String, dynamic> params = {};
    if (keyword != null) params.putIfAbsent('keyword', () => keyword);
    ResultData result = await HttpManager.post(path, params);
    if (result?.data['data'] == null) return [];
    return (result.data['data'] as List)
        .map((e) => UserCommonModel.fromJson(e))
        .toList();
  }

  //获取金刚区图标
  static Future<List<KingCoinListModel>> getKingCoinList() async {//new
    ResultData result = await HttpManager.post(APIV2.userAPI.getKingCionNew, {
      'user_id': UserManager.instance.user.info.id != null
          ? UserManager.instance.user.info.id
          : 0,
      "is_sale": UserManager.instance.isWholesale,
    });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => KingCoinListModel.fromJson(e))
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



  ///激活jpush
  static Future<bool> activeJpush(int type,String registerId ) async {
    ResultData result =
    await HttpManager.post(APIV2.userAPI.activePush, {
      'register_id':registerId,
      'type': type
    });
    if (result.data != null) {
      return true;
    }else{
      return false;
    }
  }




  static Future<List<KingCoinListModel>> getMessageList() async {//new
    ResultData result = await HttpManager.post(APIV2.userAPI.getMessageList, {
      'page':0,
      'limit':10,
    });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => KingCoinListModel.fromJson(e))
            .toList();
      }
    }
  }

}
