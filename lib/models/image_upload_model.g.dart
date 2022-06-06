// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_upload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageUploadModel _$ImageUploadModelFromJson(Map<String, dynamic> json) {
  return ImageUploadModel(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ImageUploadModelToJson(ImageUploadModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(json['url'] as String?);
}

Map<String, dynamic> _$DataToJson(Data instance) =>
    <String, dynamic>{'url': instance.url};
