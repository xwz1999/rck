
class InvoiceDetailModel {
  int id;
  int uid;
  String fpqqlsh;
  int status;
  String buyername;
  String taxnum;
  String address;
  String telephone;
  String account;
  String content;
  String message;
  String ctime;
  num pice;
  String fail;
  int type;

  InvoiceDetailModel(
      {this.id,
      this.uid,
      this.fpqqlsh,
      this.status,
      this.buyername,
      this.taxnum,
      this.address,
      this.telephone,
      this.account,
      this.content,
      this.message,
      this.ctime,
      this.pice,
      this.fail,
      this.type});

  InvoiceDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    fpqqlsh = json['fpqqlsh'];
    status = json['status'];
    buyername = json['buyername'];
    taxnum = json['taxnum'];
    address = json['address'];
    telephone = json['telephone'];
    account = json['account'];
    content = json['content'];
    message = json['message'];
    ctime = json['ctime'];
    pice = json['pice'] as num;
    fail = json['fail'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['fpqqlsh'] = this.fpqqlsh;
    data['status'] = this.status;
    data['buyername'] = this.buyername;
    data['taxnum'] = this.taxnum;
    data['address'] = this.address;
    data['telephone'] = this.telephone;
    data['account'] = this.account;
    data['content'] = this.content;
    data['message'] = this.message;
    data['ctime'] = this.ctime;
    data['pice'] = this.pice;
    data['fail'] = this.fail;
    data['type'] = this.type;
    return data;
  }
}
