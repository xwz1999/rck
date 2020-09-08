class UpgradeCardModel {
  String code;
  String msg;
  Data data;

  UpgradeCardModel({this.code, this.msg, this.data});

  UpgradeCardModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String nextAssessTime;
  UpCode upCode;
  UpCode keepCode;

  Data({this.nextAssessTime, this.upCode, this.keepCode});

  Data.fromJson(Map<String, dynamic> json) {
    nextAssessTime = json['nextAssessTime'];
    upCode =
        json['upCode'] != null ? new UpCode.fromJson(json['upCode']) : null;
    keepCode =
        json['keepCode'] != null ? new UpCode.fromJson(json['keepCode']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nextAssessTime'] = this.nextAssessTime;
    if (this.upCode != null) {
      data['upCode'] = this.upCode.toJson();
    }
    if (this.keepCode != null) {
      data['keepCode'] = this.keepCode.toJson();
    }
    return data;
  }
}

class UpCode {
  List<UnusedCode> usedCode;
  List<UnusedCode> unusedCode;

  UpCode({this.usedCode, this.unusedCode});

  UpCode.fromJson(Map<String, dynamic> json) {
    if (json['usedCode'] != null) {
      usedCode = new List<UnusedCode>();
      json['usedCode'].forEach((v) {
        usedCode.add(new UnusedCode.fromJson(v));
      });
    }
    if (json['unusedCode'] != null) {
      unusedCode = new List<UnusedCode>();
      json['unusedCode'].forEach((v) {
        unusedCode.add(new UnusedCode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usedCode'] = this.usedCode;
    if (this.unusedCode != null) {
      data['unusedCode'] = this.unusedCode.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UnusedCode {
  num id;
  String code;

  UnusedCode({this.id, this.code});

  UnusedCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    return data;
  }
}
