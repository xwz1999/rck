import 'package:recook/pages/home/promotion_time_tool.dart';

class GoodsSimpleListModel {
  String code;
  String msg;
  List<GoodsSimple> data;

  GoodsSimpleListModel({this.code, this.msg, this.data});
  GoodsSimpleListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new GoodsSimple.fromJson(v));
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

class GoodsSimple {
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
  num originalPrice;
  num discountPrice;
  num commission;
  List<String> tags;
  num percent;
  String startTime;
  String endTime;
  num coupon;
  num isImport;
  num storehouse;
  num isFerme;
  bool hasCoin;
  bool hasBalance;
  Living living;
  num gysId;
  List<String> specialIcon;
  String countryIcon;
  GoodsSimple(
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
      this.isImport,
      this.storehouse,
      this.isFerme,
      this.hasCoin,
      this.hasBalance,
      this.living,
      this.gysId,
      this.specialIcon,
      this.countryIcon});

  GoodsSimple.fromJson(Map<String, dynamic> json) {
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
    tags =
    json['tags'] != null ? json['tags'].cast<String>() : null;
    percent = json['percent'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    coupon = json['coupon'];
    isImport = json['isImport'];
    storehouse = json['storehouse'];
    isFerme = json['isFerme'];
    hasCoin = json['hasCoin'];
    hasBalance = json['hasBalance'];
    living =
        json['living'] != null ? new Living.fromJson(json['living']) : null;
    gysId = json['gys_id'];

    specialIcon =
        json['spec_icon'] != null ? json['spec_icon'].cast<String>() : null;
    countryIcon = json['country_icon'];
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
    data['isImport'] = this.isImport;
    data['storehouse'] = this.storehouse;
    data['isFerme'] = this.isFerme;
    data['hasCoin'] = this.hasCoin;
    data['hasBalance'] = this.hasBalance;
    if (this.living != null) {
      data['living'] = this.living.toJson();
    }
    data['gys_id'] = this.gysId;
    data['spec_icon'] = this.specialIcon;
    data['country_icon'] = this.countryIcon;
    return data;
  }

  getPromotionStatus() {
    return PromotionTimeTool.getPromotionStatusWithGoodsSimple(this);
  }
}

class Living {
  int status;
  int roomId;

  Living({this.status, this.roomId});

  Living.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    roomId = json['room_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['room_id'] = this.roomId;
    return data;
  }
}
