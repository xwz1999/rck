// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayResultModel _$PayResultModelFromJson(Map<String, dynamic> json) {
  return PayResultModel(
      json['code'],
      json['data'] == null
          ? null
          : PayResult.fromJson(json['data'] as Map<String, dynamic>),
      json['msg']);
}

Map<String, dynamic> _$PayResultModelToJson(PayResultModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

PayResult _$PayResultFromJson(Map<String, dynamic> json) {
  return PayResult(json['status'] as int?);
}

Map<String, dynamic> _$PayResultToJson(PayResult instance) =>
    <String, dynamic>{'status': instance.status};
