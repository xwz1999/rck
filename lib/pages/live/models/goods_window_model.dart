class GoodsWindowModel {
  List<GoodsList> list;
  num total;

  GoodsWindowModel({this.list, this.total});

  GoodsWindowModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list.add(new GoodsList.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class GoodsList {
  num id;
  String goodsName;
  String brandImg;
  String brandName;
  num brandId;
  String description;
  num inventory;
  num salesVolume;
  String mainPhotoUrl;
  String promotionName;
  String originalPrice;
  String discountPrice;
  String commission;
  List<String> tags;
  num percent;
  String startTime;
  String endTime;
  String coupon;

  GoodsList(
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

  GoodsList.fromJson(Map<String, dynamic> json) {
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
