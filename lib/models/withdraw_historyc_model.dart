class WithdrawHistoryCModel {
  String code;
  String msg;
  Data data;

  WithdrawHistoryCModel({this.code, this.msg, this.data});

  WithdrawHistoryCModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<History> list;
  int total;

  Data({this.list, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list.add(new History.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class History {
  int id;
  num amount;
  int state;
  String createdAt;
  String content;
  String proof;
  num tax;
  String logisticsName;
  String waybillCode;
  String applyUserName;
  String applyTime;
  String processUserName;
  String processTime;
  String bank;
  String code;
  String comapnyName;
  String mobile;
  String nickname;
  num balance;
  num taxAmount;
  num withdrawal;
  num actualAmount;

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    state = json['state'];
    createdAt = json['created_at'];
    content = json['content'];
    proof = json['proof'];
    tax = json['tax'];
    logisticsName = json['logistics_name'];
    waybillCode = json['waybill_code'];
    applyUserName = json['apply_user_name'];
    applyTime = json['apply_time'];
    processUserName = json['process_user_name'];
    processTime = json['process_time'];
    bank = json['bank'];
    code = json['code'];
    comapnyName = json['comapny_name'];
    mobile = json['mobile'];
    nickname = json['nickname'];
    balance = json['balance'];
    taxAmount = json['tax_amount'];
    withdrawal = json['withdrawal'];
    actualAmount = json['actual_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['state'] = this.state;
    data['created_at'] = this.createdAt;
    data['content'] = this.content;
    data['proof'] = this.proof;
    data['tax'] = this.tax;
    data['logistics_name'] = this.logisticsName;
    data['waybill_code'] = this.waybillCode;
    data['apply_user_name'] = this.applyUserName;
    data['apply_time'] = this.applyTime;
    data['process_user_name'] = this.processUserName;
    data['process_time'] = this.processTime;
    data['bank'] = this.bank;
    data['code'] = this.code;
    data['comapny_name'] = this.comapnyName;
    data['mobile'] = this.mobile;
    data['nickname'] = this.nickname;

    data['balance'] = balance;
    data['tax_amount'] = taxAmount;
    data['withdrawal'] = withdrawal;
    data['actual_amount'] = actualAmount;

    return data;
  }

  History({
    this.id,
    this.amount,
    this.state,
    this.createdAt,
    this.content,
    this.proof,
    this.tax,
    this.logisticsName,
    this.waybillCode,
    this.applyUserName,
    this.applyTime,
    this.processUserName,
    this.processTime,
    this.bank,
    this.code,
    this.comapnyName,
    this.mobile,
    this.nickname,
    this.balance,
    this.taxAmount,
    this.withdrawal,
    this.actualAmount,
  });
}
