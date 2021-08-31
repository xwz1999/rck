class AirOrderModel {
  Order order;
  List<User> user;

  AirOrderModel({this.order, this.user});

  AirOrderModel.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    if (json['user'] != null) {
      user = new List<User>();
      json['user'].forEach((v) {
        user.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  int id;
  String title;
  int userId;
  String tradeNo;
  String createdTime;
  int unsubscribe;
  int status;
  String expireTime;
  String payIp;
  String payTime;
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
  String date;
  String thirdPartyNo;
  String reservedPhone;
  String fromCity;
  String toCity;

  Order({
    this.id,
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
    this.users,
    this.date,
    this.thirdPartyNo,
    this.reservedPhone,
    this.fromCity,
    this.toCity,
  });

  Order.fromJson(Map<String, dynamic> json) {
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
    date = json['date'];
    thirdPartyNo = json['third_party_no'];
    reservedPhone = json['reserved_phone'];
    fromCity = json['from_city'];
    toCity = json['to_city'];
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
    data['date'] = this.date;
    data['third_party_no'] = this.thirdPartyNo;
    data['reserved_phone'] = this.reservedPhone;
    data['from_city'] = this.fromCity;
    data['to_city'] = this.toCity;
    return data;
  }
}

class User {
  int id;
  int userId;
  String name;
  String residentIdCard;
  String phone;
  int isDefault;

  User(
      {this.id,
      this.userId,
      this.name,
      this.residentIdCard,
      this.phone,
      this.isDefault});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    residentIdCard = json['resident_id_card'];
    phone = json['phone'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['resident_id_card'] = this.residentIdCard;
    data['phone'] = this.phone;
    data['is_default'] = this.isDefault;
    return data;
  }
}
