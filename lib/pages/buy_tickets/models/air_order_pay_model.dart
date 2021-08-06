class AirOrderPayModel {
  TicketOrders ticketOrders;
  String tradeNo;
  String ctime;
  String title;
  int state;
  String stateName;
  int billState;
  String billTime;
  String etime;
  String trainNo;
  String startStation;
  String recevieStation;
  String startTime;
  String recevieTime;
  String contactName;
  String contactTel;
  int orderType;
  String tplId;
  int totalSalePrice;
  int totalPayCash;
  int totalFacePrice;
  int totalPurPrice;
  int totalOtherFee;
  int totalRefundFee;
  Null legs;
  Null remark;

  AirOrderPayModel(
      {this.ticketOrders,
      this.tradeNo,
      this.ctime,
      this.title,
      this.state,
      this.stateName,
      this.billState,
      this.billTime,
      this.etime,
      this.trainNo,
      this.startStation,
      this.recevieStation,
      this.startTime,
      this.recevieTime,
      this.contactName,
      this.contactTel,
      this.orderType,
      this.tplId,
      this.totalSalePrice,
      this.totalPayCash,
      this.totalFacePrice,
      this.totalPurPrice,
      this.totalOtherFee,
      this.totalRefundFee,
      this.legs,
      this.remark});

  AirOrderPayModel.fromJson(Map<String, dynamic> json) {
    ticketOrders = json['ticketOrders'] != null
        ? new TicketOrders.fromJson(json['ticketOrders'])
        : null;
    tradeNo = json['tradeNo'];
    ctime = json['ctime'];
    title = json['title'];
    state = json['state'];
    stateName = json['stateName'];
    billState = json['billState'];
    billTime = json['billTime'];
    etime = json['etime'];
    trainNo = json['trainNo'];
    startStation = json['startStation'];
    recevieStation = json['recevieStation'];
    startTime = json['startTime'];
    recevieTime = json['recevieTime'];
    contactName = json['contactName'];
    contactTel = json['contactTel'];
    orderType = json['orderType'];
    tplId = json['tplId'];
    totalSalePrice = json['totalSalePrice'];
    totalPayCash = json['totalPayCash'];
    totalFacePrice = json['totalFacePrice'];
    totalPurPrice = json['totalPurPrice'];
    totalOtherFee = json['totalOtherFee'];
    totalRefundFee = json['totalRefundFee'];
    legs = json['legs'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ticketOrders != null) {
      data['ticketOrders'] = this.ticketOrders.toJson();
    }
    data['tradeNo'] = this.tradeNo;
    data['ctime'] = this.ctime;
    data['title'] = this.title;
    data['state'] = this.state;
    data['stateName'] = this.stateName;
    data['billState'] = this.billState;
    data['billTime'] = this.billTime;
    data['etime'] = this.etime;
    data['trainNo'] = this.trainNo;
    data['startStation'] = this.startStation;
    data['recevieStation'] = this.recevieStation;
    data['startTime'] = this.startTime;
    data['recevieTime'] = this.recevieTime;
    data['contactName'] = this.contactName;
    data['contactTel'] = this.contactTel;
    data['orderType'] = this.orderType;
    data['tplId'] = this.tplId;
    data['totalSalePrice'] = this.totalSalePrice;
    data['totalPayCash'] = this.totalPayCash;
    data['totalFacePrice'] = this.totalFacePrice;
    data['totalPurPrice'] = this.totalPurPrice;
    data['totalOtherFee'] = this.totalOtherFee;
    data['totalRefundFee'] = this.totalRefundFee;
    data['legs'] = this.legs;
    data['remark'] = this.remark;
    return data;
  }
}

class TicketOrders {
  List<TicketOrder> ticketOrder;

  TicketOrders({this.ticketOrder});

  TicketOrders.fromJson(Map<String, dynamic> json) {
    if (json['ticketOrder'] != null) {
      ticketOrder = new List<TicketOrder>();
      json['ticketOrder'].forEach((v) {
        ticketOrder.add(new TicketOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ticketOrder != null) {
      data['ticketOrder'] = this.ticketOrder.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TicketOrder {
  String orderNo;
  String title;
  int state;
  String stateName;
  String itemId;
  String passengerName;
  String passengerTel;
  int idcardType;
  String idcardNo;
  String ticketNo;
  int salePrice;
  int payCash;
  int facePrice;
  int purPrice;
  int otherFee;
  int refundFee;
  String feeDetail;
  Null insurance;
  int seatType;
  String seatName;
  String seatInfo;
  Null saleOrderNo;

  TicketOrder(
      {this.orderNo,
      this.title,
      this.state,
      this.stateName,
      this.itemId,
      this.passengerName,
      this.passengerTel,
      this.idcardType,
      this.idcardNo,
      this.ticketNo,
      this.salePrice,
      this.payCash,
      this.facePrice,
      this.purPrice,
      this.otherFee,
      this.refundFee,
      this.feeDetail,
      this.insurance,
      this.seatType,
      this.seatName,
      this.seatInfo,
      this.saleOrderNo});

  TicketOrder.fromJson(Map<String, dynamic> json) {
    orderNo = json['orderNo'];
    title = json['title'];
    state = json['state'];
    stateName = json['stateName'];
    itemId = json['itemId'];
    passengerName = json['passengerName'];
    passengerTel = json['passengerTel'];
    idcardType = json['idcardType'];
    idcardNo = json['idcardNo'];
    ticketNo = json['ticketNo'];
    salePrice = json['salePrice'];
    payCash = json['payCash'];
    facePrice = json['facePrice'];
    purPrice = json['purPrice'];
    otherFee = json['otherFee'];
    refundFee = json['refundFee'];
    feeDetail = json['feeDetail'];
    insurance = json['insurance'];
    seatType = json['seatType'];
    seatName = json['seatName'];
    seatInfo = json['seatInfo'];
    saleOrderNo = json['saleOrderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderNo'] = this.orderNo;
    data['title'] = this.title;
    data['state'] = this.state;
    data['stateName'] = this.stateName;
    data['itemId'] = this.itemId;
    data['passengerName'] = this.passengerName;
    data['passengerTel'] = this.passengerTel;
    data['idcardType'] = this.idcardType;
    data['idcardNo'] = this.idcardNo;
    data['ticketNo'] = this.ticketNo;
    data['salePrice'] = this.salePrice;
    data['payCash'] = this.payCash;
    data['facePrice'] = this.facePrice;
    data['purPrice'] = this.purPrice;
    data['otherFee'] = this.otherFee;
    data['refundFee'] = this.refundFee;
    data['feeDetail'] = this.feeDetail;
    data['insurance'] = this.insurance;
    data['seatType'] = this.seatType;
    data['seatName'] = this.seatName;
    data['seatInfo'] = this.seatInfo;
    data['saleOrderNo'] = this.saleOrderNo;
    return data;
  }
}
