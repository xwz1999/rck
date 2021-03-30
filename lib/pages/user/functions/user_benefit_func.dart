import 'package:common_utils/common_utils.dart';

import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/user/model/user_accumulate_model.dart';
import 'package:recook/pages/user/model/user_benefit_common_model.dart';
import 'package:recook/pages/user/model/user_benefit_day_expect_model.dart';
import 'package:recook/pages/user/model/user_benefit_expect_extra_model.dart';
import 'package:recook/pages/user/model/user_benefit_extra_detail_model.dart';
import 'package:recook/pages/user/model/user_benefit_model.dart';
import 'package:recook/pages/user/model/user_benefit_month_detail_model.dart';
import 'package:recook/pages/user/model/user_benefit_month_expect_model.dart';
import 'package:recook/pages/user/model/user_benefit_sub_model.dart';
import 'package:recook/pages/user/model/user_month_income_model.dart';
import 'package:recook/pages/user/user_benefit_sub_page.dart';

enum BenefitDateType {
  DAY,
  MONTH,
}

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

  static Future<List<UserBenefitMonthDetailModel>> monthDetail(
      DateTime date) async {
    ResultData result = await HttpManager.post(
      APIV2.userAPI.monthDetail,
      {'month': DateUtil.formatDate(date, format: 'yyyy-MM')},
    );
    if (result.data['data'] == null)
      return [];
    else
      return (result.data['data'] as List)
          .map((e) => UserBenefitMonthDetailModel.fromJson(e))
          .toList();
  }

  static Future<UserBenefitExtraDetailModel> extraDetail({
    UserBenefitPageType type,
    DateTime date,
  }) async {
    String path = '';
    switch (type) {
      case UserBenefitPageType.TEAM:
        path = APIV2.userAPI.groupDetail;
        break;
      case UserBenefitPageType.RECOMMEND:
        path = APIV2.userAPI.recommendDetail;
        break;
      case UserBenefitPageType.PLATFORM:
        path = APIV2.userAPI.platformDetail;
        break;
      default:
        break;
    }
    ResultData result = await HttpManager.post(
      path,
      {'month': DateUtil.formatDate(date, format: 'yyyy-MM')},
    );
    return UserBenefitExtraDetailModel.fromJson(result.data);
  }

  static Future<UserBenefitCommonModel> getCommonModel(
    BenefitDateType type,
    DateTime date,
  ) async {
    String path = '';
    Map<String, dynamic> params = {};
    switch (type) {
      case BenefitDateType.DAY:
        path = APIV2.benefitAPI.dayIncome;
        params.putIfAbsent(
          'day',
          () => DateUtil.formatDate(date, format: 'yyyy-MM-dd'),
        );
        break;
      case BenefitDateType.MONTH:
        path = APIV2.benefitAPI.monthIncome;
        params.putIfAbsent(
          'month',
          () => DateUtil.formatDate(date, format: 'yyyy-MM'),
        );
        break;
    }

    ResultData result = await HttpManager.post(path, params);
    return UserBenefitCommonModel.fromJson(result.data['data']);
  }

  static Future<UserBenefitDayExpectModel> getBenefitDayExpect(
      DateTime date) async {
    String path = '';
    Map<String, dynamic> params = {};
    path = APIV2.benefitAPI.dayExpect;
    params.putIfAbsent(
      'day',
      () => DateUtil.formatDate(date, format: 'yyyy-MM-dd'),
    );
    ResultData result = await HttpManager.post(path, params);
    return UserBenefitDayExpectModel.fromJson(result.data['data']);
  }

  static Future<UserBenefitMonthExpectModel> getBenefitMonthExpect(
      DateTime date) async {
    String path = '';
    Map<String, dynamic> params = {};
    path = APIV2.benefitAPI.monthExpect;
    params.putIfAbsent(
      'month',
      () => DateUtil.formatDate(date, format: 'yyyy-MM'),
    );
    ResultData result = await HttpManager.post(path, params);
    return UserBenefitMonthExpectModel.fromJson(result.data['data']);
  }

  static Future<UserBenefitExpectExtraModel> getBenefitExpectExtra(
    BenefitDateType type,
    DateTime date,
  ) async {
    String path = '';
    Map<String, dynamic> params = {};
    switch (type) {
      case BenefitDateType.DAY:
        path = APIV2.benefitAPI.dayExpectExtra;
        params.putIfAbsent(
          'day',
          () => DateUtil.formatDate(date, format: 'yyyy-MM-dd'),
        );
        break;
      case BenefitDateType.MONTH:
        path = APIV2.benefitAPI.monthExpectExtra;
        params.putIfAbsent(
          'month',
          () => DateUtil.formatDate(date, format: 'yyyy-MM'),
        );
        break;
    }
    ResultData result = await HttpManager.post(path, params);
    return UserBenefitExpectExtraModel.fromJson(result.data['data']);
  }
}
