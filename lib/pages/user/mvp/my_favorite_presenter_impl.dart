/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-26  15:11 
 * remark    : 
 * ====================================================
 */

import 'package:recook/base/http_result_model.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/my_favorites_list_model.dart';
import 'package:recook/pages/user/mvp/my_favorite_model_impl.dart';

import 'my_favorite_contact.dart';

class MyFavoritePresenterImpl extends MyFavoritePresenterI {
  @override
  MyFavoriteModelI initModel() {
    return MyFavoriteModelImpl();
  }

  @override
  getFavoritesList(int? userId) async{
    ResultData resultData = await getModel()!.getFavoritesList(userId);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    MyFavoritesListModel model = MyFavoritesListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    getRefreshView()?.refreshSuccess(model.data);
    return HttpResultModel(model.code, model, model.msg, true);
  }

  @override
  Future<HttpResultModel<BaseModel?>> favoriteAdd(int userID, int goodsID) async {
    ResultData resultData = await getModel()!.favoriteAdd(userID, goodsID);

    if (!resultData.result) {
      getRefreshView()?.failure(resultData.msg);
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getRefreshView()?.failure(model.msg);
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }

  @override
  Future<HttpResultModel<BaseModel?>> favoriteCancel(int? userID, FavoriteModel favoriteModel) async {
    ResultData resultData = await getModel()!.favoriteCancel(userID, favoriteModel.goods!.id);
    if (!resultData.result) {
      getRefreshView()!.failure(resultData.msg);
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getRefreshView()!.failure(model.msg);
      return HttpResultModel(model.code, null, model.msg, false);
    }
    getView()?.cancelFavoriteSuccess(favoriteModel);
    return HttpResultModel(model.code, model, model.msg, true);
  }
}
