class UserBalanceHistoryModel {
  String? code;
  String? msg;
  Data? data;

  UserBalanceHistoryModel({this.code, this.msg, this.data});

  UserBalanceHistoryModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
  UserBalanceHistoryModel.zero() {
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
  List<ListItem>? list;
  int? total;

  Data({this.list, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list!.add(new ListItem.fromJson(v));
      });
    }
    total = json['total'];
  }
  Data.zero() {
    list = [];
    total = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class ListItem {
  String? comment;
  String? createdAt;
  int? incomeType;
  double? amount;
  num? orderId;

  ListItem({this.comment, this.createdAt, this.incomeType, this.amount,this.orderId});

  ListItem.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    createdAt = json['createdAt'];
    incomeType = json['incomeType'];
    amount = json['amount'] + .0;
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['createdAt'] = this.createdAt;
    data['incomeType'] = this.incomeType;
    data['amount'] = this.amount;
    data['order_id'] = this.orderId;
    return data;
  }
}
