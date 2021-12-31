import 'package:json_annotation/json_annotation.dart';

import 'package:jingyaoyun/models/base_model.dart';

part 'coupon_list_model.g.dart';


@JsonSerializable()
class CouponListModel extends BaseModel {

  List<Coupon> data;

  CouponListModel(code,this.data,msg,) : super(code, msg);

  factory CouponListModel.fromJson(Map<String, dynamic> srcJson) => _$CouponListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CouponListModelToJson(this);

}


@JsonSerializable()
class Coupon extends Object {

  int id;

  String name;

  int quantity;

  int cash;

  int threshold;

  double discount;

  int limit;

  // 0、通用   1、品牌
  int scope;

  // 0 满减   //1 折扣
  int type;

  int brandId;

  String startTime;

  String endTime;

  String explanation;

  int isReceived;

  Coupon(this.id,this.name,this.quantity,this.cash,this.threshold,this.discount,this.limit,this.scope,this.type,this.brandId,this.startTime,this.endTime,this.explanation,this.isReceived,);

  factory Coupon.fromJson(Map<String, dynamic> srcJson) => _$CouponFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CouponToJson(this);
}

  
