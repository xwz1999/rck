class FollowListModel {
  int userId;
  String nickname;
  String headImgUrl;
  int follows;
  int fans;
  int isFollow;

  FollowListModel(
      {this.userId,
      this.nickname,
      this.headImgUrl,
      this.follows,
      this.fans,
      this.isFollow});

  FollowListModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    nickname = json['nickname'];
    headImgUrl = json['headImgUrl'];
    follows = json['follows'];
    fans = json['fans'];
    isFollow = json['isFollow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['nickname'] = this.nickname;
    data['headImgUrl'] = this.headImgUrl;
    data['follows'] = this.follows;
    data['fans'] = this.fans;
    data['isFollow'] = this.isFollow;
    return data;
  }
}
