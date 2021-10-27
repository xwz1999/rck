// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_cart_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingCartListModel _$ShoppingCartListModelFromJson(
    Map<String, dynamic> json) {
  return ShoppingCartListModel(
      json['code'],
      (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : ShoppingCartBrandModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['msg']);
}

Map<String, dynamic> _$ShoppingCartListModelToJson(
        ShoppingCartListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

ShoppingCartBrandModel _$ShoppingCartBrandModelFromJson(
    Map<String, dynamic> json) {
  return ShoppingCartBrandModel(
      json['id'] as int,
      json['brandID'] as int,
      json['brandLogo'] as String,
      json['brandName'] as String,
      (json['children'] as List)
          ?.map((e) => e == null
              ? null
              : ShoppingCartGoodsModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['selected'] as bool);
}

Map<String, dynamic> _$ShoppingCartBrandModelToJson(
        ShoppingCartBrandModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brandID': instance.brandID,
      'brandLogo': instance.brandLogo,
      'brandName': instance.brandName,
      'children': instance.children,
      'selected': instance.selected
    };

ShoppingCartGoodsModel _$ShoppingCartGoodsModelFromJson(
    Map<String, dynamic> json) {
  return ShoppingCartGoodsModel(
    json['shoppingTrolleyId'] as int,
    json['goodsId'] as int,
    json['goodsName'] as String,
    json['mainPhotoUrl'] as String,
    json['skuName'] as String,
    json['skuId'] as int,
    json['quantity'] as int,
    json['valid'] as bool,
    (json['price'] as num)?.toDouble(),
    json['promotionName'] as String,
    json['selected'] as bool,
    json['promotion'] == null
        ? null
        : Promotion.fromJson(json['promotion'] as Map<String, dynamic>),
    json['commission'] as num,
    json['originalPrice'] as num,
    json['isImport'] as num,
    json['isFerme'] as num,
    json['storehouse'] as int,
    json['ferme'] as num,
    json['publish_status'] as num,
    json['country_icon'] as String,
    json['sec_kill'] == null ? null : new SecKill.fromJson(json['sec_kill']),
  );
}

Map<String, dynamic> _$ShoppingCartGoodsModelToJson(
        ShoppingCartGoodsModel instance) =>
    <String, dynamic>{
      'shoppingTrolleyId': instance.shoppingTrolleyId,
      'goodsId': instance.goodsId,
      'goodsName': instance.goodsName,
      'mainPhotoUrl': instance.mainPhotoUrl,
      'skuName': instance.skuName,
      'skuId': instance.skuId,
      'quantity': instance.quantity,
      'valid': instance.valid,
      'price': instance.price,
      'promotionName': instance.promotionName,
      'selected': instance.selected,
      'promotion': instance.promotion,
      'commission': instance.commission,
      'originalPrice': instance.originalPrice,
      'publish_status': instance.publishStatus,
      'country_icon': instance.countryIcon,
      'sec_kill':instance.secKill,
    };
