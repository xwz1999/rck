class PifaBenefitModel {
  num all;
  num weiDaoZ;
  num yiDaoZ;
  List<Entry> entry;

  PifaBenefitModel({this.all, this.weiDaoZ, this.yiDaoZ, this.entry});

  PifaBenefitModel.fromJson(Map<String, dynamic> json) {
    all = json['all'];
    weiDaoZ = json['wei_dao_z'];
    yiDaoZ = json['yi_dao_z'];
    if (json['entry'] != null) {
      entry = new List<Entry>();
      json['entry'].forEach((v) {
        entry.add(new Entry.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all'] = this.all;
    data['wei_dao_z'] = this.weiDaoZ;
    data['yi_dao_z'] = this.yiDaoZ;
    if (this.entry != null) {
      data['entry'] = this.entry.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Entry {
  String name;
  num amount;
  num income;
  num notIncome;
  int count;
  int shopId;

  Entry(
      {this.name,
        this.amount,
        this.income,
        this.notIncome,
        this.count,
        this.shopId});

  Entry.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
    income = json['income'];
    notIncome = json['not_income'];
    count = json['count'];
    shopId = json['shop_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['income'] = this.income;
    data['not_income'] = this.notIncome;
    data['count'] = this.count;
    data['shop_id'] = this.shopId;
    return data;
  }
}