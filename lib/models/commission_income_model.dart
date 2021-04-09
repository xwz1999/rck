class CommissionIncomeModel {
  String code;
  String msg;
  Data data;

  CommissionIncomeModel({this.code, this.msg, this.data});

  CommissionIncomeModel.fromJson(Map<String, dynamic> json) {
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
  List<IncomeList> list;
  Statistics statistics;

  Data({this.list, this.statistics});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<IncomeList>();
      json['list'].forEach((v) {
        list.add(new IncomeList.fromJson(v));
      });
    }
    statistics = json['statistics'] != null
        ? new Statistics.fromJson(json['statistics'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    if (this.statistics != null) {
      data['statistics'] = this.statistics.toJson();
    }
    return data;
  }
}

class IncomeList {
  int id;
  num amount;
  String title;
  String comment;
  String orderTime;

  IncomeList({this.id, this.amount, this.title, this.comment, this.orderTime});

  IncomeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    title = json['title'];
    comment = json['comment'];
    orderTime = json['orderTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['title'] = this.title;
    data['comment'] = this.comment;
    data['orderTime'] = this.orderTime;
    return data;
  }
}

class Statistics {
  num orderCount;
  num income;
  num salesAmount;

  Statistics({this.orderCount, this.income, this.salesAmount});

  Statistics.fromJson(Map<String, dynamic> json) {
    orderCount = json['orderCount'];
    income = json['income'];
    salesAmount = json['salesAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderCount'] = this.orderCount;
    data['income'] = this.income;
    data['salesAmount'] = this.salesAmount;
    return data;
  }
}
