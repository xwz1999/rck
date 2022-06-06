// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionListModel _$PromotionListModelFromJson(Map<String, dynamic> json) {
  return PromotionListModel(
      json['code'],
      (json['data'] as List?)
          ?.map((e) =>
               Promotion.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['msg']);
}

Map<String, dynamic> _$PromotionListModelToJson(PromotionListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

Promotion _$PromotionFromJson(Map<String, dynamic> json) {
  return Promotion(
    json['id'] as int?, 
    json['promotionName'] as String?,
    json['startTime'] as String?,
    json['endTime'] as String?,
    json['showName'] as String?, 
    json['isProcessing'] as int?);
}

Map<String, dynamic> _$PromotionToJson(Promotion instance) => <String, dynamic>{
      'id': instance.id,
      'promotionName': instance.promotionName,
      'startTime': instance.startTime,
      'endTime' : instance.endTime,
      'showName': instance.showName,
      'isProcessing': instance.isProcessing
    };
