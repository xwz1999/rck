import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/user/model/user_accumulate_model.dart';
import 'package:recook/pages/user/model/user_benefit_model.dart';
import 'package:recook/pages/user/model/user_month_income_model.dart';

class UserBenefitFunc {
  static Future<UserBenefitModel> update() async {
    ResultData result = await HttpManager.post(APIV2.userAPI.userBenefit, {});
    return UserBenefitModel.fromJson(result.data);
  }

  static Future<UserAccumulateModel> accmulate() async {
    ResultData result = await HttpManager.post(APIV2.userAPI.accumulate, {});
    return UserAccumulateModel.fromJson(result.data);
  }

  static Future<List<UserMonthIncomeModel>> monthIncome({int year}) async {
    ResultData result = await HttpManager.post(
      APIV2.userAPI.monthIncome,
      {'year': year},
    );
    return (result.data['data'] as List)
        .map((e) => UserMonthIncomeModel.fromJson(e))
        .toList();
  }
}
