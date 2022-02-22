import 'package:jingyaoyun/models/address_list_model.dart';

class WholesaleOrderPreviewModel {
  int previewId;
  Address addr;
  List<SkuList> skuList;
  num total;

  WholesaleOrderPreviewModel(
      {this.previewId, this.addr, this.skuList, this.total});

  WholesaleOrderPreviewModel.fromJson(Map<String, dynamic> json) {
    previewId = json['preview_id'];
    addr = json['Addr'] != null ? new Address.fromJson(json['Addr']) : null;
    if (json['sku_list'] != null) {
      skuList = [];
      json['sku_list'].forEach((v) {
        skuList.add(new SkuList.fromJson(v));
      });
    }else{
      skuList = [];
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['preview_id'] = this.previewId;
    if (this.addr != null) {
      data['Addr'] = this.addr.toJson();
    }
    if (this.skuList != null) {
      data['sku_list'] = this.skuList.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

// class Address {
//   int id;
//   String name;
//   String mobile;
//   String province;
//   String city;
//   String district;
//   String address;
//   int isDefault;
//
//   Address(
//       {this.id,
//         this.name,
//         this.mobile,
//         this.province,
//         this.city,
//         this.district,
//         this.address,
//         this.isDefault});
//
//   Address.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     mobile = json['mobile'];
//     province = json['province'];
//     city = json['city'];
//     district = json['district'];
//     address = json['address'];
//     isDefault = json['isDefault'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['mobile'] = this.mobile;
//     data['province'] = this.province;
//     data['city'] = this.city;
//     data['district'] = this.district;
//     data['address'] = this.address;
//     data['isDefault'] = this.isDefault;
//     return data;
//   }
// }

class SkuList {
  int id;
  int skuId;
  num discountPrice;
  num salePrice;
  int quantity;
  int limit;
  int min;
  String skuName;
  String goodsName;
  int salePublish;
  String picUrl;

  SkuList(
      {this.id,
        this.skuId,
        this.discountPrice,
        this.salePrice,
        this.quantity,
        this.limit,
        this.min,
        this.skuName,
        this.goodsName,
        this.salePublish,
        this.picUrl});

  SkuList.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}