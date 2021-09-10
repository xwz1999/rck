
import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/buy_tickets/models/air_items_list_model.dart';
import 'package:recook/pages/buy_tickets/models/air_order_model.dart';
import 'package:recook/pages/buy_tickets/models/airline_model.dart';
import 'package:recook/pages/buy_tickets/models/airport_city_model.dart';
import 'package:recook/pages/buy_tickets/models/passager_model.dart';
import 'package:recook/pages/buy_tickets/models/submit_order_model.dart';
import 'package:recook/pages/goods/model/goods_report_model.dart';


class ReportFunc {
  //乘客列表
  static Future<List<PassagerModel>> getPassagerList(
    int userId,
  ) async {
    ResultData result = await HttpManager.post(
        APIV2.ticketAPI.getPassagerList, {'user_id': userId});

    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => PassagerModel.fromJson(e))
            .toList();
      }
    }
  }

  //添加乘客
  static Future<String> addPassager(
    int id,
    int userId,
    String name,
    String resident_id_card,
    String phone,
  ) async {
    ResultData result = await HttpManager.post(APIV2.ticketAPI.addPassager, {
      "id": id,
      'user_id': userId,
      "name": name,
      "resident_id_card": resident_id_card,
      "phone": phone,
      "is_default": 0,
    });

    if (result.data != null) {
      return result.data['code'];
    }
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
  }

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
    }
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
    }
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
    }
  }

  //提交订单接口
  static Future<SubmitOrderModel> submitAirOrder(
      String title,
      int goods_type,
      num amount_money,
      String from,
      String to,
      String from_date,
      String to_date,
      String from_port,
      String to_port,
      String line,
      String users,
      String phone,
      String fromCity,
      String toCity,
      String date) async {
    //goods_type 1为飞机票 title商品信息
    ResultData result = await HttpManager.post(APIV2.ticketAPI.submitAirOrder, {
      "user_id": UserManager.instance.user.info.id,
      "title": title,
      "goods_type": goods_type,
      "amount_money": amount_money,
      "from": from,
      "to": to,
      "from_date": from_date,
      "to_date": to_date,
      "from_port": from_port,
      "to_port": to_port,
      "line": line,
      "users": users,
      "phone": phone,
      "from_city": fromCity,
      "to_city": toCity,
      "date":date
    });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return SubmitOrderModel.fromJson(result.data['data']);
      }
    }
  }

  //飞机票订单支付接口 立方的支付
  static Future<String> airOrderPayLifang(
      int lf_order_id,
      String seatCode,
      String passagers,
      String itemId,
      String contactName,
      String contactTel,
      String date,
      String from,
      String to,
      String companyCode,
      String flightNo) async {
    ResultData result =
        await HttpManager.post(APIV2.ticketAPI.airOrderPayLifang, {
      "user_id": UserManager.instance.user.info.id,
      "lf_order_id": lf_order_id,
      "seatCode": seatCode,
      "passagers": passagers,
      "itemId": itemId,
      "contactName": contactName,
      "contactTel": contactTel,
      "date": date,
      "from": from,
      "to": to,
      "companyCode": companyCode,
      "flightNo": flightNo
    });
    if (result.data != null) {
      if (result.data['msg'] == 'ok') {
        return result.data['msg'];
      } else {
        return 'no';
      }
    }
    return 'no';
  }
}
