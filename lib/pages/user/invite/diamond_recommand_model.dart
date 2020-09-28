class DiamondRecommandModel {
  num userId;
  String nickname;
  String headImgUrl;
  num role;
  num count;
  String createdAt;
  String remarkName;
  String phoneNum;
  String wechatNo;
  num roleId;
  num userLevel;
  num roleLevel;

  DiamondRecommandModel(
      {this.userId,
      this.nickname,
      this.headImgUrl,
      this.role,
      this.count,
      this.createdAt,
      this.remarkName,
      this.phoneNum,
      this.wechatNo,
      this.roleId,
      this.userLevel,
      this.roleLevel});

  DiamondRecommandModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    nickname = json['nickname'];
    headImgUrl = json['headImgUrl'];
    role = json['role'];
    count = json['count'];
    createdAt = json['createdAt'];
    remarkName = json['remarkName'];
    phoneNum = json['phoneNum'];
    wechatNo = json['wechatNo'];
    roleId = json['roleId'];
    userLevel = json['userLevel'];
    roleLevel = json['roleLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['nickname'] = this.nickname;
    data['headImgUrl'] = this.headImgUrl;
    data['role'] = this.role;
    data['count'] = this.count;
    data['createdAt'] = this.createdAt;
    data['remarkName'] = this.remarkName;
    data['phoneNum'] = this.phoneNum;
    data['wechatNo'] = this.wechatNo;
    data['roleId'] = this.roleId;
    data['userLevel'] = this.userLevel;
    data['roleLevel'] = this.roleLevel;
    return data;
  }
}
