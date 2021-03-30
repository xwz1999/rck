/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/27  5:20 PM 
 * remark    : 
 * ====================================================
 */

import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'selling_point_list_contact.dart';

class SellingPointListModelImpl extends SellingPointListModelI {
  @override
  Future<ResultData> fetchList(int page) async {
    String url = GoodsApi.goods_sell_point_list;

    Map<String, dynamic> params = {
      "page": page
    };

    ResultData resultData =  await HttpManager.post(url, params);
    return resultData;
  }
}
