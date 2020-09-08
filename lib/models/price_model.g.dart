// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Price _$PriceFromJson(Map<String, dynamic> json) {
  return Price(
      json['min'] == null
          ? null
          : Min.fromJson(json['min'] as Map<String, dynamic>),
      json['max'] == null
          ? null
          : Max.fromJson(json['max'] as Map<String, dynamic>));
}

Map<String, dynamic> _$PriceToJson(Price instance) =>
    <String, dynamic>{'min': instance.min, 'max': instance.max};

Min _$MinFromJson(Map<String, dynamic> json) {
  return Min(
      (json['originalPrice'] as num)?.toDouble(),
      (json['discountPrice'] as num)?.toDouble(),
      (json['commission'] as num)?.toDouble());
}

Map<String, dynamic> _$MinToJson(Min instance) => <String, dynamic>{
      'originalPrice': instance.originalPrice,
      'discountPrice': instance.discountPrice,
      'commission': instance.commission
    };

Max _$MaxFromJson(Map<String, dynamic> json) {
  return Max(
      (json['originalPrice'] as num)?.toDouble(),
      (json['discountPrice'] as num)?.toDouble(),
      (json['commission'] as num)?.toDouble());
}

Map<String, dynamic> _$MaxToJson(Max instance) => <String, dynamic>{
      'originalPrice': instance.originalPrice,
      'discountPrice': instance.discountPrice,
      'commission': instance.commission
    };
