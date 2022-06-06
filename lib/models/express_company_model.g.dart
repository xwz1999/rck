// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'express_company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpressCompanyModel _$ExpressCompanyModelFromJson(Map<String, dynamic> json) {
  return ExpressCompanyModel(
      json['code'] as String?,
      (json['data'] as List?)?.map((e) => e as String).toList(),
      json['msg'] as String?);
}

Map<String, dynamic> _$ExpressCompanyModelToJson(
        ExpressCompanyModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg
    };
