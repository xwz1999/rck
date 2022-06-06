class WithdrawAmountModel {
  num? balance;
  num? taxAmount;
  num? withdrawal;
  num? actualAmount;

  WithdrawAmountModel(
      {this.balance, this.taxAmount, this.withdrawal, this.actualAmount});

  WithdrawAmountModel.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    taxAmount = json['tax_amount'];
    withdrawal = json['withdrawal'];
    actualAmount = json['actual_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['tax_amount'] = this.taxAmount;
    data['withdrawal'] = this.withdrawal;
    data['actual_amount'] = this.actualAmount;
    return data;
  }
}