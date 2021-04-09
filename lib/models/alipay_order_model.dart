import 'package:json_annotation/json_annotation.dart';

import 'package:recook/models/base_model.dart';

part 'alipay_order_model.g.dart';


@JsonSerializable()
class AlipayOrderModel extends BaseModel{

  Data data;

  AlipayOrderModel(code,this.data,msg,):super(code,msg);

  factory AlipayOrderModel.fromJson(Map<String, dynamic> srcJson) => _$AlipayOrderModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AlipayOrderModelToJson(this);

}


@JsonSerializable()
class Data extends Object {

  String orderString;

  Data(this.orderString,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}

  
