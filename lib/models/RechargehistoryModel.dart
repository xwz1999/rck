class RechargeHistoryModel {
  String? code;
  String? msg;
  Data? data;

  RechargeHistoryModel({this.code, this.msg, this.data});

  RechargeHistoryModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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
  List<RechargeHistory>? list;
  int? total;

  Data({this.list, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list!.add(new RechargeHistory.fromJson(v));
      });
    }
    total = json['total'];
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

class RechargeHistory {
  int? id;
  num? amount;
  int? kind;

  String? createdAt;

  String? attach;
  num? orderId;


  RechargeHistory(
      {this.id,
        this.amount,

        this.createdAt,
      this.kind,
        this.orderId,
      this.attach});

  RechargeHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    kind = json['kind'];
    createdAt = json['created_at'];
    attach = json['attach'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['attach'] = this.attach;
    data['created_at'] = this.createdAt;
    data['kind'] = this.kind;
    data['order_id'] = this.orderId;
    return data;
  }
}
