import 'package:jingyaoyun/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'banner_list_model.g.dart';


@JsonSerializable()
class BannerListModel extends BaseModel {

  List<BannerModel> data;

  BannerListModel(code,this.data,msg) : super(code, msg);

  factory BannerListModel.fromJson(Map<String, dynamic> srcJson) => _$BannerListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BannerListModelToJson(this);

}


@JsonSerializable()
class BannerModel extends Object {

  int id;

  int goodsId;

  String url;

  String createdAt;

  String activityUrl;

  String color;


  BannerModel(this.id,this.goodsId,this.url,this.createdAt, this.activityUrl, this.color);

  factory BannerModel.fromJson(Map<String, dynamic> srcJson) => _$BannerModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);

}

  
