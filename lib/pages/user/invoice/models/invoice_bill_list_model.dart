class InvoiceBillListModel {
  Result result;
  String statusDec;
  int color;

  InvoiceBillListModel({this.result, this.statusDec, this.color});

  InvoiceBillListModel.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
    statusDec = json['statusDec'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['statusDec'] = this.statusDec;
    data['color'] = this.color;
    return data;
  }
}

class Result {
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

  Result(
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
      this.fail});

  Result.fromJson(Map<String, dynamic> json) {
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
    pice = json['pice'];
    fail = json['fail'];
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
    return data;
  }
}
