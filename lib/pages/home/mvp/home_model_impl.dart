/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-29  11:40 
 * remark    : 
 * ====================================================
 */

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/manager/http_manager.dart';

import 'home_mvp_contact.dart';

class HomeModelImpl extends HomeMvpModelI{
  @override
  Future<ResultData> getBannerList() async {
    // ResultData resultData = await HttpManager.post(HomeApi.banner_list, {
    //     "userId":userId
    // });
    ResultData resultData = await HttpManager.post(HomeApi.banner_list, {});
    return resultData;
  }

  @override
  Future<ResultData> getPromotionList() async {
    // ResultData resultData = await HttpManager.post(HomeApi.promotion_list, {
    //   "userId":userId
    // });
    ResultData resultData = await HttpManager.post(HomeApi.promotion_list, {});
    return resultData;
  }

  @override
  Future<ResultData> getPromotionGoodsList(int promotionId) async {
    ResultData resultData = await HttpManager.post(HomeApi.promotion_goods_list, {
      "promotionId":promotionId,
      // "userId":userId
    });
    return resultData;
  }
}
