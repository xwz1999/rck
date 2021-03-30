class PerformanceInfoModel {
  String code;
  String msg;
  Data data;

  PerformanceInfoModel({this.code, this.msg, this.data});

  PerformanceInfoModel.fromJson(Map<String, dynamic> json) {
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
  List<PerformanceList> list;
  Statistics statistics;

  Data({this.list, this.statistics});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<PerformanceList>();
      json['list'].forEach((v) {
        list.add(new PerformanceList.fromJson(v));
      });
    }
    statistics = json['statistics'] != null
        ? new Statistics.fromJson(json['statistics'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    if (this.statistics != null) {
      data['statistics'] = this.statistics.toJson();
    }
    return data;
  }
}

class PerformanceList {
  String nickname;
  String avatarPath;
  int userId;
  num salesAmount;
  num role;
  

  PerformanceList({this.nickname, this.avatarPath, this.userId, this.salesAmount, this.role});

  PerformanceList.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    avatarPath = json['avatarPath'];
    userId = json['userId'];
    salesAmount = json['salesAmount'];
    role = json['role'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['avatarPath'] = this.avatarPath;
    data['userId'] = this.userId;
    data['salesAmount'] = this.salesAmount;
    data['role'] = this.role;
    
    return data;
  }
}

class Statistics {
  num salesAmount;
  num income;
  num subIncome;
  num ratio;
  num actualIncome;

  Statistics({this.salesAmount, this.income, this.subIncome, this.ratio,this.actualIncome });

  Statistics.fromJson(Map<String, dynamic> json) {
    salesAmount = json['salesAmount'];
    income = json['income'];
    subIncome = json['subIncome'];
    ratio = json['ratio'];
    actualIncome = json['actualIncome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesAmount'] = this.salesAmount;
    data['income'] = this.income;
    data['subIncome'] = this.subIncome;
    data['ratio'] = this.ratio;
    data['actualIncome'] = this.actualIncome;
    return data;
  }
}
