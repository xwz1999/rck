// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponListModel _$CouponListModelFromJson(Map<String, dynamic> json) {
  return CouponListModel(
      json['code'],
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Coupon.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['msg']);
}

Map<String, dynamic> _$CouponListModelToJson(CouponListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

Coupon _$CouponFromJson(Map<String, dynamic> json) {
  return Coupon(
      json['id'] as int,
      json['name'] as String,
      json['quantity'] as int,
      json['cash'] as int,
      json['threshold'] as int,
      (json['discount'] as num)?.toDouble(),
      json['limit'] as int,
      json['scope'] as int,
      json['type'] as int,
      json['brandId'] as int,
      json['startTime'] as String,
      json['endTime'] as String,
      json['explanation'] as String,
      json['isReceived'] as int);
}

Map<String, dynamic> _$CouponToJson(Coupon instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'cash': instance.cash,
      'threshold': instance.threshold,
      'discount': instance.discount,
      'limit': instance.limit,
      'scope': instance.scope,
      'type': instance.type,
      'brandId': instance.brandId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'explanation': instance.explanation,
      'isReceived': instance.isReceived
    };
