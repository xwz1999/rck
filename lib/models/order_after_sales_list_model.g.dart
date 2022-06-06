
part of 'order_after_sales_list_model.dart';

OrderAfterSalesListModel _$OrderAfterSalesListModelFromJson(Map<String, dynamic> json) {
  return OrderAfterSalesListModel(
      json['code'],
      (json['data'] as List?)
          ?.map((e) =>
              OrderAfterSalesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['msg']);
}

Map<String, dynamic> _$OrderAfterSalesListModelToJson(OrderAfterSalesListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };


OrderAfterSalesModel _$OrderAfterSalesModelFromJson(Map<String, dynamic> json) {
  return OrderAfterSalesModel(
    (json['asId'] as int?),
    (json['goodsId'] as int?),
    (json['goodsName'] as String?),
    (json['skuName'] as String?),
    (json['mainPhotoUrl'] as String?),
    (json['refundAmount'] as num?)??0.0,
    (json['assType'] as int?),
    (json['returnStatus'] as int?),
    (json['refundStatus'] as int?),
    (json['asDesc'] as String?),
    (json['refundDesc'] as String?),
    (json['orderGoodsId'] as int?),
    (json['refundCoin'] as num?)??0.0,
    (json['createdAt'] as String?),
    (json['quantity'] as num?),
    (json['color'] as int?),
    (json['goodsDetailId'] as int?)
  );
}

Map<String, dynamic> _$OrderAfterSalesModelToJson(OrderAfterSalesModel instance) =>
    <String, dynamic>{
      'asId': instance.asId,
      'goodsId': instance.goodsId,
      'goodsName': instance.goodsName,
      'skuName': instance.skuName,
      'mainPhotoUrl': instance.mainPhotoUrl,
      'refundAmount': instance.refundAmount,
      'assType': instance.assType,
      'returnStatus': instance.returnStatus,
      'refundStatus': instance.refundStatus,
      'asDesc': instance.asDesc,
      'refundDesc': instance.refundDesc,
      'orderGoodsId': instance.orderGoodsId,
      "refundCoin": instance.refundCoin,
      "createdAt": instance.createdAt,
      'quantity': instance.quantity,
      'color': instance.color,
      'goodsDetailId': instance.goodsDetailId
    };
