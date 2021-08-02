import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:azlistview/azlistview.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:recook/constants/api_v2.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/buy_tickets/models/airport_city_model.dart';
import 'package:recook/widgets/weather_page/weather_city_model.dart';

class AriportCityTool {
  AriportCityTool._();
  static AriportCityTool _instance;
  static List<AirportCityModel> cityModelList = [];

  static AriportCityTool getInstance() {
    if (_instance == null) {
      _instance = AriportCityTool._();
    }
    return _instance;
  }

  //获取城市和机场列表
  Future<List<AirportCityModel>> getCityAirportList() async {
    ResultData result =
        await HttpManager.post(APIV2.ticketAPI.getCityAirportList, {});
    if (result.data != null) {
      if (result.data['data'] != null) {
        print('11111111');
        List<AirportCityModel> _list = _handleList((result.data['data'] as List)
            .map((e) => AirportCityModel.fromJson(e))
            .toList());
        return _list;
      } else {
        return [];
      }
    }
  }

  List<AirportCityModel> _handleList(List<AirportCityModel> list) {
    if (list == null || list.isEmpty)
      return [];
    else {
      list.removeAt(0);
    }
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].city);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      // list[i].provinceZhPingyin = PinyinHelper.getPinyinE(list[i].provinceZh);
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    SuspensionUtil.sortListBySuspensionTag(list);
    return list;
  }

  searchWithQuery(String query, Function(List<AirportCityModel>) searchBack) {
    AriportCityTool.getInstance().getCityAirportList().then((list) {
      if (!(list is List) || TextUtils.isEmpty(query)) {
        searchBack([]);
      }
      List<AirportCityModel> modelList = list;
      List<AirportCityModel> resultList = modelList.where((item) {
        if (item.city.startsWith(query) ||
            item.namePinyin.toLowerCase().startsWith(query.toLowerCase())) {
          return true;
        }
        return false;
      }).toList();
      searchBack(resultList);
    });
  }
}
