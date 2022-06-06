// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceListModel _$InvoiceListModelFromJson(Map<String, dynamic> json) {
  return InvoiceListModel(
      json['code'],
      (json['data'] as List?)
          ?.map((e) =>
             Invoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['msg']);
}

Map<String, dynamic> _$InvoiceListModelToJson(InvoiceListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };
