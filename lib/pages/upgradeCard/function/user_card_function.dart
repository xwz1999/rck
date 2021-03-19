import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/upgradeCard/model/user_card_%20model.dart';

class UserCardFunction {
  static Future<List<UserCardModel>> fetchList(int index, int type) async {
    ResultData resultData = await HttpManager.post(APIV2.userAPI.userCard, {
      'page': index,
      'type': type,
      'limit': 10,
    });
    if (resultData == null ||
        resultData.data == null ||
        resultData.data['data'] == null ||
        resultData.data['data']['list'] == null) return [];

    return (resultData.data['data']['list'] as List)
        .map((e) => UserCardModel.fromJson(e))
        .toList();
  }

  static Future<int> count() async {
    ResultData resultData = await HttpManager.post(
      APIV2.userAPI.userCard,
      {'page': 1, 'type': 0, 'limit': 10},
    );
    if (resultData == null ||
        resultData.data == null ||
        resultData.data['data'] == null ||
        resultData.data['data']['total'] == null) return 0;

    return resultData.data['data']['total'];
  }
}
