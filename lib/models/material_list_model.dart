/*
{"code":"SUCCESS",
	"data":{"code":"SUCCESS","msg":"操作成功",
		"data":
		[{"id":5,
			"goodsId":14,
			"text":"Beanpole 户外女装速干衣服 男女通用文案",
			"userId":1,
			"headImgUrl":"/default/officaillogo.png",
			"nickname":"瑞库客官方",
			"createdAt":"2019-09-09 09:30:24",
			"isAttention":true,
			"photos":
			[
				{
					"id":4,
					"momentsCopyId":5,
					"url":"/photo/9845832c35a105007d5f587dbb7dcec4.jpg",
					"width":770,
					"height":778
				},
			],
			"Goods":
			{
				"mainPhotoURL":"/photo/1561447503104724.png",
				"name":"Beanpole 户外女装速干衣服 男女通用",
				"price":0.02
			}
		}
	]
	}
}

*/

import 'package:json_annotation/json_annotation.dart';

import 'package:recook/models/base_model.dart';

part 'material_list_model.g.dart';


@JsonSerializable()
class MaterialListModel extends BaseModel {

  List<MaterialModel> data;

  MaterialListModel(code,this.data,msg,) : super(code,msg);

  factory MaterialListModel.fromJson(Map<String, dynamic> srcJson) => _$MaterialListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MaterialListModelToJson(this);

}


@JsonSerializable()
class MaterialModel extends Object {

  int id;

  int goodsId;

  String text;

  int userId;

  String nickname;

  String headImgUrl;

  String createdAt;
  
  bool isAttention;

  List<Photos> photos;
  // List<Goods> goods;
  Goods goods;
  bool isOfficial;

  MaterialModel(
    this.id,
    this.goodsId,
    this.text,
    this.userId,
    this.nickname,
    this.headImgUrl,
    this.createdAt,
    this.isAttention,
    this.photos,
    this.goods,
    this.isOfficial
    );

  factory MaterialModel.fromJson(Map<String, dynamic> srcJson) => _$MaterialModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MaterialModelToJson(this);

}


@JsonSerializable()
class Photos extends Object {

  int id;

  int momentsCopyId;

  String url;

  int width;

  int height;

  Photos(this.id, this.momentsCopyId,this.url,this.width,this.height,);

  factory Photos.fromJson(Map<String, dynamic> srcJson) => _$PhotosFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PhotosToJson(this);

}

@JsonSerializable()
class Goods extends Object {

  String mainPhotoURL;  
  String name;
  num price;
  int id;

  Goods(this.mainPhotoURL,this.name,this.price,this.id);

  factory Goods.fromJson(Map<String, dynamic> srcJson) => _$GoodsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GoodsToJson(this);

}
