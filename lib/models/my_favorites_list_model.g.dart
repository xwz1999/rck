// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_favorites_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyFavoritesListModel _$MyFavoritesListModelFromJson(Map<String, dynamic> json) {
  return MyFavoritesListModel(
      json['code'],
      (json['data'] as List?)
          ?.map((e) =>  FavoriteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['msg']);
}

Map<String, dynamic> _$MyFavoritesListModelToJson(
        MyFavoritesListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

FavoriteModel _$FavoriteModelFromJson(Map<String, dynamic> json) {
  return FavoriteModel(
      json['favoriteId'] as int?,
      json['goods'] == null
          ? null
          : FavoriteGoods.fromJson(json['goods'] as Map<String, dynamic>));
}

Map<String, dynamic> _$FavoriteModelToJson(FavoriteModel instance) =>
    <String, dynamic>{
      'favoriteId': instance.favoriteId,
      'goods': instance.goods
    };

FavoriteGoods _$FavoriteGoodsFromJson(Map<String, dynamic> json) {
  return FavoriteGoods(
    json['id'] as int?, 
    json['description'] as String?,
    json['goodsName'] as String?,
    json['mainPhotoUrl'] as String?, 
    (json['discountPrice'] as num?)?.toDouble());
}

Map<String, dynamic> _$FavoriteGoodsToJson(FavoriteGoods instance) =>
    <String, dynamic>{
      'id': instance.id,
      'goodsName': instance.goodsName,
      'mainPhotoUrl': instance.mainPhotoUrl,
      'discountPrice': instance.discountPrice
    };
