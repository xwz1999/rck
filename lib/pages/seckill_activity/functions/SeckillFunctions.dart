
import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/buy_tickets/models/air_items_list_model.dart';
import 'package:recook/pages/buy_tickets/models/air_order_model.dart';
import 'package:recook/pages/buy_tickets/models/airline_model.dart';
import 'package:recook/pages/buy_tickets/models/airport_city_model.dart';
import 'package:recook/pages/seckill_activity/model/SeckillModel.dart';


class SeckillFunc {
  //乘客列表
  static Future<SeckillModel> getSeckillList(
      ) async {
    ResultData result = await HttpManager.post(
        APIV2.goodsAPI.getSeckillList, {});

    if (result.data != null) {
      if (result.data['data'] != null) {
        return SeckillModel.fromJson(result.data['data']);
      }
      else
        return null;
    }
    else
      return null;
  }



  //删除乘客
  static Future<String> deletePassager(
      int id,
      ) async {
    ResultData result = await HttpManager.post(APIV2.ticketAPI.deletePassager, {
      "id": id,
    });

    if (result.data != null) {
      return result.data['code'];
    }
    else
      return 'FAIL';
  }

  //获取商品属性
  static Future<AirItemModel> getAirTicketGoodsList() async {
    ResultData result =
    await HttpManager.post(APIV2.ticketAPI.getAirTicketGoodsList, {
      "id": UserManager.instance.user.info.id,
    });

    if (result.data != null) {
      if (result.data['data'] != null) {
        if (result.data['data']['air_items_list_response'] != null)
          return AirItemModel.fromJson(
              result.data['data']['air_items_list_response']);
        else
          return AirItemModel();
      }
      else
        return AirItemModel();
    }
    else
      return AirItemModel();

  }

  //获取城市和机场列表
  static Future<List<AirportCityModel>> getCityAirportList() async {
    ResultData result =
    await HttpManager.post(APIV2.ticketAPI.getCityAirportList, {});
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => AirportCityModel.fromJson(e))
            .toList();
      }
      else
        return [];
    }
    else
      return [];
  }

  //获取两个城市之间的航线//输入的是两个城市间的站点选择城市则输入所有的站点
  static Future<List<AirLineModel>> getAirLineList(
      List<String> from, String itemId, String date, List<String> to) async {
    ResultData result = await HttpManager.post(APIV2.ticketAPI.getAirLineList, {
      'id': UserManager.instance.user.info.id,
      'from': from,
      'item_id': itemId,
      'date': date,
      'to': to
    });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => AirLineModel.fromJson(e))
            .toList();
      }
      else
        return [];
    }
    else
      return [];
  }

  //获取订单列表
  static Future<List<AirOrderModel>> getAirOrderList() async {
    ResultData result =
    await HttpManager.post(APIV2.ticketAPI.getAirOrderList, {
      'user_id': UserManager.instance.user.info.id,
    });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => AirOrderModel.fromJson(e))
            .toList();
      }
      else
        return [];
    }
    else
      return [];
  }

  //取消订单
  static Future<String> changeOrderStatus(
      int orderId,
      ) async {
    ResultData result = await HttpManager.post(APIV2.ticketAPI.changeOrderStatus, {
      'user_id':UserManager.instance.user.info.id,
      "order_id": orderId,
      'status':5
    });
    if (result.data != null) {
      return result.data['code'];
    }
    else
      return null;
  }


}
