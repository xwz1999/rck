class LotteryRedeemDetailModel {
  String orderId;
  String lotteryName;
  String number;
  int status;
  String money;
  String ticketMoney;
  int isBombBonus;
  List<String> code;
  int betType;
  int num;
  String betTime;
  String stopTime;
  UserProfile userProfile;

  LotteryRedeemDetailModel(
      {this.orderId,
      this.lotteryName,
      this.number,
      this.status,
      this.money,
      this.ticketMoney,
      this.isBombBonus,
      this.code,
      this.betType,
      this.num,
      this.betTime,
      this.stopTime,
      this.userProfile});

  LotteryRedeemDetailModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    lotteryName = json['lotteryName'];
    number = json['number'];
    status = json['status'];
    money = json['money'];
    ticketMoney = json['ticketMoney'];
    isBombBonus = json['isBombBonus'];
    code = json['code'].cast<String>();
    betType = json['betType'];
    num = json['num'];
    betTime = json['betTime'];
    stopTime = json['stopTime'];
    userProfile = json['userProfile'] != null
        ? new UserProfile.fromJson(json['userProfile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['lotteryName'] = this.lotteryName;
    data['number'] = this.number;
    data['status'] = this.status;
    data['money'] = this.money;
    data['ticketMoney'] = this.ticketMoney;
    data['isBombBonus'] = this.isBombBonus;
    data['code'] = this.code;
    data['betType'] = this.betType;
    data['num'] = this.num;
    data['betTime'] = this.betTime;
    data['stopTime'] = this.stopTime;
    if (this.userProfile != null) {
      data['userProfile'] = this.userProfile.toJson();
    }
    return data;
  }
}

class UserProfile {
  String name;
  String idCard;
  String mobile;

  UserProfile({this.name, this.idCard, this.mobile});

  UserProfile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    idCard = json['idCard'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['idCard'] = this.idCard;
    data['mobile'] = this.mobile;
    return data;
  }
}
