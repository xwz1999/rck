class FigureModel {
  Stw? stw;
  Stw? xw;
  Stw? xyw;
  Stw? syw;
  Stw? tw;
  Stw? dtw;
  Stw? xtw;

  FigureModel(
      {this.stw, this.xw, this.xyw, this.syw, this.tw, this.dtw, this.xtw});

  FigureModel.fromJson(Map<String, dynamic> json) {
    stw = json['stw'] != null ? new Stw.fromJson(json['stw']) : null;
    xw = json['xw'] != null ? new Stw.fromJson(json['xw']) : null;
    xyw = json['xyw'] != null ? new Stw.fromJson(json['xyw']) : null;
    syw = json['syw'] != null ? new Stw.fromJson(json['syw']) : null;
    tw = json['tw'] != null ? new Stw.fromJson(json['tw']) : null;
    dtw = json['dtw'] != null ? new Stw.fromJson(json['dtw']) : null;
    xtw = json['xtw'] != null ? new Stw.fromJson(json['xtw']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stw != null) {
      data['stw'] = this.stw!.toJson();
    }
    if (this.xw != null) {
      data['xw'] = this.xw!.toJson();
    }
    if (this.xyw != null) {
      data['xyw'] = this.xyw!.toJson();
    }
    if (this.syw != null) {
      data['syw'] = this.syw!.toJson();
    }
    if (this.tw != null) {
      data['tw'] = this.tw!.toJson();
    }
    if (this.dtw != null) {
      data['dtw'] = this.dtw!.toJson();
    }
    if (this.xtw != null) {
      data['xtw'] = this.xtw!.toJson();
    }
    return data;
  }
}

class Stw {
  String? cm;
  String? yc;

  Stw({this.cm, this.yc});

  Stw.fromJson(Map<String, dynamic> json) {
    cm = json['cm'];
    yc = json['yc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cm'] = this.cm;
    data['yc'] = this.yc;
    return data;
  }
}