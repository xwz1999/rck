import 'dart:convert';

import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/buy_tickets/models/air_items_list_model.dart';
import 'package:recook/pages/buy_tickets/models/airline_model.dart';
import 'package:recook/pages/buy_tickets/models/airport_city_model.dart';
import 'package:recook/pages/buy_tickets/models/passager_model.dart';
import 'package:recook/utils/storage/hive_store.dart';

class PassagerFunc {
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
      'date': '2021-08-21',
      'to': to
    });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => AirLineModel.fromJson(e))
            .toList();
      }
    }
  }
}
