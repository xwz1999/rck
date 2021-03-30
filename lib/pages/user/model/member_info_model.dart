import 'package:recook/utils/user_level_tool.dart';

class MemberInfoModel {
  int id;
  String nickname;
  String headImgUrl;
  int roleLevel;
  String remarkName;
  int createdAt;
  int roleUpdateTime;
  String phone;
  String wechatNo;

  UserRoleLevel get roleLevelEnum => UserLevelTool.roleLevelEnum(roleLevel);

  MemberInfoModel(
      {this.id,
      this.nickname,
      this.headImgUrl,
      this.roleLevel,
      this.remarkName,
      this.createdAt,
      this.roleUpdateTime,
      this.phone,
      this.wechatNo});

  MemberInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    headImgUrl = json['headImgUrl'];
    roleLevel = json['roleLevel'];
    remarkName = json['remarkName'];
    createdAt = json['createdAt'];
    roleUpdateTime = json['roleUpdateTime'];
    phone = json['phone'];
    wechatNo = json['wechatNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nickname'] = this.nickname;
    data['headImgUrl'] = this.headImgUrl;
    data['roleLevel'] = this.roleLevel;
    data['remarkName'] = this.remarkName;
    data['createdAt'] = this.createdAt;
    data['roleUpdateTime'] = this.roleUpdateTime;
    data['phone'] = this.phone;
    data['wechatNo'] = this.wechatNo;
    return data;
  }
}
