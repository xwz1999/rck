class LiveListModel {
  String title;
  int id;
  String cover;
  String nickname;
  String headImgUrl;
  int look;
  String goodsName;
  String mainPhotoUrl;
  int praise;
  String originalPrice;
  String discountPrice;

  LiveListModel(
      {this.title,
      this.id,
      this.cover,
      this.nickname,
      this.headImgUrl,
      this.look,
      this.goodsName,
      this.mainPhotoUrl,
      this.originalPrice,
      this.discountPrice});

  LiveListModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    cover = json['cover'];
    nickname = json['nickname'];
    headImgUrl = json['headImgUrl'];
    look = json['look'];
    goodsName = json['goodsName'];
    mainPhotoUrl = json['mainPhotoUrl'];
    originalPrice = json['originalPrice'];
    discountPrice = json['discountPrice'];
    praise = json['praise'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['id'] = this.id;
    data['cover'] = this.cover;
    data['nickname'] = this.nickname;
    data['headImgUrl'] = this.headImgUrl;
    data['look'] = this.look;
    data['goodsName'] = this.goodsName;
    data['mainPhotoUrl'] = this.mainPhotoUrl;
    data['originalPrice'] = this.originalPrice;
    data['discountPrice'] = this.discountPrice;
    data['praise'] = this.praise;
    return data;
  }
}
