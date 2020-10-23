class ActivityVideoListModel {
  int id;
  int goodsCount;
  String cover;
  int look;
  String title;
  int isLive;
  int startAt;

  ActivityVideoListModel(
      {this.id,
      this.goodsCount,
      this.cover,
      this.look,
      this.title,
      this.isLive,
      this.startAt});

  ActivityVideoListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodsCount = json['goodsCount'];
    cover = json['cover'];
    look = json['look'];
    title = json['title'];
    isLive = json['isLive'];
    startAt = json['startAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['goodsCount'] = this.goodsCount;
    data['cover'] = this.cover;
    data['look'] = this.look;
    data['title'] = this.title;
    data['isLive'] = this.isLive;
    data['startAt'] = this.startAt;
    return data;
  }
}
