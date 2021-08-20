class GuideOrderItemModel {
  int orderId;
  int shippingMethod;
  int createdAt;
  int payTime;
  int expireTime;
  int status;
  num goodsTotalAmount;
  num actualTotalAmount;
  List<Goods> goods;

  String get statusValue {
    switch (status) {
      case 0:
        return '未支付';
      case 1:
        return '支付成功';
      case 2:
        return '订单取消';
      case 3:
        return '订单过期';
      case 4:
        return '订单完成';
      case 5:
        return '订单关闭';
      default:
        return '';
    }
  }

  GuideOrderItemModel(
      {this.orderId,
      this.shippingMethod,
      this.createdAt,
      this.payTime,
      this.expireTime,
      this.status,
      this.goodsTotalAmount,
      this.actualTotalAmount,
      this.goods});

  GuideOrderItemModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    shippingMethod = json['shippingMethod'];
    createdAt = json['createdAt'];
    payTime = json['payTime'];
    expireTime = json['expireTime'];
    status = json['status'];
    goodsTotalAmount = json['goodsTotalAmount'];
    actualTotalAmount = json['actualTotalAmount'];
    if (json['goods'] != null) {
      goods = [];
      json['goods'].forEach((v) {
        goods.add(new Goods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['shippingMethod'] = this.shippingMethod;
    data['createdAt'] = this.createdAt;
    data['payTime'] = this.payTime;
    data['expireTime'] = this.expireTime;
    data['status'] = this.status;
    data['goodsTotalAmount'] = this.goodsTotalAmount;
    data['actualTotalAmount'] = this.actualTotalAmount;
    if (this.goods != null) {
      data['goods'] = this.goods.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Goods {
  int orderGoodsId;
  String mainPhotoUrl;
  String goodsName;
  String skuName;
  int isImport;
  int quantity;
  num unitPrice;
  int expressStatus;
  int assType;
  int refundStatus;
  String countryIcon;

  bool get importValue => isImport == 1;
  String get refundStatusValue {
    switch (refundStatus) {
      case 0:
        return '';
      case 1:
        return '退款中';
      case 2:
        return '退款成功';
      default:
        return '';
    }
  }

  Goods(
      {this.orderGoodsId,
      this.mainPhotoUrl,
      this.goodsName,
      this.skuName,
      this.isImport,
      this.quantity,
      this.unitPrice,
      this.expressStatus,
      this.assType,
      this.refundStatus,
      this.countryIcon});

  Goods.fromJson(Map<String, dynamic> json) {
    orderGoodsId = json['orderGoodsId'];
    mainPhotoUrl = json['mainPhotoUrl'];
    goodsName = json['goodsName'];
    skuName = json['skuName'];
    isImport = json['isImport'];
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
    expressStatus = json['expressStatus'];
    assType = json['assType'];
    refundStatus = json['refundStatus'];
    countryIcon = json['country_icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderGoodsId'] = this.orderGoodsId;
    data['mainPhotoUrl'] = this.mainPhotoUrl;
    data['goodsName'] = this.goodsName;
    data['skuName'] = this.skuName;
    data['isImport'] = this.isImport;
    data['quantity'] = this.quantity;
    data['unitPrice'] = this.unitPrice;
    data['expressStatus'] = this.expressStatus;
    data['assType'] = this.assType;
    data['refundStatus'] = this.refundStatus;
    data['country_icon'] = this.countryIcon;
    return data;
  }
}
