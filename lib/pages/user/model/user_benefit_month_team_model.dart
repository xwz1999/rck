class UserBenefitMonthTeamModel {
  List<UserIncomeMonth> userIncome;
  num amount;
  num salesVolume;
  int ratio;
  int count;
  int isSettlement;
  int order_count;

  UserBenefitMonthTeamModel(
      {this.userIncome,
      this.amount,
      this.salesVolume,
      this.ratio,
      this.count,
      this.isSettlement,
      this.order_count});

  UserBenefitMonthTeamModel.fromJson(Map<String, dynamic> json) {
    if (json['userIncome'] != null) {
      userIncome = new List<UserIncomeMonth>();
      json['userIncome'].forEach((v) {
        userIncome.add(new UserIncomeMonth.fromJson(v));
      });
    }
    amount = json['amount'];
    salesVolume = json['salesVolume'];
    ratio = json['ratio'];
    count = json['count'];
    isSettlement = json['IsSettlement'];
    order_count = json['order_count'];
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
    data['order_count'] = this.order_count;
    return data;
  }
}

class UserIncomeMonth {
  int userId;
  String headImgUrl;
  String nickname;
  String phone;
  String wechatNo;
  String remarkName;
  int count;
  num amount;
  int roleLevel;
  int order_count;

  UserIncomeMonth(
      {this.userId,
      this.headImgUrl,
      this.nickname,
      this.phone,
      this.wechatNo,
      this.remarkName,
      this.count,
      this.amount,
      this.roleLevel,
      this.order_count});

  UserIncomeMonth.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    headImgUrl = json['headImgUrl'];
    nickname = json['nickname'];
    phone = json['phone'];
    wechatNo = json['wechatNo'];
    remarkName = json['remarkName'];
    count = json['count'];
    amount = json['amount'];
    roleLevel = json['roleLevel'];
    order_count = json['order_count'];
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
    data['order_count'] = this.order_count;
    return data;
  }
}
