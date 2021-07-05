class UserIncomeModel1 {
  Data data;

  UserIncomeModel1({this.data});

  UserIncomeModel1.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  double amount;
  double all;
  Detail detail;

  Data({this.amount, this.all, this.detail});

  Data.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    all = json['all'];
    detail =
        json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['all'] = this.all;
    if (this.detail != null) {
      data['detail'] = this.detail.toJson();
    }
    return data;
  }
}

class Detail1 {
  int date;
  num sale;
  int count;
  num coin;
  Detail1 detail;

  Detail1({this.date, this.sale, this.count, this.coin, this.detail});

  Detail1.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    sale = json['sale'];
    count = json['count'];
    coin = json['coin'];
    detail = json['detail'] != null
        ? new Detail1.fromJson(json['detail'])
        : Detail.init();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['sale'] = this.sale;
    data['count'] = this.count;
    data['coin'] = this.coin;
    if (this.detail != null) {
      data['detail'] = this.detail.toJson();
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

  factory Detail.init() => Detail(date: 0, sale: 0, count: 0, coin: 0);
}
