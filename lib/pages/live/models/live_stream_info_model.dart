class LiveStreamInfoModel {
  String nickname;
  String headImgUrl;
  String playUrl;
  int userId;
  int id;
  int isFollow;
  int isPraise;
  int praise;
  String groupId;
  List<GoodsLists> goodsLists;

  LiveStreamInfoModel(
      {this.nickname,
      this.headImgUrl,
      this.playUrl,
      this.userId,
      this.id,
      this.isFollow,
      this.isPraise,
      this.praise,
      this.groupId,
      this.goodsLists});

  LiveStreamInfoModel.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    headImgUrl = json['headImgUrl'];
    playUrl = json['playUrl'];
    userId = json['userId'];
    id = json['id'];
    isFollow = json['isFollow'];
    isPraise = json['isPraise'];
    praise = json['praise'];
    groupId = json['groupId'];
    if (json['goodsLists'] != null) {
      goodsLists = new List<GoodsLists>();
      json['goodsLists'].forEach((v) {
        goodsLists.add(new GoodsLists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['headImgUrl'] = this.headImgUrl;
    data['playUrl'] = this.playUrl;
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['isFollow'] = this.isFollow;
    data['isPraise'] = this.isPraise;
    data['praise'] = this.praise;
    data['groupId'] = this.groupId;
    if (this.goodsLists != null) {
      data['goodsLists'] = this.goodsLists.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GoodsLists {
  int id;
  String goodsName;
  String brandImg;
  String brandName;
  int brandId;
  String description;
  int inventory;
  int salesVolume;
  String mainPhotoUrl;
  String promotionName;
  String originalPrice;
  String discountPrice;
  String commission;
  List<String> tags;
  int percent;
  String startTime;
  String endTime;
  String coupon;
  int isExplain;

  GoodsLists(
      {this.id,
      this.goodsName,
      this.brandImg,
      this.brandName,
      this.brandId,
      this.description,
      this.inventory,
      this.salesVolume,
      this.mainPhotoUrl,
      this.promotionName,
      this.originalPrice,
      this.discountPrice,
      this.commission,
      this.tags,
      this.percent,
      this.startTime,
      this.endTime,
      this.coupon,
      this.isExplain});

  GoodsLists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodsName = json['goodsName'];
    brandImg = json['brandImg'];
    brandName = json['brandName'];
    brandId = json['brandId'];
    description = json['description'];
    inventory = json['inventory'];
    salesVolume = json['salesVolume'];
    mainPhotoUrl = json['mainPhotoUrl'];
    promotionName = json['promotionName'];
    originalPrice = json['originalPrice'];
    discountPrice = json['discountPrice'];
    commission = json['commission'];
    tags = json['tags'].cast<String>();
    percent = json['percent'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    coupon = json['coupon'];
    isExplain = json['isExplain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['goodsName'] = this.goodsName;
    data['brandImg'] = this.brandImg;
    data['brandName'] = this.brandName;
    data['brandId'] = this.brandId;
    data['description'] = this.description;
    data['inventory'] = this.inventory;
    data['salesVolume'] = this.salesVolume;
    data['mainPhotoUrl'] = this.mainPhotoUrl;
    data['promotionName'] = this.promotionName;
    data['originalPrice'] = this.originalPrice;
    data['discountPrice'] = this.discountPrice;
    data['commission'] = this.commission;
    data['tags'] = this.tags;
    data['percent'] = this.percent;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['coupon'] = this.coupon;
    data['isExplain'] = this.isExplain;
    return data;
  }
}
