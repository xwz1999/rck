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

  UserRoleLevel get roleLevelEnum => UserLevelTool.roleLevelEnum(roleLevel);

  bool get isRecommand => flag == 1;

  UserCommonModel(
      {this.userId,
      this.headImgUrl,
      this.nickname,
      this.phone,
      this.wechatNo,
      this.remarkName,
      this.count,
      this.roleLevel,
      this.flag});

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
