
class WholesaleGood {
  num? id;
  String? goodsName;
  String? brandImg;
  String? brandName;
  num? brandId;
  String? description;
  num? inventory;
  num? salesVolume;
  String? mainPhotoUrl;
  String? promotionName;
  num? originalPrice;
  num? discountPrice;
  num? commission;
  List<String>? tags;
  num? percent;
  String? startTime;
  String? endTime;
  num? coupon;
  num? isImport;
  num? storehouse;
  num? isFerme;
  bool? hasCoin;
  bool? hasBalance;

  num? gysId;
  List<String>? specialIcon;
  String? countryIcon;
  num? salePrice;

  WholesaleGood(
      {this.id,
        this.goodsName,
        this.brandImg,
        this.brandName,
        this.brandId,
        this.description,
        this.inventory,
        this.salesVolume,
        this.mainPhotoUrl,
        this.promotionName,
        this.originalPrice,
        this.discountPrice,
        this.commission,
        this.tags,
        this.percent,
        this.startTime,
        this.endTime,
        this.coupon,
        this.isImport,
        this.storehouse,
        this.isFerme,
        this.hasCoin,
        this.hasBalance,
        this.gysId,
        this.specialIcon,
        this.countryIcon,
      this.salePrice});

  WholesaleGood.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodsName = json['goodsName'];
    brandImg = json['brandImg'];
    brandName = json['brandName'];
    brandId = json['brandId'];
    description = json['description'];
    inventory = json['inventory'];
    salesVolume = json['salesVolume'];
    mainPhotoUrl = json['mainPhotoUrl'];
    promotionName = json['promotionName'];
    originalPrice = json['originalPrice'];
    discountPrice = json['discountPrice'];
    commission = json['commission'];
    tags =
    json['tags'] != null ? json['tags'].cast<String>() : null;
    percent = json['percent'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    coupon = json['coupon'];
    isImport = json['isImport'];
    storehouse = json['storehouse'];
    isFerme = json['isFerme'];
    hasCoin = json['hasCoin'];
    hasBalance = json['hasBalance'];
    gysId = json['gys_id'];
    salePrice = json['sale_price'];
    specialIcon =
    json['spec_icon'] != null ? json['spec_icon'].cast<String>() : null;
    countryIcon = json['country_icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['goodsName'] = this.goodsName;
    data['brandImg'] = this.brandImg;
    data['brandName'] = this.brandName;
    data['brandId'] = this.brandId;
    data['description'] = this.description;
    data['inventory'] = this.inventory;
    data['salesVolume'] = this.salesVolume;
    data['mainPhotoUrl'] = this.mainPhotoUrl;
    data['promotionName'] = this.promotionName;
    data['originalPrice'] = this.originalPrice;
    data['discountPrice'] = this.discountPrice;
    data['commission'] = this.commission;
    data['tags'] = this.tags;
    data['percent'] = this.percent;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['coupon'] = this.coupon;
    data['isImport'] = this.isImport;
    data['storehouse'] = this.storehouse;
    data['isFerme'] = this.isFerme;
    data['hasCoin'] = this.hasCoin;
    data['hasBalance'] = this.hasBalance;
    data['gys_id'] = this.gysId;
    data['spec_icon'] = this.specialIcon;
    data['country_icon'] = this.countryIcon;
    data['sale_price'] = this.salePrice;
    return data;
  }

}
