class ActivityReviewListModel {
  int? userId;
  String? nickname;
  String? headImgUrl;
  int? id;
  String? createdAt;
  String? content;
  int? commentCount;
  int? praise;
  int? isPraise;
  List<Sub>? sub;

  ActivityReviewListModel(
      {this.userId,
      this.nickname,
      this.headImgUrl,
      this.id,
      this.createdAt,
      this.content,
      this.commentCount,
      this.praise,
      this.isPraise,
      this.sub});

  ActivityReviewListModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    nickname = json['nickname'];
    headImgUrl = json['headImgUrl'];
    id = json['id'];
    createdAt = json['createdAt'];
    content = json['content'];
    commentCount = json['commentCount'];
    praise = json['praise'];
    isPraise = json['isPraise'];
    if (json['sub'] != null) {
      sub = [];
      json['sub'].forEach((v) {
        sub!.add(new Sub.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['nickname'] = this.nickname;
    data['headImgUrl'] = this.headImgUrl;
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['content'] = this.content;
    data['commentCount'] = this.commentCount;
    data['praise'] = this.praise;
    data['isPraise'] = this.isPraise;
    if (this.sub != null) {
      data['sub'] = this.sub!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sub {
  int? userId;
  String? nickname;
  String? headImgUrl;
  int? id;
  String? createdAt;
  String? content;
  int? commentCount;
  int? praise;
  int? isPraise;

  Sub(
      {this.userId,
      this.nickname,
      this.headImgUrl,
      this.id,
      this.createdAt,
      this.content,
      this.commentCount,
      this.praise,
      this.isPraise});

  Sub.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    nickname = json['nickname'];
    headImgUrl = json['headImgUrl'];
    id = json['id'];
    createdAt = json['createdAt'];
    content = json['content'];
    commentCount = json['commentCount'];
    praise = json['praise'];
    isPraise = json['isPraise'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['nickname'] = this.nickname;
    data['headImgUrl'] = this.headImgUrl;
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['content'] = this.content;
    data['commentCount'] = this.commentCount;
    data['praise'] = this.praise;
    data['isPraise'] = this.isPraise;
    return data;
  }
}
