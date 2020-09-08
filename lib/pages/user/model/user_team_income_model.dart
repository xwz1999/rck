class UserTeamIncomeModel {
  String code;
  String msg;
  Data data;

  UserTeamIncomeModel({this.code, this.msg, this.data});

  UserTeamIncomeModel.fromJson(Map<String, dynamic> json) {
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
  TeamIncome teamIncome;
  String date;
  IncomeDetail incomeDetail;
  List<Billboard> billboard;

  Data({this.teamIncome, this.date, this.incomeDetail, this.billboard});

  Data.fromJson(Map<String, dynamic> json) {
    teamIncome = json['teamIncome'] != null
        ? new TeamIncome.fromJson(json['teamIncome'])
        : null;
    date = json['date'];
    incomeDetail = json['incomeDetail'] != null
        ? new IncomeDetail.fromJson(json['incomeDetail'])
        : null;
    if (json['billboard'] != null) {
      billboard = new List<Billboard>();
      json['billboard'].forEach((v) {
        billboard.add(new Billboard.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teamIncome != null) {
      data['teamIncome'] = this.teamIncome.toJson();
    }
    data['date'] = this.date;
    if (this.incomeDetail != null) {
      data['incomeDetail'] = this.incomeDetail.toJson();
    }
    if (this.billboard != null) {
      data['billboard'] = this.billboard.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeamIncome {
  num teamAmount;
  num historyIncome;
  num memberNum;

  TeamIncome({this.teamAmount, this.historyIncome, this.memberNum});

  TeamIncome.fromJson(Map<String, dynamic> json) {
    teamAmount = json['teamAmount'];
    historyIncome = json['historyIncome'];
    memberNum = json['memberNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamAmount'] = this.teamAmount;
    data['historyIncome'] = this.historyIncome;
    data['memberNum'] = this.memberNum;
    return data;
  }
}

class IncomeDetail {
  num id;
  num userId;
  // Null period;
  num percent;
  num amount;
  num income;
  // Null createdAt;

  IncomeDetail(
      {this.id,
      this.userId,
      // this.period,
      this.percent,
      this.amount,
      this.income,
      // this.createdAt
      });

  IncomeDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    // period = json['period'];
    percent = json['percent'];
    amount = json['amount'];
    income = json['income'];
    // createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    // data['period'] = this.period;
    data['percent'] = this.percent;
    data['amount'] = this.amount;
    data['income'] = this.income;
    // data['createdAt'] = this.createdAt;
    return data;
  }
}

class Billboard {
  num userId;
  String username;
  String mobile;
  num roleLevel;
  num amount;
  String headImgUrl;
  Billboard(
      {this.userId, this.username, this.mobile, this.roleLevel, this.amount, this.headImgUrl});

  Billboard.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    mobile = json['mobile'];
    roleLevel = json['roleLevel'];
    amount = json['amount'];
    headImgUrl = json['headImgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['mobile'] = this.mobile;
    data['roleLevel'] = this.roleLevel;
    data['amount'] = this.amount;
    data['headImgUrl'] = this.headImgUrl;
    return data;
  }
}
