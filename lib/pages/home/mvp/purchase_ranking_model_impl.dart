import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/pages/home/mvp/purchase_ranking_contact.dart';

class PurchaseRankingModelImpl extends PurchaseRankingModelI {
  @override
  Future<ResultData> fetchList(int page) async {
    String url = GoodsApi.goods_purchase_ranking;

    Map<String, dynamic> params = {
      "page": page
    };

    ResultData resultData =  await HttpManager.post(url, params);
    return resultData;
  }
}
