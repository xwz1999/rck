import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/user/model/user_accumulate_model.dart';
import 'package:recook/pages/user/model/user_benefit_model.dart';
import 'package:recook/pages/user/model/user_benefit_sub_model.dart';
import 'package:recook/pages/user/model/user_month_income_model.dart';
import 'package:recook/pages/user/user_benefit_sub_page.dart';

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

  static Future<UserBenefitSubModel> subInfo(UserBenefitPageType type) async {
    String path = '';
    switch (type) {
      case UserBenefitPageType.SELF:
        path = APIV2.userAPI.selfIncome;
        break;
      case UserBenefitPageType.GUIDE:
        path = APIV2.userAPI.guideIncome;
        break;
      case UserBenefitPageType.TEAM:
        path = APIV2.userAPI.teamIncome;
        break;
      case UserBenefitPageType.RECOMMEND:
        path = APIV2.userAPI.recommandIncome;
        break;
      case UserBenefitPageType.PLATFORM:
        path = APIV2.userAPI.platformIncome;
        break;
    }
    ResultData result = await HttpManager.post(path, {});
    return UserBenefitSubModel.fromJson(result.data, type);
  }
}
