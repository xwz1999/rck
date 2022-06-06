class UserBenefitMonthDetailModel {
  int? id;
  int? userId;
  DateTime? day;
  num? purchaseAmount;
  num? purchaseCount;
  num? purchaseSalesVolume;
  num? guideAmount;
  int? guideCount;
  num? guideSalesVolume;

  UserBenefitMonthDetailModel(
      {this.id,
      this.userId,
      this.day,
      this.purchaseAmount,
      this.purchaseCount,
      this.purchaseSalesVolume,
      this.guideAmount,
      this.guideCount,
      this.guideSalesVolume});

  UserBenefitMonthDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    int dayRaw = json['day'];
    day = DateTime(dayRaw ~/ 10000, dayRaw % 10000 ~/ 100, dayRaw % 100);
    purchaseAmount = json['purchaseAmount'];
    purchaseCount = json['purchaseCount'];
    purchaseSalesVolume = json['purchaseSalesVolume'];
    guideAmount = json['guideAmount'];
    guideCount = json['guideCount'];
    guideSalesVolume = json['guideSalesVolume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['day'] = this.day;
    data['purchaseAmount'] = this.purchaseAmount;
    data['purchaseCount'] = this.purchaseCount;
    data['purchaseSalesVolume'] = this.purchaseSalesVolume;
    data['guideAmount'] = this.guideAmount;
    data['guideCount'] = this.guideCount;
    data['guideSalesVolume'] = this.guideSalesVolume;
    return data;
  }
}
