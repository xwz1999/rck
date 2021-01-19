class UserBenefitCommonModel {
  Purchase purchase;
  Purchase guide;
  Team team;
  Team recommend;
  Team reward;

  double get allAmount =>
      (this.guide?.amount ?? 0) +
      (this.purchase?.amount ?? 0) +
      (this.recommend?.amount ?? 0) +
      (this.reward?.amount ?? 0) +
      (this.team?.amount ?? 0) +
      .0;

  UserBenefitCommonModel(
      {this.purchase, this.guide, this.team, this.recommend, this.reward});

  UserBenefitCommonModel.fromJson(Map<String, dynamic> json) {
    purchase = json['purchase'] != null
        ? new Purchase.fromJson(json['purchase'])
        : null;
    guide = json['guide'] != null ? new Purchase.fromJson(json['guide']) : null;
    team = json['team'] != null ? new Team.fromJson(json['team']) : null;
    recommend =
        json['recommend'] != null ? new Team.fromJson(json['recommend']) : null;
    reward = json['reward'] != null ? new Team.fromJson(json['reward']) : null;
  }

  UserBenefitCommonModel.zero() {
    purchase = Purchase.zero();
    guide = Purchase.zero();
    team = Team.zero();
    recommend = Team.zero();
    reward = Team.zero();
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
    if (this.recommend != null) {
      data['recommend'] = this.recommend.toJson();
    }
    if (this.reward != null) {
      data['reward'] = this.reward.toJson();
    }
    return data;
  }
}

class Purchase {
  num count;
  num salesVolume;
  num amount;

  Purchase({this.count, this.salesVolume, this.amount});

  Purchase.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    salesVolume = json['salesVolume'];
    amount = json['amount'];
  }

  Purchase.zero() {
    count = 0;
    salesVolume = 0;
    amount = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['salesVolume'] = this.salesVolume;
    data['amount'] = this.amount;
    return data;
  }
}

class Team {
  num salesVolume;
  num amount;
  num ratio;

  Team({this.salesVolume, this.amount, this.ratio});

  Team.fromJson(Map<String, dynamic> json) {
    salesVolume = json['salesVolume'];
    amount = json['amount'];
    ratio = json['ratio'];
  }

  Team.zero() {
    ratio = 0;
    salesVolume = 0;
    amount = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesVolume'] = this.salesVolume;
    data['amount'] = this.amount;
    data['ratio'] = this.ratio;
    return data;
  }
}
