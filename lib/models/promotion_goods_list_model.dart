import 'package:json_annotation/json_annotation.dart';

import 'package:recook/pages/home/promotion_time_tool.dart';

part 'promotion_goods_list_model.g.dart';

@JsonSerializable()
class PromotionGoodsListModel extends Object {
  String code;

  PromotionModel data;

  String msg;

  PromotionGoodsListModel(
    this.code,
    this.data,
    this.msg,
  );

  factory PromotionGoodsListModel.fromJson(Map<String, dynamic> srcJson) =>
      _$PromotionGoodsListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PromotionGoodsListModelToJson(this);
}

@JsonSerializable()
class PromotionModel extends Object {
  List<PromotionGoodsModel> goodsList;
  List<PromotionActivityModel> activityList;
  PromotionModel(this.goodsList, this.activityList);
  factory PromotionModel.fromJson(Map<String, dynamic> srcJson) =>
      _$PromotionModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PromotionModelToJson(this);
}

@JsonSerializable()
class PromotionActivityModel extends Object {
  num id;
  String activityUrl;
  String logoUrl;
  String topUrl;

  PromotionActivityModel(this.id, this.activityUrl, this.logoUrl, this.topUrl);
  factory PromotionActivityModel.fromJson(Map<String, dynamic> srcJson) =>
      _$PromotionActivityModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PromotionActivityModelToJson(this);
}

@JsonSerializable()
class PromotionGoodsModel extends Object {
  /*
  {
    "goodsName":"左家右厨丰子恺清代古画",
    "description":"珍惜古董",
    "price":34444.5,
    "priceDesc":"¥34444.50",
    "commission":100,
    "commissionDesc":"¥100.00",
    "picture":{
        "url":"/photo/3829010101001hassnja.png",
        "width":500,
        "height":300
    },
    "inventory":1000,
    "inventoryDesc":"库存1000",
    "totalInventory":1000,
    "totalInventoryDesc":"限购1000件",
    "totalSalesVolume":10,
    "salesVolumeDesc":"已抢10件",
    "startTime":"2019-11-29 14:28",
    "endTime":"2019-11-29 14:28",
    "percentageDesc":"10%"
  } 
  */

  int goodsId;
  String goodsName;
  String description;
  double price;
  String priceDesc;
  double commission;
  String commissionDesc;
  int inventory;
  String inventoryDesc;
  int totalInventory;
  String totalInventoryDesc;
  int totalSalesVolume;
  String salesVolumeDesc;
  String startTime;
  String endTime;
  String percentageDesc;
  double percentage;
  Picture picture;
  num primePrice;
  num coupon;
  String brandName;
  String brandImg;
  num brandId;
  num isImport;
  num isFerme;
  num storehouse;

  PromotionGoodsModel(
    this.goodsId,
    this.goodsName,
    this.description,
    this.price,
    this.priceDesc,
    this.commission,
    this.commissionDesc,
    this.inventory,
    this.inventoryDesc,
    this.totalInventory,
    this.totalInventoryDesc,
    this.totalSalesVolume,
    this.salesVolumeDesc,
    this.startTime,
    this.endTime,
    this.percentageDesc,
    this.percentage,
    this.picture,
    this.primePrice,
    this.coupon,
    this.brandName,
    this.brandImg,
    this.brandId,
    this.isImport,
    this.isFerme,
    this.storehouse,
  );

  factory PromotionGoodsModel.fromJson(Map<String, dynamic> srcJson) =>
      _$PromotionGoodsModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PromotionGoodsModelToJson(this);

  getPromotionStatus() {
    return PromotionTimeTool.getPromotionStatusWithPGModel(this);
  }

  // ColumnGoodsModel transformToColumnModel() {
  //   ColumnGoodsModel columnGoodsModel = ColumnGoodsModel(
  //     isProcessing: this.isProcessing,
  //     salesVolume: this.salesVolume,
  //     title: this.goodsName,
  //     inventory: this.inventory,
  //     price: this.price.min.discountPrice,
  //     commission: this.price.min.commission,
  //     des: this.description,
  //     imgUrl: this.picture.url);
  //   return columnGoodsModel;
  // }
}

@JsonSerializable()
class Picture extends Object {
  String url;

  int width;

  int height;

  Picture(
    this.url,
    this.width,
    this.height,
  );

  factory Picture.fromJson(Map<String, dynamic> srcJson) =>
      _$PictureFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PictureToJson(this);
}
