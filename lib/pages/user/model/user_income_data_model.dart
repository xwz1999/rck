class UseerIncomeDataModel {
  Purchase purchase;
  Purchase guide;
  Purchase team;
  int hasTeam;

  bool get hasTeamValue => hasTeam == 1;

  UseerIncomeDataModel({this.purchase, this.guide, this.team, this.hasTeam});

  UseerIncomeDataModel.fromJson(Map<String, dynamic> json) {
    purchase = json['purchase'] != null
        ? new Purchase.fromJson(json['purchase'])
        : null;
    guide = json['guide'] != null ? new Purchase.fromJson(json['guide']) : null;
    team = json['team'] != null ? new Purchase.fromJson(json['team']) : null;
    hasTeam = json['hasTeam'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.purchase != null) {
      data['purchase'] = this.purchase.toJson();
    }
    if (this.guide != null) {
      data['guide'] = this.guide.toJson();
    }
    if (this.team != null) {
      data['team'] = this.team.toJson();
    }
    data['hasTeam'] = this.hasTeam;
    return data;
  }
}

class Purchase {
  num expectAmount;
  num expectCount;
  num amount;
  num count;

  String get expectAmountValue => (expectAmount ?? 0.0).toStringAsFixed(2);
  String get expectCountValue => (expectCount ?? 0).toString();
  String get amountValue => (amount ?? 0.0).toStringAsFixed(2);
  String get countValue => (count ?? 0).toString();

  Purchase({this.expectAmount, this.expectCount, this.amount, this.count});

  Purchase.fromJson(Map<String, dynamic> json) {
    expectAmount = json['expectAmount'];
    expectCount = json['expectCount'];
    amount = json['amount'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expectAmount'] = this.expectAmount;
    data['expectCount'] = this.expectCount;
    data['amount'] = this.amount;
    data['count'] = this.count;
    return data;
  }
}
