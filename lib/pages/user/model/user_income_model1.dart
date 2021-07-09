class UserIncomeModel1 {
  num amount;
  num all;
  List<Detial> detial;

  UserIncomeModel1({this.amount, this.all, this.detial});

  UserIncomeModel1.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    all = json['all'];
    if (json['detial'] != null) {
      detial = new List<Detial>();
      json['detial'].forEach((v) {
        detial.add(new Detial.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['all'] = this.all;
    if (this.detial != null) {
      data['detial'] = this.detial.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detial {
  int date;
  num sale;
  int count;
  num coin;
  List<Detail> detail;

  Detial({this.date, this.sale, this.count, this.coin, this.detail});

  Detial.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    sale = json['sale'];
    count = json['count'];
    coin = json['coin'];
    if (json['detail'] != null) {
      detail = new List<Detail>();
      json['detail'].forEach((v) {
        detail.add(new Detail.fromJson(v));
      });
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

class Detail {
  int date;
  num sale;
  int count;
  num coin;

  Detail({this.date, this.sale, this.count, this.coin});

  Detail.fromJson(Map<String, dynamic> json) {
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
