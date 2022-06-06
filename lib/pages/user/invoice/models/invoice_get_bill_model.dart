class InvoiceGetBillModel {
  String? endTime;
  String? goodsName;
  num? goodsTotalAmount;
  int? orderId;

  InvoiceGetBillModel(
      {this.endTime, this.goodsName, this.goodsTotalAmount, this.orderId});

  InvoiceGetBillModel.fromJson(Map<String, dynamic> json) {
    endTime = json['end_time'];
    goodsName = json['goods_name'];
    goodsTotalAmount = json['goods_total_amount'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['end_time'] = this.endTime;
    data['goods_name'] = this.goodsName;
    data['goods_total_amount'] = this.goodsTotalAmount;
    data['order_id'] = this.orderId;
    return data;
  }
}
