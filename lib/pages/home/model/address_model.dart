class AddressDefaultModel {
  int? id;
  String? name;
  String? mobile;
  String? province;
  String? city;
  String? district;
  String? address;
  int? isDefault;

  AddressDefaultModel(
      {this.id,
        this.name,
        this.mobile,
        this.province,
        this.city,
        this.district,
        this.address,
        this.isDefault});

  AddressDefaultModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    province = json['province'];
    city = json['city'];
    district = json['district'];
    address = json['address'];
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['province'] = this.province;
    data['city'] = this.city;
    data['district'] = this.district;
    data['address'] = this.address;
    data['isDefault'] = this.isDefault;
    return data;
  }
}