class UserSelfIncomeModel {
  String? code;
  String? msg;
  Data? data;

  UserSelfIncomeModel({this.code, this.msg, this.data});

  UserSelfIncomeModel.fromJson(Map<String, dynamic> json) {
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
  MyShopping? myShopping;
  String? date;
  num? coinNum;
  List<IncomeList>? list;

  Data({this.myShopping, this.date, this.coinNum, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    myShopping = json['myShopping'] != null
        ? new MyShopping.fromJson(json['myShopping'])
        : null;
    date = json['date'];
    coinNum = json['coinNum'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list!.add(new IncomeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.myShopping != null) {
      data['myShopping'] = this.myShopping!.toJson();
    }
    data['date'] = this.date;
    data['coinNum'] = this.coinNum;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyShopping {
  num? orderNum;
  num? amount;
  num? historyIncome;

  MyShopping({this.orderNum, this.amount, this.historyIncome});

  MyShopping.fromJson(Map<String, dynamic> json) {
    orderNum = json['orderNum'];
    amount = json['amount'];
    historyIncome = json['historyIncome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderNum'] = this.orderNum;
    data['amount'] = this.amount;
    data['historyIncome'] = this.historyIncome;
    return data;
  }
}

class IncomeList {
  String? time;
  num? orderNum;
  num? amount;
  num? historyIncome;

  IncomeList({this.time, this.orderNum, this.amount, this.historyIncome});

  IncomeList.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    orderNum = json['orderNum'];
    amount = json['amount'];
    historyIncome = json['historyIncome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['orderNum'] = this.orderNum;
    data['amount'] = this.amount;
    data['historyIncome'] = this.historyIncome;
    return data;
  }
}
