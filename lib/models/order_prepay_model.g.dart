// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_prepay_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderPrepayModel _$OrderPrepayModelFromJson(Map<String, dynamic> json) {
  return OrderPrepayModel(
      json['code'],
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      json['msg']);
}

Map<String, dynamic> _$OrderPrepayModelToJson(OrderPrepayModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['id'] as int,
      json['userId'] as int,
      (json['actualTotalAmount'] as num)?.toDouble(),
      json['status'] as int,
      json['createdAt'] as String);
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'actualTotalAmount': instance.actualTotalAmount,
      'status': instance.status,
      'createdAt': instance.createdAt
    };
