class UserBenefitModel {
  String code;
  String msg;
  Data data;

  UserBenefitModel({this.code, this.msg, this.data});
  UserBenefitModel.zero() {
    this.code = '';
    this.msg = '';
    this.data = Data.zero();
  }

  UserBenefitModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  double monthExpect;
  double dayExpect;
  double lastMonthExpect;
  double lastMonthIncome;

  Data(
      {this.monthExpect,
      this.dayExpect,
      this.lastMonthExpect,
      this.lastMonthIncome});

  Data.zero(
      {this.monthExpect = 0,
      this.dayExpect = 0,
      this.lastMonthExpect = 0,
      this.lastMonthIncome = 0});

  Data.fromJson(Map<String, dynamic> json) {
    monthExpect = json['monthExpect'] + .0;
    dayExpect = json['dayExpect'] + .0;
    lastMonthExpect = json['lastMonthExpect'] + .0;
    lastMonthIncome = json['lastMonthIncome'] + .0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthExpect'] = this.monthExpect;
    data['dayExpect'] = this.dayExpect;
    data['lastMonthExpect'] = this.lastMonthExpect;
    data['lastMonthIncome'] = this.lastMonthIncome;
    return data;
  }
}
