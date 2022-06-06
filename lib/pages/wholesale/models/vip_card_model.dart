class VipCardModel {
  int? skuId;
  int? goodsId;
  String? skuName;
  int? discountPrice;
  int? coupon;
  int? effectTime;
  int? effectDayType;

  VipCardModel(
      {this.skuId,
        this.goodsId,
        this.skuName,
        this.discountPrice,
        this.coupon,
        this.effectTime,
        this.effectDayType});

  VipCardModel.fromJson(Map<String, dynamic> json) {
    skuId = json['sku_id'];
    goodsId = json['goods_id'];
    skuName = json['sku_name'];
    discountPrice = json['discount_price'];
    coupon = json['coupon'];
    effectTime = json['effect_time'];
    effectDayType = json['effect_day_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku_id'] = this.skuId;
    data['goods_id'] = this.goodsId;
    data['sku_name'] = this.skuName;
    data['discount_price'] = this.discountPrice;
    data['coupon'] = this.coupon;
    data['effect_time'] = this.effectTime;
    data['effect_day_type'] = this.effectDayType;
    return data;
  }
}