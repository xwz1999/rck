class UserIncomeDataModel {
  num? eCount1;
  num? eAmount1;
  num? count1;
  num? amount1;
  num? eCount2;
  num? eAmount2;
  num? eCount3;
  num? eAmount3;
  num? eCount4;
  num? eAmount4;

  num? count2;
  num? amount2;
  num? count3;
  num? amount3;
  num? count4;
  num? amount4;

  num? eCount5;
  num? eAmount5;
  num? count5;
  num? amount5;

  num? eCount6;
  num? eAmount6;
  num? count6;
  num? amount6;

  num? eCount7;
  num? eAmount7;
  num? count7;
  num? amount7;

  num? count10;
  num? amount10;


  num? total;
  num? eTotal;


  num? yearSale;
  num? monthSale;
  num? yearCount;
  num? monthCount;
  num? totalSale;



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
        this.eTotal,
        this.eAmount5,
        this.amount5,
        this.count5,
        this.eCount5,
        this.eAmount6,
        this.amount6,
        this.count6,
        this.eCount6,
        this.eAmount7,
        this.amount7,
        this.count7,
        this.eCount7,
        this.amount10,
        this.count10,
        this.monthCount,
        this.monthSale,
        this.totalSale,
        this.yearCount,
        this.yearSale
      });

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

    eCount5 = json['ECount5'];
    eAmount5 = json['EAmount5'];
    count5 = json['Count5'];
    amount5 = json['Amount5'];

    eCount6 = json['ECount6'];
    eAmount6 = json['EAmount6'];
    count6 = json['Count6'];
    amount6 = json['Amount6'];

    eCount7 = json['ECount7'];
    eAmount7 = json['EAmount7'];
    count7 = json['Count7'];
    amount7 = json['Amount7'];

    count10 = json['Count10'];
    amount10 = json['Amount10'];

    monthCount = json['MonthCount'];

    monthSale = json['MonthSale'];
    totalSale = json['TotalSale'];
    yearCount = json['YearCount'];
    yearSale = json['YearSale'];

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

    data['ECount5'] = this.eCount5;
    data['EAmount5'] = this.eAmount5;
    data['Count5'] = this.count5;
    data['Amount5'] = this.amount5;

    data['ECount6'] = this.eCount6;
    data['EAmount6'] = this.eAmount6;
    data['Count6'] = this.count6;
    data['Amount6'] = this.amount6;

    data['ECount7'] = this.eCount7;
    data['EAmount7'] = this.eAmount7;
    data['Count7'] = this.count7;
    data['Amount7'] = this.amount7;

    data['Count10'] = this.count10;
    data['Amount10'] = this.amount10;


    data['MonthCount'] = this.monthCount;

    data['MonthSale'] = this.monthSale;
    data['TotalSale'] = this.totalSale;
    data['YearCount'] = this.yearCount;
    data['YearSale'] = this.yearSale;

    return data;
  }
}