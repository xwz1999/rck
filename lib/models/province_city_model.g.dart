// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'province_city_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvinceCityModel _$ProvinceCityModelFromJson(Map<String, dynamic> json) {
  return ProvinceCityModel(
      json['code'],
      (json['data'] as List?)
          ?.map((e) =>
               Province.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['msg']);
}

Map<String, dynamic> _$ProvinceCityModelToJson(ProvinceCityModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

Province _$ProvinceFromJson(Map<String, dynamic> json) {
  return Province(
      json['name'] as String?,
      (json['cities'] as List?)
          ?.map((e) =>
               City.fromJson(e as Map<String, dynamic>))
          .toList());
}

Map<String, dynamic> _$ProvinceToJson(Province instance) =>
    <String, dynamic>{'name': instance.name, 'cities': instance.cities};

City _$CityFromJson(Map<String, dynamic> json) {
  return City(
      json['name'] as String?,
      (json['districts'] as List?)
          ?.map((e) =>
              District.fromJson(e as Map<String, dynamic>))
          .toList());
}

Map<String, dynamic> _$CityToJson(City instance) =>
    <String, dynamic>{'name': instance.name, 'districts': instance.districts};

District _$DistrictFromJson(Map<String, dynamic> json) {
  return District(json['name'] as String?);
}

Map<String, dynamic> _$DistrictToJson(District instance) =>
    <String, dynamic>{'name': instance.name};
