class WithdrawDetailModel {
  String code;
  String msg;
  Data data;

  WithdrawDetailModel({this.code, this.msg, this.data});

  WithdrawDetailModel.fromJson(Map<String, dynamic> json) {
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
  num id;
  num userId;
  String userName;
  num type;
  num amount;
  String alipay;
  String bankAccount;
  String bankName;
  num status;
  String auditTime;
  String createdAt;
  String doneTime;
  num taxFee;
  num actualAmount;

  Data(
      {this.id,
      this.userId,
      this.userName,
      this.type,
      this.amount,
      this.alipay,
      this.bankAccount,
      this.bankName,
      this.status,
      this.auditTime,
      this.createdAt,
      this.doneTime,this.taxFee,this.actualAmount });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    type = json['type'];
    amount = json['amount'];
    alipay = json['alipay'];
    bankAccount = json['bank_account'];
    bankName = json['bank_name'];
    status = json['status'];
    auditTime = json['auditTime'];
    createdAt = json['created_at'];
    doneTime = json["doneTime"];
    taxFee = json['tax_fee'];
    actualAmount = json['actual_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['alipay'] = this.alipay;
    data['bank_account'] = this.bankAccount;
    data['bank_name'] = this.bankName;
    data['status'] = this.status;
    data['auditTime'] = this.auditTime;
    data['created_at'] = this.createdAt;
    data['doneTime'] = this.doneTime;

    data['tax_fee'] = this.taxFee;
    data['actual_amount'] = this.actualAmount;
    return data;
  }
}
