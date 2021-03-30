class BalancePageModel {
  String code;
  String msg;
  Data data;

  BalancePageModel({this.code, this.msg, this.data});

  BalancePageModel.fromJson(Map<String, dynamic> json) {
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
  num balance;
  List<DataList> list;

  Data({this.balance, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    if (json['list'] != null) {
      list = new List<DataList>();
      json['list'].forEach((v) {
        list.add(new DataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataList {
  num id;
  num amount;
  String title;
  String comment;
  String createdAt;

  DataList({this.id, this.amount, this.title, this.comment, this.createdAt});

  DataList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    title = json['title'];
    comment = json['comment'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['title'] = this.title;
    data['comment'] = this.comment;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
