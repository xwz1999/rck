
part of 'new_user_discount_model.dart';

NewUserDiscountModel _$NewUserDiscountModelFromJson(Map<String, dynamic> json) {
  return NewUserDiscountModel(
      json['code'] as String,
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      json['msg'] as String);
}

Map<String, dynamic> _$NewUserDiscountModelToJson(NewUserDiscountModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['name'] as String,
      json['cash'] as num,
      json['explanation'] as String,
      json['status'] as int,
      (json['goodsList'] as List)
          ?.map((e) =>
              e == null ? null : Goods.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['couponId'] as int,
          );
}

Map<String, dynamic> _$DataToJson(Data instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cash': instance.cash,
      'explanation': instance.explanation,
      'status': instance.status,
      'goodsList': instance.goodsList,
      'couponId': instance.couponId,
    };

Goods _$GoodsFromJson(Map<String, dynamic> json) {
  return Goods(
      json['goodsId'] as int,
      json['goodsName'] as String,
      json['mainPhotoUrl'] as String,
      json['label'] as String,
      json['price'] as String,
      json['originPrice'] as String,
      );
}

Map<String, dynamic> _$GoodsToJson(Goods instance) =>
    <String, dynamic>{
      'goodsId': instance.goodsId,
      'goodsName': instance.goodsName,
      'mainPhotoUrl': instance.mainPhotoUrl,
      'label': instance.label,
      'price': instance.price,
      'originPrice': instance.originPrice
    };
