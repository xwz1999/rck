import 'package:json_annotation/json_annotation.dart';

part 'order_return_address_model.g.dart';


@JsonSerializable()
class OrderReturnAddressModel {


  String code;
  String msg;
  AddressModel data;

  OrderReturnAddressModel(this.code, this.msg, this.data);

  factory OrderReturnAddressModel.fromJson(Map<String, dynamic> json) => _$OrderReturnAddressModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderReturnAddressModelToJson(this);
}

@JsonSerializable()
class AddressModel {

  int id;
  String address;
  String name;
  String mobile;

  AddressModel(this.id, this.address, this.name, this.mobile);

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}