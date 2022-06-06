import 'package:recook/pages/user/benefit_view_gen.dart';

class UserBenefitMonthExpectModel {
  Purchase? purchase;
  Purchase? guide;
  List<PurchaseList>? purchaseList;
  List<PurchaseList>? guideList;

  UserBenefitMonthExpectModel(
      {this.purchase, this.guide, this.purchaseList, this.guideList});

  UserBenefitMonthExpectModel.fromJson(Map<String, dynamic> json) {
    purchase = json['purchase'] != null
        ? new Purchase.fromJson(json['purchase'])
        : null;
    guide = json['guide'] != null ? new Purchase.fromJson(json['guide']) : null;
    if (json['purchaseList'] != null) {
      purchaseList = [];
      json['purchaseList'].forEach((v) {
        purchaseList!.add(new PurchaseList.fromJson(v));
      });
    } else
      purchaseList = [];
    if (json['guideList'] != null) {
      guideList = [];
      json['guideList'].forEach((v) {
        guideList!.add(new PurchaseList.fromJson(v));
      });
    } else
      guideList = [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.purchase != null) {
      data['purchase'] = this.purchase!.toJson();
    }
    if (this.guide != null) {
      data['guide'] = this.guide!.toJson();
    }
    if (this.purchaseList != null) {
      data['purchaseList'] = this.purchaseList!.map((v) => v.toJson()).toList();
    }
    if (this.guideList != null) {
      data['guideList'] = this.guideList!.map((v) => v.toJson()).toList();
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

class PurchaseList {
  int? day;
  int? count;
  num? salesVolume;
  num? amount;

  DateTime get date => DateTime(day! ~/ 10000, day! % 10000 ~/ 100, day! % 100);

  PurchaseList({this.day, this.count, this.salesVolume, this.amount});

  PurchaseList.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    count = json['count'];
    salesVolume = json['salesVolume'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['count'] = this.count;
    data['salesVolume'] = this.salesVolume;
    data['amount'] = this.amount;
    return data;
  }
}
