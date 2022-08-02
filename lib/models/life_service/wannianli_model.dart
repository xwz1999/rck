class WanNianLiModel {
  String? holiday;
  String? avoid;
  String? animalsYear;
  String? desc;
  String? weekday;
  String? suit;
  String? lunarYear;
  String? lunar;
  String? yearMonth;
  String? date;

  WanNianLiModel(
      {this.holiday,
        this.avoid,
        this.animalsYear,
        this.desc,
        this.weekday,
        this.suit,
        this.lunarYear,
        this.lunar,
        this.yearMonth,
        this.date});

  WanNianLiModel.fromJson(Map<String, dynamic> json) {
    holiday = json['holiday'];
    avoid = json['avoid'];
    animalsYear = json['animalsYear'];
    desc = json['desc'];
    weekday = json['weekday'];
    suit = json['suit'];
    lunarYear = json['lunarYear'];
    lunar = json['lunar'];
    yearMonth = json['year-month'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['holiday'] = this.holiday;
    data['avoid'] = this.avoid;
    data['animalsYear'] = this.animalsYear;
    data['desc'] = this.desc;
    data['weekday'] = this.weekday;
    data['suit'] = this.suit;
    data['lunarYear'] = this.lunarYear;
    data['lunar'] = this.lunar;
    data['year-month'] = this.yearMonth;
    data['date'] = this.date;
    return data;
  }
}