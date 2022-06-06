
part of 'order_return_status_model.dart';

OrderReturnStatusModel _$OrderReturnStatusModelFromJson(Map<String, dynamic> json) {
  return OrderReturnStatusModel(
      json['code'] as String?,
      json['data'] == null
          ? null
          : StatusData.fromJson(json['data'] as Map<String, dynamic>),
      json['msg'] as String?);
}

Map<String, dynamic> _$OrderReturnStatusModelToJson(OrderReturnStatusModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg
    };


StatusData _$StatusDataFromJson(Map<String, dynamic> json) {
  return StatusData(
      (json['asId']as int?),
      (json['userId']as int?),
      (json['orderId']as int?),
      (json['orderGoodsId']as int?),
      (json['vendorId']as int?),
      (json['vendorName']as String?),
      (json['brandName']as String?),
      (json['goodsId']as int?),
      (json['goodsName']as String?),
      (json['skuName']as String?),
      (json['skuCode']as String?),
      (json['mainPhotoUrl']as String?),
      (json['quantity']as int?),
      (json['orderTotalAmount']as num?)?.toDouble(),
      (json['refundAmount']as num?)?.toDouble(),
      (json['tradeNo']as String?),
      (json['payMethod']as num?)?.toDouble(),
      (json['assType']as int?),
      (json['returnStatus']as int?),
      (json['applyTime']as String?),
      (json['checkTime']as String?),
      (json['reason']as String?),
      (json['rejectReason']as String?),
      (json['expressCompName']as String?),
      (json['expressCompCode']as String?),
      (json['expressNo']as String?),
      (json['expressTime']as String?),
      (json['refundNo']as String?),
      (json['refundStatus']as int?),
      (json['finishTime']as String?),
      (json['createdAt']as String?),
      (json['title']as String?),
      (json['subtitle']as String?),
      (json['reasonType'] as int?),
      (json['refundCoin'] as num?),
      (json['rightTile'] as String?),
      (json['statusTile'] as int?),
      (json['residueHour'] as num?),
      (json['address'] as String?),
      (json['status'] as int?),
      (json['reasonContent'] as String?),
      (json['reasonImg'] as String?),
    );
}

Map<String, dynamic> _$StatusDataToJson(StatusData instance) =>
    <String, dynamic>{
      'asId': instance.asId,
      'userId': instance.userId,
      'orderId': instance.orderId,
      'orderGoodsId': instance.orderGoodsId,
      'vendorId': instance.vendorId,
      'vendorName': instance.vendorName,
      'brandName': instance.brandName,
      'goodsId': instance.goodsId,
      'goodsName': instance.goodsName,
      'skuName': instance.skuName,
      'skuCode': instance.skuCode,
      'mainPhotoUrl': instance.mainPhotoUrl,
      'quantity': instance.quantity,
      'orderTotalAmount': instance.orderTotalAmount,
      'refundAmount': instance.refundAmount,
      'tradeNo': instance.tradeNo,
      'payMethod': instance.payMethod,
      'assType': instance.assType,
      'returnStatus': instance.returnStatus,
      'applyTime': instance.applyTime,
      'checkTime': instance.checkTime,
      'reason': instance.reason,
      'rejectReason': instance.rejectReason,
      'expressCompName': instance.expressCompName,
      'expressCompCode': instance.expressCompCode,
      'expressNo': instance.expressNo,
      'expressTime': instance.expressTime,
      'refundNo': instance.refundNo,
      'refundStatus': instance.refundStatus,
      'finishTime': instance.finishTime,
      'createdAt': instance.createdAt,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'reasonType': instance.reasonType,
      'refundCoin': instance.refundCoin,
      "rightTile": instance.rightTile,
      "statusTile": instance.statusTile,
      "residueHour": instance.residueHour,
      "reasonContent": instance.reasonContent,
      "reasonImg": instance.reasonImg,
    };


OrderStatusDetail _$OrderStatusDetailFromJson(Map<String, dynamic> json) {
  return OrderStatusDetail(
    json['goodsName'] as String?,
    json['skuName'] as String?,
    json['mainPhotoUrl'] as String?,
    json['quantity'] as num?,
    json['actualAmount'] as num?,
    json['assType'] as int?,
    json['refundStatus'] as int?,
    json['returnStatus'] as int?,
    json['returnTime'] as String?,
    json['returnReason'] as String?,
    json['returnRejectReason'] as String?,
  );
}

Map<String, dynamic> _$OrderStatusDetailToJson(OrderStatusDetail instance) =>
    <String, dynamic>{
      'goodsName': instance.goodsName,
      'skuName': instance.skuName,
      'mainPhotoUrl': instance.mainPhotoUrl,
      'quantity': instance.quantity,
      'actualAmount': instance.actualAmount,
      'assType': instance.assType,
      'refundStatus': instance.refundStatus,
      'returnStatus': instance.returnStatus,
      'returnTime': instance.returnTime,
      'returnReason': instance.returnReason,
      'returnRejectReason': instance.returnRejectReason,
    }; 
