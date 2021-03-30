import 'package:json_annotation/json_annotation.dart';

part 'order_return_status_model.g.dart';

@JsonSerializable()
class OrderReturnStatusModel {

  String code;
  String msg;
  StatusData data;

  OrderReturnStatusModel(this.code, this.data, this.msg);

  factory OrderReturnStatusModel.fromJson(Map<String, dynamic> json) => _$OrderReturnStatusModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderReturnStatusModelToJson(this);
}

@JsonSerializable()
class StatusData {


  int asId;
  int userId;
  int orderId;
  int orderGoodsId;
  int vendorId;
  String vendorName;
  String brandName;
  int goodsId;
  String goodsName;
  String skuName;
  String skuCode;
  String mainPhotoUrl;
  int quantity;
  double orderTotalAmount;
  double refundAmount;
  
  String tradeNo;
  double payMethod;
  int assType;
  int returnStatus;
  String applyTime;
  String checkTime;
  String reason;
  String rejectReason;
  String expressCompName;
  String expressCompCode;
  String expressNo;
  String expressTime;
  String refundNo;
  int refundStatus;
  String finishTime;
  String createdAt;
  String title;
  String subtitle;
  int reasonType;
  num refundCoin;
  String rightTile;
  int statusTile;
  num residueHour;
  String address;
  int status;
  String reasonContent;
  String reasonImg;
  // double totalActualAmount;
  // List<OrderStatusDetail> list;

  StatusData(
    this.asId,
    this.userId,
    this.orderId,
    this.orderGoodsId,
    this.vendorId,
    this.vendorName,
    this.brandName,
    this.goodsId,
    this.goodsName,
    this.skuName,
    this.skuCode,
    this.mainPhotoUrl,
    this.quantity,
    this.orderTotalAmount,
    this.refundAmount,
    this.tradeNo,
    this.payMethod,
    this.assType,
    this.returnStatus,
    this.applyTime,
    this.checkTime,
    this.reason,
    this.rejectReason,
    this.expressCompName,
    this.expressCompCode,
    this.expressNo,
    this.expressTime,
    this.refundNo,
    this.refundStatus,
    this.finishTime,
    this.createdAt,
    this.title,
    this.subtitle,
    this.reasonType,
    this.refundCoin,
    this.rightTile,
    this.statusTile,
    this.residueHour,
    this.address,
    this.status,
    this.reasonContent,
    this.reasonImg,
  );

  factory StatusData.fromJson(Map<String, dynamic> json) => _$StatusDataFromJson(json);
  Map<String, dynamic> toJson() => _$StatusDataToJson(this);
}

@JsonSerializable()
class OrderStatusDetail {

  String goodsName;
  String skuName;
  String mainPhotoUrl;
  num quantity;
  num actualAmount;
  int assType;
  int refundStatus;
  int returnStatus;
  String returnTime;
  String returnReason;
  String returnRejectReason;

  OrderStatusDetail(this.goodsName, this.skuName, this.mainPhotoUrl, this.quantity, 
    this.actualAmount, this.assType, this.refundStatus, this.returnStatus, this.returnTime,
    this.returnReason, this.returnRejectReason);

  factory OrderStatusDetail.fromJson(Map<String, dynamic> json) => _$OrderStatusDetailFromJson(json);
  Map<String, dynamic> toJson() => _$OrderStatusDetailToJson(this);
}
