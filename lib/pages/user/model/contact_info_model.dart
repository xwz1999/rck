class ContactInfoModel {
  String? address;
  String? email;
  String? mobile;
  String? name;

  ContactInfoModel({this.address, this.email, this.mobile, this.name});

  ContactInfoModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    email = json['email'];
    mobile = json['mobile'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['name'] = this.name;
    return data;
  }
}