// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logistic_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogisticListModel _$LogisticListModelFromJson(Map<String, dynamic> json) {
  return LogisticListModel(
      json['code'],
      (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : LogisticDetailModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['msg']);
}

Map<String, dynamic> _$LogisticListModelToJson(LogisticListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

LogisticDetailModel _$LogisticDetailModelFromJson(Map<String, dynamic> json) {
  return LogisticDetailModel(
      (json['picUrls'] as List)?.map((e) => e as String)?.toList(),
      json['name'] as String,
      json['no'] as String,
      (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : LogisticStatus.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$LogisticDetailModelToJson(
        LogisticDetailModel instance) =>
    <String, dynamic>{
      'picUrls': instance.picUrls,
      'name': instance.name,
      'no': instance.no,
      'data': instance.data
    };

LogisticStatus _$LogisticStatusFromJson(Map<String, dynamic> json) {
  return LogisticStatus(json['context'] as String, json['ftime'] as String);
}

Map<String, dynamic> _$LogisticStatusToJson(LogisticStatus instance) =>
    <String, dynamic>{'context': instance.context, 'ftime': instance.ftime};
