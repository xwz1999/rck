
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/manager/http_manager.dart';

import 'package:jingyaoyun/pages/goods/model/goods_report_model.dart';


class ReportFunc {


  //获取产品画像数据
  static Future<GoodsReportModel> getGoodsPortrait(int goodsId,int datType) async {
    ResultData result =
        await HttpManager.post(APIV2.goodsAPI.getProductPortrait, {
      "goods_id": goodsId,
      'day_type':datType
    });

    if (result.data != null) {
      if (result.data['data'] != null) {
          return GoodsReportModel.fromJson(
              result.data['data']);
      }
    }
  }

}
