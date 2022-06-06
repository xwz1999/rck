import 'package:common_utils/common_utils.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/home/model/profit_card_model.dart';
import 'package:recook/pages/user/model/pifa_benefit_model.dart';
import 'package:recook/pages/user/model/pifa_table_model.dart';
import 'package:recook/pages/user/model/user_accumulate_model.dart';
import 'package:recook/pages/user/model/user_benefit_common_model.dart';
import 'package:recook/pages/user/model/user_benefit_day_expect_model.dart';
import 'package:recook/pages/user/model/user_benefit_day_team_model.dart';
import 'package:recook/pages/user/model/user_benefit_expect_extra_model.dart';
import 'package:recook/pages/user/model/user_benefit_extra_detail_model.dart';
import 'package:recook/pages/user/model/user_benefit_model.dart';
import 'package:recook/pages/user/model/user_benefit_month_detail_model.dart';
import 'package:recook/pages/user/model/user_benefit_month_expect_model.dart';
import 'package:recook/pages/user/model/user_benefit_month_team_model.dart';
import 'package:recook/pages/user/model/user_benefit_sub_model.dart';
import 'package:recook/pages/user/model/user_income_model.dart';
import 'package:recook/pages/user/model/user_month_income_model.dart';
import 'package:recook/pages/user/user_benefit_sub_page.dart';

enum BenefitDateType {
  DAY,
  MONTH,
}

class UserBenefitFunc {
  ///合伙人批发收益
  static Future<PifaBenefitModel?> getPifaBenefit() async {
    ResultData result = await HttpManager.post(
        APIV2.userAPI.getPifaBenefit, {'user_id': UserManager.instance!.user.info!.id,});

    if (result.data != null) {
      if (result.data['data'] != null) {
        return PifaBenefitModel.fromJson(result.data['data']);
      }
    }
    return null;
  }

  static Future<List<ProfitCardModel>> getProfitCard(String date,) async {

    Map<String, dynamic> params = {'date':date,};


    ResultData result = await HttpManager.post(
        APIV2.userAPI.cardProfit, params);
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => ProfitCardModel.fromJson(e))
            .toList();
      } else
        return [];
    } else
      return [];
  }



  ///合伙人批发收益
  static Future<PiFaTableModel?> getPiFaTable(int kind,{DateTime? start,DateTime? end}) async {

    Map<String, dynamic> params = {'user_id': UserManager.instance!.user.info!.id,'kind':kind,};
    if(start!=null){
      params.putIfAbsent(
        'start',
            () => start.toIso8601String(),
      );
    }
    if(end!=null){
      params.putIfAbsent(
        'end',
            () => end.toIso8601String(),
      );
    }

    ResultData result = await HttpManager.post(
        APIV2.userAPI.piFaTable, params);
    if (result.data != null) {
      if (result.data['data'] != null) {
        return PiFaTableModel.fromJson(result.data['data']);
      } else
        return null;
    } else
      return null;
  }


  ///合伙人批发收益详情
  static Future<PifaBenefitModel?> getPifaBenefitDetail(int? shopId,String date) async {
    ResultData result = await HttpManager.post(
        APIV2.userAPI.getPifaBenefitDetail, {'user_id': UserManager.instance!.user.info!.id,'shop_id':shopId,'date':date});

    if (result.data != null) {
      if (result.data['data'] != null) {
        return PifaBenefitModel.fromJson(result.data['data']);
      }
    }
    return null;
  }

  ///合伙人获取其他收益
  static Future<PifaBenefitModel?> getBenefit(int kind,{String? date}) async {///5=店铺 6=自购  8=分享
    Map<String, dynamic> params = {'user_id': UserManager.instance!.user.info!.id,'kind':kind,};
    if(date!=null){
      params.putIfAbsent(
        'date',
            () => date,
      );
    }
    ResultData result = await HttpManager.post(
        APIV2.userAPI.getBenefit, params);

    if (result.data != null) {
      if (result.data['data'] != null) {
        return PifaBenefitModel.fromJson(result.data['data']);
      }
    }
    return null;
  }








  //已到账收益
  static Future<UserIncomeModel?> receicedIncome(
      String dateStr, int type) async {
    ResultData result = await HttpManager.post(
        APIV2.userAPI.receivedDetail, {'date_str': dateStr, 'type': type});

    if (result.data != null) {
      if (result.data['data'] != null) {
        return UserIncomeModel.fromJson(result.data['data']);
      }
    }
    return null;
  }

  //未到账收益
  static Future<UserIncomeModel?> notReceicedIncome(
      String dateStr, int type) async {
    ResultData result = await HttpManager.post(
        APIV2.userAPI.notReceivedDetail, {'date_str': dateStr, 'type': type});

    if (result.data != null) {
      if (result.data['data'] != null) {
        return UserIncomeModel.fromJson(result.data['data']);
      }
    }
    return null;
  }

  //团队未到账补贴
  static Future<UserIncomeModel?> teamNotReceicedIncome(int level) async {
    ResultData result = await HttpManager.post(
        APIV2.userAPI.groupNotReceivedDetail, {'level': level});

    if (result.data != null) {
      if (result.data['data'] != null) {
        return UserIncomeModel.fromJson(result.data['data']);
      }
    }
    return null;
  }

  //团队到账补贴
  static Future<UserIncomeModel?> teamReceicedIncome(int year, int level) async {
    ResultData result = await HttpManager.post(
        APIV2.userAPI.groupReceivedDetail, {'year': year, 'level': level});

    if (result.data != null) {
      if (result.data['data'] != null) {
        return UserIncomeModel.fromJson(result.data['data']);
      }
    }
    return null;
  }

  //店铺未到账收益日
  static Future<UserBenefitDayTeamModel?> teamNotReceicedDay(String day) async {
    ResultData result =
        await HttpManager.post(APIV2.userAPI.groupNotReceivedDay, {'day': day});

    if (result.data != null) {
      if (result.data['data'] != null) {
        return UserBenefitDayTeamModel.fromJson(result.data['data']);
      }
    }
    return null;
  }

  //店铺自营到账收益月
  static Future<UserBenefitMonthTeamModel?> selfReceicedMonth(
      String month) async {
    ResultData result = await HttpManager.post(
        APIV2.userAPI.groupSelfReceivedMonth, {'month': month});

    if (result.data != null) {
      if (result.data['data'] != null) {
        return UserBenefitMonthTeamModel.fromJson(result.data['data']);
      }
    }
    return null;
  }

  //店铺分销到账收益月
  static Future<UserBenefitMonthTeamModel?> distributionReceicedMonth(
      String month) async {
    ResultData result = await HttpManager.post(
        APIV2.userAPI.groupDistributionReceivedMonth, {'month': month});

    if (result.data != null) {
      if (result.data['data'] != null) {
        return UserBenefitMonthTeamModel.fromJson(result.data['data']);
      }
    }
    return null;
  }

  //店铺代理到账收益月
  static Future<UserBenefitMonthTeamModel?> agentReceicedMonth(
      String month) async {
    ResultData result = await HttpManager.post(
        APIV2.userAPI.groupAgentReceivedMonth, {'month': month});

    if (result.data != null) {
      if (result.data['data'] != null) {
        return UserBenefitMonthTeamModel.fromJson(result.data['data']);
      }
    }
    return null;
  }

  static Future<UserBenefitModel> update() async {
    ResultData result = await HttpManager.post(APIV2.userAPI.userBenefit, {});
    return UserBenefitModel.fromJson(result.data);
  }

  static Future<UserAccumulateModel> accmulate() async {
    ResultData result = await HttpManager.post(APIV2.userAPI.accumulate, {});
    return UserAccumulateModel.fromJson(result.data);
  }

  static Future<List<UserMonthIncomeModel>> monthIncome({int? year}) async {
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
    UserBenefitPageType? type,
    DateTime? date,
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
