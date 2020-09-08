import 'package:recook/models/base_model.dart';

import 'package:json_annotation/json_annotation.dart';

part 'order_after_sales_list_model.g.dart';

@JsonSerializable()
class OrderAfterSalesListModel extends BaseModel {
  
  List<OrderAfterSalesModel> data;

  OrderAfterSalesListModel(
    code,
    this.data,
    msg,
  ) : super(code, msg);

  factory OrderAfterSalesListModel.fromJson(Map<String, dynamic> json) => _$OrderAfterSalesListModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderAfterSalesListModelToJson(this);
}

@JsonSerializable()
class OrderAfterSalesModel {

  int asId;
  int goodsId;
  String goodsName;
  String skuName;
  String mainPhotoUrl;
  num refundAmount;
  num refundCoin;
  int assType;
  int returnStatus;
  int refundStatus;
  String asDesc;
  String refundDesc;
  int orderGoodsId;
  String createdAt;
  num quantity;
  int color;
  int goodsDetailId;
  OrderAfterSalesModel(
    this.asId,
    this.goodsId,
    this.goodsName,
    this.skuName,
    this.mainPhotoUrl,
    this.refundAmount,
    this.assType,
    this.returnStatus,
    this.refundStatus,
    this.asDesc,
    this.refundDesc,
    this.orderGoodsId,
    this.refundCoin,
    this.createdAt,
    this.quantity,
    this.color,
    this.goodsDetailId
  );

  factory OrderAfterSalesModel.fromJson(Map<String, dynamic> json) => _$OrderAfterSalesModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderAfterSalesModelToJson(this);
}
