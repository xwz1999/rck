/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/27  4:14 PM 
 * remark    : 
 * ====================================================
 */

import 'package:jingyaoyun/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';


@JsonSerializable()
class CategoryModel extends BaseModel {

  List<FirstCategory> data;

  CategoryModel(code,this.data,msg,): super(code, msg);

  factory CategoryModel.fromJson(Map<String, dynamic> srcJson) => _$CategoryModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

}


@JsonSerializable()
class FirstCategory extends Object {

  int id;

  String name;

  int parentId;

  String logoUrl;

  List<SecondCategory> sub;

  FirstCategory(this.id,this.name,this.parentId,this.logoUrl,this.sub,);

  factory FirstCategory.fromJson(Map<String, dynamic> srcJson) => _$FirstCategoryFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FirstCategoryToJson(this);

}


@JsonSerializable()
class SecondCategory extends Object {

  int id;

  String name;

  int parentId;

  String logoUrl;

  SecondCategory(this.id,this.name,this.parentId,this.logoUrl,);

  factory SecondCategory.fromJson(Map<String, dynamic> srcJson) => _$SecondCategoryFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SecondCategoryToJson(this);

}


