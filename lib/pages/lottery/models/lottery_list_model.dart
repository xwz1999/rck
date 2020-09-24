class LotteryListModel {
  String code;
  List<Data> data;
  String msg;

  LotteryListModel({this.code, this.data, this.msg});

  LotteryListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class Data {
  String icon;
  int id;
  Last last;
  String name;
  Last now;
  String number;

  Data({this.icon, this.id, this.last, this.name, this.now, this.number});

  Data.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    id = json['id'];
    last = json['last'] != null ? new Last.fromJson(json['last']) : null;
    name = json['name'];
    now = json['now'] != null ? new Last.fromJson(json['now']) : null;
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['id'] = this.id;
    if (this.last != null) {
      data['last'] = this.last.toJson();
    }
    data['name'] = this.name;
    if (this.now != null) {
      data['now'] = this.now.toJson();
    }
    data['number'] = this.number;
    return data;
  }
}

class Last {
  String bonusCode;
  int id;
  String lotteryId;
  String number;
  String officialStartTime;
  String officialStopTime;
  String startTime;
  int status;
  String stopTime;

  Last(
      {this.bonusCode,
      this.id,
      this.lotteryId,
      this.number,
      this.officialStartTime,
      this.officialStopTime,
      this.startTime,
      this.status,
      this.stopTime});

  Last.fromJson(Map<String, dynamic> json) {
    bonusCode = json['bonus_code'];
    id = json['id'];
    lotteryId = json['lottery_id'];
    number = json['number'];
    officialStartTime = json['official_start_time'];
    officialStopTime = json['official_stop_time'];
    startTime = json['start_time'];
    status = json['status'];
    stopTime = json['stop_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bonus_code'] = this.bonusCode;
    data['id'] = this.id;
    data['lottery_id'] = this.lotteryId;
    data['number'] = this.number;
    data['official_start_time'] = this.officialStartTime;
    data['official_stop_time'] = this.officialStopTime;
    data['start_time'] = this.startTime;
    data['status'] = this.status;
    data['stop_time'] = this.stopTime;
    return data;
  }
}
