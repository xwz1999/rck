class VideoListModel {
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
  Goods? goods;
  String? mediaUrl;
  int? topicId;
  String? topicName;
  int? isFollow;
  int? compliance;
  int? passStatus;
  VideoListModel({
    this.userId,
    this.nickname,
    this.headImgUrl,
    this.content,
    this.coverUrl,
    this.trendId,
    this.originId,
    this.trendType,
    this.praise,
    this.isPraise,
    this.goods,
    this.mediaUrl,
    this.topicId,
    this.topicName,
    this.isFollow,
    this.compliance,
    this.passStatus,
  });

  VideoListModel.fromJson(Map<String, dynamic> json) {
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
    goods = json['goods'] != null ? new Goods.fromJson(json['goods']) : null;
    mediaUrl = json['mediaUrl'];
    topicId = json['topicId'];
    topicName = json['topicName'];
    isFollow = json['isFollow'];
    compliance= json['compliance'];
    passStatus= json['pass_status'];
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
    if (this.goods != null) {
      data['goods'] = this.goods!.toJson();
    }
    data['mediaUrl'] = this.mediaUrl;
    data['topicId'] = this.topicId;
    data['topicName'] = this.topicName;
    data['isFollow'] = this.isFollow;
    data['compliance'] = this.compliance;
    data['pass_status'] = this.passStatus;
    return data;
  }
}

class Goods {
  int? id;
  String? mainPhotoURL;
  String? name;
  String? price;

  Goods({this.id, this.mainPhotoURL, this.name, this.price});

  Goods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainPhotoURL = json['mainPhotoURL'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mainPhotoURL'] = this.mainPhotoURL;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}
