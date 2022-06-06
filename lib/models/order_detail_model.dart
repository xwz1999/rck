
/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-08  15:46 
 * remark    : 
 * ====================================================
 */

import 'package:json_annotation/json_annotation.dart';

part 'order_detail_model.g.dart';

/*


invoice ：
     `id`           INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
     `user_id`      INT UNSIGNED NOT NULL COMMENT '用户',
     `type`         TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发票类型 0个人 1公司',
     `title`        VARCHAR(50) NOT NULL DEFAULT '' COMMENT '抬头',
     `tax_no`       VARCHAR(50) NOT NULL DEFAULT '' COMMENT '税号',
     `created_at`   TIMESTAMP,
*/

@JsonSerializable()
class OrderDetailModel extends Object {
  String? code;

  OrderDetail? data;

  String? msg;

  OrderDetailModel(
    this.code,
    this.data,
    this.msg,
  );

  factory OrderDetailModel.fromJson(Map<String, dynamic> srcJson) =>
      _$OrderDetailModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OrderDetailModelToJson(this);
}

@JsonSerializable()
class OrderDetail extends Object {
  int? id;
  int? parentId; //分享者id
  int? userId; //下单者id
  int? isSubordinate; //是否为上下级
  String? title; //订单简要标题
  double? brandCouponTotalAmount; //品牌优惠券抵扣总金额
  double? universeCouponTotalAmount; // 购物券抵扣总金额
  double? coinTotalAmount; // 瑞币抵扣总金额
  double? expressTotalFee; // 总快递费
  double? goodsTotalAmount; // 商品总金额，
  double? goodsTotalCommission; // 商品总返还金额
  double? actualTotalAmount; // 实际支付的金额
  int? shippingMethod; // 0快递 1自提
  String? buyerMsg; // 买家留言
  int? status; // 0未付款 1支付成功 2订单取消 3订单过期 4交易成功 5订单关闭
  int? expressStatus; // 快递状态 0 没有发货 1部分发货 2全部发货
  // int isApplyInvoice;// 是否申请过开票
  // int isFinishInvoice;// 是否完成开票 0没有 1完成了
  int? invoiceStatus; // 开票状态 0 未申请， 1已申请 2已开票
  int? isAss; // 0正常 1申请过售后
  String? evaluatedAt; // 评价时间
  String? createdAt; // 创建时间
  String? expireTime; // 订单过期时间
  String? payIp; // 支付时的ip
  String? tradeNo; // 传递给第三方支付的id凭证
  String? payTime; // 支付时间
  int? payMethod; // 支付方式: 0:recookpay 1:微信 2:支付宝 3:零支付 4:小程序支付'
  String? completedAt; // 交易完成时间
  int? totalGoodsCount; // 商品总件数

  // double actualAmount;
  // int shippingMethod;
  // String buyerMessage;
  // int status;
  // String createdAt;
  // String evaluatedAt;
  // String expireTime;
  // String completedAt;
  Coupon? coupon;
  Addr? addr;
  List<Brands>? brands;
  // Balance balance;
  // Payment payment;
  // Invoice invoice;
  bool? canConfirm;
  List<StatusList>? statusList;

  String? makeUpText;
  num? makeUpAmount;
  bool? canPay;

  OrderDetail(
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
    this.buyerMsg,
    this.status,
    this.expressStatus,
    this.invoiceStatus,
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
    this.coupon,
    this.addr,
    this.brands,
    this.canConfirm,
    this.statusList,this.makeUpText,this.makeUpAmount,this.canPay
  );

  factory OrderDetail.fromJson(Map<String, dynamic> srcJson) =>
      _$OrderDetailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
}

@JsonSerializable()
class Addr extends Object {
  int? id;

  int? orderId;

  int? addressId;

  String? province;

  String? city;

  String? district;

  String? address;

  String? receiverName;

  String? mobile;

  Addr(
    this.id,
    this.orderId,
    this.addressId,
    this.province,
    this.city,
    this.district,
    this.address,
    this.receiverName,
    this.mobile,
  );

  factory Addr.fromJson(Map<String, dynamic> srcJson) =>
      _$AddrFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddrToJson(this);
}

@JsonSerializable()
class Brands extends Object {
  int? brandId;
  String? brandName;
  String? brandLogoUrl;
  double? brandExpressTotalAmount;
  double? brandGoodsTotalAmount;
  int? brandGoodsTotalCount;
  Coupon? coupon;

  List<Goods>? goods;

  Brands(
      this.brandId,
      this.brandName,
      this.brandLogoUrl,
      this.brandExpressTotalAmount,
      this.brandGoodsTotalAmount,
      this.brandGoodsTotalCount,
      this.goods,
      this.coupon);

  factory Brands.fromJson(Map<String, dynamic> srcJson) =>
      _$BrandsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BrandsToJson(this);
}

@JsonSerializable()
class Goods extends Object {
  int? goodsDetailId;
  int? orderId;
  int? vendorId; // 供应商ID: 0表示自营
  int? brandId; // 品牌
  String? brandName; // 品牌名称
  int? goodsId; // 商品ID
  String? goodsName; // 商品名快照
  int? skuId; // 商品sku_id
  String? skuName; // SKU名字组合起来
  String? skuCode; // 条形码或者编码
  String? mainPhotoUrl; // 主图快照 先读sku 没有则读取主图
  int? quantity; // 商品数量
  String? promotionName; // 活动名称
  double? unitPrice; // 单价
  double? totalCommission; // 提成总额
  double? brandCouponAmount; // 品牌优惠券抵扣金额
  double? universeBrandCouponAmount; // 购物券抵扣金额
  double? coinAmount; // 瑞币抵扣金额
  double? goodsAmount; // 商品总金额 单价x数量，不含其他费用减除
  double? expressFee; // 快递费
  double? actualAmount; // 实际支付的金额
  int? expressStatus;
  String? expressCompName;
  String? expressCompCode;
  String? expressNo;
  int? assType; //售后类型 0无 1退款 2退货退款
  int? refundStatus; // 0无申请退款的记录  1退款中 2退款成功
  int? returnStatus; // 0正常，1等待商家审核 2审核被拒绝 3审核成功 4买家已填写退货物流信息 5收到退货，确认退款完成 6退货被拒绝
  String? returnReason; // 买家退货理由
  String? returnRejectReason;
  bool? selected;
  String? rStatus;
  int? isClosed;
  int? asId;
  Goods(
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
      this.selected,
      this.rStatus,
      this.isClosed,
      this.asId) {
    this.selected = false;
  }

  // Goods(this.id,
  //     this.orderId,
  //     this.brandDetailId,
  //     this.selected) {
  //   this.selected = false;
  // }

  factory Goods.fromJson(Map<String, dynamic> srcJson) =>
      _$GoodsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GoodsToJson(this);
}

@JsonSerializable()
class Balance extends Object {
  int? id;

  int? orderId;

  double? deductedAmount;

  Balance(
    this.id,
    this.orderId,
    this.deductedAmount,
  );

  factory Balance.fromJson(Map<String, dynamic> srcJson) =>
      _$BalanceFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BalanceToJson(this);
}

@JsonSerializable()
class Payment extends Object {
  String? tradeNo;

  int? method;

  double? amount;

  int? status;

  String? createdAt;

  String? completeTime;

  String? expireTime;

  Payment(this.tradeNo, this.method, this.amount, this.status, this.createdAt,
      this.completeTime, this.expireTime);

  factory Payment.fromJson(Map<String, dynamic> srcJson) =>
      _$PaymentFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

@JsonSerializable()
class Invoice extends Object {
  int? id;

  int? userId;

  int? type;

  String? title;

  String? taxNo;

  String? createdAt;

  Invoice(
      this.id, this.userId, this.type, this.title, this.taxNo, this.createdAt);

  factory Invoice.fromJson(Map<String, dynamic> srcJson) =>
      _$InvoiceFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}

@JsonSerializable()
class Coupon extends Object {
  int? id;

  int? brandId;

  int? scope;

  String? couponName; //'使用的优惠券名称'

  double? deductedAmount; //'抵扣的金额',

  Coupon(
    this.id,
    this.brandId,
    this.scope,
    this.couponName,
    this.deductedAmount,
  );

  factory Coupon.fromJson(Map<String, dynamic> srcJson) =>
      _$CouponFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CouponToJson(this);
}
@JsonSerializable()
class StatusList extends Object{
  int? goodsId;
  int? status;

  StatusList({this.goodsId, this.status});

  StatusList.fromJson(Map<String, dynamic> json) {
    goodsId = json['goods_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goods_id'] = this.goodsId;
    data['status'] = this.status;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'goodsId': goodsId,
      'status': status,
    };
  }

  factory StatusList.fromMap(Map<String, dynamic> map) {
    return StatusList(
      goodsId: map['goodsId'],
      status: map['status'],
    );
  }

}
