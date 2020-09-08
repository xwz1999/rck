import 'package:json_annotation/json_annotation.dart';
import 'package:recook/models/base_model.dart';

part 'province_city_model.g.dart';


@JsonSerializable()
class ProvinceCityModel extends BaseModel {

  List<Province> data;

  ProvinceCityModel(code,this.data,msg) : super(code, msg);

  factory ProvinceCityModel.fromJson(Map<String, dynamic> srcJson) => _$ProvinceCityModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProvinceCityModelToJson(this);

}


@JsonSerializable()
class Province extends Object {

  String name;

  List<City> cities;

  Province(this.name,this.cities,);

  factory Province.fromJson(Map<String, dynamic> srcJson) => _$ProvinceFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProvinceToJson(this);

}


@JsonSerializable()
class City extends Object {

  String name;

  List<District> districts;

  City(this.name,this.districts,);

  factory City.fromJson(Map<String, dynamic> srcJson) => _$CityFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CityToJson(this);

}


@JsonSerializable()
class District extends Object {

  String name;

  District(this.name,);

  factory District.fromJson(Map<String, dynamic> srcJson) => _$DistrictFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DistrictToJson(this);

}

  
