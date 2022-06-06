class WholesaleCarModel {
  int? id;
  int? skuId;
  num? discountPrice;
  num? salePrice;
  int? quantity;
  int? limit;
  int? min;
  String? skuName;
  String? goodsName;
  int? salePublish;
  String? picUrl;
  int? goodsId;
  bool selected = false;


  WholesaleCarModel(
      this.id,
        this.skuId,
        this.discountPrice,
        this.salePrice,
        this.quantity,
        this.limit,
        this.min,
        this.skuName,
        this.goodsName,
        this.salePublish,
        this.goodsId,
        this.picUrl,{this.selected = false});

  WholesaleCarModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    skuId = json['sku_id'];
    discountPrice = json['discount_price'];
    salePrice = json['sale_price'];
    quantity = json['quantity'];
    limit = json['limit'];
    min = json['min'];
    skuName = json['sku_name'];
    goodsName = json['goods_name'];
    salePublish = json['sale_publish'];
    picUrl = json['pic_url'];
    goodsId = json['goods_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sku_id'] = this.skuId;
    data['discount_price'] = this.discountPrice;
    data['sale_price'] = this.salePrice;
    data['quantity'] = this.quantity;
    data['limit'] = this.limit;
    data['min'] = this.min;
    data['sku_name'] = this.skuName;
    data['goods_name'] = this.goodsName;
    data['sale_publish'] = this.salePublish;
    data['pic_url'] = this.picUrl;
    data['goods_id'] = this.goodsId;
    return data;
  }
}