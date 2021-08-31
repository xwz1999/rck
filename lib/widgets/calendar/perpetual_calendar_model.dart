class PerpetualCalendarModel {
  int code;
  String msg;
  List<Newslist> newslist;

  PerpetualCalendarModel({this.code, this.msg, this.newslist});

  PerpetualCalendarModel.fromJson(Map<String, dynamic> json) {
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
  String gregoriandate;
  String lunardate;
  String lunarFestival;
  String festival;
  String fitness;
  String taboo;
  String shenwei;
  String taishen;
  String chongsha;
  String suisha;
  String wuxingjiazi;
  String wuxingnayear;
  String wuxingnamonth;
  String xingsu;
  String pengzu;
  String jianshen;
  String tiangandizhiyear;
  String tiangandizhimonth;
  String tiangandizhiday;
  String lmonthname;
  String shengxiao;
  String lubarmonth;
  String lunarday;
  String jieqi;

  Newslist(
      {this.gregoriandate,
      this.lunardate,
      this.lunarFestival,
      this.festival,
      this.fitness,
      this.taboo,
      this.shenwei,
      this.taishen,
      this.chongsha,
      this.suisha,
      this.wuxingjiazi,
      this.wuxingnayear,
      this.wuxingnamonth,
      this.xingsu,
      this.pengzu,
      this.jianshen,
      this.tiangandizhiyear,
      this.tiangandizhimonth,
      this.tiangandizhiday,
      this.lmonthname,
      this.shengxiao,
      this.lubarmonth,
      this.lunarday,
      this.jieqi});

  Newslist.fromJson(Map<String, dynamic> json) {
    gregoriandate = json['gregoriandate'];
    lunardate = json['lunardate'];
    lunarFestival = json['lunar_festival'];
    festival = json['festival'];
    fitness = json['fitness'];
    taboo = json['taboo'];
    shenwei = json['shenwei'];
    taishen = json['taishen'];
    chongsha = json['chongsha'];
    suisha = json['suisha'];
    wuxingjiazi = json['wuxingjiazi'];
    wuxingnayear = json['wuxingnayear'];
    wuxingnamonth = json['wuxingnamonth'];
    xingsu = json['xingsu'];
    pengzu = json['pengzu'];
    jianshen = json['jianshen'];
    tiangandizhiyear = json['tiangandizhiyear'];
    tiangandizhimonth = json['tiangandizhimonth'];
    tiangandizhiday = json['tiangandizhiday'];
    lmonthname = json['lmonthname'];
    shengxiao = json['shengxiao'];
    lubarmonth = json['lubarmonth'];
    lunarday = json['lunarday'];
    jieqi = json['jieqi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gregoriandate'] = this.gregoriandate;
    data['lunardate'] = this.lunardate;
    data['lunar_festival'] = this.lunarFestival;
    data['festival'] = this.festival;
    data['fitness'] = this.fitness;
    data['taboo'] = this.taboo;
    data['shenwei'] = this.shenwei;
    data['taishen'] = this.taishen;
    data['chongsha'] = this.chongsha;
    data['suisha'] = this.suisha;
    data['wuxingjiazi'] = this.wuxingjiazi;
    data['wuxingnayear'] = this.wuxingnayear;
    data['wuxingnamonth'] = this.wuxingnamonth;
    data['xingsu'] = this.xingsu;
    data['pengzu'] = this.pengzu;
    data['jianshen'] = this.jianshen;
    data['tiangandizhiyear'] = this.tiangandizhiyear;
    data['tiangandizhimonth'] = this.tiangandizhimonth;
    data['tiangandizhiday'] = this.tiangandizhiday;
    data['lmonthname'] = this.lmonthname;
    data['shengxiao'] = this.shengxiao;
    data['lubarmonth'] = this.lubarmonth;
    data['lunarday'] = this.lunarday;
    data['jieqi'] = this.jieqi;
    return data;
  }
}