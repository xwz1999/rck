import 'package:json_annotation/json_annotation.dart';

import 'package:jingyaoyun/models/base_model.dart';

part 'address_list_model.g.dart';


@JsonSerializable()
class AddressListModel extends BaseModel {

  List<Address> data;

  AddressListModel(code,this.data,msg,) : super(code,msg);

  factory AddressListModel.fromJson(Map<String, dynamic> srcJson) => _$AddressListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddressListModelToJson(this);

}


@JsonSerializable()
class Address extends Object {

  int id;

  String name;

  String mobile;

  String province;

  String city;

  String district;

  String address;

  int isDefault;

  Address(this.id,this.name,this.mobile,this.province,this.city,this.district,this.address,this.isDefault);

  factory Address.empty() {
    return Address(null, "", "", "", "", "", "", 0);
  }

  factory Address.fromJson(Map<String, dynamic> srcJson) => _$AddressFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

}

  
