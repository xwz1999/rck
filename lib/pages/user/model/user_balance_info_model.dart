class UserBalanceInfoModel {
  String? code;
  String? msg;
  Data? data;

  UserBalanceInfoModel({this.code, this.msg, this.data});

  UserBalanceInfoModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
  UserBalanceInfoModel.zero() {
    code = '';
    msg = '';
    data = Data.zero();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  num? balance;
  num? totalWithdraw;

  Data({this.balance, this.totalWithdraw});

  Data.fromJson(Map<String, dynamic> json) {
    balance = json['balance'] ?? 0;
    totalWithdraw = json['totalWithdraw'] ?? 0;
  }

  Data.zero() {
    balance = 0;
    totalWithdraw = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['totalWithdraw'] = this.totalWithdraw;
    return data;
  }
}
