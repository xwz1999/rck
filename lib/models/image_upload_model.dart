/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-28  16:16 
 * remark    : 
 * ====================================================
 */

import 'package:recook/models/base_model.dart';
/*
{
    "code":"SUCCESS",
    "data":{
        "code":"SUCCESS",
        "msg":"上传成功",
        "data":{
            "url":"/photo/e8911861ac284c05f6ac7fa600a11515.jpg"
        }
    }
}
*/

import 'package:json_annotation/json_annotation.dart';

part 'image_upload_model.g.dart';


@JsonSerializable()
class ImageUploadModel extends BaseModel {

  Data? data;

  ImageUploadModel(code,msg,this.data,):super(code,msg);

  factory ImageUploadModel.fromJson(Map<String, dynamic> srcJson) => _$ImageUploadModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ImageUploadModelToJson(this);

}


@JsonSerializable()
class Data extends Object {

  String? url;

  Data(this.url,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}


