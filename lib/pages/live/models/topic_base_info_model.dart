class TopicBaseInfoModel {
  int? id;
  String? title;
  int? substance;
  int? partake;
  String? createdAt;
  String? updatedAt;
  int? isDel;
  int? isHot;
  String? topicImg;
  int? isFollow;

  TopicBaseInfoModel(
      {this.id,
      this.title,
      this.substance,
      this.partake,
      this.createdAt,
      this.updatedAt,
      this.isDel,
      this.isHot,
      this.topicImg,
      this.isFollow});

  TopicBaseInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    substance = json['substance'];
    partake = json['partake'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isDel = json['isDel'];
    isHot = json['isHot'];
    topicImg = json['topicImg'];
    isFollow = json['isFollow'];
  }

  TopicBaseInfoModel.zero() {
    id = 0;
    title = '';
    substance = 0;
    partake = 0;
    createdAt = "2020-09-11 14:48:56";
    updatedAt = "2020-09-11 14:49:00";
    isDel = 0;
    isHot = 0;
    topicImg = '';
    isFollow = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['substance'] = this.substance;
    data['partake'] = this.partake;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['isDel'] = this.isDel;
    data['isHot'] = this.isHot;
    data['topicImg'] = this.topicImg;
    data['isFollow'] = this.isFollow;
    return data;
  }
}
