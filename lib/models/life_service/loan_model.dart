class LoanModel {
  Bx? bx;
  Bj? bj;

  LoanModel({this.bx, this.bj});

  LoanModel.fromJson(Map<String, dynamic> json) {
    bx = json['bx'] != null ? new Bx.fromJson(json['bx']) : null;
    bj = json['bj'] != null ? new Bj.fromJson(json['bj']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bx != null) {
      data['bx'] = this.bx!.toJson();
    }
    if (this.bj != null) {
      data['bj'] = this.bj!.toJson();
    }
    return data;
  }
}

class Bx {
  String? bxPerMonth;
  String? bxTotal;
  String? lxPerMonth;
  String? lxTotal;

  Bx({this.bxPerMonth, this.bxTotal, this.lxPerMonth, this.lxTotal});

  Bx.fromJson(Map<String, dynamic> json) {
    bxPerMonth = json['bxPerMonth'];
    bxTotal = json['bxTotal'];
    lxPerMonth = json['lxPerMonth'];
    lxTotal = json['lxTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bxPerMonth'] = this.bxPerMonth;
    data['bxTotal'] = this.bxTotal;
    data['lxPerMonth'] = this.lxPerMonth;
    data['lxTotal'] = this.lxTotal;
    return data;
  }
}

class Bj {
  String? bxTotal;
  String? lxTotal;
  List? perMonth;
  String? lxLastMonth;
  String? lxFirstMonth;
  String? capital;

  Bj(
      {this.bxTotal,
        this.lxTotal,
        this.perMonth,
        this.lxLastMonth,
        this.lxFirstMonth,
        this.capital});

  Bj.fromJson(Map<String, dynamic> json) {
    bxTotal = json['bxTotal'];
    lxTotal = json['lxTotal'];
    perMonth = json['perMonth'].cast<String>();
    lxLastMonth = json['lxLastMonth'];
    lxFirstMonth = json['lxFirstMonth'];
    capital = json['capital'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bxTotal'] = this.bxTotal;
    data['lxTotal'] = this.lxTotal;
    data['perMonth'] = this.perMonth;
    data['lxLastMonth'] = this.lxLastMonth;
    data['lxFirstMonth'] = this.lxFirstMonth;
    data['capital'] = this.capital;
    return data;
  }
}