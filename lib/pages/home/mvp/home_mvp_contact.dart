/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-29  11:35 
 * remark    : 
 * ====================================================
 */


import 'package:jingyaoyun/models/banner_list_model.dart';
import 'package:jingyaoyun/models/promotion_goods_list_model.dart';
import 'package:jingyaoyun/models/promotion_list_model.dart';
import 'package:jingyaoyun/utils/mvp.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view_contact.dart';

abstract class HomeMvpPresenterI
    extends MvpListViewPresenterI<PromotionGoodsModel, HomeMvpViewI, HomeMvpModelI> {

  getBannerList();
  getPromotionList();
  getPromotionGoodsList(int promotionId);
}

abstract class HomeMvpModelI extends MvpModel {
  getBannerList();
  getPromotionList();
  getPromotionGoodsList(int promotionId);
}

abstract class HomeMvpViewI extends MvpView {
  getBannerSuccess(List<BannerModel> list);
  getPromotionListSuccess(List<Promotion> promotions);
  requestFail(String msg);
}
