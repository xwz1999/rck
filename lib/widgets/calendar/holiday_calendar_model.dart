class HolidayCalendarModel {
  int code;
  String msg;
  List<Newslist> newslist;

  HolidayCalendarModel({this.code, this.msg, this.newslist});

  HolidayCalendarModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['newslist'] != null) {
      newslist = new List<Newslist>();
      json['newslist'].forEach((v) {
        newslist.add(new Newslist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.newslist != null) {
      data['newslist'] = this.newslist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Newslist {
  String holiday;
  String name;
  String vacation;
  String remark;
  String wage;
  int start;
  int now;
  int end;
  String tip;
  String rest;

  Newslist(
      {this.holiday,
      this.name,
      this.vacation,
      this.remark,
      this.wage,
      this.start,
      this.now,
      this.end,
      this.tip,
      this.rest});

  Newslist.fromJson(Map<String, dynamic> json) {
    holiday = json['holiday'];
    name = json['name'];
    vacation = json['vacation'];
    remark = json['remark'];
    wage = json['wage'];
    start = json['start'];
    now = json['now'];
    end = json['end'];
    tip = json['tip'];
    rest = json['rest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['holiday'] = this.holiday;
    data['name'] = this.name;
    data['vacation'] = this.vacation;
    data['remark'] = this.remark;
    data['wage'] = this.wage;
    data['start'] = this.start;
    data['now'] = this.now;
    data['end'] = this.end;
    data['tip'] = this.tip;
    data['rest'] = this.rest;
    return data;
  }
}