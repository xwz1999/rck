// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recook_fund_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecookFundModel _$RecookFundModelFromJson(Map<String, dynamic> json) {
  return RecookFundModel(
      json['code'],
      json['msg'],
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$RecookFundModelToJson(RecookFundModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    json['id'] as int, 
    (json['amount'] as num)?.toDouble(),
    (json['unrecordedAmount'] as num)?.toDouble(),
    json['havePassword'] as bool,
    json['balance'] as num
    );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'balance':instance.balance,
      'unrecordedAmount': instance.unrecordedAmount,
      'havePassword': instance.havePassword,
    };
