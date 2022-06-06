// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluation_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvaluationListModel _$EvaluationListModelFromJson(Map<String, dynamic> json) {
  return EvaluationListModel(
      json['code'],
      json['msg'],
  (json['data'] as List<dynamic>?)
      ?.map((e) =>
      Data.fromJson(e as Map<String, dynamic>))
      .toList());
}

Map<String, dynamic> _$EvaluationListModelToJson(
        EvaluationListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['id'] as int?,
      json['goodsId'] as int?,
      json['userId'] as int?,
      json['nickname'] as String?,
      json['headImgUrl'] as String?,
      json['content'] as String?,
      json['createdAt'] as String?,
        (json['Photos'] as List<dynamic>?)
          ?.map((e) =>
          Photos.fromJson(e as Map<String, dynamic>))
          .toList(),
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'goodsId': instance.goodsId,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'headImgUrl': instance.headImgUrl,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'photos': instance.photos
    };

Photos _$PhotosFromJson(Map<String, dynamic> json) {
  return Photos(json['id'] as int?, json['url'] as String?, json['width'] as int?,
      json['height'] as int?);
}

Map<String, dynamic> _$PhotosToJson(Photos instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'width': instance.width,
      'height': instance.height
    };
