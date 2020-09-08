class ShopSelfIncomeModel {
  String code;
  String msg;
  Data data;

  ShopSelfIncomeModel({this.code, this.msg, this.data});

  ShopSelfIncomeModel.fromJson(Map<String, dynamic> json) {
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
  List<Incomes> incomes;
  num totalAmount;
  num totalIncome;
  num totalOrderCount;

  Data(
      {this.incomes, this.totalAmount, this.totalIncome, this.totalOrderCount});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['incomes'] != null) {
      incomes = new List<Incomes>();
      json['incomes'].forEach((v) {
        incomes.add(new Incomes.fromJson(v));
      });
    }
    totalAmount = json['totalAmount'];
    totalIncome = json['totalIncome'];
    totalOrderCount = json['totalOrderCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.incomes != null) {
      data['incomes'] = this.incomes.map((v) => v.toJson()).toList();
    }
    data['totalAmount'] = this.totalAmount;
    data['totalIncome'] = this.totalIncome;
    data['totalOrderCount'] = this.totalOrderCount;
    return data;
  }
}

class Incomes {
  String date;
  num orderCount;
  num amount;
  num income;

  Incomes({this.date, this.orderCount, this.amount, this.income});

  Incomes.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    orderCount = json['OrderCount'];
    amount = json['Amount'];
    income = json['Income'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['OrderCount'] = this.orderCount;
    data['Amount'] = this.amount;
    data['Income'] = this.income;
    return data;
  }
}
