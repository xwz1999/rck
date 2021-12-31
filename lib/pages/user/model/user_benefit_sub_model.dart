import 'package:jingyaoyun/pages/user/user_benefit_sub_page.dart';

class UserBenefitSubModel {
  String code;
  String msg;
  Data data;
  UserBenefitPageType type;

  UserBenefitSubModel({this.code, this.msg, this.data});

  UserBenefitSubModel.fromJson(
      Map<String, dynamic> json, UserBenefitPageType type) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data'], type) : null;
    this.type = type;
  }
}

class Data {
  num count;
  num amount;
  num salesVolume;

  Data({this.count, this.amount, this.salesVolume});

  Data.fromJson(Map<String, dynamic> json, UserBenefitPageType type) {
    switch (type) {
      case UserBenefitPageType.SELF:
        amount = json['purchaseAmount'];
        salesVolume = json['purchaseSalesVolume'];
        count = json['purchaseCount'];
        break;
      case UserBenefitPageType.GUIDE:
        amount = json['guideAmount'];
        count = json['guideCount'];
        salesVolume = json['guideSalesVolume'];
        break;
      case UserBenefitPageType.TEAM:
        count = json['teamCount'];
        amount = json['teamAmount'];
        salesVolume = json['teamSalesVolume'];
        break;
      case UserBenefitPageType.RECOMMEND:
        count = json['recommendCount'];
        amount = json['recommendAmount'];
        salesVolume = json['recommendSalesVolume'];
        break;
      case UserBenefitPageType.PLATFORM:
        count = json['rewardCount'];
        amount = json['rewardAmount'];
        salesVolume = json['rewardSalesVolume'];
        break;
    }
  }
}
