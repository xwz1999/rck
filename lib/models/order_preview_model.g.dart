// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_preview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderPreviewModel _$OrderPreviewModelFromJson(Map<String, dynamic> json) {
  return OrderPreviewModel(
      json['code'],
      json['data'] == null
          ? null
          : OrderDetail.fromJson(json['data'] as Map<String, dynamic>),
      json['msg']);
}

Map<String, dynamic> _$OrderPreviewModelToJson(OrderPreviewModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) {
  return OrderDetail(
    json['id'] as int,
    json['parentId'] as int,
    json['userId'] as int,
    json['isSubordinate'] as int,
    (json['brandCouponTotalAmount'] as num)?.toDouble(),
    (json['universeCouponTotalAmount'] as num)?.toDouble(),
    (json['coinTotalAmount'] as num)?.toDouble(),
    (json['expressTotalFee'] as num)?.toDouble(),
    (json['goodsTotalAmount'] as num)?.toDouble(),
    (json['goodsTotalCommission'] as num)?.toDouble(),
    (json['actualTotalAmount'] as num)?.toDouble(),
    json['shippingMethod'] as int,
    json['buyerMessage'] as String,
    json['totalGoodsCount'] as int,
    json['coupon'] == null
        ? null
        : Coupon.fromJson(json['coupon'] as Map<String, dynamic>),
    json['addr'] == null
        ? null
        : Addr.fromJson(json['addr'] as Map<String, dynamic>),
    (json['brands'] as List)
        ?.map((e) =>
            e == null ? null : Brands.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['userRole'] as num,
    json['coinStatus'] == null
        ? null
        : CoinStatus.fromJson(json['coinStatus'] as Map<String, dynamic>),
    json['hasAuth'] as bool,
  );
}

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'userId': instance.userId,
      'isSubordinate': instance.isSubordinate,
      'brandCouponTotalAmount': instance.brandCouponTotalAmount,
      'universeCouponTotalAmount': instance.universeCouponTotalAmount,
      'coinTotalAmount': instance.coinTotalAmount,
      'expressTotalFee': instance.expressTotalFee,
      'goodsTotalAmount': instance.goodsTotalAmount,
      'goodsTotalCommission': instance.goodsTotalCommission,
      'shippingMethod': instance.shippingMethod,
      'buyerMessage': instance.buyerMessage,
      'totalGoodsCount': instance.totalGoodsCount,
      'coupon': instance.coupon,
      'addr': instance.addr,
      'brands': instance.brands,
      'userRole': instance.userRole
    };

CoinStatus _$CoinStatusFromJson(Map<String, dynamic> json) {
  return CoinStatus(
    json['coin'] as num,
    json['isUseCoin'] as bool,
    json['isEnable'] as bool,
  );
}

Map<String, dynamic> _$CoinStatusToJson(CoinStatus coinStatus) =>
    <String, dynamic>{
      "coin": coinStatus.coin,
      "isUseCoin": coinStatus.isUseCoin,
      "isEnable": coinStatus.isEnable
    };

Coupon _$CouponFromJson(Map<String, dynamic> json) {
  return Coupon(
      json['id'] as int,
      json['brandId'] as int,
      json['scope'] as int,
      json['couponName'] as String,
      (json['deductedAmount'] as num)?.toDouble());
}

Map<String, dynamic> _$CouponToJson(Coupon instance) => <String, dynamic>{
      'id': instance.id,
      'brandId': instance.brandId,
      'scope': instance.scope,
      'couponName': instance.couponName,
      'deductedAmount': instance.deductedAmount
    };

Addr _$AddrFromJson(Map<String, dynamic> json) {
  return Addr(
      json['id'] as int,
      json['addressId'] as int,
      json['province'] as String,
      json['city'] as String,
      json['district'] as String,
      json['address'] as String,
      json['receiverName'] as String,
      json['mobile'] as String,
      json['isDeliveryArea'] as int);
}

Map<String, dynamic> _$AddrToJson(Addr instance) => <String, dynamic>{
      'id': instance.id,
      'addressId': instance.addressId,
      'province': instance.province,
      'city': instance.city,
      'district': instance.district,
      'address': instance.address,
      'receiverName': instance.receiverName,
      'mobile': instance.mobile,
      'isDeliveryArea': instance.isDeliveryArea
    };

Brands _$BrandsFromJson(Map<String, dynamic> json) {
  return Brands(
      json['brandId'] as int,
      json['brandName'] as String,
      json['brandLogoUrl'] as String,
      (json['brandExpressTotalAmount'] as num)?.toDouble(),
      (json['brandGoodsTotalAmount'] as num)?.toDouble(),
      json['brandGoodsTotalCount'] as int,
      (json['goods'] as List)
          ?.map((e) =>
              e == null ? null : OrderGoods.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['coupon'] == null
          ? null
          : Coupon.fromJson(json['coupon'] as Map<String, dynamic>));
}

Map<String, dynamic> _$BrandsToJson(Brands instance) => <String, dynamic>{
      'brandId': instance.brandId,
      'brandName': instance.brandName,
      'brandLogoUrl': instance.brandLogoUrl,
      'brandExpressTotalAmount': instance.brandExpressTotalAmount,
      'brandGoodsTotalAmount': instance.brandGoodsTotalAmount,
      'brandGoodsTotalCount': instance.brandGoodsTotalCount,
      'goods': instance.goods,
      'coupon': instance.coupon,
    };

OrderGoods _$OrderGoodsFromJson(Map<String, dynamic> json) {
  return OrderGoods(
    json['goodsId'] as int,
    json['goodsName'] as String,
    json['skuId'] as int,
    json['skuName'] as String,
    json['skuCode'] as String,
    json['mainPhotoUrl'] as String,
    json['quantity'] as int,
    json['promotionName'] as String,
    (json['unitPrice'] as num)?.toDouble(),
    (json['totalCommission'] as num)?.toDouble(),
    (json['brandCouponAmount'] as num)?.toDouble(),
    (json['universeBrandCouponAmount'] as num)?.toDouble(),
    (json['coinAmount'] as num)?.toDouble(),
    (json['goodsAmount'] as num)?.toDouble(),
    (json['expressFee'] as num)?.toDouble(),
    (json['actualAmount'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$OrderGoodsToJson(OrderGoods instance) =>
    <String, dynamic>{
      'goodsId': instance.goodsId,
      'goodsName': instance.goodsName,
      'skuId': instance.skuId,
      'skuName': instance.skuName,
      'skuCode': instance.skuCode,
      'mainPhotoUrl': instance.mainPhotoUrl,
      'quantity': instance.quantity,
      'promotionName': instance.promotionName,
      'unitPrice': instance.unitPrice,
      'totalCommission': instance.totalCommission,
      'universeBrandCouponAmount': instance.universeBrandCouponAmount,
      'coinAmount': instance.coinAmount,
      'goodsAmount': instance.goodsAmount,
      'expressFee': instance.expressFee,
      'actualAmount': instance.actualAmount,
    };

Balance _$BalanceFromJson(Map<String, dynamic> json) {
  return Balance(
      json['id'] as int, (json['deductedAmount'] as num)?.toDouble());
}

Map<String, dynamic> _$BalanceToJson(Balance instance) => <String, dynamic>{
      'id': instance.id,
      'deductedAmount': instance.deductedAmount
    };
