class WholesaleCustomerModel {
  String? mobile;
  String? wechat;
  String? photo;

  WholesaleCustomerModel({this.mobile, this.wechat, this.photo});

  WholesaleCustomerModel.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    wechat = json['wechat'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['wechat'] = this.wechat;
    data['photo'] = this.photo;
    return data;
  }
}