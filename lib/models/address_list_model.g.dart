// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressListModel _$AddressListModelFromJson(Map<String, dynamic> json) {
  return AddressListModel(
      json['code'],
      (json['data'] as List<dynamic>?)
          ?.map((e) =>
               Address.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['msg']);
}

Map<String, dynamic> _$AddressListModelToJson(AddressListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
      json['id'] as int?,
      json['name'] as String?,
      json['mobile'] as String?,
      json['province'] as String?,
      json['city'] as String?,
      json['district'] as String?,
      json['address'] as String?,
      json['isDefault'] as int?);
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mobile': instance.mobile,
      'province': instance.province,
      'city': instance.city,
      'district': instance.district,
      'address': instance.address,
      'isDefault': instance.isDefault
    };
