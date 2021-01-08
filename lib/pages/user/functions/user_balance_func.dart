import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/user/model/user_balance_info_model.dart';

class UserBalanceFunc {
  static Future<UserBalanceInfoModel> info() async {
    ResultData result = await HttpManager.post(APIV2.userAPI.balanceInfo, {});
    return UserBalanceInfoModel.fromJson(result.data);
  }
}
