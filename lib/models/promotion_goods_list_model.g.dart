// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_goods_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionGoodsListModel _$PromotionGoodsListModelFromJson(
    Map<String, dynamic> json) {
  return PromotionGoodsListModel(
      json['code'] as String,
      json['data'] == null
          ? null
          : PromotionModel.fromJson(json['data'] as Map<String, dynamic>),
      json['msg'] as String);
}

Map<String, dynamic> _$PromotionGoodsListModelToJson(
        PromotionGoodsListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg
    };

PromotionModel _$PromotionModelFromJson(Map<String, dynamic> json) {
  return PromotionModel(
    (json['goodsList'] as List)
        ?.map((e) => e == null
            ? null
            : PromotionGoodsModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['activityList'] as List)
        ?.map((e) => e == null
            ? null
            : PromotionActivityModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PromotionModelToJson(PromotionModel instance) =>
    <String, dynamic>{
      'goodsList': instance.goodsList,
      'activityList': instance.activityList,
    };

PromotionActivityModel _$PromotionActivityModelFromJson(
    Map<String, dynamic> json) {
  return PromotionActivityModel(
    json['id'] as num,
    json['activityUrl'] as String,
    json['logoUrl'] as String,
    json['topUrl'] as String,
  );
}

Map<String, dynamic> _$PromotionActivityModelToJson(
        PromotionActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'activityUrl': instance.activityUrl,
      'logoUrl': instance.logoUrl,
      'topUrl': instance.topUrl,
    };

PromotionGoodsModel _$PromotionGoodsModelFromJson(Map<String, dynamic> json) {
  return PromotionGoodsModel(
    json['goodsId'] as int,
    json['goodsName'] as String,
    json['description'] as String,
    (json['price'] as num)?.toDouble(),
    json['priceDesc'] as String,
    (json['commission'] as num)?.toDouble(),
    json['commissionDesc'] as String,
    json['inventory'] as int,
    json['inventoryDesc'] as String,
    json['totalInventory'] as int,
    json['totalInventoryDesc'] as String,
    json['totalSalesVolume'] as int,
    json['salesVolumeDesc'] as String,
    json['startTime'] as String,
    json['endTime'] as String,
    json['percentageDesc'] as String,
    (json['percentage'] as num)?.toDouble(),
    json['picture'] == null
        ? null
        : Picture.fromJson(json['picture'] as Map<String, dynamic>),
    json["primePrice"] as num,
    json["coupon"] as num,
    json['brandName'] as String,
    json['brandImg'] as String,
    json['brandId'] as num,
    json['isImport'] as num,
    json['isFerme'] as num,
    json['storehouse'] as num,
  );
}

Map<String, dynamic> _$PromotionGoodsModelToJson(
        PromotionGoodsModel instance) =>
    <String, dynamic>{
      'goodsId': instance.goodsId,
      'goodsName': instance.goodsName,
      'description': instance.description,
      'price': instance.price,
      'priceDesc': instance.priceDesc,
      'commission': instance.commission,
      'commissionDesc': instance.commissionDesc,
      'inventory': instance.inventory,
      'inventoryDesc': instance.inventoryDesc,
      'totalInventory': instance.totalInventory,
      'totalInventoryDesc': instance.totalInventoryDesc,
      'totalSalesVolume': instance.totalSalesVolume,
      'salesVolumeDesc': instance.salesVolumeDesc,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'percentageDesc': instance.percentageDesc,
      'percentage': instance.percentage,
      'picture': instance.picture,
      "primePrice": instance.primePrice,
      'coupon': instance.coupon,
      'brandName': instance.brandName,
      'brandImg': instance.brandImg
    };

Picture _$PictureFromJson(Map<String, dynamic> json) {
  return Picture(
      json['url'] as String, json['width'] as int, json['height'] as int);
}

Map<String, dynamic> _$PictureToJson(Picture instance) => <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height
    };
