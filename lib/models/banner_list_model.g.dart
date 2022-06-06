// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerListModel _$BannerListModelFromJson(Map<String, dynamic> json) {
  return BannerListModel(
      json['code'],

      (json['data'] as List<dynamic>?)
          ?.map((e) =>
          BannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['msg']);
}

Map<String, dynamic> _$BannerListModelToJson(BannerListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) {
  return BannerModel(
    json['id'] as int?, 
    json['goodsId'] as int?,
    json['url'] as String?, 
    json['createdAt'] as String?,
    json['activityUrl'] as String?,
    json['color'] as String?);
}

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'goodsId': instance.goodsId,
      'url': instance.url,
      'createdAt': instance.createdAt,
      'activityUrl': instance.activityUrl,
      'color': instance.color,
    };
