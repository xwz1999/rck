class OilPriceModel {
  String? city;
  String? s92h;
  String? s95h;
  String? s98h;
  String? s0h;

  OilPriceModel({this.city, this.s92h, this.s95h, this.s98h, this.s0h});

  OilPriceModel.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    s92h = json['92h'];
    s95h = json['95h'];
    s98h = json['98h'];
    s0h = json['0h'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['92h'] = this.s92h;
    data['95h'] = this.s95h;
    data['98h'] = this.s98h;
    data['0h'] = this.s0h;
    return data;
  }
}