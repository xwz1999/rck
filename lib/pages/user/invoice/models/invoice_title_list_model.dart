class InvoiceTitleListModel {
  int id;
  int uid;
  int type;
  String name;
  String taxnum;
  String address;
  String phone;
  String bank;
  int defaultValue;

  InvoiceTitleListModel({
    this.id,
    this.uid,
    this.type,
    this.name,
    this.taxnum,
    this.address,
    this.phone,
    this.bank,
    this.defaultValue,
  });

  InvoiceTitleListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    type = json['type'];
    name = json['name'];
    taxnum = json['taxnum'];
    address = json['address'];
    phone = json['phone'];
    bank = json['bank'];
    defaultValue = json['default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['type'] = this.type;
    data['name'] = this.name;
    data['taxnum'] = this.taxnum;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['bank'] = this.bank;
    data['default'] = this.defaultValue;
    return data;
  }
}
