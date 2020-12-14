/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/27  5:19 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/goods_simple_list_model.dart';
import 'goods_list_contact.dart';
import 'goods_list_model_impl.dart';

class GoodsListPresenterImpl extends GoodsListPresenterI {
  @override
  GoodListModelI initModel() {
    return GoodsListModelImpl();
  }

  @override
  fetchSearchList(String keyword, int page) {
    getModel().fetchSearchList(keyword, page).then((ResultData response) {
      if (!response.result) {
        getRefreshView().refreshFailure(response.msg);
      } else {
//        getRefreshView().refreshSuccess([]);
        GoodsSimpleListModel model =
            GoodsSimpleListModel.fromJson(response.data);
        if (model.code == HttpStatus.SUCCESS) {
          if (page == 0) {
            getRefreshView().refreshSuccess(model.data);
          } else {
            getRefreshView().loadMoreSuccess(model.data);
          }
        } else {
          if (page == 0) {
            getRefreshView().refreshFailure(model.msg);
          } else {
            getRefreshView().loadMoreFailure(error: model.msg);
          }
        }
      }
    });
  }

  @override
  fetchBrandList(int brandId, int page, SortType type) {
    getModel().fetchBrandList(brandId, page, type).then((ResultData response) {
      if (!response.result) {
        getRefreshView().refreshFailure(response.msg);
      } else {
//        getRefreshView().refreshSuccess([]);
        GoodsSimpleListModel model =
            GoodsSimpleListModel.fromJson(response.data);
        if (model.code == HttpStatus.SUCCESS) {
          if (page == 0) {
            getRefreshView().refreshSuccess(model.data);
          } else {
            getRefreshView().loadMoreSuccess(model.data);
          }
        } else {
          if (page == 0) {
            getRefreshView().refreshFailure(model.msg);
          } else {
            getRefreshView().loadMoreFailure(error: model.msg);
          }
        }
      }
    });
  }

  @override
  fetchList(int categoryID, int page, SortType type,
      {String keyword, VoidCallback onLoadDone}) async {
    return await getModel()
        .fetchList(categoryID, page, type, keyword: keyword)
        .then((ResultData response) {
      if (!response.result) {
        getRefreshView().refreshFailure(response.msg);
      } else {
//        getRefreshView().refreshSuccess([]);
        GoodsSimpleListModel model =
            GoodsSimpleListModel.fromJson(response.data);
        if (model.code == HttpStatus.SUCCESS) {
          if (page == 0) {
            getRefreshView().refreshSuccess(model.data);
          } else {
            getRefreshView().loadMoreSuccess(model.data);
          }
        } else {
          if (page == 0) {
            getRefreshView().refreshFailure(model.msg);
          } else {
            getRefreshView().loadMoreFailure(error: model.msg);
          }
        }
      }
      if (onLoadDone != null) onLoadDone();
    });
  }
}
