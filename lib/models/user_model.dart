/*
 * ====================================================
 * package   : models
 * author    : Created by nansi.
 * time      : 2019/5/5  3:58 PM 
 * remark    : 
 * ====================================================
 */

import 'package:recook/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/*
{
    "code":"SUCCESS",
    "data":{
        "code":"SUCCESS",
        "data":{
            "tkn":{
                "id":2,
                "token":"4b88dc68f1c095a6886d966993bf0e01"
            },
            "info":{
                "id":2,
                "nickname":"",
                "headImgUrl":"/default/259d3c1fbbb8e4fd8bacdbe5d5d110c7.png",
                "wxOpenId":"",
                "wxUnionId":"",
                "mobile":"18867626276",
                "identityCardName":"",
                "identityCardNo":"",
                "gender":0,
                "birthday":"1980-01-01 00:00:00",
                "invitationNo":"ABABCA",
                "level":20,
                "balance":0,
                "coin":0,
                "createdAt":"2019-05-22 18:15:13",
                "updatedAt":"2019-05-22 18:15:13",
                "deletedAt":null
            },
            "status":1
        },
        "msg":"登录成功"
    }
}


 */

@JsonSerializable()
class UserModel extends BaseModel {
  User data;
  UserModel(this.data, String code, String msg) : super(code, msg);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class User {
  Tkn auth;
  Info   info;
  int status;

  User(this.auth, this.info, this.status);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User.empty() {
    // info = info.empty();
    info = Info.empty();
  }
}

//   "id": 2,
//   "nickname": "",
//   "headImgUrl": "",
//   "wxOpenId": "",
//   "wxUnionId": "",
//   "mobile": "18867626276",
//   "identityCardName": "",
//   "identityCardNo": "",
//   "gender": 0,       0 未填写性别 ；  1 ： 男  ； 2： 女
//   "birthday": "1980-01-01T00:00:00+08:00",
//   "invitationNo": "ABABCA",
//   "offlineStoreId": 1,
//   "level": 0,
//   "balance": 0,
//   "coin": 0,
//   "createdAt": "2019-05-22T18:15:13.46104782+08:00",
//   "updatedAt": "2019-05-22T18:15:13.46104782+08:00",
//   "deletedAt": null
//   "isVerified": bool 是否实名认证

/*
0:"id" -> 1000114
1:"nickname" -> "曾大克"
2:"headImgUrl" -> "/default/male.png"
3:"wxUnionId" -> ""
4:"mobile" -> "18067170899"
5:"gender" -> 1
6:"birthday" -> "1980-01-01 00:00:00"
7:"invitationNo" -> "9A59DP"
8:"role" -> 0
9:"type" -> 0
10:"addr" -> ""
11:"phone" -> "18815288517"
12:"wechatNo" -> ""
13:"remarkName" -> ""
14:"introCode" -> "0"
15:"upgradeCode" -> ""
16:"roleId" -> 0
17:"roleLevel" -> 0
18:"userLevel" -> 0
19:"isVerified" -> true
*/

@JsonSerializable()
class Info {
  int id;
  String nickname;
  String headImgUrl;
  String wxOpenId;
  String wxUnionId;
  String mobile;
  String identityCardName;
  String identityCardNo;
  int gender;
  String birthday;
  String invitationNo;
  int offlineStoreId;
  int level;
  int balance;
  int coin;
  String createdAt;
  String updatedAt;
  String deletedAt;
  bool isVerified;

  int role;

  String addr;
  String phone;
  String wechatNo;

  String remarkName;
  String introCode;
  String upgradeCode;
  int roleId;
  int roleLevel;
  int userLevel;
  bool isSetPayPwd; //是否设置过支付密码 支付和提现需要用到
  bool realInfoStatus; // 是否实名认证
  String realName;//真实姓名
  String idCard;

  ///导师微信号
  String teacherWechatNo;
  Info(
    this.id,
    this.nickname,
    this.headImgUrl,
    this.wxOpenId,
    this.wxUnionId,
    this.mobile,
    this.identityCardName,
    this.identityCardNo,
    this.gender,
    this.birthday,
    this.invitationNo,
    this.offlineStoreId,
    this.level,
    this.balance,
    this.coin,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isVerified,
    this.role,
    this.addr,
    this.phone,
    this.wechatNo,
    this.remarkName,
    this.introCode,
    this.upgradeCode,
    this.roleId,
    this.roleLevel,
    this.userLevel,
    this.isSetPayPwd,
    this.realInfoStatus,
    this.realName,
    this.idCard,
    this.teacherWechatNo,
  );

  //紧急提交修复
  Info.empty() {
    this.id = 0;
    this.nickname = "游客";
    this.role = 0;
    this.roleLevel = 500;
    this.userLevel = 40;
    // this.headImgUrl = "";
  }

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);

  Map<String, dynamic> toJson() => _$InfoToJson(this);
}

@JsonSerializable()
class Tkn {
  int id;
  String token;

  Tkn(this.id, this.token);

  factory Tkn.fromJson(Map<String, dynamic> json) => _$TknFromJson(json);

  Map<String, dynamic> toJson() => _$TknToJson(this);
}
