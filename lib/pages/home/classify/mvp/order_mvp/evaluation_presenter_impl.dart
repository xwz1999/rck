/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-09-01  14:50 
 * remark    : 
 * ====================================================
 */

import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/evaluation_list_model.dart';
import 'package:jingyaoyun/pages/home/classify/mvp/order_mvp/evaluation_list_contact.dart';

import 'evaluation_model_impl.dart';

class EvaluationPresenterImpl extends EvaluationListPresenterI{
  @override
  EvaluationListModelI initModel() {
    return EvaluationModelImpl();
  }

  @override
  getEvaluationList(int userId, int goodsId, int page) async {
    ResultData resultData = await getModel().getEvaluationList(userId, goodsId, page);
    if (!resultData.result) {
      getRefreshView().failure(resultData.msg);
      return;
    }
    EvaluationListModel listModel = EvaluationListModel.fromJson(resultData.data);
    if (listModel.code != HttpStatus.SUCCESS) {
      getRefreshView().failure(resultData.msg);
      return;
    }
    getRefreshView().refreshSuccess(listModel.data);
  }

  @override
  loadMore(int userId, int goodsId, int page) async {
    ResultData resultData = await getModel().getEvaluationList(userId, goodsId, page);
    if (!resultData.result) {
      getRefreshView().loadMoreFailure(error: resultData.msg);
      return;
    }
    EvaluationListModel listModel = EvaluationListModel.fromJson(resultData.data);
    if (listModel.code != HttpStatus.SUCCESS) {
      getRefreshView().loadMoreFailure(error: resultData.msg);
      return;
    }
    getRefreshView().loadMoreSuccess(listModel.data);
  }
}
