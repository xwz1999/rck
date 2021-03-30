import 'package:flutter/foundation.dart';

import 'package:recook/utils/user_level_tool.dart';

class UserCommonModel {
  int userId;
  String headImgUrl;
  String nickname;
  String phone;
  String wechatNo;
  String remarkName;
  int count;
  int roleLevel;
  int flag;
  num amount;

  UserRoleLevel get roleLevelEnum => UserLevelTool.roleLevelEnum(roleLevel);

  bool get isRecommand => flag == 1;

  String get countValue {
    if (count == -1)
      return '—';
    else
      return (count ?? 0).toString();
  }

  String get amountValue {
    if (amount == -1)
      return '—';
    else
      return (amount ?? 0.0).toStringAsFixed(2);
  }

  UserCommonModel({
    @required this.userId,
    @required this.headImgUrl,
    @required this.nickname,
    @required this.phone,
    @required this.wechatNo,
    @required this.remarkName,
    @required this.count,
    @required this.roleLevel,
    @required this.flag,
    @required this.amount,
  });

  UserCommonModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    headImgUrl = json['headImgUrl'];
    nickname = json['nickname'];
    phone = json['phone'];
    wechatNo = json['wechatNo'];
    remarkName = json['remarkName'];
    count = json['count'];
    roleLevel = json['roleLevel'];
    flag = json['flag'];
    amount = json['amount'];
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
    data['roleLevel'] = this.roleLevel;
    data['flag'] = this.flag;
    return data;
  }
}
