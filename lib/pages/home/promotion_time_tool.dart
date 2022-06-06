import 'package:recook/constants/header.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/models/goods_simple_list_model.dart';
import 'package:recook/models/promotion_goods_list_model.dart';

enum PromotionStatus{
  none,
  ready,  //预热中
  start,  //活动中
  end,    //已结束
  tomorrow//明日预告
}

class PromotionTimeTool{
  static getPromotionStatusWithTabbar(String? startTime, String? endTime){
    DateTime time = DateTime.now();
    // DateTime time = DateTime.parse("2020-03-18 23:00:00");
    if (!TextUtils.isEmpty(startTime) && !TextUtils.isEmpty(endTime)) {
      if (DateTime.parse(startTime!).isBefore(time) && DateTime.parse(endTime!).isAfter(time)) {  
        //活动中
        return PromotionStatus.start;
      }
      if (DateTime.parse(startTime).isAfter(time)){
        DateTime startDate = DateTime.parse(startTime);
        if (startDate.day != time.day) {
          return PromotionStatus.tomorrow;
        }else{
          return PromotionStatus.ready;
        }
      }
      if(DateTime.parse(endTime!).isBefore(time)){
        return PromotionStatus.end;
      }
      return PromotionStatus.none;
    }
    return PromotionStatus.none;
  }
  static getPromotionStatus(String? startTime, String? endTime){
    // DateTime time = DateTime.parse("2020-03-18 23:00:00");
    DateTime time = DateTime.now();
    if (!TextUtils.isEmpty(startTime) && !TextUtils.isEmpty(endTime)) {
      if (DateTime.parse(startTime!).isBefore(time) && DateTime.parse(endTime!).isAfter(time)) {  
        //活动中
        return PromotionStatus.start;
      }
      if (DateTime.parse(startTime).isAfter(time)){
        return PromotionStatus.ready;
      }
      if(DateTime.parse(endTime!).isBefore(time)){
        return PromotionStatus.end;
      }
      return PromotionStatus.none;
    }
    return PromotionStatus.none;
  }

  static getPromotionStatusWithGoodsSimple(GoodsSimple model){
    String? startTime = model.startTime;
    String? endTime = model.endTime;
    if (!TextUtils.isEmpty(startTime) && !TextUtils.isEmpty(endTime)) {
      if (DateTime.parse(startTime!).isBefore(DateTime.now()) && DateTime.parse(endTime!).isAfter(DateTime.now())) {  
        //活动中
        return PromotionStatus.start;
      }
      if (DateTime.parse(startTime).isAfter(DateTime.now())){
        return PromotionStatus.ready;
      }
      if(DateTime.parse(endTime!).isBefore(DateTime.now())){
        return PromotionStatus.end;
      }
      return PromotionStatus.none;
    }
    return PromotionStatus.none;
  }

  static getPromotionStatusWithPGModel(PromotionGoodsModel model){
    String? startTime = model.startTime;
    String? endTime = model.endTime;
    if (!TextUtils.isEmpty(startTime) && !TextUtils.isEmpty(endTime)) {
      if (DateTime.parse(startTime!).isBefore(DateTime.now()) && DateTime.parse(endTime!).isAfter(DateTime.now())) {  
        //活动中
        return PromotionStatus.start;
      }
      if (DateTime.parse(startTime).isAfter(DateTime.now())){
        return PromotionStatus.ready;
      }
      if(DateTime.parse(endTime!).isBefore(DateTime.now())){
        return PromotionStatus.end;
      }
      return PromotionStatus.none;
    }
    return PromotionStatus.none;
  }

  static getPromotionStatusWithGoodDetailModel(GoodsDetailModel model){
    bool hasPromotion = model.data!.promotion != null;
    if (!hasPromotion) {
      return PromotionStatus.none;
    }
    String? startTime = model.data!.promotion!.startTime;
    String? endTime = model.data!.promotion!.endTime;
    
    if (!TextUtils.isEmpty(startTime) && !TextUtils.isEmpty(endTime)) {
      if (DateTime.parse(startTime!).isBefore(DateTime.now()) && DateTime.parse(endTime!).isAfter(DateTime.now())) {  
        //活动中
        return PromotionStatus.start;
      }
      if (DateTime.parse(startTime).isAfter(DateTime.now())){
        return PromotionStatus.ready;
      }
      if(DateTime.parse(endTime!).isBefore(DateTime.now())){
        return PromotionStatus.end;
      }
      return PromotionStatus.none;
    }
    return PromotionStatus.none;
  }

}
