import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/services.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/weather_page/weather_city_model.dart';
import 'package:lpinyin/lpinyin.dart';

class WeatherCityTool {
  WeatherCityTool._();
  static WeatherCityTool? _instance;
  static List<WeatherCityModel> cityList = [];
  static WeatherCityTool? getInstance() {
    if (_instance == null) {
      _instance = WeatherCityTool._();
    }
    return _instance;
  }

  Future<dynamic> getCityList() async {
    if (cityList.length > 0) return cityList;
    String jsonString =
        await rootBundle.loadString("assets/json/weatherCity.json");
    List sourceJson = json.decode(jsonString);
    cityList = sourceJson.map((m) => WeatherCityModel.fromJson(m)).toList();
    _handleList(cityList);
    return cityList;
  }

  _handleList(List<WeatherCityModel> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].cityZh!);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      list[i].provinceZhPingyin = PinyinHelper.getPinyinE(list[i].provinceZh!);
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    SuspensionUtil.sortListBySuspensionTag(list);
  }

  searchWithQuery(String query, Function(List<WeatherCityModel>) searchBack) {
    WeatherCityTool.getInstance()!.getCityList().then((list) {
      if (!(list is List) || TextUtils.isEmpty(query)) {
        searchBack([]);
      }
      List<WeatherCityModel> modelList = list;
      List<WeatherCityModel> resultList = modelList.where((item) {
        if (item.cityZh!.startsWith(query) ||
            item.namePinyin!.toLowerCase().startsWith(query.toLowerCase()) ||
            item.provinceZh!.startsWith(query) ||
            item.provinceZhPingyin!
                .toLowerCase()
                .startsWith(query.toLowerCase())) {
          return true;
        }
        return false;
      }).toList();
      searchBack(resultList);
    });
  }
}
