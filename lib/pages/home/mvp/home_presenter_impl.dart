/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-29  11:40 
 * remark    : 
 * ====================================================
 */

import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/banner_list_model.dart';
import 'package:jingyaoyun/models/promotion_goods_list_model.dart';
import 'package:jingyaoyun/models/promotion_list_model.dart';
import 'home_model_impl.dart';
import 'home_mvp_contact.dart';

class HomePresenterImpl extends HomeMvpPresenterI{
  @override
  getBannerList() async {
    ResultData resultData = await getModel().getBannerList();
    if (!resultData.result) {
      getView().requestFail(resultData.msg);
      return;
    }

    BannerListModel model = BannerListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getView().requestFail(model.msg);
      return;
    }
    getView().getBannerSuccess(model.data);
  }

  @override
  HomeMvpModelI initModel() {
    return HomeModelImpl();
  }

  @override
  getPromotionList() async {
    ResultData resultData = await getModel().getPromotionList();
    if (!resultData.result) {
      getView().requestFail(resultData.msg);
      return;
    }

    PromotionListModel model = PromotionListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getView().requestFail(model.msg);
      return;
    }
    getView().getPromotionListSuccess(model.data);
  }

  @override
  getPromotionGoodsList(int promotionId) async {
    ResultData resultData = await getModel().getPromotionGoodsList(promotionId);
    if (!resultData.result) {
      getView().requestFail(resultData.msg);
      return;
    }
    PromotionGoodsListModel model = PromotionGoodsListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getView().requestFail(model.msg);
      return;
    }
    getRefreshView().refreshSuccess(model.data);
  }
}
