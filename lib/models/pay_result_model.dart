/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-16  09:14 
 * remark    : 
 * ====================================================
 */

import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'pay_result_model.g.dart';


@JsonSerializable()
class PayResultModel extends BaseModel {

  PayResult data;

  PayResultModel(code,this.data,msg,) : super(code,msg);

  factory PayResultModel.fromJson(Map<String, dynamic> srcJson) => _$PayResultModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PayResultModelToJson(this);

}


@JsonSerializable()
class PayResult extends Object {
  /// 0：未支付  1：已支付
  int status;

  PayResult(this.status,);

  factory PayResult.fromJson(Map<String, dynamic> srcJson) => _$PayResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PayResultToJson(this);

}

  
