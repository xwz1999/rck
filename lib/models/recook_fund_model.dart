/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-29  11:25 
 * remark    : 
 * ====================================================
 */

import 'package:recook/models/base_model.dart';
/*
{
    "code":"SUCCESS",
    "msg":"操作成功",
    "data":{
        "id":2,
        "amount":0,
        "unrecordedAmount":0
    }
}
 */

import 'package:json_annotation/json_annotation.dart';

part 'recook_fund_model.g.dart';


@JsonSerializable()
class RecookFundModel extends BaseModel {

  Data data;

  RecookFundModel(code,msg,this.data,) : super(code,msg);

  factory RecookFundModel.fromJson(Map<String, dynamic> srcJson) => _$RecookFundModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RecookFundModelToJson(this);

}


@JsonSerializable()
class Data extends Object {

  int id;

  double amount;

  double unrecordedAmount;

  bool havePassword;

  num balance;

  Data(this.id,this.amount,this.unrecordedAmount, this.havePassword,this.balance);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}


