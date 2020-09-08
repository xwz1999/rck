// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) {
  return CategoryModel(
      json['code'],
      (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : FirstCategory.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['msg']);
}

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

FirstCategory _$FirstCategoryFromJson(Map<String, dynamic> json) {
  return FirstCategory(
      json['id'] as int,
      json['name'] as String,
      json['parentId'] as int,
      json['logoUrl'] as String,
      (json['sub'] as List)
          ?.map((e) => e == null
              ? null
              : SecondCategory.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$FirstCategoryToJson(FirstCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parentId': instance.parentId,
      'logoUrl': instance.logoUrl,
      'sub': instance.sub
    };

SecondCategory _$SecondCategoryFromJson(Map<String, dynamic> json) {
  return SecondCategory(json['id'] as int, json['name'] as String,
      json['parentId'] as int, json['logoUrl'] as String);
}

Map<String, dynamic> _$SecondCategoryToJson(SecondCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parentId': instance.parentId,
      'logoUrl': instance.logoUrl
    };
