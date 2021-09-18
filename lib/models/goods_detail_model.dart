import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/price_model.dart';

import 'goods_simple_list_model.dart';

part 'goods_detail_model.g.dart';

/*
{
    "code": "SUCCESS",
    "data": {
        "code": "SUCCESS",
        "data": {
            "id": 10,
            "brandId": 1,
            "goodsName": "美女装 网红品牌 夏装",
            "description": "日本进口",
            "firstCategoryId": 1,
            "secondCategoryId": 2,
            "FreightID": 1,
            "weight": 0.1,
            "inventory": 0,
            "salesVolume": 0,
            "price": {
                "min": {
                    "originalPrice": 0.02,
                    "discountPrice": 0.01,
                    "commission": 0
                },
                "max": {
                    "originalPrice": 0.02,
                    "discountPrice": 0.01,
                    "commission": 0
                }
            },
            "video": {
                "id": 1,
                "url": "/video/1561431762233000.mp4",
                "duration": 5,
                "size": 0.6
            },
            "mainPhotos": [
                {
                    "id": 10,
                    "goodsId": 10,
                    "url": "/photo/1561367346534618.jpg",
                    "isMaster": 1,
                    "orderNo": 0,
                    "width": 100,
                    "height": 100
                }
            ],
            "attributes": [
                {
                    "name": "颜色",
                    "children": [
                        {
                            "id": 10,
                            "value": "红色"
                        }
                    ]
                }
            ],
            "sku": [
                {
                    "id": 10,
                    "goodsId": 10,
                    "combineId": "10",
                    "picUrl": "/photo/1561431788095859.jpg",
                    "originalPrice": 0.02,
                    "discountPrice": 0.01,
                    "commission": 0,
                    "salesVolume": 0,
                    "inventory": 200
                }
            ],
            "promotion": null,
            "brand": {
                "id": 1,
                "name": "测试品牌",
                "desc": "测试品牌测试品牌测试品牌",
                "tel": "18812345678",
                "web": "https://www.baidu.com",
                "goodsCount": 4,
                "logoUrl": "/photo/fb3701c8f6adde26d60d2da988ee09c9.png",
                "authUrl": "/photo/fb3701c8f6adde26d60d2da988ee09c9.png"
            },
            "evaluations": {
                "total": 0,
                "children": []
            },
            "coupons": [
                {
                    "id": 1,
                    "name": "50减20通用券",
                    "quantity": 998,
                    "cash": 20,
                    "threshold": 50,
                    "limit": 2,
                    "scope": 0,
                    "brandId": 0,
                    "startTime": "2019-07-14 10:33:32",
                    "endTime": "2019-08-31 10:33:38",
                    "explanation": "全场通用无限制"
                }
            ]
        },
        "msg": "操作成功"
    }
}
 */

@JsonSerializable()
class GoodsDetailModel extends BaseModel {
  Data data;

  GoodsDetailModel(code, this.data, msg) : super(code, msg);

  factory GoodsDetailModel.fromJson(Map<String, dynamic> srcJson) =>
      _$GoodsDetailModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GoodsDetailModelToJson(this);
}

@JsonSerializable()
class Data extends Object {
  int id;

  int brandId;


  String goodsName;

  String description;

  int firstCategoryId;

  int secondCategoryId;

  int inventory;

  int salesVolume;

  Price price;

  Video video;

  List<MainPhotos> mainPhotos;

  List<Attributes> attributes;

  List<Sku> sku;

  Promotion promotion;

  Brand brand;

  Evaluations evaluations;

  List<Coupons> coupons;

  bool isFavorite;

  int shoppingTrolleyCount; //购物车数量

  Notice notice;

  List<Recommends> recommends;

  num isImport;
  num isFerme;
  num storehouse;
  String countryIcon;
  Living living;

  Seckill seckill;
  int vendorId;


  Data(
      this.id,
      this.brandId,
      this.goodsName,
      this.description,
      this.firstCategoryId,
      this.secondCategoryId,
      this.inventory,
      this.salesVolume,
      this.price,
      this.video,
      this.mainPhotos,
      this.attributes,
      this.sku,
      this.promotion,
      this.brand,
      this.evaluations,
      this.coupons,
      this.isFavorite,
      this.shoppingTrolleyCount,
      this.recommends,
      this.isImport,
      this.isFerme,
      this.storehouse,
      this.notice,
      this.countryIcon,
      this.living,
      this.seckill,
      this.vendorId
      );

  factory Data.fromJson(Map<String, dynamic> srcJson) =>
      _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);
  getPriceString() {
    if (price == null) {
      return "";
    }
    double minPrice = price.min.discountPrice;
    double maxPrice = price.max.discountPrice;
    String returnPrice;
    if (minPrice == maxPrice) {
      returnPrice = maxPrice.toStringAsFixed(2);
    } else {
      returnPrice =
          "${minPrice.toStringAsFixed(2)}-${maxPrice.toStringAsFixed(2)}";
    }
    return returnPrice;
  }
}

class Seckill {
  num seckill_status;
  String seckillEndTime;
  num seckillMinPrice;
  num seckillCommission;

  Seckill({this.seckill_status, this.seckillEndTime, this.seckillMinPrice, this.seckillCommission});

  Seckill.fromJson(Map<String, dynamic> json) {
    seckill_status = json['sec_kill'];
    seckillEndTime = json['sec_kill_end_time'];
    seckillMinPrice = json['sec_kill_min_price'];
    seckillCommission = json['sec_kill_commission'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sec_kill'] = this.seckill_status;
    data['sec_kill_end_time'] = this.seckillEndTime;
    data['sec_kill_min_price'] = this.seckillMinPrice;
    data['sec_kill_commission'] = this.seckillCommission;
    return data;
  }
}

@JsonSerializable()
class MainPhotos extends Object {
  int id;

  int goodsId;

  String url;

  int isMaster;

  int orderNo;

  int width;

  int height;

  bool isSelect;
  int isSelectNumber;

  MainPhotos(this.id, this.goodsId, this.url, this.isMaster, this.orderNo,
      this.width, this.height,
      {this.isSelect = false, this.isSelectNumber = 0});

  factory MainPhotos.fromJson(Map<String, dynamic> srcJson) =>
      _$MainPhotosFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MainPhotosToJson(this);
}

@JsonSerializable()
class Attributes extends Object {
  String name;

  List<Children> children;

  Attributes(
    this.name,
    this.children,
  );

  factory Attributes.fromJson(Map<String, dynamic> srcJson) =>
      _$AttributesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AttributesToJson(this);
}

@JsonSerializable()
class Children extends Object {
  int id;

  String value;

  Children(
    this.id,
    this.value,
  );

  factory Children.fromJson(Map<String, dynamic> srcJson) =>
      _$ChildrenFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ChildrenToJson(this);
}

@JsonSerializable()
class Sku extends Object {
  int id;

  int goodsId;

  String combineId;

  String picUrl;

  String code;

  double originalPrice;

  double discountPrice;

  double commission;

  int salesVolume;

  int inventory;

  String name;
  num coupon;

  Sku(
      this.id,
      this.goodsId,
      this.combineId,
      this.picUrl,
      this.code,
      this.originalPrice,
      this.discountPrice,
      this.commission,
      this.salesVolume,
      this.inventory,
      this.name,
      this.coupon);

  factory Sku.fromJson(Map<String, dynamic> srcJson) => _$SkuFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SkuToJson(this);
}

@JsonSerializable()
class Promotion extends Object {
  int id;
  int promotionId;
  String promotionName;
  String date;
  int goodsId;
  String startTime;
  String endTime;
  int totalInventory; //库存

  // String name;

  // String labels;

  // double discount;

  Promotion(this.id, this.promotionId, this.promotionName, this.date,
      this.goodsId, this.startTime, this.endTime, this.totalInventory);

  factory Promotion.fromJson(Map<String, dynamic> srcJson) =>
      _$PromotionFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PromotionToJson(this);

  bool isWaitPromotionStart() {
    if (TextUtils.isEmpty(this.startTime)) {
      return false;
    }
    DateTime promotionDate = DateTime.parse(startTime);
    if (DateTime.now().isBefore(promotionDate)) {
      return true;
    }
    return false;
  }
}

@JsonSerializable()
class Brand extends Object {
  int id;

  String name;

  String desc;

  String tel;

  String web;

  int goodsCount;

  String logoUrl;

  String firstImg;
  String lastImg;

  // String authUrl;

  String showUrl;

  Brand(this.id, this.name, this.desc, this.tel, this.web, this.goodsCount,
      this.logoUrl, this.showUrl, this.firstImg, this.lastImg);

  factory Brand.fromJson(Map<String, dynamic> srcJson) =>
      _$BrandFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BrandToJson(this);
}

@JsonSerializable()
class Evaluations extends Object {
  int total;

  List<Evaluation> children;

  Evaluations(
    this.total,
    this.children,
  );

  factory Evaluations.fromJson(Map<String, dynamic> srcJson) =>
      _$EvaluationsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EvaluationsToJson(this);
}

@JsonSerializable()
class Evaluation extends Object {
  int id;

  int userId;

  BigInt orderId;

  int goodsId;

  String nickname;

  String headImgUrl;

  String content;

  Evaluation(
    this.id,
    this.userId,
    this.orderId,
    this.goodsId,
    this.nickname,
    this.headImgUrl,
    this.content,
  );

  factory Evaluation.fromJson(Map<String, dynamic> srcJson) =>
      _$EvaluationFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EvaluationToJson(this);
}

@JsonSerializable()
class Coupons extends Object {
  int id;

  String name;

  int quantity;

  int cash;

  int threshold;

  double discount;

  int limit;

  int scope;

  int type;

  int brandId;

  String startTime;

  String endTime;

  String explanation;

  Coupons(
    this.id,
    this.name,
    this.quantity,
    this.cash,
    this.threshold,
    this.discount,
    this.limit,
    this.scope,
    this.type,
    this.brandId,
    this.startTime,
    this.endTime,
    this.explanation,
  );

  factory Coupons.fromJson(Map<String, dynamic> srcJson) =>
      _$CouponsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CouponsToJson(this);
}

@JsonSerializable()
class Video extends Object {
  int id;

  String url;

  int duration;

  double size;

  String thumbnail;

  Video(this.id, this.url, this.duration, this.size, this.thumbnail);

  factory Video.fromJson(Map<String, dynamic> srcJson) =>
      _$VideoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VideoToJson(this);
}

@JsonSerializable()
class Recommends extends Object {
  String goodsName;
  int goodsId;
  String price;
  String mainPhotoUrl;

  Recommends(this.goodsName, this.goodsId, this.price, this.mainPhotoUrl);

  factory Recommends.fromJson(Map<String, dynamic> srcJson) =>
      _$RecommendsFromJson(srcJson);
  Map<String, dynamic> toJson() => _$RecommendsToJson(this);
}

class Notice {
  String title;
  String img;

  ///type: 1头显示，2尾显示，3头尾显示
  int type;
  Notice({
    this.title,
    this.img,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'img': img,
      'type': type,
    };
  }

  factory Notice.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Notice(
      title: map['title'],
      img: map['img'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Notice.fromJson(dynamic source) => Notice.fromMap(source);
}
