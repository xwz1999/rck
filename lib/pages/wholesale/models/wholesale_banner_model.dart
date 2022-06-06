class WholesaleBannerModel {
  int? id;
  int? goodsId;
  String? photo;
  int? orderSort;
  String? start;
  String? end;
  bool? valid;

  WholesaleBannerModel(
      {this.id,
        this.goodsId,
        this.photo,
        this.orderSort,
        this.start,
        this.end,
        this.valid});

  WholesaleBannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodsId = json['goods_id'];
    photo = json['photo'];
    orderSort = json['order_sort'];
    start = json['start'];
    end = json['end'];
    valid = json['valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['goods_id'] = this.goodsId;
    data['photo'] = this.photo;
    data['order_sort'] = this.orderSort;
    data['start'] = this.start;
    data['end'] = this.end;
    data['valid'] = this.valid;
    return data;
  }
}