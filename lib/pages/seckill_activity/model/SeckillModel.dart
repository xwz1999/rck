class SeckillModel {
  int status;
  List<SeckillGoods> seckillGoodsList;
  String endTime;
  String startTime;
  num shoppingPeople;

  SeckillModel(
      {this.status,
        this.seckillGoodsList,
        this.endTime,
        this.startTime,
        this.shoppingPeople});

  SeckillModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['goods_list'] != null) {
      seckillGoodsList = new List<SeckillGoods>();
      json['goods_list'].forEach((v) {
        seckillGoodsList.add(new SeckillGoods.fromJson(v));
      });
    }
    endTime = json['end_time'];
    startTime = json['start_time'];
    shoppingPeople = json['shopping_people'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.seckillGoodsList != null) {
      data['goods_list'] = this.seckillGoodsList.map((v) => v.toJson()).toList();
    }
    data['end_time'] = this.endTime;
    data['start_time'] = this.startTime;
    data['shopping_people'] = this.shoppingPeople;
    return data;
  }
}

class SeckillGoods {
  num goodsId;
  String goodsName;
  String subTitle;
  String mainPhoto;
  String countryUrl;
  String brandName;
  String brandUrl;
  num minDiscountPrice;
  num saleNum;

  SeckillGoods(
      {this.goodsId,
        this.goodsName,
        this.subTitle,
        this.mainPhoto,
        this.countryUrl,
        this.brandName,
        this.brandUrl,
        this.minDiscountPrice,
        this.saleNum});

  SeckillGoods.fromJson(Map<String, dynamic> json) {
    goodsId = json['goods_id'];
    goodsName = json['goods_name'];
    subTitle = json['sub_title'];
    mainPhoto = json['main_photo'];
    countryUrl = json['country_url'];
    brandName = json['brand_name'];
    brandUrl = json['brand_url'];
    minDiscountPrice = json['min_discount_price'];
    saleNum = json['sale_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goods_id'] = this.goodsId;
    data['goods_name'] = this.goodsName;
    data['sub_title'] = this.subTitle;
    data['main_photo'] = this.mainPhoto;
    data['country_url'] = this.countryUrl;
    data['brand_name'] = this.brandName;
    data['brand_url'] = this.brandUrl;
    data['min_discount_price'] = this.minDiscountPrice;
    data['sale_num'] = this.saleNum;
    return data;
  }
}