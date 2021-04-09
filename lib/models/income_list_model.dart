class IncomeListModel {
  String code;
  String msg;
  List<Data> data;

  IncomeListModel({this.code, this.msg, this.data});

  IncomeListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  num amount;
  String title;
  String comment;
  num orderId;
  String orderTime;

  Data(
      {this.id,
      this.amount,
      this.title,
      this.comment,
      this.orderId,
      this.orderTime});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    title = json['title'];
    comment = json['comment'];
    orderId = json['orderId'];
    orderTime = json['orderTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['title'] = this.title;
    data['comment'] = this.comment;
    data['orderId'] = this.orderId;
    data['orderTime'] = this.orderTime;
    return data;
  }
}
