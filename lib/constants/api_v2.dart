class APIV2 {
  static UserAPI userAPI = UserAPI();
  static BenefitAPI benefitAPI = BenefitAPI();
}

class UserAPI {
  ///我的收益
  String get userBenefit => '/v2/app/user/income';

  ///余额信息
  String get balanceInfo => '/v2/app/user/balance/info';

  ///月余额记录信息
  String get balanceMonthHistory => '/v2/app/user/balance/month_history';

  ///累计收益
  String get accumulate => '/v2/app/user/income/accumulate';

  ///年度月收益
  String get monthIncome => '/v2/app/user/income/month_income';

  ///累计自购收益
  String get selfIncome => '/v2/app/user/income/purchase_accumulate';

  ///累计导购收益
  String get guideIncome => '/v2/app/user/income/guide_accumulate';

  ///累计团队收益
  String get teamIncome => '/v2/app/user/income/team_income';

  ///累计推荐收益
  String get recommandIncome => '/v2/app/user/income/recommend_income';

  ///累计平台奖励
  String get platformIncome => '/v2/app/user/income/reward_income';

  ///月度日收益
  ///
  ///包含`自购收益`和`导购收益`
  String get monthDetail => '/v2/app/user/income/day_income';

  ///团队月收益详情
  String get groupDetail => '/v2/app/user/income/team_month_income';

  ///月推荐收益详情
  String get recommendDetail => '/v2/app/user/income/recommend_month_income';

  ///月平台奖励收益详情
  String get platformDetail => '/v2/app/user/income/reward_month_income';

  ///我的团队列表
  String get myGroup => '/v2/app/user/team';

  ///我的推荐列表
  String get myRecommend => '/v2/app/user/recommend';

  ///我的奖励列表
  String get myReward => '/v2/app/user/reward';

  ///推荐升级钻石
  String get recommendDiamond => '/v2/app/user/recommend_diamond';

  ///用户角色变动
  String get userLottery => '/v2/app/user/lottery';

  ///确认角色变动
  String get agreeLottery => '/v2/app/user/lottery_agree';
}

class BenefitAPI {
  ///日收益详情
  String get dayIncome => '/v2/app/user/income/day_incomes';

  ///月收益详情
  String get monthIncome => '/v2/app/user/income/month_incomes';

  ///日自购导购预估收益
  String get dayExpect => '/v2/app/user/income/day_expect';

  ///月自购导购预估收益
  String get monthExpect => '/v2/app/user/income/month_expect';

  ///日团队推荐平台预估收益
  String get dayExpectExtra => '/v2/app/user/income/day_expect_team';

  ///月团队推荐平台预估收益
  String get monthExpectExtra => '/v2/app/user/income/month_expect_team';
}
