class ShopTeamIncomeModel {
  String? code;
  String? msg;
  Data? data;

  ShopTeamIncomeModel({this.code, this.msg, this.data});

  ShopTeamIncomeModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  num? amount;
  num? income;
  num? memberCount;
  List<Members>? members;
  num? percent;

  Data(
      {this.amount, this.income, this.memberCount, this.members, this.percent});

  Data.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    income = json['income'];
    memberCount = json['memberCount'];
    if (json['members'] != null) {
      members = [];
      json['members'].forEach((v) {
        members!.add(new Members.fromJson(v));
      });
    }
    percent = json['percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['income'] = this.income;
    data['memberCount'] = this.memberCount;
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    data['percent'] = this.percent;
    return data;
  }
}

class Members {
  num? userId;
  String? nickname;
  String? headImgUrl;
  String? mobile;
  num? roleLevel;
  String? roleLevelName;
  num? amount;

  Members(
      {this.userId,
      this.nickname,
      this.headImgUrl,
      this.mobile,
      this.roleLevel,
      this.roleLevelName,
      this.amount});

  Members.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    nickname = json['Nickname'];
    headImgUrl = json['HeadImgUrl'];
    mobile = json['Mobile'];
    roleLevel = json['RoleLevel'];
    roleLevelName = json['RoleLevelName'];
    amount = json['Amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['Nickname'] = this.nickname;
    data['HeadImgUrl'] = this.headImgUrl;
    data['Mobile'] = this.mobile;
    data['RoleLevel'] = this.roleLevel;
    data['RoleLevelName'] = this.roleLevelName;
    data['Amount'] = this.amount;
    return data;
  }
}
