class VideoGoodsModel {
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

  VideoGoodsModel(
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
      this.coupon});

  VideoGoodsModel.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
