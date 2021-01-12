class UserAccumulateModel {
  String code;
  String msg;
  Data data;

  UserAccumulateModel({this.code, this.msg, this.data});

  UserAccumulateModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  UserAccumulateModel.zero() {
    code = '';
    msg = '';
    data = Data.zero();
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
  double purchaseAmount;
  double guideAmount;
  double teamAmount;
  double recommendAmount;
  double rewardAmount;

  Data(
      {this.purchaseAmount,
      this.guideAmount,
      this.teamAmount,
      this.recommendAmount,
      this.rewardAmount});
  Data.zero() {
    this.purchaseAmount = 0;
    this.guideAmount = 0;
    this.teamAmount = 0;
    this.recommendAmount = 0;
    this.rewardAmount = 0;
  }

  Data.fromJson(Map<String, dynamic> json) {
    purchaseAmount = json['purchaseAmount'] + .0;
    guideAmount = json['guideAmount'] + .0;
    teamAmount = json['teamAmount'] + .0;
    recommendAmount = json['recommendAmount'] + .0;
    rewardAmount = json['rewardAmount'] + .0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['purchaseAmount'] = this.purchaseAmount;
    data['guideAmount'] = this.guideAmount;
    data['teamAmount'] = this.teamAmount;
    data['recommendAmount'] = this.recommendAmount;
    data['rewardAmount'] = this.rewardAmount;
    return data;
  }
}
