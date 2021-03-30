/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-25  17:01 
 * remark    : 
 * ====================================================
 */

import 'package:json_annotation/json_annotation.dart';

part 'price_model.g.dart';

@JsonSerializable()
class Price extends Object {
  Min min;

  Max max;

  Price(
    this.min,
    this.max,
  );

  factory Price.fromJson(Map<String, dynamic> srcJson) =>
      _$PriceFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PriceToJson(this);
}

@JsonSerializable()
class Min extends Object {
  double originalPrice;

  double discountPrice;

  double commission;

  double ferme;

  Min(
    this.originalPrice,
    this.discountPrice,
    this.commission,
    this.ferme,
  );

  factory Min.fromJson(Map<String, dynamic> srcJson) => _$MinFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MinToJson(this);
}

@JsonSerializable()
class Max extends Object {
  double originalPrice;

  double discountPrice;

  double commission;

  Max(
    this.originalPrice,
    this.discountPrice,
    this.commission,
  );

  factory Max.fromJson(Map<String, dynamic> srcJson) => _$MaxFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MaxToJson(this);
}
