class UserIncomeDataModel {
  num eCount1;
  num eAmount1;
  num eCount2;
  num eAmount2;
  num eCount3;
  num eAmount3;
  num eCount4;
  num eAmount4;
  num count1;
  num amount1;
  num count2;
  num amount2;
  num count3;
  num amount3;
  num count4;
  num amount4;
  num total;
  num eTotal;

  UserIncomeDataModel(
      {this.eCount1,
        this.eAmount1,
        this.eCount2,
        this.eAmount2,
        this.eCount3,
        this.eAmount3,
        this.eCount4,
        this.eAmount4,
        this.count1,
        this.amount1,
        this.count2,
        this.amount2,
        this.count3,
        this.amount3,
        this.count4,
        this.amount4,
        this.total,
        this.eTotal});

  UserIncomeDataModel.fromJson(Map<String, dynamic> json) {
    eCount1 = json['ECount1'];
    eAmount1 = json['EAmount1'];
    eCount2 = json['ECount2'];
    eAmount2 = json['EAmount2'];
    eCount3 = json['ECount3'];
    eAmount3 = json['EAmount3'];
    eCount4 = json['ECount4'];
    eAmount4 = json['EAmount4'];
    count1 = json['Count1'];
    amount1 = json['Amount1'];
    count2 = json['Count2'];
    amount2 = json['Amount2'];
    count3 = json['Count3'];
    amount3 = json['Amount3'];
    count4 = json['Count4'];
    amount4 = json['Amount4'];
    total = json['Total'];
    eTotal = json['ETotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ECount1'] = this.eCount1;
    data['EAmount1'] = this.eAmount1;
    data['ECount2'] = this.eCount2;
    data['EAmount2'] = this.eAmount2;
    data['ECount3'] = this.eCount3;
    data['EAmount3'] = this.eAmount3;
    data['ECount4'] = this.eCount4;
    data['EAmount4'] = this.eAmount4;
    data['Count1'] = this.count1;
    data['Amount1'] = this.amount1;
    data['Count2'] = this.count2;
    data['Amount2'] = this.amount2;
    data['Count3'] = this.count3;
    data['Amount3'] = this.amount3;
    data['Count4'] = this.count4;
    data['Amount4'] = this.amount4;
    data['Total'] = this.total;
    data['ETotal'] = this.eTotal;
    return data;
  }
}