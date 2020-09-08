// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_pickup_store_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelfPickupStoreListModel _$SelfPickupStoreListModelFromJson(
    Map<String, dynamic> json) {
  return SelfPickupStoreListModel(
      json['code'],
      (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : SelfPickupStoreModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['msg']);
}

Map<String, dynamic> _$SelfPickupStoreListModelToJson(
        SelfPickupStoreListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

SelfPickupStoreModel _$SelfPickupStoreModelFromJson(Map<String, dynamic> json) {
  return SelfPickupStoreModel(json['id'] as int, json['token'] as String,
      json['name'] as String, json['address'] as String);
}

Map<String, dynamic> _$SelfPickupStoreModelToJson(
        SelfPickupStoreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'name': instance.name,
      'address': instance.address
    };
