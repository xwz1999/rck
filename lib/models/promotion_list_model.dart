import 'package:json_annotation/json_annotation.dart';

import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/models/base_model.dart';

part 'promotion_list_model.g.dart';


@JsonSerializable()
class PromotionListModel extends BaseModel {

  List<Promotion> data;

  PromotionListModel(code,this.data,msg,):super(code,msg);

  factory PromotionListModel.fromJson(Map<String, dynamic> srcJson) => _$PromotionListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PromotionListModelToJson(this);

}


@JsonSerializable()
class Promotion extends Object {

  int id;
  String promotionName;
  String startTime;
  String endTime;
  String showName;
  int isProcessing;

  String trueEndTime;

  Promotion(this.id,this.promotionName,this.startTime, this.endTime, this.showName, this.isProcessing,{this.trueEndTime});

  String getTrueEndTime(){
    if (TextUtils.isEmpty(trueEndTime)) {
      if (TextUtils.isEmpty(startTime)){
        return null;
      }else{
        trueEndTime = DateTime.parse(startTime).add(Duration(hours: 2)).toString();
      }
    }
    return trueEndTime;
  }

  factory Promotion.fromJson(Map<String, dynamic> srcJson) => _$PromotionFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PromotionToJson(this);

}

  
