class APIV2 {
  static UserAPI userAPI = UserAPI();
}

class UserAPI {

  ///我的收益
    String get userBenefit => '/v2/app/user/income';
}
