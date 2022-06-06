class UserIncomeModel {
  num? amount;
  num? all;
  num? team;
  num? recommend;
  num? reward;
  List<Detail>? detail;

  UserIncomeModel(
      {this.amount,
      this.all,
      this.detail,
      this.team,
      this.recommend,
      this.reward});

  UserIncomeModel.zero() {
    this.amount = 0;
    this.all = 0;
    this.team = 0;
    this.recommend = 0;
    this.reward = 0;
    this.detail = [];
  }

  UserIncomeModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    all = json['all'];
    team = json['team'];
    recommend = json['recommend'];
    reward = json['reward'];

    if (json['detail'] != null) {
      detail = [];
      json['detail'].forEach((v) {
        detail!.add(new Detail.fromJson(v));
      });
    } else {
      detail = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['all'] = this.all;
    data['team'] = this.team;
    data['recommend'] = this.recommend;
    data['reward'] = this.reward;

    if (this.detail != null) {
      data['detail'] = this.detail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail {
  num? date;
  num? sale;
  num? count;
  num? coin;

  List<Detail1>? detail;

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
        detail!.add(new Detail1.fromJson(v));
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
      data['detail'] = this.detail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail1 {
  num? id;
  num? date;
  num? sale;
  num? count;
  num? coin;

  Detail1({this.id, this.date, this.sale, this.count, this.coin});

  Detail1.zero(
      {this.id = 0,
      this.date = 0,
      this.sale = 0,
      this.count = 0,
      this.coin = 0});

  Detail1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    sale = json['sale'];
    count = json['count'];
    coin = json['coin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['sale'] = this.sale;
    data['count'] = this.count;
    data['coin'] = this.coin;
    return data;
  }
}
