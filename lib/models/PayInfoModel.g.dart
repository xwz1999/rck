// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PayInfoModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayInfoModel _$PayInfoModelFromJson(Map<String, dynamic> json) {
  return PayInfoModel(
      json['data'] == null
          ? null
          : PayInfo.fromJson(json['data'] as Map<String, dynamic>),
      json['code'],
      json['msg']);
}

Map<String, dynamic> _$PayInfoModelToJson(PayInfoModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.payInfo
    };

PayInfo _$PayInfoFromJson(Map<String, dynamic> json) {
  return PayInfo(
      json['noncestr'] as String,
      json['sign'] as String,
      json['prepayid'] as String,
      json['appid'] as String,
      json['partnerid'] as String,
      json['package'] as String,
      json['timestamp'] as String);
}

Map<String, dynamic> _$PayInfoToJson(PayInfo instance) => <String, dynamic>{
      'noncestr': instance.noncestr,
      'sign': instance.sign,
      'prepayid': instance.prepayid,
      'appid': instance.appid,
      'partnerid': instance.partnerid,
      'package': instance.package,
      'timestamp': instance.timestamp
    };
