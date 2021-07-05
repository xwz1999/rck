class UserIncomeModel {
  double amount;
  double all;
  List<Detail> detail;

  UserIncomeModel({this.amount, this.all, this.detail});

  UserIncomeModel.zero() {
    this.amount = 0;
    this.all = 0;
    this.detail = [];
  }

  UserIncomeModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    all = json['all'];
    if (json['detail'] != null) {
      detail = [];
      json['detail'].forEach((v) {
        detail.add(new Detail.fromJson(v));
      });
    } else {
      detail = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['all'] = this.all;
    if (this.detail != null) {
      data['detail'] = this.detail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail {
  num date;
  num sale;
  num count;
  num coin;

  List<Detail1> detail;

  Detail({this.date, this.sale, this.count, this.coin, this.detail});

  Detail.zero({this.date = 0, this.sale = 0, this.count = 0, this.coin = 0});

  Detail.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    sale = json['sale'];
    count = json['count'];
    coin = json['coin'];

    if (json['detail'] != null) {
      detail = [];
      json['detail'].forEach((v) {
        detail.add(new Detail1.fromJson(v));
      });
    } else {
      detail = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['sale'] = this.sale;
    data['count'] = this.count;
    data['coin'] = this.coin;
    if (this.detail != null) {
      data['detail'] = this.detail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail1 {
  num date;
  num sale;
  num count;
  num coin;

  Detail1({this.date, this.sale, this.count, this.coin});

  Detail1.zero({this.date = 0, this.sale = 0, this.count = 0, this.coin = 0});

  Detail1.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    sale = json['sale'];
    count = json['count'];
    coin = json['coin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['sale'] = this.sale;
    data['count'] = this.count;
    data['coin'] = this.coin;
    return data;
  }
}
