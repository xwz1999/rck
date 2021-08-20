// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderListModel _$OrderListModelFromJson(Map<String, dynamic> json) {
  return OrderListModel(
      json['code'],
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : OrderModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['msg']);
}

Map<String, dynamic> _$OrderListModelToJson(OrderListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return OrderModel(
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
    json['isApplyInvoice'] as int,
    json['isFinishInvoice'] as int,
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
    (json['goodsList'] as List)
        ?.map((e) => e == null
            ? null
            : OrderGoodsModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['canConfirm'] as bool,
  );
}

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
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
      'isApplyInvoice': instance.isApplyInvoice,
      'isFinishInvoice': instance.isFinishInvoice,
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
      'goodsList': instance.goodsList,
      'canConfirm': instance.canConfirm,
    };

// OrderBrandsModel _$OrderBrandsModelFromJson(Map<String, dynamic> json) {
//   return OrderBrandsModel(
//       json['id'] as int,
//       json['orderId'] as int,
//       json['userId'] as int,
//       json['brandId'] as int,
//       json['brandName'] as String,
//       json['brandLogoUrl'] as String,
//       json['isBrandShipper'] as int,
//       (json['expressFee'] as num)?.toDouble(),
//       (json['actualAmount'] as num)?.toDouble(),
//       json['expressStatus'] as int,
//       json['createdAt'] as String,
//       (json['goods'] as List)
//           ?.map((e) => e == null
//               ? null
//               : OrderGoodsModel.fromJson(e as Map<String, dynamic>))
//           ?.toList());
// }

// Map<String, dynamic> _$OrderBrandsModelToJson(OrderBrandsModel instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'orderId': instance.orderId,
//       'userId': instance.userId,
//       'brandId': instance.brandId,
//       'brandName': instance.brandName,
//       'brandLogoUrl': instance.brandLogoUrl,
//       'isBrandShipper': instance.isBrandShipper,
//       'expressFee': instance.expressFee,
//       'actualAmount': instance.actualAmount,
//       'expressStatus': instance.expressStatus,
//       'createdAt': instance.createdAt,
//       'goods': instance.goods
//     };

OrderGoodsModel _$OrderGoodsModelFromJson(Map<String, dynamic> json) {
  return OrderGoodsModel(
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
    json['rStatus'] as String,
    json['isImport'] as int,
    json['countryIcon'] as String,
  );
}

Map<String, dynamic> _$OrderGoodsModelToJson(OrderGoodsModel instance) =>
    <String, dynamic>{
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
      'rStatus': instance.rStatus
    };

// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'order_list_model.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// OrderListModel _$OrderListModelFromJson(Map<String, dynamic> json) {
//   return OrderListModel(
//       json['code'],
//       (json['data'] as List)
//           ?.map((e) =>
//               e == null ? null : OrderModel.fromJson(e as Map<String, dynamic>))
//           ?.toList(),
//       json['msg']);
// }

// Map<String, dynamic> _$OrderListModelToJson(OrderListModel instance) =>
//     <String, dynamic>{
//       'code': instance.code,
//       'msg': instance.msg,
//       'data': instance.data
//     };

// OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
//   return OrderModel(
//       json['id'] as int,
//       json['userId'] as int,
//       (json['actualAmount'] as num)?.toDouble(),
//       json['shippingMethod'] as int,
//       json['buyerMessage'] as String,
//       json['status'] as int,
//       json['evaluatedAt'] as String,
//       json['createdAt'] as String,
//       json['expireTime'] as String,
//       (json['brands'] as List)
//           ?.map((e) => e == null
//               ? null
//               : OrderBrandsModel.fromJson(e as Map<String, dynamic>))
//           ?.toList());
// }

// Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'userId': instance.userId,
//       'actualAmount': instance.actualAmount,
//       'shippingMethod': instance.shippingMethod,
//       'buyerMessage': instance.buyerMessage,
//       'status': instance.status,
//       'createdAt': instance.createdAt,
//       'evaluatedAt': instance.evaluatedAt,
//       'expireTime': instance.expireTime,
//       'brands': instance.brands
//     };

// OrderBrandsModel _$OrderBrandsModelFromJson(Map<String, dynamic> json) {
//   return OrderBrandsModel(
//       json['id'] as int,
//       json['orderId'] as int,
//       json['userId'] as int,
//       json['brandId'] as int,
//       json['brandName'] as String,
//       json['brandLogoUrl'] as String,
//       json['isBrandShipper'] as int,
//       (json['expressFee'] as num)?.toDouble(),
//       (json['actualAmount'] as num)?.toDouble(),
//       json['expressStatus'] as int,
//       json['createdAt'] as String,
//       (json['goods'] as List)
//           ?.map((e) => e == null
//               ? null
//               : OrderGoodsModel.fromJson(e as Map<String, dynamic>))
//           ?.toList());
// }

// Map<String, dynamic> _$OrderBrandsModelToJson(OrderBrandsModel instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'orderId': instance.orderId,
//       'userId': instance.userId,
//       'brandId': instance.brandId,
//       'brandName': instance.brandName,
//       'brandLogoUrl': instance.brandLogoUrl,
//       'isBrandShipper': instance.isBrandShipper,
//       'expressFee': instance.expressFee,
//       'actualAmount': instance.actualAmount,
//       'expressStatus': instance.expressStatus,
//       'createdAt': instance.createdAt,
//       'goods': instance.goods
//     };

// OrderGoodsModel _$OrderGoodsModelFromJson(Map<String, dynamic> json) {
//   return OrderGoodsModel(
//       json['id'] as int,
//       json['orderId'] as int,
//       json['brandDetailId'] as int,
//       json['goodsId'] as int,
//       json['goodsName'] as String,
//       json['skuId'] as int,
//       json['skuName'] as String,
//       json['skuCode'] as String,
//       (json['price'] as num)?.toDouble(),
//       json['mainPhotoUrl'] as String,
//       json['quantity'] as int,
//       (json['weight'] as num)?.toDouble(),
//       (json['commission'] as num)?.toDouble(),
//       json['promotionName'] as String,
//       json['promotionDiscount'] as int,
//       (json['brandCouponAmount'] as num)?.toDouble(),
//       (json['universeBrandCouponAmount'] as num)?.toDouble(),
//       (json['balanceAmount'] as num)?.toDouble(),
//       (json['actualAmount'] as num)?.toDouble(),
//       json['expressStatus'] as int,
//       json['expressCompName'] as String,
//       json['expressCompCode'] as String,
//       json['expressNo'] as String,
//       json['assType'] as int,
//       json['refundStatus'] as int,
//       json['returnStatus'] as int);
// }

// Map<String, dynamic> _$OrderGoodsModelToJson(OrderGoodsModel instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'orderId': instance.orderId,
//       'brandDetailId': instance.brandDetailId,
//       'goodsId': instance.goodsId,
//       'goodsName': instance.goodsName,
//       'skuId': instance.skuId,
//       'skuName': instance.skuName,
//       'skuCode': instance.skuCode,
//       'price': instance.price,
//       'mainPhotoUrl': instance.mainPhotoUrl,
//       'quantity': instance.quantity,
//       'weight': instance.weight,
//       'commission': instance.commission,
//       'promotionName': instance.promotionName,
//       'promotionDiscount': instance.promotionDiscount,
//       'brandCouponAmount': instance.brandCouponAmount,
//       'universeBrandCouponAmount': instance.universeBrandCouponAmount,
//       'balanceAmount': instance.balanceAmount,
//       'actualAmount': instance.actualAmount,
//       'expressStatus': instance.expressStatus,
//       'expressCompName': instance.expressCompName,
//       'expressCompCode': instance.expressCompCode,
//       'expressNo': instance.expressNo,
//       'assType': instance.assType,
//       'refundStatus': instance.refundStatus,
//       'returnStatus': instance.returnStatus
//     };
