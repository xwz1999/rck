class GoodsDetailImagesModel {
  String? code;
  String? msg;
  Data? data;

  GoodsDetailImagesModel({this.code, this.msg, this.data});

  GoodsDetailImagesModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Brand? brand;
  List<Images>? list;

  Data({this.brand, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.brand != null) {
      data['brand'] = this.brand!.toJson();
    }
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Brand {
  num? id;
  String? name;
  String? desc;
  String? web;
  num? goodsCount;
  String? logoUrl;
  String? authUrl;
  String? showUrl;
  String? lastImg;
  String? firstImg;
  num? infoId;
  String? infoUrl;

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
    data['InfoId'] = this.infoId;
    data['InfoUrl'] = this.infoUrl;
    return data;
  }
}

class Images {
  num? id;
  num? goodsId;
  String? url;
  String? name;
  num? orderNo;
  num? width;
  num? height;

  Images(
      {this.id,
      this.goodsId,
      this.url,
      this.name,
      this.orderNo,
      this.width,
      this.height});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodsId = json['goodsId'];
    url = json['url'];
    name = json['name'];
    orderNo = json['orderNo'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['goodsId'] = this.goodsId;
    data['url'] = this.url;
    data['name'] = this.name;
    data['orderNo'] = this.orderNo;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}
