// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alipay_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlipayOrderModel _$AlipayOrderModelFromJson(Map<String, dynamic> json) {
  return AlipayOrderModel(
      json['code'],
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      json['msg']);
}

Map<String, dynamic> _$AlipayOrderModelToJson(AlipayOrderModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(json['orderString'] as String);
}

Map<String, dynamic> _$DataToJson(Data instance) =>
    <String, dynamic>{'orderString': instance.orderString};
