class TopicListModel {
  int id;
  String title;
  String createdAt;
  String updatedAt;
  int isDel;
  int isHot;
  String topicImg;
  int substance;
  int partake;
  int isFollow;

  TopicListModel(
      {this.id,
      this.title,
      this.createdAt,
      this.updatedAt,
      this.isDel,
      this.isHot,
      this.topicImg,
      this.substance,
      this.partake,
      this.isFollow});

  TopicListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isDel = json['isDel'];
    isHot = json['isHot'];
    topicImg = json['topicImg'];
    substance = json['substance'];
    partake = json['partake'];
    isFollow = json['isFollow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['isDel'] = this.isDel;
    data['isHot'] = this.isHot;
    data['topicImg'] = this.topicImg;
    data['substance'] = this.substance;
    data['partake'] = this.partake;
    data['isFollow'] = this.isFollow;
    return data;
  }
}
