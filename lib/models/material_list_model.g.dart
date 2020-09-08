// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaterialListModel _$MaterialListModelFromJson(Map<String, dynamic> json) {
  return MaterialListModel(
      json['code'],
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : MaterialModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
          json['msg'],);
}

Map<String, dynamic> _$MaterialListModelToJson(
        MaterialListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

MaterialModel _$MaterialModelFromJson(Map<String, dynamic> json) {
  return MaterialModel(
      json['id'] as int,
      json['goodsId'] as int,
      json['text'] as String,
      json['userId'] as int,
      json['nickname'] as String,
      json['headImgUrl'] as String,
      json['createdAt'] as String,
      json['isAttention'] as bool,
      (json['photos'] as List)
          ?.map((e) => e == null ? null : Photos.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      // json['goods'] as Goods,
      json['goods'] == null
          ? null
          : Goods.fromJson(json['goods'] as Map<String, dynamic>),
      // (json['goods'] as List)
      //     ?.map((e) => e == null ? null : Goods.fromJson(e as Map<String, dynamic>))
      //     ?.toList(),
      json['isOfficial']  as bool,
      );
}

Map<String, dynamic> _$MaterialModelToJson(MaterialModel instance) => <String, dynamic>{
      'id': instance.id,
      'goodsId': instance.goodsId,
      'text': instance.text,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'headImgUrl': instance.headImgUrl,
      'createdAt': instance.createdAt,
      'isAttention': instance.isAttention,
      'photos': instance.photos,
      'goods': instance.goods,
      'isOfficial': instance.isOfficial,
    };

Photos _$PhotosFromJson(Map<String, dynamic> json) {
  return Photos(
    json['id'] as int, 
    json['momentsCopyId'] as int,
    json['url'] as String, 
    json['width'] as int,
    json['height'] as int);
}

Map<String, dynamic> _$PhotosToJson(Photos instance) => <String, dynamic>{
      'id': instance.id,
      'momentsCopyId': instance.momentsCopyId,
      'url': instance.url,
      'width': instance.width,
      'height': instance.height
    };

Goods _$GoodsFromJson(Map<String, dynamic> json) {
  return Goods(
    json['mainPhotoURL'] as String, 
    json['name'] as String,
    json['price'] as num,
    json['id'] as int);
}

Map<String, dynamic> _$GoodsToJson(Goods instance) => <String, dynamic>{
      'mainPhotoURL': instance.mainPhotoURL,
      'name': instance.name,
      'price': instance.price,
      'id' : instance.id,
    };
