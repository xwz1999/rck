class UserMonthIncomeModel {
  int id;
  int userId;
  DateTime date;
  double amount;
  double purchaseAmount;
  double guideAmount;
  bool isSettlement;
  double teamAmount;
  double recommendAmount;
  double rewardAmount;

  UserMonthIncomeModel(
      {this.id,
      this.userId,
      this.date,
      this.amount,
      this.purchaseAmount,
      this.guideAmount,
      this.isSettlement,
      this.teamAmount,
      this.recommendAmount,
      this.rewardAmount});

  UserMonthIncomeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    date = DateTime(json['date'] ~/ 100, json['date'] % 100);
    amount = json['amount'] + .0;
    purchaseAmount = json['purchase_amount'] + .0;
    guideAmount = json['guide_amount'] + .0;
    isSettlement = json['isSettlement'] == 1;
    teamAmount = json['teamAmount'] + .0;
    recommendAmount = json['recommendAmount'] + .0;
    rewardAmount = json['rewardAmount'] + .0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['date'] = this.date;
    data['amount'] = this.amount;
    data['purchase_amount'] = this.purchaseAmount;
    data['guide_amount'] = this.guideAmount;
    data['isSettlement'] = this.isSettlement;
    data['teamAmount'] = this.teamAmount;
    data['recommendAmount'] = this.recommendAmount;
    data['rewardAmount'] = this.rewardAmount;
    return data;
  }
}
