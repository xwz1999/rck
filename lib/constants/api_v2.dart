class APIV2 {
  static UserAPI userAPI = UserAPI();
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
}
