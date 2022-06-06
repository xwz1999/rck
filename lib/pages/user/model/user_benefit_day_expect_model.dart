import 'package:recook/pages/user/benefit_view_gen.dart';

class UserBenefitDayExpectModel {
  Purchase? purchase;
  Purchase? guide;

  UserBenefitDayExpectModel({this.purchase, this.guide});

  UserBenefitDayExpectModel.fromJson(Map<String, dynamic> json) {
    purchase = json['purchase'] != null
        ? new Purchase.fromJson(json['purchase'])
        : null;
    guide = json['guide'] != null ? new Purchase.fromJson(json['guide']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.purchase != null) {
      data['purchase'] = this.purchase!.toJson();
    }
    if (this.guide != null) {
      data['guide'] = this.guide!.toJson();
    }
    return data;
  }
}

class Purchase {
  int? count;
  num? salesVolume;
  num? amount;

  DisplayCard get card => DisplayCard(
        count: count,
        sales: salesVolume,
        benefit: amount,
      );

  Purchase({this.count, this.salesVolume, this.amount});

  Purchase.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    salesVolume = json['salesVolume'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['salesVolume'] = this.salesVolume;
    data['amount'] = this.amount;
    return data;
  }
}
