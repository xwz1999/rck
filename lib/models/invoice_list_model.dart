
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

import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/order_detail_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invoice_list_model.g.dart';


@JsonSerializable()
class InvoiceListModel extends BaseModel{

  List<Invoice> data;

  InvoiceListModel(code,this.data,msg,) : super(code,msg);

  factory InvoiceListModel.fromJson(Map<String, dynamic> srcJson) => _$InvoiceListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InvoiceListModelToJson(this);

}

