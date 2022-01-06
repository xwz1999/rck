/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-26  14:40 
 * remark    : 
 * ====================================================
 */

import 'package:jingyaoyun/models/base_model.dart';
/*
{
    "code": "SUCCESS",
    "data": {
        "code": "SUCCESS",
        "msg": "操作成功",
        "data": [
            {
                "favoriteId": 1,
                "goods": {
                    "id": 14,
                    "goodsName": "Beanpole 户外女装速干衣服 男女通用",
                    "url": "/photo/1561447503104724.png",
                    "discountPrice": 0.02
                }
            },
            {
                "favoriteId": 10,
                "goods": {
                    "id": 16,
                    "goodsName": "阿迪达斯三叶草☘️ 经典 古天乐同款小白衣服",
                    "url": "/photo/1561704938561871.jpg",
                    "discountPrice": 0.03
                }
            },
            {
                "favoriteId": 5,
                "goods": {
                    "id": 21,
                    "goodsName": "测试主图测试主图",
                    "url": "/photo/9f396fd2ab6a5e2f09c9645b04f15a61.png",
                    "discountPrice": 176
                }
            }
        ]
    }
}
*/

import 'package:json_annotation/json_annotation.dart';

part 'my_favorites_list_model.g.dart';


@JsonSerializable()
class MyFavoritesListModel extends BaseModel {

  List<FavoriteModel> data;

  MyFavoritesListModel(code,this.data,msg) : super(code,msg);

  factory MyFavoritesListModel.fromJson(Map<String, dynamic> srcJson) => _$MyFavoritesListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MyFavoritesListModelToJson(this);

}


@JsonSerializable()
class FavoriteModel extends Object {

  int favoriteId;

  FavoriteGoods goods;

  FavoriteModel(this.favoriteId,this.goods,);

  factory FavoriteModel.fromJson(Map<String, dynamic> srcJson) => _$FavoriteModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);

}


@JsonSerializable()
class FavoriteGoods extends Object {

  int id;
  String description;
  String goodsName;

  String mainPhotoUrl;

  double discountPrice;

  FavoriteGoods(
    this.id,
    this.description,
    this.goodsName,
    this.mainPhotoUrl,
    this.discountPrice,);

  factory FavoriteGoods.fromJson(Map<String, dynamic> srcJson) => _$FavoriteGoodsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FavoriteGoodsToJson(this);

}

  
