import 'package:jingyaoyun/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_prepay_model.g.dart';


@JsonSerializable()
class OrderPrepayModel extends BaseModel {

  Data data;

  OrderPrepayModel(code,this.data,msg,):super(code,msg);

  factory OrderPrepayModel.fromJson(Map<String, dynamic> srcJson) => _$OrderPrepayModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OrderPrepayModelToJson(this);

}


@JsonSerializable()
class Data extends Object {

  int id;

  int userId;

  double actualTotalAmount;

  int status;

  String createdAt;

  Data(this.id,this.userId,this.actualTotalAmount,this.status,this.createdAt,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}

  
