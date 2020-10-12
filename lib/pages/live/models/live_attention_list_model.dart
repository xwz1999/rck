class LiveAttentionListModel {
  int id;
  String nickname;
  String headImgUrl;
  int isLive;

  LiveAttentionListModel(
      {this.id, this.nickname, this.headImgUrl, this.isLive});

  LiveAttentionListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    headImgUrl = json['headImgUrl'];
    isLive = json['isLive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nickname'] = this.nickname;
    data['headImgUrl'] = this.headImgUrl;
    data['isLive'] = this.isLive;
    return data;
  }
}
