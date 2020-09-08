import 'package:json_annotation/json_annotation.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/price_model.dart';

part 'goods_list_model.g.dart';


@JsonSerializable()
class GoodsListModel extends BaseModel {

  List<Goods> data;

  GoodsListModel(code,this.data,msg,) : super(code, msg);

  factory GoodsListModel.fromJson(Map<String, dynamic> srcJson) => _$GoodsListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GoodsListModelToJson(this);

}


@JsonSerializable()
class Goods extends Object {

  int id;

  int brandId;

  String goodsName;

  String description;

  int firstCategoryId;

  int secondCategoryId;

  int commissionRate;

  double discount;

  Price price;

  int inventory;

  int salesVolume;

  String url;

  String promotionName;

  Goods(this.id,this.brandId,this.goodsName,this.description,this.firstCategoryId,this.secondCategoryId,this.commissionRate,this.discount,this.price,this.inventory,this.salesVolume,this.url,this.promotionName);

  factory Goods.fromJson(Map<String, dynamic> srcJson) => _$GoodsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GoodsToJson(this);

}