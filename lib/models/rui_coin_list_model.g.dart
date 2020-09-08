// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'rui_coin_list_model.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// RuiCoinListModel _$RuiCoinListModelFromJson(Map<String, dynamic> json) {
//   return RuiCoinListModel(
//       json['code'],
//       json['msg'],
//       json['data'] == null
//           ? null
//           : RuiCoinModel.fromJson(json['data'] as Map<String, dynamic>));
// }

// Map<String, dynamic> _$RuiCoinListModelToJson(RuiCoinListModel instance) =>
//     <String, dynamic>{
//       'code': instance.code,
//       'msg': instance.msg,
//       'data': instance.data
//     };

// RuiCoinModel _$RuiCoinModelFromJson(Map<String, dynamic> json) {
//   return RuiCoinModel(
//       (json['amount'] as num)?.toDouble(),
//       (json['detail'] as List)
//           ?.map((e) =>
//               e == null ? null : Detail.fromJson(e as Map<String, dynamic>))
//           ?.toList());
// }

// Map<String, dynamic> _$RuiCoinModelToJson(RuiCoinModel instance) =>
//     <String, dynamic>{'amount': instance.amount, 'detail': instance.detail};

// Detail _$DetailFromJson(Map<String, dynamic> json) {
//   return Detail(
//       json['id'] as int,
//       json['type'] as int,
//       json['number'] as int,
//       json['title'] as String,
//       json['channel'] as String,
//       json['orderID'] as int,
//       json['createdAt'] as String,
//       json['amount'] as num,);
// }

// Map<String, dynamic> _$DetailToJson(Detail instance) => <String, dynamic>{
//       'id': instance.id,
//       'type': instance.type,
//       'number': instance.number,
//       'title': instance.title,
//       'channel': instance.channel,
//       'orderID': instance.orderID,
//       'createdAt': instance.createdAt,
//       'amount': instance.amount
//     };
