import 'package:recook/utils/user_level_tool.dart';

class UserBenefitExtraDetailModel {
  String code;
  String msg;
  Data data;

  UserBenefitExtraDetailModel({this.code, this.msg, this.data});

  UserBenefitExtraDetailModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<UserIncome> userIncome;
  num amount = 0;
  num salesVolume;
  num ratio;
  int count;
  int isSettlement;

  Data(
      {this.userIncome,
      this.amount,
      this.salesVolume,
      this.ratio,
      this.count,
      this.isSettlement});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['userIncome'] != null) {
      userIncome = new List<UserIncome>();
      json['userIncome'].forEach((v) {
        userIncome.add(new UserIncome.fromJson(v));
      });
    } else {
      userIncome = [];
    }
    amount = json['teamAmount'];
    salesVolume = json['salesVolume'];
    ratio = json['ratio'];
    count = json['count'];
    isSettlement = json['IsSettlement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userIncome != null) {
      data['userIncome'] = this.userIncome.map((v) => v.toJson()).toList();
    }
    data['amount'] = this.amount;
    data['salesVolume'] = this.salesVolume;
    data['ratio'] = this.ratio;
    data['count'] = this.count;
    data['IsSettlement'] = this.isSettlement;
    return data;
  }
}

class UserIncome {
  int userId;
  String headImgUrl;
  String nickname;
  String phone;
  String wechatNo;
  String remarkName;
  int count;
  num amount;
  int roleLevel;

  UserRoleLevel get roleLevelEnum => UserLevelTool.roleLevelEnum(roleLevel);

  UserIncome(
      {this.userId,
      this.headImgUrl,
      this.nickname,
      this.phone,
      this.wechatNo,
      this.remarkName,
      this.count,
      this.amount,
      this.roleLevel});

  UserIncome.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    headImgUrl = json['headImgUrl'];
    nickname = json['nickname'];
    phone = json['phone'];
    wechatNo = json['wechatNo'];
    remarkName = json['remarkName'];
    count = json['count'];
    amount = json['amount'];
    roleLevel = json['roleLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['headImgUrl'] = this.headImgUrl;
    data['nickname'] = this.nickname;
    data['phone'] = this.phone;
    data['wechatNo'] = this.wechatNo;
    data['remarkName'] = this.remarkName;
    data['count'] = this.count;
    data['amount'] = this.amount;
    data['roleLevel'] = this.roleLevel;
    return data;
  }
}
