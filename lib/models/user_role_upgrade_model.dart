class UserRoleUpgradeModel {
  String code;
  String msg;
  UpgradeModel data;

  UserRoleUpgradeModel({this.code, this.msg, this.data});

  UserRoleUpgradeModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new UpgradeModel.fromJson(json['data']) : null;
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

class UpgradeModel {
  int roleLevel;
  int upGrade;
  int userLevel;

  UpgradeModel({this.roleLevel, this.upGrade, this.userLevel});

  UpgradeModel.fromJson(Map<String, dynamic> json) {
    roleLevel = json['roleLevel'];
    upGrade = json['upGrade'];
    userLevel = json['userLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roleLevel'] = this.roleLevel;
    data['upGrade'] = this.upGrade;
    data['userLevel'] = this.userLevel;
    return data;
  }
}
