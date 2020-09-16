class ShopSummaryModel {
  String code;
  String msg;
  Data data;

  ShopSummaryModel({this.code, this.msg, this.data});

  ShopSummaryModel.fromJson(Map<String, dynamic> json) {
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
  num roleLevel;
  Card card;
  AccumulateIncome accumulateIncome;
  MyShoppingWithTime myShoppingWithTime;
  MyShoppingWithTime shareIncomeWithTime;
  TeamIncomeWithTime teamIncomeWithTime;
  OrderCenter orderCenter;
  Assessment assessment;
  UpNotify upNotify;
  Data(
      {this.roleLevel,
      this.card,
      this.accumulateIncome,
      this.myShoppingWithTime,
      this.shareIncomeWithTime,
      this.teamIncomeWithTime,
      this.orderCenter,
      this.assessment,
      this.upNotify});

  Data.fromJson(Map<String, dynamic> json) {
    roleLevel = json['roleLevel'];
    card = json['card'] != null ? new Card.fromJson(json['card']) : null;
    accumulateIncome = json['accumulateIncome'] != null
        ? new AccumulateIncome.fromJson(json['accumulateIncome'])
        : null;
    myShoppingWithTime = json['myShoppingWithTime'] != null
        ? new MyShoppingWithTime.fromJson(json['myShoppingWithTime'])
        : null;
    shareIncomeWithTime = json['shareIncomeWithTime'] != null
        ? new MyShoppingWithTime.fromJson(json['shareIncomeWithTime'])
        : null;
    teamIncomeWithTime = json['teamIncomeWithTime'] != null
        ? new TeamIncomeWithTime.fromJson(json['teamIncomeWithTime'])
        : null;
    orderCenter = json['orderCenter'] != null
        ? new OrderCenter.fromJson(json['orderCenter'])
        : null;
    assessment = json['assessment'] != null
        ? new Assessment.fromJson(json['assessment'])
        : null;
    upNotify = json['upNotify'] != null
        ? new UpNotify.fromJson(json['upNotify'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roleLevel'] = this.roleLevel;
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
    if (this.accumulateIncome != null) {
      data['accumulateIncome'] = this.accumulateIncome.toJson();
    }
    if (this.myShoppingWithTime != null) {
      data['myShoppingWithTime'] = this.myShoppingWithTime.toJson();
    }
    if (this.shareIncomeWithTime != null) {
      data['shareIncomeWithTime'] = this.shareIncomeWithTime.toJson();
    }
    if (this.teamIncomeWithTime != null) {
      data['teamIncomeWithTime'] = this.teamIncomeWithTime.toJson();
    }
    if (this.orderCenter != null) {
      data['orderCenter'] = this.orderCenter.toJson();
    }
    if (this.assessment != null) {
      data['assessment'] = this.assessment.toJson();
    }
    if (this.upNotify != null) {
      data['upNotify'] = this.upNotify.toJson();
    }
    return data;
  }
}

class UpNotify {
  bool isNotify;
  String notifyType;
  String notifyContent;

  UpNotify({this.isNotify, this.notifyType, this.notifyContent});

  UpNotify.fromJson(Map<String, dynamic> json) {
    isNotify = json['isNotify'];
    notifyType = json['notifyType'];
    notifyContent = json['notifyContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isNotify'] = this.isNotify;
    data['notifyType'] = this.notifyType;
    data['notifyContent'] = this.notifyContent;
    return data;
  }
}

class Card {
  num teamIn;
  num percent;
  num balance;
  Stand stand;
  num target;

  Card({this.teamIn, this.percent, this.balance, this.stand, this.target});

  Card.fromJson(Map<String, dynamic> json) {
    teamIn = json['teamIn'];
    percent = json['percent'];
    balance = json['balance'];
    stand = json['stand'] != null ? new Stand.fromJson(json['stand']) : null;
    target = json['Target'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamIn'] = this.teamIn;
    data['percent'] = this.percent;
    data['balance'] = this.balance;
    if (this.stand != null) {
      data['stand'] = this.stand.toJson();
    }
    data['Target'] = this.target;
    return data;
  }
}

class Stand {
  num level;
  num basePercent;
  List<IncreaseNum> increaseNum;

  Stand({this.level, this.basePercent, this.increaseNum});

  Stand.fromJson(Map<String, dynamic> json) {
    level = json['Level'];
    basePercent = json['BasePercent'];
    if (json['IncreaseNum'] != null) {
      increaseNum = new List<IncreaseNum>();
      json['IncreaseNum'].forEach((v) {
        increaseNum.add(new IncreaseNum.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Level'] = this.level;
    data['BasePercent'] = this.basePercent;
    if (this.increaseNum != null) {
      data['IncreaseNum'] = this.increaseNum.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IncreaseNum {
  num quantity;
  num percent;

  IncreaseNum({this.quantity, this.percent});

  IncreaseNum.fromJson(Map<String, dynamic> json) {
    quantity = json['Quantity'];
    percent = json['Percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Quantity'] = this.quantity;
    data['Percent'] = this.percent;
    return data;
  }
}

class AccumulateIncome {
  num all;
  num selfShopping;
  num share;
  num team;

  AccumulateIncome({this.all, this.selfShopping, this.share, this.team});

  AccumulateIncome.fromJson(Map<String, dynamic> json) {
    all = json['all'];
    selfShopping = json['selfShopping'];
    share = json['share'];
    team = json['team'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all'] = this.all;
    data['selfShopping'] = this.selfShopping;
    data['share'] = this.share;
    data['team'] = this.team;
    return data;
  }
}

class MyShoppingWithTime {
  Today today;
  Today thisMonth;
  Today prevMonth;

  MyShoppingWithTime({this.today, this.thisMonth, this.prevMonth});

  MyShoppingWithTime.fromJson(Map<String, dynamic> json) {
    today = json['today'] != null ? new Today.fromJson(json['today']) : null;
    thisMonth = json['thisMonth'] != null
        ? new Today.fromJson(json['thisMonth'])
        : null;
    prevMonth = json['prevMonth'] != null
        ? new Today.fromJson(json['prevMonth'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.today != null) {
      data['today'] = this.today.toJson();
    }
    if (this.thisMonth != null) {
      data['thisMonth'] = this.thisMonth.toJson();
    }
    if (this.prevMonth != null) {
      data['prevMonth'] = this.prevMonth.toJson();
    }
    return data;
  }
}

class TeamIncomeWithTime {
  TeamInToday today;
  TeamInToday thisMonth;
  TeamInToday prevMonth;

  TeamIncomeWithTime({this.today, this.thisMonth, this.prevMonth});

  TeamIncomeWithTime.fromJson(Map<String, dynamic> json) {
    today =
        json['today'] != null ? new TeamInToday.fromJson(json['today']) : null;
    thisMonth = json['thisMonth'] != null
        ? new TeamInToday.fromJson(json['thisMonth'])
        : null;
    prevMonth = json['prevMonth'] != null
        ? new TeamInToday.fromJson(json['prevMonth'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.today != null) {
      data['today'] = this.today.toJson();
    }
    if (this.thisMonth != null) {
      data['thisMonth'] = this.thisMonth.toJson();
    }
    if (this.prevMonth != null) {
      data['prevMonth'] = this.prevMonth.toJson();
    }
    return data;
  }
}

class Today {
  num orderNum;
  num amount;
  num historyIncome;

  Today({this.orderNum, this.amount, this.historyIncome});

  Today.fromJson(Map<String, dynamic> json) {
    orderNum = json['orderNum'];
    amount = json['amount'];
    historyIncome = json['historyIncome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderNum'] = this.orderNum;
    data['amount'] = this.amount;
    data['historyIncome'] = this.historyIncome;
    return data;
  }
}

class TeamInToday {
  num amount;
  num percent;
  num historyIncome;
  String msg;
  String alertMsg;

  TeamInToday(
      {this.amount, this.percent, this.historyIncome, this.msg, this.alertMsg});

  TeamInToday.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    percent = json['percent'];
    historyIncome = json['historyIncome'];
    msg = json['msg'];
    alertMsg = json['alertMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['percent'] = this.percent;
    data['historyIncome'] = this.historyIncome;
    data['msg'] = this.msg;
    data['alertMsg'] = this.alertMsg;
    return data;
  }
}

class OrderCenter {
  num waitPay;
  num waitSend;
  num waitRecv;
  num afterSales;

  OrderCenter({this.waitPay, this.waitSend, this.waitRecv, this.afterSales});

  OrderCenter.fromJson(Map<String, dynamic> json) {
    waitPay = json['waitPay'];
    waitSend = json['waitSend'];
    waitRecv = json['waitRecv'];
    afterSales = json['afterSales'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['waitPay'] = this.waitPay;
    data['waitSend'] = this.waitSend;
    data['waitRecv'] = this.waitRecv;
    data['afterSales'] = this.afterSales;
    return data;
  }
}

class Assessment {
  String aTime;
  UpStandard upStandard;
  UpStandard keepStandard;
  Upper upper;
  Upper keeper;
  String content;

  Assessment({
    this.aTime,
    this.upStandard,
    this.keepStandard,
    this.upper,
    this.keeper,
    this.content,
  });

  Assessment.fromJson(Map<String, dynamic> json) {
    aTime = json['aTime'];
    upStandard = json['UpStandard'] != null
        ? new UpStandard.fromJson(json['UpStandard'])
        : null;
    keepStandard = json['KeepStandard'] != null
        ? new UpStandard.fromJson(json['KeepStandard'])
        : null;
    upper = json['upper'] != null ? new Upper.fromJson(json['upper']) : null;
    keeper = json['keeper'] != null ? new Upper.fromJson(json['keeper']) : null;
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.upStandard != null) {
      data['UpStandard'] = this.upStandard.toJson();
    }
    if (this.keepStandard != null) {
      data['KeepStandard'] = this.keepStandard.toJson();
    }
    if (this.upper != null) {
      data['upper'] = this.upper.toJson();
    }
    if (this.keeper != null) {
      data['keeper'] = this.keeper.toJson();
    }
    data['aTime'] = this.aTime;
    data['content'] = this.content;
    return data;
  }
}

class UpStandard {
  Role200 role200;
  Role200 role300;

  UpStandard({this.role200, this.role300});

  UpStandard.fromJson(Map<String, dynamic> json) {
    role200 =
        json['role200'] != null ? new Role200.fromJson(json['role200']) : null;
    role300 =
        json['role300'] != null ? new Role200.fromJson(json['role300']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.role200 != null) {
      data['role200'] = this.role200.toJson();
    }
    if (this.role300 != null) {
      data['role300'] = this.role300.toJson();
    }
    return data;
  }
}

class Role200 {
  num roleLevel;
  num person;
  num quantity;

  Role200({this.roleLevel, this.person, this.quantity});

  Role200.fromJson(Map<String, dynamic> json) {
    roleLevel = json['RoleLevel'];
    person = json['Person'];
    quantity = json['Quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RoleLevel'] = this.roleLevel;
    data['Person'] = this.person;
    data['Quantity'] = this.quantity;
    return data;
  }
}

class Upper {
  String sale;
  String developNew;
  bool switchOnoff;

  Upper({this.sale, this.developNew, this.switchOnoff});

  Upper.fromJson(Map<String, dynamic> json) {
    sale = json['sale'];
    developNew = json['developNew'];
    switchOnoff = json['switchOnoff'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sale'] = this.sale;
    data['developNew'] = this.developNew;
    data['switchOnoff'] = this.switchOnoff;
    return data;
  }
}
