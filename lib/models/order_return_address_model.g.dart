part of 'order_return_address_model.dart';

OrderReturnAddressModel _$OrderReturnAddressModelFromJson(Map<String, dynamic> json) {
  return OrderReturnAddressModel(
      json['code'] as String,
      json['msg'] as String,
      json['data'] == null
          ? null
          : AddressModel.fromJson(json['data'] as Map<String, dynamic>),
      );
}

Map<String, dynamic> _$OrderReturnAddressModelToJson(OrderReturnAddressModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg
    };



AddressModel _$AddressModelFromJson(Map<String, dynamic> json) {
  return AddressModel(
    json['id'] as int,
    json['address'] as String,
    json['name'] as String,
    json['mobile'] as String,
  );
}

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'name': instance.name,
      'mobile': instance.mobile,
    }; 