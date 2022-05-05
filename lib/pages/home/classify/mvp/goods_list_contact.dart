/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/27  5:15 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/models/goods_simple_list_model.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';

enum SortType { comprehensive, priceAsc, priceDesc, salesAsc, salesDesc }

abstract class GoodsListPresenterI
    extends MvpListViewPresenterI<GoodsSimple, GoodListViewI, GoodListModelI> {
  fetchList(int categoryID, int page, SortType type,int countryId,
      {String keyword, VoidCallback onLoadDone});
  fetchBrandList(int brandId, int page, SortType type);
  fetchSearchList(String keyword, int page);
}

abstract class GoodListModelI extends MvpModel {
  fetchList(int categoryID, int page, SortType type,int countryId, {String keyword,int JDType});
  fetchBrandList(int brandId, int page, SortType type);
  fetchSearchList(String keyword, int page);
}

abstract class GoodListViewI extends MvpView {}
