class LotteryRedeemHistoryModel {
  int id;
  int lotteryId;
  String lotteryName;
  String number;
  String betTime;
  int status;
  String orderId;

  LotteryRedeemHistoryModel(
      {this.id,
      this.lotteryId,
      this.lotteryName,
      this.number,
      this.betTime,
      this.status,
      this.orderId});

  LotteryRedeemHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lotteryId = json['lotteryId'];
    lotteryName = json['LotteryName'];
    number = json['number'];
    betTime = json['betTime'];
    status = json['status'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lotteryId'] = this.lotteryId;
    data['LotteryName'] = this.lotteryName;
    data['number'] = this.number;
    data['betTime'] = this.betTime;
    data['status'] = this.status;
    data['orderId'] = this.orderId;
    return data;
  }
}
