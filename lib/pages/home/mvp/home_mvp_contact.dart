/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-29  11:35 
 * remark    : 
 * ====================================================
 */


import 'package:recook/models/banner_list_model.dart';
import 'package:recook/models/promotion_goods_list_model.dart';
import 'package:recook/models/promotion_list_model.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';

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
