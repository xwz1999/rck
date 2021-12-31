import 'package:jingyaoyun/models/order_detail_model.dart' as order_detail_model;
import 'package:jingyaoyun/models/order_list_model.dart';

class GoodsStatusTool {
  static goodsExpressStatusOrderDetailModel(order_detail_model.Goods goods) {
    switch (goods.expressStatus) {
      case 0:
        return "待发货";
      case 1:
        return "已发货";
    }
  }
  static goodsExpressStatusOrderGoodsModel(OrderGoodsModel goods){
    switch (goods.expressStatus) {
      case 0:
        return "待发货";
      case 1:
        return "已发货";
      default:
        return "";
        break;
    }
  }
  _expressStatus(OrderModel goods) {
    if (goods.status != 1) return "";
    switch (goods.expressStatus) {
      case 0:
        return "待发货";
      case 2:
        return "全部发货";
      case 1:
        return "部分发货";
    }
  }
}
