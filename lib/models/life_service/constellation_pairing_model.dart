class ConstellationPairingModel {
  String? men;
  String? women;
  String? zhishu;
  String? bizhong;
  String? xiangyue;
  String? tcdj;
  String? jieguo;
  String? lianai;
  String? zhuyi;

  ConstellationPairingModel(
      {this.men,
        this.women,
        this.zhishu,
        this.bizhong,
        this.xiangyue,
        this.tcdj,
        this.jieguo,
        this.lianai,
        this.zhuyi});

  ConstellationPairingModel.fromJson(Map<String, dynamic> json) {
    men = json['men'];
    women = json['women'];
    zhishu = json['zhishu'];
    bizhong = json['bizhong'];
    xiangyue = json['xiangyue'];
    tcdj = json['tcdj'];
    jieguo = json['jieguo'];
    lianai = json['lianai'];
    zhuyi = json['zhuyi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['men'] = this.men;
    data['women'] = this.women;
    data['zhishu'] = this.zhishu;
    data['bizhong'] = this.bizhong;
    data['xiangyue'] = this.xiangyue;
    data['tcdj'] = this.tcdj;
    data['jieguo'] = this.jieguo;
    data['lianai'] = this.lianai;
    data['zhuyi'] = this.zhuyi;
    return data;
  }
}