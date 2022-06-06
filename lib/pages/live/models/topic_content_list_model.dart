class TopicContentListModel {
  int? userId;
  String? nickname;
  String? headImgUrl;
  String? content;
  String? coverUrl;
  int? trendId;
  int? originId;
  int? trendType;
  int? praise;
  int? isPraise;

  TopicContentListModel(
      {this.userId,
      this.nickname,
      this.headImgUrl,
      this.content,
      this.coverUrl,
      this.trendId,
      this.originId,
      this.trendType,
      this.praise,
      this.isPraise});

  TopicContentListModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    nickname = json['nickname'];
    headImgUrl = json['headImgUrl'];
    content = json['content'];
    coverUrl = json['coverUrl'];
    trendId = json['trendId'];
    originId = json['originId'];
    trendType = json['trendType'];
    praise = json['praise'];
    isPraise = json['isPraise'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['nickname'] = this.nickname;
    data['headImgUrl'] = this.headImgUrl;
    data['content'] = this.content;
    data['coverUrl'] = this.coverUrl;
    data['trendId'] = this.trendId;
    data['originId'] = this.originId;
    data['trendType'] = this.trendType;
    data['praise'] = this.praise;
    data['isPraise'] = this.isPraise;
    return data;
  }
}
