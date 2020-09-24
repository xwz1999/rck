class LotteryListModel {
  int id;
  String name;
  String icon;
  String number;
  Now now;
  Now last;

  LotteryListModel(
      {this.id, this.name, this.icon, this.number, this.now, this.last});

  LotteryListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    number = json['number'];
    now = json['now'] != null ? new Now.fromJson(json['now']) : null;
    last = json['last'] != null ? new Now.fromJson(json['last']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['number'] = this.number;
    if (this.now != null) {
      data['now'] = this.now.toJson();
    }
    if (this.last != null) {
      data['last'] = this.last.toJson();
    }
    return data;
  }
}

class Now {
  int id;
  int lotteryId;
  String number;
  String startTime;
  String stopTime;
  String officialStartTime;
  String officialStopTime;
  int status;
  String bonusCode;

  Now(
      {this.id,
      this.lotteryId,
      this.number,
      this.startTime,
      this.stopTime,
      this.officialStartTime,
      this.officialStopTime,
      this.status,
      this.bonusCode});

  Now.fromJson(Map<String, dynamic> json) {
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
