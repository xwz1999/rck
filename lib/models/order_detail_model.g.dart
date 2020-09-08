// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailModel _$OrderDetailModelFromJson(Map<String, dynamic> json) {
  return OrderDetailModel(
      json['code'] as String,
      json['data'] == null
          ? null
          : OrderDetail.fromJson(json['data'] as Map<String, dynamic>),
      json['msg'] as String);
}

Map<String, dynamic> _$OrderDetailModelToJson(OrderDetailModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg
    };

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) {
  return OrderDetail(
      json['id'] as int,
      json['parentId'] as int,
      json['userId'] as int,
      json['isSubordinate'] as int,
      json['title'] as String,
      (json['brandCouponTotalAmount'] as num)?.toDouble(),
      (json['universeCouponTotalAmount'] as num)?.toDouble(),
      (json['coinTotalAmount'] as num)?.toDouble(),
      (json['expressTotalFee'] as num)?.toDouble(),
      (json['goodsTotalAmount'] as num)?.toDouble(),
      (json['goodsTotalCommission'] as num)?.toDouble(),
      (json['actualTotalAmount'] as num)?.toDouble(),
      json['shippingMethod'] as int,
      json['buyerMessage'] as String,
      json['status'] as int,
      json['expressStatus'] as int,
      json['invoiceStatus'] as int,
      json['isAss'] as int,
      json['evaluatedAt'] as String,
      json['createdAt'] as String,
      json['expireTime'] as String,
      json['payIp'] as String,
      json['tradeNo'] as String,
      json['payTime'] as String,
      json['payMethod'] as int,
      json['completedAt'] as String,
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
      json['canConfirm'] as bool,
      // json['balance'] == null
      //     ? null
      //     : Balance.fromJson(json['balance'] as Map<String, dynamic>),
      // json['payment'] == null
      //     ? null
      //     : Payment.fromJson(json['payment'] as Map<String, dynamic>),
      // json['invoice'] == null
      //     ? null
      //     : Invoice.fromJson(json['invoice'] as Map<String, dynamic>)
          );
}

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'userId': instance.userId,
      'isSubordinate': instance.isSubordinate,
      'title': instance.title,
      'brandCouponTotalAmount': instance.brandCouponTotalAmount,
      'universeCouponTotalAmount': instance.universeCouponTotalAmount,
      'coinTotalAmount': instance.coinTotalAmount,
      'expressTotalFee': instance.expressTotalFee,
      'goodsTotalAmount': instance.goodsTotalAmount,
      'goodsTotalCommission': instance.goodsTotalCommission,
      'actualTotalAmount': instance.actualTotalAmount,
      'shippingMethod': instance.shippingMethod,
      'buyerMessage': instance.buyerMessage,
      'status': instance.status,
      'expressStatus': instance.expressStatus,
      'invoiceStatus': instance.invoiceStatus,
      'isAss': instance.isAss,
      'evaluatedAt': instance.evaluatedAt,
      'createdAt': instance.createdAt,
      'expireTime': instance.expireTime,
      'payIp': instance.payIp,
      'tradeNo': instance.tradeNo,
      'payTime': instance.payTime,
      'payMethod': instance.payMethod,
      'completedAt': instance.completedAt,
      'totalGoodsCount': instance.totalGoodsCount,
      'coupon': instance.coupon,
      'addr': instance.addr,
      'brands': instance.brands,
      'canConfirm': instance.canConfirm
    };

Addr _$AddrFromJson(Map<String, dynamic> json) {
  return Addr(
      json['id'] as int,
      json['orderId'] as int,
      json['addressId'] as int,
      json['province'] as String,
      json['city'] as String,
      json['district'] as String,
      json['address'] as String,
      json['receiverName'] as String,
      json['mobile'] as String);
}

Map<String, dynamic> _$AddrToJson(Addr instance) => <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'addressId': instance.addressId,
      'province': instance.province,
      'city': instance.city,
      'district': instance.district,
      'address': instance.address,
      'receiverName': instance.receiverName,
      'mobile': instance.mobile
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
              e == null ? null : Goods.fromJson(e as Map<String, dynamic>))
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

Goods _$GoodsFromJson(Map<String, dynamic> json) {
  return Goods(
      json['goodsDetailId'] as int,
      json['orderId'] as int,
      json['vendorId'] as int,
      json['brandId'] as int,
      json['brandName'] as String,
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
      json['expressStatus'] as int,
      json['expressCompName'] as String,
      json['expressCompCode'] as String,
      json['expressNo'] as String,
      json['assType'] as int,
      json['refundStatus'] as int,
      json['returnStatus'] as int,
      json['returnReason'] as String,
      json['returnRejectReason'] as String,
      json['selected'] as bool,
      json['rStatus'] as String,
      json['IsClosed'] as int,
      json['asId'] as int,
    );
}

Map<String, dynamic> _$GoodsToJson(Goods instance) => <String, dynamic>{
      'goodsDetailId': instance.goodsDetailId,
      'orderId': instance.orderId,
      'vendorId': instance.vendorId,
      'brandId': instance.brandId,
      'brandName': instance.brandName,
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
      'brandCouponAmount': instance.brandCouponAmount,
      'universeBrandCouponAmount': instance.universeBrandCouponAmount,
      'coinAmount': instance.coinAmount,
      'goodsAmount': instance.goodsAmount,
      'expressFee': instance.expressFee,
      'actualAmount': instance.actualAmount,
      'expressStatus': instance.expressStatus,
      'expressCompName': instance.expressCompName,
      'expressCompCode': instance.expressCompCode,
      'expressNo': instance.expressNo,
      'assType': instance.assType,
      'refundStatus': instance.refundStatus,
      'returnStatus': instance.returnStatus,
      'returnReason': instance.returnReason,
      'returnRejectReason': instance.returnRejectReason,
      'selected': instance.selected,
      'rStatus' : instance.rStatus,
      'isClosed' : instance.isClosed,
      'asId': instance.asId,
    };

Balance _$BalanceFromJson(Map<String, dynamic> json) {
  return Balance(json['id'] as int, json['orderId'] as int,
      (json['deductedAmount'] as num)?.toDouble());
}

Map<String, dynamic> _$BalanceToJson(Balance instance) => <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'deductedAmount': instance.deductedAmount
    };

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return Payment(
      json['tradeNo'] as String,
      json['method'] as int,
      (json['amount'] as num)?.toDouble(),
      json['status'] as int,
      json['createdAt'] as String,
      json['completeTime'] as String,
      json['expireTime'] as String);
}

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'tradeNo': instance.tradeNo,
      'method': instance.method,
      'amount': instance.amount,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'completeTime': instance.completeTime,
      'expireTime': instance.expireTime
    };

Invoice _$InvoiceFromJson(Map<String, dynamic> json) {
  return Invoice(
      json['id'] as int,
      json['userId'] as int,
      json['type'] as int,
      json['title'] as String,
      json['taxNo'] as String,
      json['createdAt'] as String);
}

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': instance.type,
      'title': instance.title,
      'taxNo': instance.taxNo,
      'createdAt': instance.createdAt
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