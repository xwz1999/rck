// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodsDetailModel _$GoodsDetailModelFromJson(Map<String, dynamic> json) {
  return GoodsDetailModel(
      json['code'],
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      json['msg']);
}

Map<String, dynamic> _$GoodsDetailModelToJson(GoodsDetailModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    json['id'] as int,
    json['brandId'] as int,
    json['goodsName'] as String,
    json['description'] as String,
    json['firstCategoryId'] as int,
    json['secondCategoryId'] as int,
    json['inventory'] as int,
    json['salesVolume'] as int,
    json['price'] == null
        ? null
        : Price.fromJson(json['price'] as Map<String, dynamic>),
    json['video'] == null
        ? null
        : Video.fromJson(json['video'] as Map<String, dynamic>),
    (json['mainPhotos'] as List)
        ?.map((e) =>
            e == null ? null : MainPhotos.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['attributes'] as List)
        ?.map((e) =>
            e == null ? null : Attributes.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['sku'] as List)
        ?.map((e) => e == null ? null : Sku.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['promotion'] == null
        ? null
        : Promotion.fromJson(json['promotion'] as Map<String, dynamic>),
    json['brand'] == null
        ? null
        : Brand.fromJson(json['brand'] as Map<String, dynamic>),
    json['evaluations'] == null
        ? null
        : Evaluations.fromJson(json['evaluations'] as Map<String, dynamic>),
    (json['coupons'] as List)
        ?.map((e) =>
            e == null ? null : Coupons.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['isFavorite'] as bool,
    json['shoppingTrolleyCount'] as int,
    (json['recommends'] as List)
        ?.map((e) =>
            e == null ? null : Recommends.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['isImport'],
    json['isFerme'],
    json['storehouse'],
    json['notice'] == null
        ? null
        : Notice.fromJson(json['notice'] as Map<String, dynamic>),
    json['country_icon'],
    json['living'] == null ? null : new Living.fromJson(json['living']),
    json['sec_kill'] == null ? null : new SecKill.fromJson(json['sec_kill']),
    json['vendorId'] as int,
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'brandId': instance.brandId,
      'goodsName': instance.goodsName,
      'description': instance.description,
      'firstCategoryId': instance.firstCategoryId,
      'secondCategoryId': instance.secondCategoryId,
      'inventory': instance.inventory,
      'salesVolume': instance.salesVolume,
      'price': instance.price,
      'video': instance.video,
      'mainPhotos': instance.mainPhotos,
      'attributes': instance.attributes,
      'sku': instance.sku,
      'promotion': instance.promotion,
      'brand': instance.brand,
      'evaluations': instance.evaluations,
      'coupons': instance.coupons,
      'isFavorite': instance.isFavorite,
      'shoppingTrolleyCount': instance.shoppingTrolleyCount,
      'country_icon': instance.countryIcon,
      'living': instance.living,
      'sec_kill':instance.secKill,
      'vendorId':instance.vendorId
    };

MainPhotos _$MainPhotosFromJson(Map<String, dynamic> json) {
  return MainPhotos(
      json['id'] as int,
      json['goodsId'] as int,
      json['url'] as String,
      json['isMaster'] as int,
      json['orderNo'] as int,
      json['width'] as int,
      json['height'] as int);
}

Map<String, dynamic> _$MainPhotosToJson(MainPhotos instance) =>
    <String, dynamic>{
      'id': instance.id,
      'goodsId': instance.goodsId,
      'url': instance.url,
      'isMaster': instance.isMaster,
      'orderNo': instance.orderNo,
      'width': instance.width,
      'height': instance.height
    };

Attributes _$AttributesFromJson(Map<String, dynamic> json) {
  return Attributes(
      json['name'] as String,
      (json['children'] as List)
          ?.map((e) =>
              e == null ? null : Children.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$AttributesToJson(Attributes instance) =>
    <String, dynamic>{'name': instance.name, 'children': instance.children};

Children _$ChildrenFromJson(Map<String, dynamic> json) {
  return Children(json['id'] as int, json['value'] as String);
}

Map<String, dynamic> _$ChildrenToJson(Children instance) =>
    <String, dynamic>{'id': instance.id, 'value': instance.value};

Sku _$SkuFromJson(Map<String, dynamic> json) {
  return Sku(
    json['id'] as int,
    json['goodsId'] as int,
    json['combineId'] as String,
    json['picUrl'] as String,
    json['code'] as String,
    (json['originalPrice'] as num)?.toDouble(),
    (json['discountPrice'] as num)?.toDouble(),
    (json['commission'] as num)?.toDouble(),
    json['salesVolume'] as int,
    json['inventory'] as int,
    json['name'] as String,
    json['coupon'] as num,
  );
}

Map<String, dynamic> _$SkuToJson(Sku instance) => <String, dynamic>{
      'id': instance.id,
      'goodsId': instance.goodsId,
      'combineId': instance.combineId,
      'picUrl': instance.picUrl,
      'code': instance.code,
      'originalPrice': instance.originalPrice,
      'discountPrice': instance.discountPrice,
      'commission': instance.commission,
      'salesVolume': instance.salesVolume,
      'inventory': instance.inventory,
      'name': instance.name,
      'coupon': instance.coupon,
    };

Promotion _$PromotionFromJson(Map<String, dynamic> json) {
  return Promotion(
    json['id'] as int,
    json['promotionId'] as int,
    json['promotionName'] as String,
    json['date'] as String,
    json['goodsId'] as int,
    json['startTime'] as String,
    json['endTime'] as String,
    json['totalInventory'] as int,
  );
}

Map<String, dynamic> _$PromotionToJson(Promotion instance) => <String, dynamic>{
      'id': instance.id,
      'promotionId': instance.promotionId,
      'promotionName': instance.promotionName,
      'date': instance.date,
      'goodsId': instance.goodsId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'totalInventory': instance.totalInventory,
    };

Brand _$BrandFromJson(Map<String, dynamic> json) {
  return Brand(
      json['id'] as int,
      json['name'] as String,
      json['desc'] as String,
      json['tel'] as String,
      json['web'] as String,
      json['goodsCount'] as int,
      json['logoUrl'] as String,
      json['showUrl'] as String,
      json['firstImg'] as String,
      json['lastImg'] as String);
}

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'tel': instance.tel,
      'web': instance.web,
      'goodsCount': instance.goodsCount,
      'logoUrl': instance.logoUrl,
      'showUrl': instance.showUrl,
      'firstImg': instance.firstImg,
      'lastImg': instance.lastImg
    };

Evaluations _$EvaluationsFromJson(Map<String, dynamic> json) {
  return Evaluations(
      json['total'] as int,
      (json['children'] as List)
          ?.map((e) =>
              e == null ? null : Evaluation.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$EvaluationsToJson(Evaluations instance) =>
    <String, dynamic>{'total': instance.total, 'children': instance.children};

Evaluation _$EvaluationFromJson(Map<String, dynamic> json) {
  return Evaluation(
      json['id'] as int,
      json['userId'] as int,
      json['orderId'] == null ? null : BigInt.parse(json['orderId'] as String),
      json['goodsId'] as int,
      json['nickname'] as String,
      json['headImgUrl'] as String,
      json['content'] as String);
}

Map<String, dynamic> _$EvaluationToJson(Evaluation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'orderId': instance.orderId?.toString(),
      'goodsId': instance.goodsId,
      'nickname': instance.nickname,
      'headImgUrl': instance.headImgUrl,
      'content': instance.content
    };

Coupons _$CouponsFromJson(Map<String, dynamic> json) {
  return Coupons(
      json['id'] as int,
      json['name'] as String,
      json['quantity'] as int,
      json['cash'] as int,
      json['threshold'] as int,
      (json['discount'] as num)?.toDouble(),
      json['limit'] as int,
      json['scope'] as int,
      json['type'] as int,
      json['brandId'] as int,
      json['startTime'] as String,
      json['endTime'] as String,
      json['explanation'] as String);
}

Map<String, dynamic> _$CouponsToJson(Coupons instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'cash': instance.cash,
      'threshold': instance.threshold,
      'discount': instance.discount,
      'limit': instance.limit,
      'scope': instance.scope,
      'type': instance.type,
      'brandId': instance.brandId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'explanation': instance.explanation
    };

Video _$VideoFromJson(Map<String, dynamic> json) {
  return Video(
    json['id'] as int,
    json['url'] as String,
    json['duration'] as int,
    (json['size'] as num)?.toDouble(),
    json['thumbnail'] as String,
  );
}

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'duration': instance.duration,
      'size': instance.size,
      'thumbnail': instance.thumbnail,
    };

Recommends _$RecommendsFromJson(Map<String, dynamic> json) {
  return Recommends(
    json['goodsName'] as String,
    json['goodsId'] as int,
    json['price'] as String,
    json['mainPhotoUrl'] as String,
  );
}

Map<String, dynamic> _$RecommendsToJson(Recommends instance) =>
    <String, dynamic>{
      'goodsName': instance.goodsName,
      'goodsId': instance.goodsId,
      'price': instance.price,
      'mainPhotoUrl': instance.mainPhotoUrl,
    };
