class ViewGoodsModel {
  int id;
  String goodsName;
  String subtitle;
  String mainPhotoUrl;
  String brandName;
  String brandLogo;
  int inventory;
  int salesVolume;
  String promotionName;
  int originalPrice;
  int discountPrice;
  double commission;
  int coupon;
  Null tags;
  int percent;
  Null startTime;
  Null endTime;
  Live live;

  ViewGoodsModel(
      {this.id,
      this.goodsName,
      this.subtitle,
      this.mainPhotoUrl,
      this.brandName,
      this.brandLogo,
      this.inventory,
      this.salesVolume,
      this.promotionName,
      this.originalPrice,
      this.discountPrice,
      this.commission,
      this.coupon,
      this.tags,
      this.percent,
      this.startTime,
      this.endTime,
      this.live});

  ViewGoodsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodsName = json['goods_name'];
    subtitle = json['subtitle'];
    mainPhotoUrl = json['main_photo_url'];
    brandName = json['brand_name'];
    brandLogo = json['brand_logo'];
    inventory = json['inventory'];
    salesVolume = json['salesVolume'];
    promotionName = json['promotionName'];
    originalPrice = json['originalPrice'];
    discountPrice = json['discountPrice'];
    commission = json['commission'];
    coupon = json['coupon'];
    tags = json['tags'];
    percent = json['percent'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    live = json['live'] != null ? new Live.fromJson(json['live']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['goods_name'] = this.goodsName;
    data['subtitle'] = this.subtitle;
    data['main_photo_url'] = this.mainPhotoUrl;
    data['brand_name'] = this.brandName;
    data['brand_logo'] = this.brandLogo;
    data['inventory'] = this.inventory;
    data['salesVolume'] = this.salesVolume;
    data['promotionName'] = this.promotionName;
    data['originalPrice'] = this.originalPrice;
    data['discountPrice'] = this.discountPrice;
    data['commission'] = this.commission;
    data['coupon'] = this.coupon;
    data['tags'] = this.tags;
    data['percent'] = this.percent;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    if (this.live != null) {
      data['live'] = this.live.toJson();
    }
    return data;
  }
}

class Live {
  int status;
  int itemId;

  Live({this.status, this.itemId});

  Live.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    itemId = json['item_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['item_id'] = this.itemId;
    return data;
  }
}
