import 'package:flutter/foundation.dart';

import 'package:recook/utils/user_level_tool.dart';

class UserPartnerModel {
  int userId;
  String headImgUrl;
  String nickname;
  String phone;
  String wechatNo;
  String remarkName;
  int count;
  int roleLevel;
  num amount;
  int order_count;

  UserRoleLevel get roleLevelEnum => UserLevelTool.roleLevelEnum(roleLevel);

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

  String get orderValue {
    if (order_count == -1)
      return '—';
    else
      return (order_count ?? 0.0).toStringAsFixed(2);
  }

  UserPartnerModel({
    @required this.userId,
    @required this.headImgUrl,
    @required this.nickname,
    @required this.phone,
    @required this.wechatNo,
    @required this.remarkName,
    @required this.count,
    @required this.roleLevel,
    @required this.amount,
    @required this.order_count,
  });

  UserPartnerModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    headImgUrl = json['headImgUrl'];
    nickname = json['nickname'];
    phone = json['phone'];
    wechatNo = json['wechatNo'];
    remarkName = json['remarkName'];
    count = json['count'];
    roleLevel = json['roleLevel'];
    amount = json['amount'];
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
    data['roleLevel'] = this.roleLevel;
    data['amount'] = this.amount;
    data['order_count'] = this.order_count;
    return data;
  }
}
