class GoodsHotSellListModel {
  String code;
  String msg;
  List<Data> data;

  GoodsHotSellListModel({this.code, this.msg, this.data});

  GoodsHotSellListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  String goodsName;
  String description;
  num inventory;
  num salesVolume;
  String mainPhotoUrl;
  String promotionName;
  num discountPrice;
  num originalPrice;
  num commission;
  num index;
  num coupon;
  String brandName;
  String brandImg;
  num brandId;
  int isImport;
  int isFerme;
  int storehouse;
  String countryIcon;
  Data({
    this.id,
    this.goodsName,
    this.description,
    this.inventory,
    this.salesVolume,
    this.mainPhotoUrl,
    this.promotionName,
    this.discountPrice,
    this.originalPrice,
    this.commission,
    this.coupon,
    this.index = 0,
    this.brandName,
    this.brandImg,
    this.brandId,
    this.isFerme,
    this.isImport,
    this.storehouse,
    this.countryIcon,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodsName = json['goodsName'];
    description = json['description'];
    inventory = json['inventory'];
    salesVolume = json['salesVolume'];
    mainPhotoUrl = json['mainPhotoUrl'];
    promotionName = json['promotionName'];
    discountPrice = json['discountPrice'];
    originalPrice = json['originalPrice'];
    commission = json['commission'];
    coupon = json['coupon'];
    brandName = json['brandName'];
    brandImg = json['brandImg'];
    brandId = json['brandId'];
    isImport = json['isImport'];
    isFerme = json['isFerme'];
    storehouse = json['storehouse'];
    countryIcon = json['country_icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['goodsName'] = this.goodsName;
    data['description'] = this.description;
    data['inventory'] = this.inventory;
    data['salesVolume'] = this.salesVolume;
    data['mainPhotoUrl'] = this.mainPhotoUrl;
    data['promotionName'] = this.promotionName;
    data['discountPrice'] = this.discountPrice;
    data['originalPrice'] = this.originalPrice;
    data['commission'] = this.commission;
    data['coupon'] = this.coupon;
    data['isImport'] = this.isImport;
    data['isFerme'] = this.isFerme;
    data['storehouse'] = this.storehouse;
    data['country_icon'] = this.countryIcon;
    return data;
  }
}
