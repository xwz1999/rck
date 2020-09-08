// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'user_brief_info_model.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// UserBriefInfoModel _$UserBriefInfoModelFromJson(Map<String, dynamic> json) {
//   return UserBriefInfoModel(
//       json['code'],
//       json['data'] == null
//           ? null
//           : UserBrief.fromJson(json['data'] as Map<String, dynamic>),
//       json['msg']);
// }

// Map<String, dynamic> _$UserBriefInfoModelToJson(UserBriefInfoModel instance) =>
//     <String, dynamic>{
//       'code': instance.code,
//       'msg': instance.msg,
//       'data': instance.data
//     };

// UserBrief _$UserBriefFromJson(Map<String, dynamic> json) {
//   return UserBrief(
//       (json['role'] as int),
//       (json['amount'] as num)?.toDouble(),
//       json['asset'] == null
//           ? null
//           : Asset.fromJson(json['asset'] as Map<String, dynamic>),
//       json['order'] == null
//           ? null
//           : Order.fromJson(json['order'] as Map<String, dynamic>),
//       json['versionInfo'] == null
//           ? null
//           : VersionInfo.fromJson(json['versionInfo'] as Map<String, dynamic>),
//       (json['inviteCount'] as int),
//       (json["advice"] as String),
//       json['buy'] == null
//           ? null
//           : Buy.fromJson(json['buy'] as Map<String, dynamic>),
//           );
// }

// Map<String, dynamic> _$UserBriefToJson(UserBrief instance) => <String, dynamic>{
//       'role': instance.role,
//       'amount': instance.amount,
//       'asset': instance.asset,
//       'order': instance.order,
//       'versionInfo': instance.versionInfo,
//       'inviteCount': instance.inviteCount,
//       'advice': instance.advice,
//       'buy': instance.buy,
//     };

// Buy _$BuyFromJson(Map<String, dynamic> json) {
//   return Buy(
//       (json['commission'] as num)?.toDouble(),
//       (json['frozenCommission'] as num)?.toDouble(),
//       (json['cumulativeCommission'] as num)?.toDouble(),
//   );
// }

// Map<String, dynamic> _$BuyToJson(Buy instance) => <String, dynamic>{
//       'commission': instance.commission,
//       'frozenCommission': instance.frozenCommission,
//       'cumulativeCommission': instance.cumulativeCommission
//     };

// Asset _$AssetFromJson(Map<String, dynamic> json) {
//   return Asset(
//       // (json['fund'] as num)?.toDouble(),
//       // (json['monthUnrecordedFund'] as num)?.toDouble(),
//       json['coin'] as int,
//       json['couponCount'] as int,
//       json['favoritesCount'] as int);
// }

// Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
//       // 'fund': instance.fund,
//       // 'monthUnrecordedFund': instance.monthUnrecordedFund,
//       'coin': instance.coin,
//       'couponCount': instance.couponCount,
//       'favoritesCount': instance.favoritesCount
//     };

// Order _$OrderFromJson(Map<String, dynamic> json) {
//   return Order(json['unpaidCount'] as int, json['noShipCount'] as int,
//       json['noReceiveCount'] as int);
// }

// Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
//       'unpaidCount': instance.unpaidCount,
//       'noShipCount': instance.noShipCount,
//       'noReceiveCount': instance.noReceiveCount
//     };

// VersionInfo _$VersionInfoFromJson(Map<String, dynamic> json) {
//   return VersionInfo(
//     json['version'] as String, 
//     json['desc'] as String,
//     json['createdAt'] as String,
//     json['build'] as int,);
// }

// Map<String, dynamic> _$VersionInfoToJson(VersionInfo instance) => <String, dynamic>{
//       'version': instance.version,
//       'desc': instance.desc,
//       'createdAt': instance.createdAt,
//       'build': instance.build,
//     };
