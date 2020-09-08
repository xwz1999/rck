// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodsListModel _$GoodsListModelFromJson(Map<String, dynamic> json) {
  return GoodsListModel(
      json['code'],
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Goods.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['msg']);
}

Map<String, dynamic> _$GoodsListModelToJson(GoodsListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

Goods _$GoodsFromJson(Map<String, dynamic> json) {
  return Goods(
      json['id'] as int,
      json['brandId'] as int,
      json['goodsName'] as String,
      json['description'] as String,
      json['firstCategoryId'] as int,
      json['secondCategoryId'] as int,
      json['commissionRate'] as int,
      (json['discount'] as num)?.toDouble(),
      json['price'] == null
          ? null
          : Price.fromJson(json['price'] as Map<String, dynamic>),
      json['inventory'] as int,
      json['salesVolume'] as int,
      json['url'] as String,
      json['promotionName'] as String);
}

Map<String, dynamic> _$GoodsToJson(Goods instance) => <String, dynamic>{
      'id': instance.id,
      'brandId': instance.brandId,
      'goodsName': instance.goodsName,
      'description': instance.description,
      'firstCategoryId': instance.firstCategoryId,
      'secondCategoryId': instance.secondCategoryId,
      'commissionRate': instance.commissionRate,
      'discount': instance.discount,
      'price': instance.price,
      'inventory': instance.inventory,
      'salesVolume': instance.salesVolume,
      'url': instance.url,
      'promotionName': instance.promotionName
    };
