class ConstellationModel {
  String? icon;
  String? name;
  String? range;
  String? zxtd;
  String? sssx;
  String? zggw;
  String? yysx;
  String? zdtz;
  String? zgxx;
  String? xyys;
  String? jssw;
  String? xyhm;
  String? kyjs;
  String? bx;
  String? yd;
  String? qd;
  String? jbtz;
  String? jttz;
  String? xsfg;
  String? gxmd;
  String? zj;

  ConstellationModel(
      {this.icon,
        this.name,
        this.range,
        this.zxtd,
        this.sssx,
        this.zggw,
        this.yysx,
        this.zdtz,
        this.zgxx,
        this.xyys,
        this.jssw,
        this.xyhm,
        this.kyjs,
        this.bx,
        this.yd,
        this.qd,
        this.jbtz,
        this.jttz,
        this.xsfg,
        this.gxmd,
        this.zj});

  ConstellationModel.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    name = json['name'];
    range = json['range'];
    zxtd = json['zxtd'];
    sssx = json['sssx'];
    zggw = json['zggw'];
    yysx = json['yysx'];
    zdtz = json['zdtz'];
    zgxx = json['zgxx'];
    xyys = json['xyys'];
    jssw = json['jssw'];
    xyhm = json['xyhm'];
    kyjs = json['kyjs'];
    bx = json['bx'];
    yd = json['yd'];
    qd = json['qd'];
    jbtz = json['jbtz'];
    jttz = json['jttz'];
    xsfg = json['xsfg'];
    gxmd = json['gxmd'];
    zj = json['zj'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['name'] = this.name;
    data['range'] = this.range;
    data['zxtd'] = this.zxtd;
    data['sssx'] = this.sssx;
    data['zggw'] = this.zggw;
    data['yysx'] = this.yysx;
    data['zdtz'] = this.zdtz;
    data['zgxx'] = this.zgxx;
    data['xyys'] = this.xyys;
    data['jssw'] = this.jssw;
    data['xyhm'] = this.xyhm;
    data['kyjs'] = this.kyjs;
    data['bx'] = this.bx;
    data['yd'] = this.yd;
    data['qd'] = this.qd;
    data['jbtz'] = this.jbtz;
    data['jttz'] = this.jttz;
    data['xsfg'] = this.xsfg;
    data['gxmd'] = this.gxmd;
    data['zj'] = this.zj;
    return data;
  }
}