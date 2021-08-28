class PerpetualCalendarModel {
  String reason;
  Result result;
  int errorCode;

  PerpetualCalendarModel({this.reason, this.result, this.errorCode});

  PerpetualCalendarModel.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
    errorCode = json['error_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reason'] = this.reason;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['error_code'] = this.errorCode;
    return data;
  }
}

class Result {
  String id;
  String yangli;
  String yinli;
  String wuxing;
  String chongsha;
  String baiji;
  String jishen;
  String yi;
  String xiongshen;
  String ji;

  Result(
      {this.id,
      this.yangli,
      this.yinli,
      this.wuxing,
      this.chongsha,
      this.baiji,
      this.jishen,
      this.yi,
      this.xiongshen,
      this.ji});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yangli = json['yangli'];
    yinli = json['yinli'];
    wuxing = json['wuxing'];
    chongsha = json['chongsha'];
    baiji = json['baiji'];
    jishen = json['jishen'];
    yi = json['yi'];
    xiongshen = json['xiongshen'];
    ji = json['ji'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yangli'] = this.yangli;
    data['yinli'] = this.yinli;
    data['wuxing'] = this.wuxing;
    data['chongsha'] = this.chongsha;
    data['baiji'] = this.baiji;
    data['jishen'] = this.jishen;
    data['yi'] = this.yi;
    data['xiongshen'] = this.xiongshen;
    data['ji'] = this.ji;
    return data;
  }
}