class OrderReviewListModel {
  MyOrderGoodsDea? myOrderGoodsDea;
  int? passEvaluation;
  int? compliance;

  OrderReviewListModel(
      {this.myOrderGoodsDea, this.passEvaluation, this.compliance});

  OrderReviewListModel.fromJson(Map<String, dynamic> json) {
    myOrderGoodsDea = json['my_order_goods_dea'] != null
        ? new MyOrderGoodsDea.fromJson(json['my_order_goods_dea'])
        : null;
    passEvaluation = json['pass_evaluation'];
    compliance = json['compliance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.myOrderGoodsDea != null) {
      data['my_order_goods_dea'] = this.myOrderGoodsDea!.toJson();
    }
    data['pass_evaluation'] = this.passEvaluation;
    data['compliance'] = this.compliance;
    return data;
  }
}

class MyOrderGoodsDea {
  int? goodsDetailId;
  int? orderId;
  int? parentId;
  int? sharerId;
  int? userId;
  int? vendorId;
  String? vendorName;
  int? brandId;
  String? brandName;
  String? cateName;
  int? goodsId;
  String? goodsName;
  int? skuId;
  String? skuName;
  String? skuCode;
  String? mainPhotoUrl;
  int? quantity;
  String? promotionName;
  num? unitPrice;
  num? purchasePrice;
  num? totalCommission;
  num? brandCouponAmount;
  num? universeBrandCouponAmount;
  num? coinAmount;
  num? goodsAmount;
  num? expressFee;
  num? actualAmount;
  String? buyerMessage;
  String? orderTime;
  int? payStatus;
  String? createdAt;
  int? expressStatus;
  Null expressTime;
  String? expressCompName;
  String? expressCompCode;
  String? expressNo;
  int? assType;
  int? refundStatus;
  int? status;
  Addr? addr;
  int? shippingMethod;
  int? isClosed;
  String? rStatus;
  String? detailInfo;
  int? bill;
  String? fpqqlsh;
  int? isExport;
  String? bomaoNo;
  int? evaluatedId;

  MyOrderGoodsDea(
      {this.goodsDetailId,
      this.orderId,
      this.parentId,
      this.sharerId,
      this.userId,
      this.vendorId,
      this.vendorName,
      this.brandId,
      this.brandName,
      this.cateName,
      this.goodsId,
      this.goodsName,
      this.skuId,
      this.skuName,
      this.skuCode,
      this.mainPhotoUrl,
      this.quantity,
      this.promotionName,
      this.unitPrice,
      this.purchasePrice,
      this.totalCommission,
      this.brandCouponAmount,
      this.universeBrandCouponAmount,
      this.coinAmount,
      this.goodsAmount,
      this.expressFee,
      this.actualAmount,
      this.buyerMessage,
      this.orderTime,
      this.payStatus,
      this.createdAt,
      this.expressStatus,
      this.expressTime,
      this.expressCompName,
      this.expressCompCode,
      this.expressNo,
      this.assType,
      this.refundStatus,
      this.status,
      this.addr,
      this.shippingMethod,
      this.isClosed,
      this.rStatus,
      this.detailInfo,
      this.bill,
      this.fpqqlsh,
      this.isExport,
      this.bomaoNo,
      this.evaluatedId});

  MyOrderGoodsDea.fromJson(Map<String, dynamic> json) {
    goodsDetailId = json['goodsDetailId'];
    orderId = json['orderId'];
    parentId = json['parentId'];
    sharerId = json['sharerId'];
    userId = json['userId'];
    vendorId = json['vendorId'];
    vendorName = json['vendorName'];
    brandId = json['brandId'];
    brandName = json['brandName'];
    cateName = json['cateName'];
    goodsId = json['goodsId'];
    goodsName = json['goodsName'];
    skuId = json['skuId'];
    skuName = json['skuName'];
    skuCode = json['skuCode'];
    mainPhotoUrl = json['mainPhotoUrl'];
    quantity = json['quantity'];
    promotionName = json['promotionName'];
    unitPrice = json['unitPrice'];
    purchasePrice = json['purchasePrice'];
    totalCommission = json['totalCommission'];
    brandCouponAmount = json['brandCouponAmount'];
    universeBrandCouponAmount = json['universeBrandCouponAmount'];
    coinAmount = json['coinAmount'];
    goodsAmount = json['goodsAmount'];
    expressFee = json['expressFee'];
    actualAmount = json['actualAmount'];
    buyerMessage = json['buyerMessage'];
    orderTime = json['orderTime'];
    payStatus = json['payStatus'];
    createdAt = json['createdAt'];
    expressStatus = json['expressStatus'];
    expressTime = json['expressTime'];
    expressCompName = json['expressCompName'];
    expressCompCode = json['expressCompCode'];
    expressNo = json['expressNo'];
    assType = json['assType'];
    refundStatus = json['refundStatus'];
    status = json['status'];
    addr = json['Addr'] != null ? new Addr.fromJson(json['Addr']) : null;
    shippingMethod = json['ShippingMethod'];
    isClosed = json['isClosed'];
    rStatus = json['rStatus'];
    detailInfo = json['DetailInfo'];
    bill = json['bill'];
    fpqqlsh = json['fpqqlsh'];
    isExport = json['is_export'];
    bomaoNo = json['bomao_no'];
    evaluatedId = json['evaluated_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goodsDetailId'] = this.goodsDetailId;
    data['orderId'] = this.orderId;
    data['parentId'] = this.parentId;
    data['sharerId'] = this.sharerId;
    data['userId'] = this.userId;
    data['vendorId'] = this.vendorId;
    data['vendorName'] = this.vendorName;
    data['brandId'] = this.brandId;
    data['brandName'] = this.brandName;
    data['cateName'] = this.cateName;
    data['goodsId'] = this.goodsId;
    data['goodsName'] = this.goodsName;
    data['skuId'] = this.skuId;
    data['skuName'] = this.skuName;
    data['skuCode'] = this.skuCode;
    data['mainPhotoUrl'] = this.mainPhotoUrl;
    data['quantity'] = this.quantity;
    data['promotionName'] = this.promotionName;
    data['unitPrice'] = this.unitPrice;
    data['purchasePrice'] = this.purchasePrice;
    data['totalCommission'] = this.totalCommission;
    data['brandCouponAmount'] = this.brandCouponAmount;
    data['universeBrandCouponAmount'] = this.universeBrandCouponAmount;
    data['coinAmount'] = this.coinAmount;
    data['goodsAmount'] = this.goodsAmount;
    data['expressFee'] = this.expressFee;
    data['actualAmount'] = this.actualAmount;
    data['buyerMessage'] = this.buyerMessage;
    data['orderTime'] = this.orderTime;
    data['payStatus'] = this.payStatus;
    data['createdAt'] = this.createdAt;
    data['expressStatus'] = this.expressStatus;
    data['expressTime'] = this.expressTime;
    data['expressCompName'] = this.expressCompName;
    data['expressCompCode'] = this.expressCompCode;
    data['expressNo'] = this.expressNo;
    data['assType'] = this.assType;
    data['refundStatus'] = this.refundStatus;
    data['status'] = this.status;
    if (this.addr != null) {
      data['Addr'] = this.addr!.toJson();
    }
    data['ShippingMethod'] = this.shippingMethod;
    data['isClosed'] = this.isClosed;
    data['rStatus'] = this.rStatus;
    data['DetailInfo'] = this.detailInfo;
    data['bill'] = this.bill;
    data['fpqqlsh'] = this.fpqqlsh;
    data['is_export'] = this.isExport;
    data['bomao_no'] = this.bomaoNo;
    data['evaluated_id'] = this.evaluatedId;
    return data;
  }
}

class Addr {
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
      {this.id,
      this.orderId,
      this.addressId,
      this.province,
      this.city,
      this.district,
      this.address,
      this.receiverName,
      this.mobile});

  Addr.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    addressId = json['addressId'];
    province = json['province'];
    city = json['city'];
    district = json['district'];
    address = json['address'];
    receiverName = json['receiverName'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderId'] = this.orderId;
    data['addressId'] = this.addressId;
    data['province'] = this.province;
    data['city'] = this.city;
    data['district'] = this.district;
    data['address'] = this.address;
    data['receiverName'] = this.receiverName;
    data['mobile'] = this.mobile;
    return data;
  }
}
