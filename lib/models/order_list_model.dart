/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-02  13:13 
 * remark    : 
 * ====================================================
 */

import 'dart:core';

import 'package:jingyaoyun/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_list_model.g.dart';

/*
status :
    0 : 未支付
    1 : 支付成功
    2 : 订单取消
    3 : 订单过期

expressStatus 快递状态
    0: 待发货
    1:全部发货
    2:部分发货
    
    `ass_type`          '售后类型 0无 1退款 2退货退款',

    先判断 refund_status ，不为0的话说明在退款流程，否则在退货流程中，判断 return_status
    `refund_status`     '0正常，无申请退款的记录 1退款中 2退款成功',
    `return_status`     '0正常，1等待商家收货 2被拒绝 3成功',
 */

@JsonSerializable()
class OrderListModel extends BaseModel {
  List<OrderModel> data;

  OrderListModel(
    code,
    this.data,
    msg,
  ) : super(code, msg);

  factory OrderListModel.fromJson(Map<String, dynamic> srcJson) =>
      _$OrderListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OrderListModelToJson(this);
}

@JsonSerializable()
class OrderModel extends Object {
  int id;
  int parentId;
  int userId;
  int isSubordinate;
  String title;
  double brandCouponTotalAmount;
  double universeCouponTotalAmount;
  double coinTotalAmount;
  double expressTotalFee;
  double goodsTotalAmount;
  double goodsTotalCommission;
  double actualTotalAmount;
  int shippingMethod;

  String buyerMessage;

  int status;
  int expressStatus;
  int isApplyInvoice;
  int isFinishInvoice;
  int isAss;

  String evaluatedAt;
  String createdAt;

  String expireTime;
  String payIp;
  String tradeNo;
  String payTime;
  int payMethod;
  String completedAt;
  int totalGoodsCount;

  List<OrderGoodsModel> goodsList;

  bool canConfirm;
  // List<OrderBrandsModel> brands;

  OrderModel(
    this.id,
    this.parentId,
    this.userId,
    this.isSubordinate,
    this.title,
    this.brandCouponTotalAmount,
    this.universeCouponTotalAmount,
    this.coinTotalAmount,
    this.expressTotalFee,
    this.goodsTotalAmount,
    this.goodsTotalCommission,
    this.actualTotalAmount,
    this.shippingMethod,
    this.buyerMessage,
    this.status,
    this.expressStatus,
    this.isApplyInvoice,
    this.isFinishInvoice,
    this.isAss,
    this.evaluatedAt,
    this.createdAt,
    this.expireTime,
    this.payIp,
    this.tradeNo,
    this.payTime,
    this.payMethod,
    this.completedAt,
    this.totalGoodsCount,
    this.goodsList,
    this.canConfirm,
  );

  factory OrderModel.fromJson(Map<String, dynamic> srcJson) =>
      _$OrderModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

// @JsonSerializable()
// class OrderBrandsModel extends Object {
//   int id;

//   int orderId;

//   int userId;

//   int brandId;

//   String brandName;

//   String brandLogoUrl;

//   int isBrandShipper;

//   double expressFee;

//   double actualAmount;

//   int expressStatus;

//   String createdAt;

//   List<OrderGoodsModel> goods;

//   OrderBrandsModel(
//     this.id,
//     this.orderId,
//     this.userId,
//     this.brandId,
//     this.brandName,
//     this.brandLogoUrl,
//     this.isBrandShipper,
//     this.expressFee,
//     this.actualAmount,
//     this.expressStatus,
//     this.createdAt,
//     this.goods,
//   );

//   factory OrderBrandsModel.fromJson(Map<String, dynamic> srcJson) => _$OrderBrandsModelFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$OrderBrandsModelToJson(this);
// }

@JsonSerializable()
class OrderGoodsModel extends Object {
  int goodsDetailId;
  int orderId;
  int vendorId; // 供应商ID: 0表示自营
  int brandId; //品牌
  String brandName; //品牌名称
  int goodsId; //商品id
  String goodsName; //商品名称
  int skuId;
  String skuName;
  String skuCode;
  String mainPhotoUrl; //主图
  int quantity; //商品数量
  String promotionName; //活动名称
  double unitPrice; //单价
  double totalCommission; //提成总额
  double brandCouponAmount; // 品牌优惠券抵扣金额
  double universeBrandCouponAmount; // 购物券抵扣金额
  double coinAmount; // 瑞币抵扣金额
  double goodsAmount; // 商品总金额 单价x数量，不含其他费用减除
  double expressFee; // 快递费
  double actualAmount; // 实际支付的金额

  int expressStatus;
  String expressCompName;
  String expressCompCode;
  String expressNo;
  int assType;

  int refundStatus;
  int returnStatus; // 0正常，1等待商家审核 2审核被拒绝 3审核成功 4买家已填写退货物流信息 5收到退货，确认退款完成 6退货被拒绝
  String returnReason; // 买家退货理由
  String returnRejectReason;
  String rStatus;
  int isImport;
  String countryIcon;

  bool get importValue => isImport == 1;
  OrderGoodsModel(
    this.goodsDetailId,
    this.orderId,
    this.vendorId,
    this.brandId,
    this.brandName,
    this.goodsId,
    this.goodsName,
    this.skuId,
    this.skuName,
    this.skuCode,
    this.mainPhotoUrl,
    this.quantity,
    this.promotionName,
    this.unitPrice,
    this.totalCommission,
    this.brandCouponAmount,
    this.universeBrandCouponAmount,
    this.coinAmount,
    this.goodsAmount,
    this.expressFee,
    this.actualAmount,
    this.expressStatus,
    this.expressCompName,
    this.expressCompCode,
    this.expressNo,
    this.assType,
    this.refundStatus,
    this.returnStatus,
    this.returnReason,
    this.returnRejectReason,
    this.rStatus,
    this.isImport,
    this.countryIcon,
  );

  factory OrderGoodsModel.fromJson(Map<String, dynamic> srcJson) =>
      _$OrderGoodsModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OrderGoodsModelToJson(this);
}

// /*
//  * ====================================================
//  * package   :
//  * author    : Created by nansi.
//  * time      : 2019-08-02  13:13
//  * remark    :
//  * ====================================================
//  */

// import 'package:json_annotation/json_annotation.dart';
// import 'package:jingyaoyun/models/base_model.dart';

// part 'order_list_model.g.dart';

// /*

// status :
//     0 : 未支付
//     1 : 支付成功
//     2 : 订单取消
//     3 : 订单过期

// expressStatus 快递状态
//     0:待发货
//     1:全部发货
//     2:部分发货

//     `ass_type`          '售后类型 0无 1退款 2退货退款',

//     先判断 refund_status ，不为0的话说明在退款流程，否则在退货流程中，判断 return_status
//     `refund_status`     '0正常，无申请退款的记录 1退款中 2退款成功',
//     `return_status`     '0正常，1等待商家收货 2被拒绝 3成功',
//  */

// @JsonSerializable()
// class OrderListModel extends BaseModel {
//   List<OrderModel> data;

//   OrderListModel(
//     code,
//     this.data,
//     msg,
//   ) : super(code, msg);

//   factory OrderListModel.fromJson(Map<String, dynamic> srcJson) =>
//       _$OrderListModelFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$OrderListModelToJson(this);
// }

// @JsonSerializable()
// class OrderModel extends Object {
//   int id;

//   int userId;

//   double actualAmount;

//   int shippingMethod;

//   String buyerMessage;

//   int status;

//   String createdAt;

//   String evaluatedAt;

//   String expireTime;

//   List<OrderBrandsModel> brands;

//   OrderModel(
//     this.id,
//     this.userId,
//     this.actualAmount,
//     this.shippingMethod,
//     this.buyerMessage,
//     this.status,
//     this.evaluatedAt,
//     this.createdAt,
//     this.expireTime,
//     this.brands,
//   );

//   factory OrderModel.fromJson(Map<String, dynamic> srcJson) => _$OrderModelFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$OrderModelToJson(this);
// }

// @JsonSerializable()
// class OrderBrandsModel extends Object {
//   int id;

//   int orderId;

//   int userId;

//   int brandId;

//   String brandName;

//   String brandLogoUrl;

//   int isBrandShipper;

//   double expressFee;

//   double actualAmount;

//   int expressStatus;

//   String createdAt;

//   List<OrderGoodsModel> goods;

//   OrderBrandsModel(
//     this.id,
//     this.orderId,
//     this.userId,
//     this.brandId,
//     this.brandName,
//     this.brandLogoUrl,
//     this.isBrandShipper,
//     this.expressFee,
//     this.actualAmount,
//     this.expressStatus,
//     this.createdAt,
//     this.goods,
//   );

//   factory OrderBrandsModel.fromJson(Map<String, dynamic> srcJson) => _$OrderBrandsModelFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$OrderBrandsModelToJson(this);
// }

// @JsonSerializable()
// class OrderGoodsModel extends Object {
//   int id;

//   int orderId;

//   int brandDetailId;

//   int goodsId;

//   String goodsName;

//   int skuId;

//   String skuName;

//   String skuCode;

//   double price;

//   String mainPhotoUrl;

//   int quantity;

//   double weight;

//   double commission;

//   String promotionName;

//   int promotionDiscount;

//   double brandCouponAmount;

//   double universeBrandCouponAmount;

//   double balanceAmount;

//   double actualAmount;

//   int expressStatus;

//   String expressCompName;

//   String expressCompCode;

//   String expressNo;

//   int assType;

//   int refundStatus;

//   int returnStatus;

//   OrderGoodsModel(
//     this.id,
//     this.orderId,
//     this.brandDetailId,
//     this.goodsId,
//     this.goodsName,
//     this.skuId,
//     this.skuName,
//     this.skuCode,
//     this.price,
//     this.mainPhotoUrl,
//     this.quantity,
//     this.weight,
//     this.commission,
//     this.promotionName,
//     this.promotionDiscount,
//     this.brandCouponAmount,
//     this.universeBrandCouponAmount,
//     this.balanceAmount,
//     this.actualAmount,
//     this.expressStatus,
//     this.expressCompName,
//     this.expressCompCode,
//     this.expressNo,
//     this.assType,
//     this.refundStatus,
//     this.returnStatus,
//   );

//   factory OrderGoodsModel.fromJson(Map<String, dynamic> srcJson) => _$OrderGoodsModelFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$OrderGoodsModelToJson(this);
// }
