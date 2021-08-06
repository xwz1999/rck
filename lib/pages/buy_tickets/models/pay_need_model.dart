class PayNeedModel {
  int id;
  int lfOrderId;
  String seatCode;
  String passagers;
  String itemId;
  String contactName;
  String contactTel;
  String date;
  String from;
  String to;
  String companyCode;
  String flightNo;

  PayNeedModel(
      {this.id,
      this.lfOrderId,
      this.seatCode,
      this.passagers,
      this.itemId,
      this.contactName,
      this.contactTel,
      this.date,
      this.from,
      this.to,
      this.companyCode,
      this.flightNo});

  PayNeedModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lfOrderId = json['lf_order_id'];
    seatCode = json['seatCode'];
    passagers = json['passagers'];
    itemId = json['itemId'];
    contactName = json['contactName'];
    contactTel = json['contactTel'];
    date = json['date'];
    from = json['from'];
    to = json['to'];
    companyCode = json['companyCode'];
    flightNo = json['flightNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lf_order_id'] = this.lfOrderId;
    data['seatCode'] = this.seatCode;
    data['passagers'] = this.passagers;
    data['itemId'] = this.itemId;
    data['contactName'] = this.contactName;
    data['contactTel'] = this.contactTel;
    data['date'] = this.date;
    data['from'] = this.from;
    data['to'] = this.to;
    data['companyCode'] = this.companyCode;
    data['flightNo'] = this.flightNo;
    return data;
  }
}
