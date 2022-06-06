/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-09-01  14:50 
 * remark    : 
 * ====================================================
 */

import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/home/classify/mvp/order_mvp/evaluation_list_contact.dart';

class EvaluationModelImpl extends EvaluationListModelI{
  @override
  getEvaluationList(int? userId, int? goodsId, int page) async{
    ResultData resultData = await HttpManager.post(GoodsApi.goods_evaluation_list, {
      "userId": userId,
      "goodsId":goodsId,
      "page": page
    });
    return resultData;
  }

  @override
  loadMore(int userId, int goodsId, int page) async {
    ResultData resultData = await HttpManager.post(GoodsApi.goods_evaluation_list, {
      "userId": userId,
      "goodsId":goodsId,
      "page": page
    });
    return resultData;
  }
}
