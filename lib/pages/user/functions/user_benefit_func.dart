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

  static Future<UserMonthIncomeModel> monthIncome({int month}) async {
    ResultData result = await HttpManager.post(
      APIV2.userAPI.monthIncome,
      {'year': month},
    );
    return UserMonthIncomeModel.fromJson(result.data);
  }
}
