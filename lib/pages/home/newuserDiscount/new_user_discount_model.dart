

import 'package:json_annotation/json_annotation.dart';

part 'new_user_discount_model.g.dart';

@JsonSerializable()
class NewUserDiscountModel {

  String code;

  Data data;

  String msg;

  NewUserDiscountModel(this.code, this.data, this.msg);

  factory NewUserDiscountModel.fromJson(Map<String, dynamic> json) => _$NewUserDiscountModelFromJson(json);
  Map<String, dynamic> toJson() => _$NewUserDiscountModelToJson(this);
}

@JsonSerializable()
class Data {
  /*
  "name" -> "10减1品牌券"
1:"cash" -> 1
2:"explanation" -> "左家右厨适用"
3:"status" -> 0
4:"goodsList" -> List (2 items)
  */

  String name;
  num cash;
  String explanation;
  int status;
  List<Goods> goodsList;
  int couponId;


  Data(this.name, this.cash, this.explanation, this.status, this.goodsList, this.couponId);

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);

}

@JsonSerializable()
class Goods {

  /*
  0:"goodsId" -> 1
  1:"goodsName" -> "圆形塑料菜板a"
  2:"mainPhotoUrl" -> "/photo/4291bc8efd9c0e920cb017304a5a9d10.jpg"
  3:"label" -> "新人特惠"
  4:"price" -> "8.50"
  5:"OriginPrice" -> "0.20"
  */

  int goodsId;
  String goodsName;
  String mainPhotoUrl;
  String label;
  String price;
  String originPrice;

  Goods(this.goodsId, this.goodsName, this.mainPhotoUrl, this.label, this.price, this.originPrice);

  factory Goods.fromJson(Map<String, dynamic> json) => _$GoodsFromJson(json);
  Map<String, dynamic> toJson() => _$GoodsToJson(this);
}
