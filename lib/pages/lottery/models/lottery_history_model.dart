class LotteryHistoryModel {
  int id;
  int lotteryId;
  String number;
  String startTime;
  String stopTime;
  String officialStartTime;
  String officialStopTime;
  int status;
  String bonusCode;

  LotteryHistoryModel(
      {this.id,
      this.lotteryId,
      this.number,
      this.startTime,
      this.stopTime,
      this.officialStartTime,
      this.officialStopTime,
      this.status,
      this.bonusCode});

  LotteryHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lotteryId = json['lottery_id'];
    number = json['number'];
    startTime = json['start_time'];
    stopTime = json['stop_time'];
    officialStartTime = json['official_start_time'];
    officialStopTime = json['official_stop_time'];
    status = json['status'];
    bonusCode = json['bonus_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lottery_id'] = this.lotteryId;
    data['number'] = this.number;
    data['start_time'] = this.startTime;
    data['stop_time'] = this.stopTime;
    data['official_start_time'] = this.officialStartTime;
    data['official_stop_time'] = this.officialStopTime;
    data['status'] = this.status;
    data['bonus_code'] = this.bonusCode;
    return data;
  }
}
