import 'package:flustars/flustars.dart';
import 'package:jingyaoyun/pages/home/promotion_time_tool.dart';

import 'goods_hot_sell_list_model.dart';
import 'goods_simple_list_model.dart';

class PromotionGoodsListModel {
  String code;
  String msg;
  PromotionModel data;

  PromotionGoodsListModel({this.code, this.msg, this.data});

  PromotionGoodsListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data =
        json['data'] != null ? new PromotionModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class PromotionModel {
  List<PromotionGoodsModel> goodsList;
  List<PromotionActivityModel> activityList;

  PromotionModel({this.goodsList, this.activityList});

  PromotionModel.fromJson(Map<String, dynamic> json) {
    if (json['goodsList'] != null) {
      goodsList = new List<PromotionGoodsModel>();
      json['goodsList'].forEach((v) {
        goodsList.add(new PromotionGoodsModel.fromJson(v));
      });
    }
    if (json['activityList'] != null) {
      activityList = new List<PromotionActivityModel>();
      json['activityList'].forEach((v) {
        activityList.add(new PromotionActivityModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.goodsList != null) {
      data['goodsList'] = this.goodsList.map((v) => v.toJson()).toList();
    }
    if (this.activityList != null) {
      data['activityList'] = this.activityList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PromotionActivityModel {
  int id;
  int activitySortId;
  String activityUrl;
  String logoUrl;
  String topUrl;

  PromotionActivityModel(
      {this.id,
      this.activityUrl,
      this.logoUrl,
      this.topUrl,
      this.activitySortId});

  PromotionActivityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    activityUrl = json['activityUrl'];
    logoUrl = json['logoUrl'];
    topUrl = json['topUrl'];
    activitySortId = json['activity_sort_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['activityUrl'] = this.activityUrl;
    data['logoUrl'] = this.logoUrl;
    data['topUrl'] = this.topUrl;
    data['activity_sort_id'] = this.activitySortId;
    return data;
  }
}

class PromotionGoodsModel {
  int goodsId;
  String goodsName;
  String brandName;
  String brandImg;
  num brandId;
  String description;
  num price;
  num primePrice;
  String priceDesc;
  num commission;
  String commissionDesc;
  Picture picture;
  int inventory;
  String inventoryDesc;
  num totalInventory;
  String totalInventoryDesc;
  int totalSalesVolume;
  String salesVolumeDesc;
  String startTime;
  String endTime;
  num percentage;
  String percentageDesc;
  num coupon;
  num isImport;
  num storehouse;
  num isFerme;
  Living living;
  List<String> specialSale;
  num gysId;
  List<String> specialIcon;
  String countryIcon;
  SecKill secKill;

  PromotionGoodsModel(
      {this.goodsId,
      this.goodsName,
      this.brandName,
      this.brandImg,
      this.brandId,
      this.description,
      this.price,
      this.primePrice,
      this.priceDesc,
      this.commission,
      this.commissionDesc,
      this.picture,
      this.inventory,
      this.inventoryDesc,
      this.totalInventory,
      this.totalInventoryDesc,
      this.totalSalesVolume,
      this.salesVolumeDesc,
      this.startTime,
      this.endTime,
      this.percentage,
      this.percentageDesc,
      this.coupon,
      this.isImport,
      this.storehouse,
      this.isFerme,
      this.living,
      this.specialSale,
      this.gysId,
      this.specialIcon,
      this.countryIcon,
        this.secKill});

  PromotionGoodsModel.fromJson(Map<String, dynamic> json) {
    goodsId = json['goodsId'];
    goodsName = json['goodsName'];
    brandName = json['brandName'];
    brandImg = json['brandImg'];
    brandId = json['brandId'];
    description = json['description'];
    price = json['price'];
    primePrice = json['primePrice'];
    priceDesc = json['priceDesc'];
    commission = json['commission'];
    commissionDesc = json['commissionDesc'];
    picture =
        json['picture'] != null ? new Picture.fromJson(json['picture']) : null;
    inventory = json['inventory'];
    inventoryDesc = json['inventoryDesc'];
    totalInventory = json['totalInventory'];
    totalInventoryDesc = json['totalInventoryDesc'];
    totalSalesVolume = json['totalSalesVolume'];
    salesVolumeDesc = json['salesVolumeDesc'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    percentage = json['percentage'];
    percentageDesc = json['percentageDesc'];
    coupon = json['coupon'];
    isImport = json['isImport'];
    storehouse = json['storehouse'];
    isFerme = json['isFerme'];
    living =
        json['living'] != null ? new Living.fromJson(json['living']) : null;
    specialSale = json['special_sale'] != null
        ? json['special_sale'].cast<String>()
        : null;
    specialIcon =
        json['spec_icon'] != null ? json['spec_icon'].cast<String>() : null;
    gysId = json['gys_id'];
    countryIcon = json['country_icon'];
    secKill = json['sec_kill'] != null
        ? new SecKill.fromJson(json['sec_kill'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goodsId'] = this.goodsId;
    data['goodsName'] = this.goodsName;
    data['brandName'] = this.brandName;
    data['brandImg'] = this.brandImg;
    data['brandId'] = this.brandId;
    data['description'] = this.description;
    data['price'] = this.price;
    data['primePrice'] = this.primePrice;
    data['priceDesc'] = this.priceDesc;
    data['commission'] = this.commission;
    data['commissionDesc'] = this.commissionDesc;
    if (this.picture != null) {
      data['picture'] = this.picture.toJson();
    }
    data['inventory'] = this.inventory;
    data['inventoryDesc'] = this.inventoryDesc;
    data['totalInventory'] = this.totalInventory;
    data['totalInventoryDesc'] = this.totalInventoryDesc;
    data['totalSalesVolume'] = this.totalSalesVolume;
    data['salesVolumeDesc'] = this.salesVolumeDesc;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['percentage'] = this.percentage;
    data['percentageDesc'] = this.percentageDesc;
    data['coupon'] = this.coupon;
    data['isImport'] = this.isImport;
    data['storehouse'] = this.storehouse;
    data['isFerme'] = this.isFerme;
    if (this.living != null) {
      data['living'] = this.living.toJson();
    }
    data['special_sale'] = this.specialSale;
    data['gys_id'] = this.gysId;
    data['spec_icon'] = this.specialIcon;
    data['country_icon'] = this.countryIcon;
    if (this.secKill != null) {
      data['sec_kill'] = this.secKill.toJson();
    }
    return data;
  }

  getPromotionStatus() {
    return PromotionTimeTool.getPromotionStatusWithPGModel(this);
  }
}

class Picture {
  String url;
  int width;
  int height;

  Picture({this.url, this.width, this.height});

  Picture.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}
