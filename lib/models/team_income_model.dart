class TeamIncomeModel {
  String? code;
  String? msg;
  Data? data;

  TeamIncomeModel({this.code, this.msg, this.data});

  TeamIncomeModel.fromJson(Map<String, dynamic> json) {
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
  num? roleLevel;
  bool? roleVisable;
  num? yearIncome;
  AccumulateIncome? accumulateIncome;
  List<Incomes>? incomes;

  Data(
      {this.roleLevel,
      this.roleVisable,
      this.yearIncome,
      this.accumulateIncome,
      this.incomes});

  Data.fromJson(Map<String, dynamic> json) {
    roleLevel = json['roleLevel'];
    roleVisable = json['roleVisable'];
    yearIncome = json['yearIncome'];
    accumulateIncome = json['accumulateIncome'] != null
        ? new AccumulateIncome.fromJson(json['accumulateIncome'])
        : null;
    if (json['incomes'] != null) {
      incomes = [];
      json['incomes'].forEach((v) {
        incomes!.add(new Incomes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roleLevel'] = this.roleLevel;
    data['roleVisable'] = this.roleVisable;
    data['yearIncome'] = this.yearIncome;
    if (this.accumulateIncome != null) {
      data['accumulateIncome'] = this.accumulateIncome!.toJson();
    }
    if (this.incomes != null) {
      data['incomes'] = this.incomes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AccumulateIncome {
  num? all;
  num? selfShopping;
  num? share;
  num? team;

  AccumulateIncome({this.all, this.selfShopping, this.share, this.team});

  AccumulateIncome.fromJson(Map<String, dynamic> json) {
    all = json['all'];
    selfShopping = json['selfShopping'];
    share = json['share'];
    team = json['team'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all'] = this.all;
    data['selfShopping'] = this.selfShopping;
    data['share'] = this.share;
    data['team'] = this.team;
    return data;
  }
}

class Incomes {
  String? month;
  num? myIncome;
  num? shareIncome;
  num? teamIncome;
  num? totalIncome;

  Incomes(
      {this.month,
      this.myIncome,
      this.shareIncome,
      this.teamIncome,
      this.totalIncome});

  Incomes.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    myIncome = json['myIncome'];
    shareIncome = json['shareIncome'];
    teamIncome = json['teamIncome'];
    totalIncome = json['totalIncome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['myIncome'] = this.myIncome;
    data['shareIncome'] = this.shareIncome;
    data['teamIncome'] = this.teamIncome;
    data['totalIncome'] = this.totalIncome;
    return data;
  }
}
