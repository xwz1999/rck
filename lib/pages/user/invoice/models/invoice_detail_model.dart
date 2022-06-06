class InvoiceDetailModel {
  int? id;
  int? userId;
  int? orderId;
  String? buyerName;
  String? taxNum;
  String? address;
  String? telephone;
  String? phone;
  String? email;
  String? account;
  String? message;
  num? totalAmount;
  int? invoiceStatus;
  String? fpqqlsh;
  String? ctime;
  String? failReasons;
  String? ctimeInvoice;
  String? invoiceUrl;

  InvoiceDetailModel(
      {this.id,
      this.userId,
      this.orderId,
      this.buyerName,
      this.taxNum,
      this.address,
      this.telephone,
      this.phone,
      this.email,
      this.account,
      this.message,
      this.totalAmount,
      this.invoiceStatus,
      this.fpqqlsh,
      this.ctime,
      this.failReasons,
      this.ctimeInvoice,
      this.invoiceUrl});

  InvoiceDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    buyerName = json['buyer_name'];
    taxNum = json['tax_num'];
    address = json['address'];
    telephone = json['telephone'];
    phone = json['phone'];
    email = json['email'];
    account = json['account'];
    message = json['message'];
    totalAmount = json['total_amount'];
    invoiceStatus = json['invoice_status'];
    fpqqlsh = json['fpqqlsh'];
    ctime = json['ctime'];
    failReasons = json['fail_reasons'];
    ctimeInvoice = json['ctime_invoice'];
    invoiceUrl = json['invoice_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['order_id'] = this.orderId;
    data['buyer_name'] = this.buyerName;
    data['tax_num'] = this.taxNum;
    data['address'] = this.address;
    data['telephone'] = this.telephone;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['account'] = this.account;
    data['message'] = this.message;
    data['total_amount'] = this.totalAmount;
    data['invoice_status'] = this.invoiceStatus;
    data['fpqqlsh'] = this.fpqqlsh;
    data['ctime'] = this.ctime;
    data['fail_reasons'] = this.failReasons;
    data['ctime_invoice'] = this.ctimeInvoice;
    data['invoice_url'] = this.invoiceUrl;
    return data;
  }
}
