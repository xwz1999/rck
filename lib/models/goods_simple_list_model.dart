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
  String brandName;
  String brandImg;
  num brandId;
  int isImport;
  int isFerme;
  int storehouse;
  GoodsSimple({
    this.id,
    this.goodsName,
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
    this.brandName,
    this.brandImg,
    this.brandId,
    this.isFerme,
    this.isImport,
    this.storehouse,
  });

  GoodsSimple.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodsName = json['goodsName'];
    description = json['description'];
    inventory = json['inventory'];
    salesVolume = json['salesVolume'];
    mainPhotoUrl = json['mainPhotoUrl'];
    promotionName = json['promotionName'];
    originalPrice = json['originalPrice'];
    discountPrice = json['discountPrice'];
    commission = json['commission'];
    if (json['tags'] != null) {
      tags = json['tags'].cast<String>();
    }
    percent = json['percent'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    coupon = json['coupon'];
    brandName = json['brandName'];
    brandImg = json['brandImg'];
    brandId = json['brandId'];
    isImport = json['isImport'];
    isFerme = json['isFerme'];
    storehouse = json['storehouse'];
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
    data['originalPrice'] = this.originalPrice;
    data['discountPrice'] = this.discountPrice;
    data['commission'] = this.commission;
    data['tags'] = this.tags;
    data['percent'] = this.percent;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['isImport'] = this.isImport;
    data['isFerme'] = this.isFerme;
    data['storehouse'] = this.storehouse;
    return data;
  }

  getPromotionStatus() {
    return PromotionTimeTool.getPromotionStatusWithGoodsSimple(this);
  }
}
