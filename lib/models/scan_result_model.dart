import 'dart:convert';

/// modela ==modelb
class ScanResultModel {
  final int skuID;
  final String skuCode;
  final String skuName;
  final String brandName;
  final String brandImg;
  final String goodsName;
  final num discount;
  final num commission;
  final String goodsImg;

  ScanResultModel(
    this.skuID,
    this.skuCode,
    this.skuName,
    this.brandName,
    this.brandImg,
    this.goodsName,
    this.discount,
    this.commission,
    this.goodsImg,
  );

  Map<String, dynamic> toMap() {
    return {
      'skuID': skuID,
      'skuCode': skuCode,
      'skuName': skuName,
      'brandName': brandName,
      'brandImg': brandImg,
      'goodsName': goodsName,
      'discount': discount,
      'commission': commission,
      'goodsImg': goodsImg,
    };
  }

  factory ScanResultModel.fromMap(Map<String, dynamic> map) {
    return ScanResultModel(
      map['skuID'],
      map['skuCode'],
      map['skuName'],
      map['brandName'],
      map['brandImg'],
      map['goodsName'],
      map['discount'],
      map['commission'],
      map['goodsImg'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ScanResultModel.fromJson(String source) =>
      ScanResultModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ScanResultModel(skuID: $skuID, skuCode: $skuCode, skuName: $skuName, brandName: $brandName, brandImg: $brandImg, goodsName: $goodsName, discount: $discount, commission: $commission, goodsImg: $goodsImg)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ScanResultModel &&
      other.skuID == skuID &&
      other.skuCode == skuCode &&
      other.skuName == skuName &&
      other.brandName == brandName &&
      other.brandImg == brandImg &&
      other.goodsName == goodsName &&
      other.discount == discount &&
      other.commission == commission &&
      other.goodsImg == goodsImg;
  }

  @override
  int get hashCode {
    return skuID.hashCode ^
      skuCode.hashCode ^
      skuName.hashCode ^
      brandName.hashCode ^
      brandImg.hashCode ^
      goodsName.hashCode ^
      discount.hashCode ^
      commission.hashCode ^
      goodsImg.hashCode;
  }
}
