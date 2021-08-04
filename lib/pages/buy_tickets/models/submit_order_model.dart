class SubmitOrderModel {
  int id;
  String title;
  int userId;
  String tradeNo;
  String createdTime;
  int unsubscribe;
  int status;
  String expireTime;
  String payIp;
  Null payTime;
  int payMethod;
  int goodsType;
  num amountMoney;
  String from;
  String to;
  String fromDate;
  String toDate;
  String fromPort;
  String toPort;
  String line;
  String users;

  SubmitOrderModel(
      {this.id,
      this.title,
      this.userId,
      this.tradeNo,
      this.createdTime,
      this.unsubscribe,
      this.status,
      this.expireTime,
      this.payIp,
      this.payTime,
      this.payMethod,
      this.goodsType,
      this.amountMoney,
      this.from,
      this.to,
      this.fromDate,
      this.toDate,
      this.fromPort,
      this.toPort,
      this.line,
      this.users});

  SubmitOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    userId = json['user_id'];
    tradeNo = json['trade_no'];
    createdTime = json['created_time'];
    unsubscribe = json['unsubscribe'];
    status = json['status'];
    expireTime = json['expire_time'];
    payIp = json['pay_ip'];
    payTime = json['pay_time'];
    payMethod = json['pay_method'];
    goodsType = json['goods_type'];
    amountMoney = json['amount_money'];
    from = json['from'];
    to = json['to'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    fromPort = json['from_port'];
    toPort = json['to_port'];
    line = json['line'];
    users = json['users'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['user_id'] = this.userId;
    data['trade_no'] = this.tradeNo;
    data['created_time'] = this.createdTime;
    data['unsubscribe'] = this.unsubscribe;
    data['status'] = this.status;
    data['expire_time'] = this.expireTime;
    data['pay_ip'] = this.payIp;
    data['pay_time'] = this.payTime;
    data['pay_method'] = this.payMethod;
    data['goods_type'] = this.goodsType;
    data['amount_money'] = this.amountMoney;
    data['from'] = this.from;
    data['to'] = this.to;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['from_port'] = this.fromPort;
    data['to_port'] = this.toPort;
    data['line'] = this.line;
    data['users'] = this.users;
    return data;
  }
}
