class ProfitCardModel {
  String? name;
  String? mobile;
  String? int;
  num? amount;



  ProfitCardModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    int = json['int'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['int'] = this.int;
    data['amount'] = this.amount;
    return data;
  }

  ProfitCardModel({
     this.name,
     this.mobile,
     this.int,
     this.amount,
  });
}