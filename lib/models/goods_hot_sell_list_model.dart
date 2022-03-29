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
  int gysId;
  SecKill secKill;
  num salePrice;

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
    this.gysId,
    this.secKill,
    this.salePrice
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
    gysId = json['gys_id'];
    salePrice = json['sale_price'];
    secKill = json['sec_kill'] != null
        ? new SecKill.fromJson(json['sec_kill'])
        : null;
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
    data['gys_id'] = this.gysId;
    data['sale_price'] = this.salePrice;
    if (this.secKill != null) {
      data['sec_kill'] = this.secKill.toJson();
    }
    return data;
  }
}
class SecKill {
  int secKill;
  String secKillEndTime;
  num secKillMinPrice;
  num secKillCommission;
  num realStock;
  num secStock;
  num saleNum;

  SecKill(
      {this.secKill,
        this.secKillEndTime,
        this.secKillMinPrice,
        this.secKillCommission,
        this.realStock,
        this.secStock,
        this.saleNum
      });

  SecKill.fromJson(Map<String, dynamic> json) {
    secKill = json['sec_kill'];
    secKillEndTime = json['sec_kill_end_time'];
    secKillMinPrice = json['sec_kill_min_price'];
    secKillCommission = json['sec_kill_commission'];
    realStock = json['real_stock'];
    secStock = json['sec_stock'];
    saleNum = json['sale_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sec_kill'] = this.secKill;
    data['sec_kill_end_time'] = this.secKillEndTime;
    data['sec_kill_min_price'] = this.secKillMinPrice;
    data['sec_kill_commission'] = this.secKillCommission;
    data['real_stock'] = this.realStock;
    data['sec_stock'] = this.secStock;
    data['sale_num'] = this.saleNum;
    return data;
  }
}
