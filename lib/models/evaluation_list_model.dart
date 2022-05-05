/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-09-01  14:46 
 * remark    : 
 * ====================================================
 */
import 'package:recook/models/base_model.dart';
/*
{
    "code": "SUCCESS",
    "data": {
        "code": "SUCCESS",
        "msg": "操作成功",
        "data": [
            {
                "id": 2,
                "goodsId": 10,
                "userId": 2,
                "nickname": "瑞库客6276",
                "headImgUrl": "/photo/252051585ad58089fe722f3fe369870a.jpg",
                "content": "haibucuo1",
                "createdAt": "2019-08-30 16:18:55",
                "photos": [
                    {
                        "id": 1,
                        "url": "/photo/a6017fce1a2c34d47763b7869fb3fb79.jpg",
                        "width": 4032,
                        "height": 3024
                    },
                    {
                        "id": 2,
                        "url": "/photo/043972d33295c448a079f9dc79a1c108.jpg",
                        "width": 3000,
                        "height": 2002
                    }
                ]
            }
        ]
    }
}
* */

import 'package:json_annotation/json_annotation.dart';

part 'evaluation_list_model.g.dart';


@JsonSerializable()
class EvaluationListModel extends BaseModel {

  List<Data> data;

  EvaluationListModel(code,msg,this.data,) : super(code,msg);

  factory EvaluationListModel.fromJson(Map<String, dynamic> srcJson) => _$EvaluationListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EvaluationListModelToJson(this);

}


@JsonSerializable()
class Data extends Object {

  int id;

  int goodsId;

  int userId;

  String nickname;

  String headImgUrl;

  String content;

  String createdAt;

  List<Photos> photos;

  Data(this.id,this.goodsId,this.userId,this.nickname,this.headImgUrl,this.content,this.createdAt,this.photos,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}


@JsonSerializable()
class Photos extends Object {

  int id;

  String url;

  int width;

  int height;

  Photos(this.id,this.url,this.width,this.height,);

  factory Photos.fromJson(Map<String, dynamic> srcJson) => _$PhotosFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PhotosToJson(this);

}


