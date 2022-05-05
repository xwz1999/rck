import 'package:recook/pages/live/models/video_list_model.dart';

class ActivityListModel {
  String content;
  Goods goods;
  int id;
  List<ImgList> imgList;
  int originId;

  ///动态类型 动态类型 1=图文 2=短视频
  int trendType;
  String updatedAt;
  Short short;
  int praise;
  int isPraise;
  int topicId;
  String topicName;
  int isFollow;
  int compliance;
  int passStatus;

  ActivityListModel({
    this.content,
    this.goods,
    this.id,
    this.imgList,
    this.originId,
    this.trendType,
    this.updatedAt,
    this.short,
    this.praise,
    this.isPraise,
    this.topicId,
    this.topicName,
    this.isFollow,
    this.compliance,
    this.passStatus,
  });

  ActivityListModel.fromVideoList(VideoListModel model) {
    this.content = model.content;
    this.goods = Goods.fromJson(model.goods.toJson());
    this.id = model.trendId;
    this.imgList = [];
    this.originId = 0;
    this.trendType = 2;
    this.updatedAt = '';
    this.short = Short(
      mediaUrl: model.mediaUrl,
      coverUrl: model.coverUrl,
    );
    this.praise = model.praise;
    this.isPraise = model.isPraise;
    this.topicId = model.topicId;
    this.topicName = model.topicName;
    this.isFollow = model.isFollow;
    this.compliance = model.compliance;
    this.passStatus = model.passStatus;
  }

  ActivityListModel.fromJson(Map<String, dynamic> json) {
    //TODO 动态列表
    content = json['content'];
    goods = json['goods'] != null ? new Goods.fromJson(json['goods']) : null;
    id = json['id'];
    if (json['imgList'] != null) {
      imgList = [];
      json['imgList'].forEach((v) {
        imgList.add(new ImgList.fromJson(v));
      });
    }
    originId = json['originId'];
    trendType = json['trendType'];
    updatedAt = json['updatedAt'];
    short = json['short'] != null ? new Short.fromJson(json['short']) : null;
    praise = json['praise'];
    isPraise = json['isPraise'];
    topicId = json['topicId'];
    topicName = json['topicName'];
        compliance = json['compliance'];
    passStatus = json['pass_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    if (this.goods != null) {
      data['goods'] = this.goods.toJson();
    }
    data['id'] = this.id;
    if (this.imgList != null) {
      data['imgList'] = this.imgList.map((v) => v.toJson()).toList();
    }
    data['originId'] = this.originId;
    data['trendType'] = this.trendType;
    data['updatedAt'] = this.updatedAt;
    if (this.short != null) {
      data['short'] = this.short.toJson();
    }
    data['praise'] = this.praise;
    data['isPraise'] = this.isPraise;
    data['topicId'] = this.topicId;
    data['topicName'] = this.topicName;
    data['compliance'] = this.compliance;
    data['pass_status'] = this.passStatus;

    return data;
  }
}

class Goods {
  int id;
  String mainPhotoURL;
  String name;
  String price;

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

class ImgList {
  num height;
  int id;
  int momentsCopyId;
  String url;
  num width;

  ImgList({this.height, this.id, this.momentsCopyId, this.url, this.width});

  ImgList.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    id = json['id'];
    momentsCopyId = json['momentsCopyId'];
    url = json['url'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['id'] = this.id;
    data['momentsCopyId'] = this.momentsCopyId;
    data['url'] = this.url;
    data['width'] = this.width;
    return data;
  }
}

class Short {
  String mediaUrl;
  String coverUrl;

  Short({this.mediaUrl, this.coverUrl});

  Short.fromJson(Map<String, dynamic> json) {
    mediaUrl = json['media_url'];
    coverUrl = json['cover_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['media_url'] = this.mediaUrl;
    data['cover_url'] = this.coverUrl;
    return data;
  }
}
