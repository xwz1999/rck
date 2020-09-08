/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-16  17:00 
 * remark    : 
 * ====================================================
 */

import 'package:json_annotation/json_annotation.dart';

part 'express_company_model.g.dart';


@JsonSerializable()
class ExpressCompanyModel extends Object {

  String code;

  List<String> data;

  String msg;

  ExpressCompanyModel(this.code,this.data,this.msg,);

  factory ExpressCompanyModel.fromJson(Map<String, dynamic> srcJson) => _$ExpressCompanyModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ExpressCompanyModelToJson(this);

}


