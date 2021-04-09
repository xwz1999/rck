
/*
{
  "code": "SUCCESS",
  "data": [
    {
      "id": 1,
      "type": 1,
      "title": "qqq",
      "taxNo": "qqqqqqq"
    }
  ],
  "msg": "操作成功"
}
*/

import 'package:json_annotation/json_annotation.dart';

import 'package:recook/models/base_model.dart';
import 'package:recook/models/order_detail_model.dart';

part 'invoice_list_model.g.dart';


@JsonSerializable()
class InvoiceListModel extends BaseModel{

  List<Invoice> data;

  InvoiceListModel(code,this.data,msg,) : super(code,msg);

  factory InvoiceListModel.fromJson(Map<String, dynamic> srcJson) => _$InvoiceListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InvoiceListModelToJson(this);

}

