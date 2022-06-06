import 'package:recook/models/goods_detail_model.dart';

class WholesaleDetailModel {
  num? id;
  num? brandId;
  num? vendorId;
  String? goodsName;
  String? description;
  String? material;
  num? firstCategoryId;
  num? secondCategoryId;
  num? publishStatus;
  num? weight;
  num? isJoinTeamPerformance;
  num? bomaoStatus;
  num? bomaoId;
  num? thirdPartyId;
  num? thirdPartyType;
  num? hasAuth;
  num? isImport;
  num? storehouse;
  num? isFerme;
  num? country;
  num? salePublish;
  bool? isSale;
  num? inventory;
  num? salesVolume;
  num? saleInventory;
  Price? price;
  List<Recommends>? recommends;
  List<MainPhotos>? mainPhotos;
  List<Attributes>? attributes;
  List<WholesaleSku?>? sku;
  bool? isFavorite;
  num? shoppingTrolleyCount;
  bool? isAllow;
  Video? video;
  Brand? brand;
  Notice? notice;

  WholesaleDetailModel(
      {this.id,
        this.brandId,
        this.vendorId,
        this.goodsName,
        this.description,
        this.material,
        this.firstCategoryId,
        this.secondCategoryId,
        this.publishStatus,
        this.weight,
        this.isJoinTeamPerformance,
        this.bomaoStatus,
        this.bomaoId,
        this.thirdPartyId,
        this.thirdPartyType,
        this.hasAuth,
        this.isImport,
        this.storehouse,
        this.isFerme,
        this.country,
        this.salePublish,
        this.isSale,
        this.inventory,
        this.salesVolume,
        this.saleInventory,
        this.price,
        this.recommends,
        this.mainPhotos,
        this.attributes,
        this.sku,
        this.isFavorite,
        this.shoppingTrolleyCount,
        this.isAllow,
        this.video,
        this.brand,
        this.notice


      });
  getPriceString() {
    if (price == null) {
      return "";
    }
    double? minPrice = price!.min!.discountPrice as double?;
    double? maxPrice = price!.max!.discountPrice as double?;
    String returnPrice;
    if (minPrice == maxPrice) {
      returnPrice = maxPrice!.toStringAsFixed(2);
    } else {
      returnPrice =
      "${minPrice!.toStringAsFixed(2)}-${maxPrice!.toStringAsFixed(2)}";
    }
    return returnPrice;
  }

  WholesaleDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandId = json['brandId'];
    vendorId = json['vendorId'];
    goodsName = json['goodsName'];
    description = json['description'];
    material = json['material'];
    firstCategoryId = json['firstCategoryId'];
    secondCategoryId = json['secondCategoryId'];
    publishStatus = json['publish_status'];
    weight = json['weight'];
    isJoinTeamPerformance = json['isJoinTeamPerformance'];
    bomaoStatus = json['bomaoStatus'];
    bomaoId = json['bomaoId'];
    thirdPartyId = json['thirdPartyId'];
    thirdPartyType = json['thirdPartyType'];
    hasAuth = json['hasAuth'];
    isImport = json['isImport'];
    storehouse = json['storehouse'];
    isFerme = json['isFerme'];
    country = json['country'];
    salePublish = json['sale_publish'];
    isSale = json['is_sale'];
    inventory = json['inventory'];
    salesVolume = json['salesVolume'];
    saleInventory = json['sale_inventory'];
    price = json['price'] != null ? new Price.fromJson(json['price']) : null;
    if (json['recommends'] != null) {
      recommends = [];
      json['recommends'].forEach((v) {
        recommends!.add(new Recommends.fromJson(v));
      });
    } else
      recommends = [];

    if (json['mainPhotos'] != null) {
      mainPhotos = [];
      json['mainPhotos'].forEach((v) {
        mainPhotos!.add(new MainPhotos.fromJson(v));
      });
    }else
      mainPhotos = [];

    if (json['attributes'] != null) {
      attributes = [];
      json['attributes'].forEach((v) {
        attributes!.add(new Attributes.fromJson(v));
      });
    }else
      attributes = [];

    if (json['sku'] != null) {
      sku = [];
      json['sku'].forEach((v) {
        sku!.add(new WholesaleSku.fromJson(v));
      });
    }else
      sku = [];
    isFavorite = json['isFavorite'];
    shoppingTrolleyCount = json['shoppingTrolleyCount'];
    isAllow = json['isAllow'];
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
    notice =
    json['notice'] != null ? new Notice.fromJson(json['notice']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brandId'] = this.brandId;
    data['vendorId'] = this.vendorId;
    data['goodsName'] = this.goodsName;
    data['description'] = this.description;
    data['material'] = this.material;
    data['firstCategoryId'] = this.firstCategoryId;
    data['secondCategoryId'] = this.secondCategoryId;
    data['publish_status'] = this.publishStatus;
    data['weight'] = this.weight;
    data['isJoinTeamPerformance'] = this.isJoinTeamPerformance;
    data['bomaoStatus'] = this.bomaoStatus;
    data['bomaoId'] = this.bomaoId;
    data['thirdPartyId'] = this.thirdPartyId;
    data['thirdPartyType'] = this.thirdPartyType;
    data['hasAuth'] = this.hasAuth;
    data['isImport'] = this.isImport;
    data['storehouse'] = this.storehouse;
    data['isFerme'] = this.isFerme;
    data['country'] = this.country;
    data['sale_publish'] = this.salePublish;
    data['is_sale'] = this.isSale;
    data['inventory'] = this.inventory;
    data['salesVolume'] = this.salesVolume;
    data['sale_inventory'] = this.saleInventory;
    if (this.price != null) {
      data['price'] = this.price!.toJson();
    }
    if (this.recommends != null) {
      data['recommends'] = this.recommends!.map((v) => v.toJson()).toList();
    }
    if (this.mainPhotos != null) {
      data['mainPhotos'] = this.mainPhotos!.map((v) => v.toJson()).toList();
    }
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
    if (this.sku != null) {
      data['sku'] = this.sku!.map((v) => v!.toJson()).toList();
    }
    data['isFavorite'] = this.isFavorite;
    data['shoppingTrolleyCount'] = this.shoppingTrolleyCount;
    data['isAllow'] = this.isAllow;
    if (this.brand != null) {
      data['brand'] = this.brand!.toJson();
    }
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    if (this.notice != null) {
      data['notice'] = this.notice!.toJson();
    }
    return data;
  }
}

class Price {
  Min? min;
  Min? max;

  Price({this.min, this.max});

  Price.fromJson(Map<String, dynamic> json) {
    min = json['min'] != null ? new Min.fromJson(json['min']) : null;
    max = json['max'] != null ? new Min.fromJson(json['max']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.min != null) {
      data['min'] = this.min!.toJson();
    }
    if (this.max != null) {
      data['max'] = this.max!.toJson();
    }
    return data;
  }
}

class Min {
  num? originalPrice;
  num? discountPrice;
  num? commission;
  int? ferme;
  num? salePrice;
  int? min;
  int? limit;

  Min(
      {this.originalPrice,
        this.discountPrice,
        this.commission,
        this.ferme,
        this.salePrice,
        this.min,
        this.limit});

  Min.fromJson(Map<String, dynamic> json) {
    originalPrice = json['originalPrice'];
    discountPrice = json['discountPrice'];
    commission = json['commission'];
    ferme = json['ferme'];
    salePrice = json['sale_price'];
    min = json['min'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['originalPrice'] = this.originalPrice;
    data['discountPrice'] = this.discountPrice;
    data['commission'] = this.commission;
    data['ferme'] = this.ferme;
    data['sale_price'] = this.salePrice;
    data['min'] = this.min;
    data['limit'] = this.limit;
    return data;
  }
}

class Brand {
  int? id;
  String? name;
  String? desc;
  String? web;
  int? goodsCount;
  String? logoUrl;
  String? authUrl;
  String? showUrl;
  String? lastImg;
  String? firstImg;
  int? firstWidth;
  int? firstHeight;
  int? lastWidth;
  int? lastHeight;
  int? infoId;
  Null infoUrl;

  Brand(
      {this.id,
        this.name,
        this.desc,
        this.web,
        this.goodsCount,
        this.logoUrl,
        this.authUrl,
        this.showUrl,
        this.lastImg,
        this.firstImg,
        this.firstWidth,
        this.firstHeight,
        this.lastWidth,
        this.lastHeight,
        this.infoId,
        this.infoUrl});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    web = json['web'];
    goodsCount = json['goodsCount'];
    logoUrl = json['logoUrl'];
    authUrl = json['authUrl'];
    showUrl = json['showUrl'];
    lastImg = json['lastImg'];
    firstImg = json['firstImg'];
    firstWidth = json['firstWidth'];
    firstHeight = json['firstHeight'];
    lastWidth = json['lastWidth'];
    lastHeight = json['lastHeight'];
    infoId = json['InfoId'];
    infoUrl = json['InfoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['web'] = this.web;
    data['goodsCount'] = this.goodsCount;
    data['logoUrl'] = this.logoUrl;
    data['authUrl'] = this.authUrl;
    data['showUrl'] = this.showUrl;
    data['lastImg'] = this.lastImg;
    data['firstImg'] = this.firstImg;
    data['firstWidth'] = this.firstWidth;
    data['firstHeight'] = this.firstHeight;
    data['lastWidth'] = this.lastWidth;
    data['lastHeight'] = this.lastHeight;
    data['InfoId'] = this.infoId;
    data['InfoUrl'] = this.infoUrl;
    return data;
  }
}




class WholesaleSku {
  num? id;
  num? goodsId;
  String? name;
  String? combineId;
  String? picUrl;
  String? code;
  num? purchasePrice;
  num? originalPrice;
  num? discountPrice;
  num? commissionRate;
  num? commission;
  num? salePrice;
  num? controlPrice;
  num? salesVolume;
  num? inventory;
  num? salesVolumeInc;
  num? coupon;
  String? goodsNum;
  String? bmSkuId;
  String? bmShopId;
  String? thirdPartySkuId;
  num? thirdPartySkuType;
  num? saleInventory;
  num? limit;
  num? min;

  WholesaleSku(
      {this.id,
        this.goodsId,
        this.name,
        this.combineId,
        this.picUrl,
        this.code,
        this.purchasePrice,
        this.originalPrice,
        this.discountPrice,
        this.commissionRate,
        this.commission,
        this.salePrice,
        this.controlPrice,
        this.salesVolume,
        this.inventory,
        this.salesVolumeInc,
        this.coupon,
        this.goodsNum,
        this.bmSkuId,
        this.bmShopId,
        this.thirdPartySkuId,
        this.thirdPartySkuType,
        this.saleInventory,
        this.limit,
        this.min});

  WholesaleSku.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodsId = json['goodsId'];
    name = json['name'];
    combineId = json['combineId'];
    picUrl = json['picUrl'];
    code = json['code'];
    purchasePrice = json['purchasePrice'];
    originalPrice = json['originalPrice'];
    discountPrice = json['discountPrice'];
    commissionRate = json['commissionRate'];
    commission = json['commission'];
    salePrice = json['sale_price'];
    controlPrice = json['controlPrice'];
    salesVolume = json['salesVolume'];
    inventory = json['inventory'];
    salesVolumeInc = json['salesVolumeInc'];
    coupon = json['coupon'];
    goodsNum = json['goodsNum'];
    bmSkuId = json['bm_sku_id'];
    bmShopId = json['bm_shop_id'];
    thirdPartySkuId = json['thirdPartySkuId'];
    thirdPartySkuType = json['thirdPartySkuType'];
    saleInventory = json['sale_inventory'];
    limit = json['limit'];
    min = json['min'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['goodsId'] = this.goodsId;
    data['name'] = this.name;
    data['combineId'] = this.combineId;
    data['picUrl'] = this.picUrl;
    data['code'] = this.code;
    data['purchasePrice'] = this.purchasePrice;
    data['originalPrice'] = this.originalPrice;
    data['discountPrice'] = this.discountPrice;
    data['commissionRate'] = this.commissionRate;
    data['commission'] = this.commission;
    data['sale_price'] = this.salePrice;
    data['controlPrice'] = this.controlPrice;
    data['salesVolume'] = this.salesVolume;
    data['inventory'] = this.inventory;
    data['salesVolumeInc'] = this.salesVolumeInc;
    data['coupon'] = this.coupon;
    data['goodsNum'] = this.goodsNum;
    data['bm_sku_id'] = this.bmSkuId;
    data['bm_shop_id'] = this.bmShopId;
    data['thirdPartySkuId'] = this.thirdPartySkuId;
    data['thirdPartySkuType'] = this.thirdPartySkuType;
    data['sale_inventory'] = this.saleInventory;
    data['limit'] = this.limit;
    data['min'] = this.min;
    return data;
  }
}


class Video {
  int? id;

  String? url;

  int? duration;

  double? size;

  String? thumbnail;

  Video(this.id, this.url, this.duration, this.size, this.thumbnail);

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    duration = json['duration'];
    size = json['size'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['duration'] = this.duration;
    data['size'] = this.size;
    data['thumbnail'] = this.thumbnail;
    return data;
  }

}

class Notice {
  String? title;
  String? img;
  int? type;

  Notice({this.title, this.img, this.type});

  Notice.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    img = json['img'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['img'] = this.img;
    data['type'] = this.type;
    return data;
  }
}