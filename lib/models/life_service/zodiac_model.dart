class ZodiacModel {
  String? name;
  String? years;
  String? fw;
  String? sc;
  String? sz;
  String? xyh;
  String? ys;
  String? sy;
  String? aq;
  String? xg;
  String? yd;
  String? qd;
  List<CurrentAge>? currentAge;

  ZodiacModel(
      {this.name,
        this.years,
        this.fw,
        this.sc,
        this.sz,
        this.xyh,
        this.ys,
        this.sy,
        this.aq,
        this.xg,
        this.yd,
        this.qd,
        this.currentAge});

  ZodiacModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    years = json['years'];
    fw = json['fw'];
    sc = json['sc'];
    sz = json['sz'];
    xyh = json['xyh'];
    ys = json['ys'];
    sy = json['sy'];
    aq = json['aq'];
    xg = json['xg'];
    yd = json['yd'];
    qd = json['qd'];
    if (json['currentAge'] != null) {
      currentAge = [];
      json['currentAge'].forEach((v) {
        currentAge!.add(new CurrentAge.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['years'] = this.years;
    data['fw'] = this.fw;
    data['sc'] = this.sc;
    data['sz'] = this.sz;
    data['xyh'] = this.xyh;
    data['ys'] = this.ys;
    data['sy'] = this.sy;
    data['aq'] = this.aq;
    data['xg'] = this.xg;
    data['yd'] = this.yd;
    data['qd'] = this.qd;
    if (this.currentAge != null) {
      data['currentAge'] = this.currentAge!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrentAge {
  int? y;
  int? s;
  int? x;

  CurrentAge({this.y, this.s, this.x});

  CurrentAge.fromJson(Map<String, dynamic> json) {
    y = json['y'];
    s = json['s'];
    x = json['x'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['y'] = this.y;
    data['s'] = this.s;
    data['x'] = this.x;
    return data;
  }
}