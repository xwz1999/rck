class GoodsReportModel {
  BasicParameters basicParameters;
  List<SaleNum> saleNum;
  List<TopTen> topTen;
  List<AgePort> agePort;
  Gender gender;

  GoodsReportModel(
      {this.basicParameters,
      this.saleNum,
      this.topTen,
      this.agePort,
      this.gender});

  GoodsReportModel.fromJson(Map<String, dynamic> json) {
    basicParameters = json['basic_parameters'] != null
        ? new BasicParameters.fromJson(json['basic_parameters'])
        : null;
    if (json['sale_num'] != null) {
      saleNum = new List<SaleNum>();
      json['sale_num'].forEach((v) {
        saleNum.add(new SaleNum.fromJson(v));
      });
    }
    if (json['top_ten'] != null) {
      topTen = new List<TopTen>();
      json['top_ten'].forEach((v) {
        topTen.add(new TopTen.fromJson(v));
      });
    }
    if (json['age_port'] != null) {
      agePort = new List<AgePort>();
      json['age_port'].forEach((v) {
        agePort.add(new AgePort.fromJson(v));
      });
    }
    gender =
        json['gender'] != null ? new Gender.fromJson(json['gender']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.basicParameters != null) {
      data['basic_parameters'] = this.basicParameters.toJson();
    }
    if (this.saleNum != null) {
      data['sale_num'] = this.saleNum.map((v) => v.toJson()).toList();
    }
    if (this.topTen != null) {
      data['top_ten'] = this.topTen.map((v) => v.toJson()).toList();
    }
    if (this.agePort != null) {
      data['age_port'] = this.agePort.map((v) => v.toJson()).toList();
    }
    if (this.gender != null) {
      data['gender'] = this.gender.toJson();
    }
    return data;
  }
}

class BasicParameters {
  String brandName;
  String goodsName;
  String mainMaterial;
  String mainPhoto;
  num weight;

  BasicParameters(
      {this.brandName,
      this.goodsName,
      this.mainMaterial,
      this.mainPhoto,
      this.weight});

  BasicParameters.fromJson(Map<String, dynamic> json) {
    brandName = json['brand_name'];
    goodsName = json['goods_name'];
    mainMaterial = json['main_material'];
    mainPhoto = json['main_photo'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand_name'] = this.brandName;
    data['goods_name'] = this.goodsName;
    data['main_material'] = this.mainMaterial;
    data['main_photo'] = this.mainPhoto;
    data['weight'] = this.weight;
    return data;
  }
}

class SaleNum {
  int saleNum;
  int sortId;

  SaleNum({this.saleNum, this.sortId});

  SaleNum.fromJson(Map<String, dynamic> json) {
    saleNum = json['sale_num'];
    sortId = json['sort_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sale_num'] = this.saleNum;
    data['sort_id'] = this.sortId;
    return data;
  }
}

class TopTen {
  String province;
  int sum;

  TopTen({this.province, this.sum});

  TopTen.fromJson(Map<String, dynamic> json) {
    province = json['province'];
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['province'] = this.province;
    data['sum'] = this.sum;
    return data;
  }
}

class AgePort {
  int sortId;
  num numi;

  AgePort({this.sortId, this.numi});

  AgePort.fromJson(Map<String, dynamic> json) {
    sortId = json['sort_id'];
    numi = json['num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sort_id'] = this.sortId;
    data['num'] = this.numi;
    return data;
  }
}

class Gender {
  int male;
  int female;

  Gender({this.male, this.female});

  Gender.fromJson(Map<String, dynamic> json) {
    male = json['male'];
    female = json['female'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['male'] = this.male;
    data['female'] = this.female;
    return data;
  }
}
