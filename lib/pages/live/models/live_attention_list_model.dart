class LiveAttentionListModel {
  int? id;
  String? nickname;
  String? headImgUrl;
  int? isLive;
  int? userId;

  LiveAttentionListModel(
      {this.id, this.nickname, this.headImgUrl, this.isLive, this.userId});

  LiveAttentionListModel.fromJson(Map<String, dynamic> json) {
    id = json['liveItemId'];
    nickname = json['nickname'];
    headImgUrl = json['headImgUrl'];
    isLive = json['isLive'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['liveItemId'] = this.id;
    data['nickname'] = this.nickname;
    data['headImgUrl'] = this.headImgUrl;
    data['isLive'] = this.isLive;
    return data;
  }
}
