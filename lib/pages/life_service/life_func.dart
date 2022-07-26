import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:power_logger/power_logger.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/life_service/ConstellationModel.dart';
import 'package:recook/models/life_service/FigureModel.dart';
import 'package:recook/models/life_service/IdiomModel.dart';
import 'package:recook/models/life_service/birth_flower_model.dart';
import 'package:recook/models/life_service/foot_rank_model.dart';
import 'package:recook/models/life_service/hot_person_model.dart';
import 'package:recook/models/life_service/hot_video_model.dart';
import 'package:recook/models/life_service/hw_calculator_model.dart';
import 'package:recook/models/life_service/joke_model.dart';
import 'package:recook/models/life_service/loan_model.dart';
import 'package:recook/models/life_service/nba_model.dart';
import 'package:recook/models/life_service/nba_rank_model.dart';
import 'package:recook/models/life_service/news_detail_model.dart';
import 'package:recook/models/life_service/news_model.dart';
import 'package:recook/models/life_service/sudoku_model.dart';
import 'package:recook/models/life_service/zodiac_model.dart';

class LifeFunc {

  static Future<Response?> getJuHe(
      String url, String params, String key,{bool isList =false}) async {
    return await HttpManager.netFetchNormal(
       ( isList?APIV2.juHeAPI.juHeMainList: APIV2.juHeAPI.juHeMain) + url + '?key=' + key + params,
        null,
        null,
        Options(method: "post", sendTimeout: 5000, receiveTimeout: 5000));
  }

  ///生日花语
  static Future<BirthFlowerModel?> getBirthFlower(String keyWord) async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.srhy,
        '&keyword=$keyWord',
        APIV2.juHeAPI.srhyKey);
    if (res == null) {
      return null;
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    BirthFlowerModel? model;
    model = BirthFlowerModel.fromJson(map['result'] as Map<String, dynamic>);
    return model;
  }


  ///新闻列表
  static Future<List<NewsModel>?> getNewsList(int page) async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.xwtt,
        '&type=top&page=${page}&page_size=10&is_filter=1',
        APIV2.juHeAPI.xwttKey,isList: true);

    if (res == null) {
      return [];
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    List<NewsModel>? model;
    print(map['result']);
    if(map['result']['data']!=null){
      model =  (map['result']['data'] as List).map((e) => NewsModel.fromJson(e)).toList();
    }else{
      model = [];
    }
    // model = (map['result'] as Map<String, dynamic>).map((e) => NewsModel.fromJson(e)).toList();
    return model;
  }

///新闻详情
  static Future<NewsDetailModel?> getNewsDetailModel(String key) async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.xwttXq,
        '&uniquekey=$key',
        APIV2.juHeAPI.xwttKey,isList: true);
    if (res == null) {
      return null;
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    NewsDetailModel? model;
    model = NewsDetailModel.fromJson(map['result'] as Map<String, dynamic>);
    return model;
  }

  ///热门视频列表
  static Future<List<HotVideoModel>?> getHotVideoList(String type) async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.rmsp,
        '&type=$type',
        APIV2.juHeAPI.rmspKey);

    if (res == null) {
      return [];
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    List<HotVideoModel>? model;
    print(map['result']);
    if(map['result']!=null){
      model =  (map['result'] as List).map((e) => HotVideoModel.fromJson(e)).toList();
    }else{
      model = [];
    }
    return model;
  }


  ///热门视频达人列表
  static Future<List<HotPersonModel>?> getHotPersonList(int index,int offset) async {
    String type = '';
    switch(index){
      case 1:
        type = 'amusement_new';
        break;
      case 2:
        type = 'game_console';
        break;
      case 3:
        type = 'food_new';
        break;
      case 4:
        type = 'car_comment';
        break;
      case 5:
        type = 'travel_new';
        break;
      case 6:
        type = 'sport_overall';
        break;
      case 7:
        type = 'cospa_overall';
        break;
    }
    Response? res = await getJuHe(
        APIV2.juHeAPI.rmsp,
        '&type=$type&offset=$offset&size=10',
        APIV2.juHeAPI.rmspKey);

    if (res == null) {
      return [];
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    List<HotPersonModel>? model;
    print(map['result']);
    if(map['result']!=null){
      model =  (map['result'] as List).map((e) => HotPersonModel.fromJson(e)).toList();
    }else{
      model = [];
    }
    return model;
  }

  ///数独游戏
  static Future<SudokuModel?> getSudokuModel(String key) async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.sdyy,
        '&difficulty=$key',
        APIV2.juHeAPI.sdyyKey);
    if (res == null) {
      return null;
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    SudokuModel? model;
    model = SudokuModel.fromJson(map['result'] as Map<String, dynamic>);
    return model;
  }



  ///笑话大全
  static Future<List<JokeModel>?> getJokeList() async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.xhdq,
        '',
        APIV2.juHeAPI.xhdqKey,isList: true);

    if (res == null) {
      return [];
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    List<JokeModel>? model;
    print(map['result']);
    if(map['result']!=null){
      model =  (map['result'] as List).map((e) => JokeModel.fromJson(e)).toList();
    }else{
      model = [];
    }
    return model;
  }


  ///标准身高体重计算器
  static Future<HwCalculatorModel?> getHwCalculatorModel(int sex,int role,num height,num weight) async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.sgtz,
        '&sex=$sex&role=$role&height=$height&weight=$weight',
        APIV2.juHeAPI.sgtzKey);
    if (res == null) {
      return null;
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    HwCalculatorModel? model;
    model = HwCalculatorModel.fromJson(map['result'] as Map<String, dynamic>);
    return model;
  }


  ///成语接龙
  static Future<IdiomModel?> getIdiomModel(String wd) async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.cyjl,
        '&wd=$wd',
        APIV2.juHeAPI.cyjlKey);
    if (res == null) {
      return null;
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    IdiomModel? model;
    model = IdiomModel.fromJson(map['result'] as Map<String, dynamic>);
    return model;
  }



  ///NBA赛程查询
  static Future<NbaModel?> getNbaModel() async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.nba,
        '',
        APIV2.juHeAPI.nbaKey);
    if (res == null) {
      return null;
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    NbaModel? model;
    model = NbaModel.fromJson(map['result'] as Map<String, dynamic>);
    return model;
  }


  ///NBA球队排名
  static Future<NBARankModel?> getNBARankModel() async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.nbaRank,
        '',
        APIV2.juHeAPI.nbaKey);
    if (res == null) {
      return null;
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    NBARankModel? model;
    model = NBARankModel.fromJson(map['result'] as Map<String, dynamic>);
    return model;
  }


  ///足球联赛赛程查询
  static Future<NbaModel?> getFootModel(String type) async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.zqls,
        '&type=$type',
        APIV2.juHeAPI.zqlsKey);
    if (res == null) {
      return null;
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    NbaModel? model;
    model = NbaModel.fromJson(map['result'] as Map<String, dynamic>);
    return model;
  }


  ///足球联赛排名查询
  static Future<FootRankModel?> getFootRankModel(String type) async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.zqlsRank,
        '&type=$type',
        APIV2.juHeAPI.zqlsKey);
    if (res == null) {
      return null;
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    FootRankModel? model;
    model = FootRankModel.fromJson(map['result'] as Map<String, dynamic>);
    return model;
  }


  ///每日心灵鸡汤
  static Future<String?> getSoul() async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.xljt,
        '',
        APIV2.juHeAPI.xljtKey);
    if (res == null) {
      return null;
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    //print(map['result']['text']);
    if(map['result']!=null){
      if(map['result']['text']!=null){
        return map['result']['text'];
      }else{
        return '';
      }
    }else{
      return '';
    }
  }


  ///生肖查询
  static Future<ZodiacModel?> getZodiacModel(String keyword) async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.sxcx,
        '&keyword=$keyword',
        APIV2.juHeAPI.sxcxKey);
    if (res == null) {
      return null;
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    ZodiacModel? model;
    model = ZodiacModel.fromJson(map['result'] as Map<String, dynamic>);
    return model;
  }

  ///星座查询
  static Future<ConstellationModel?> getConstellationModel(String keyword) async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.xzcx,
        '&keyword=$keyword',
        APIV2.juHeAPI.xzcxKey);
    if (res == null) {
      return null;
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    ConstellationModel? model;
    model = ConstellationModel.fromJson(map['result'] as Map<String, dynamic>);
    return model;
  }

  ///贷款公积金查询
  static Future<LoanModel?> getLoanModel(num money,String year,String active ) async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.dkgjj,
        '&money=$money&year=$year&active=$active',
        APIV2.juHeAPI.dkgjjKey);
    if (res == null) {
      return null;
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    LoanModel? model;
    model = LoanModel.fromJson(map['result'] as Map<String, dynamic>);
    return model;
  }

  ///最佳身材计算器
  static Future<FigureModel?> getFigureModel(num height) async {
    Response? res = await getJuHe(
        APIV2.juHeAPI.zjsc,
        '&height=$height',
        APIV2.juHeAPI.zjscKey);
    if (res == null) {
      return null;
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    FigureModel? model;
    model = FigureModel.fromJson(map['result'] as Map<String, dynamic>);
    return model;
  }


}
