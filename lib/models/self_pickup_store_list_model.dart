/*
{
  "code": "SUCCESS",
  "data": [
    {
      "id": 1,
      "token": "a76268c58ed930a838414a1cd05974f0",
      "name": "宁波总店",
      "address": "浙江省宁波市鄞州区第一大厦1990号"
    }
  ],
  "msg": "操作成功"
}
*/

import 'package:jingyaoyun/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'self_pickup_store_list_model.g.dart';


@JsonSerializable()
class SelfPickupStoreListModel extends BaseModel {

  List<SelfPickupStoreModel> data;

  SelfPickupStoreListModel(code,this.data,msg,) : super(code,msg);

  factory SelfPickupStoreListModel.fromJson(Map<String, dynamic> srcJson) => _$SelfPickupStoreListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SelfPickupStoreListModelToJson(this);

}


@JsonSerializable()
class SelfPickupStoreModel extends Object {

  int id;

  String token;

  String name;

  String address;

  SelfPickupStoreModel(this.id,this.token,this.name,this.address,);

  factory SelfPickupStoreModel.fromJson(Map<String, dynamic> srcJson) => _$SelfPickupStoreModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SelfPickupStoreModelToJson(this);

}

  
