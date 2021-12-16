/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/27  4:00 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/constants/api.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/category_list_model.dart';
import 'package:recook/models/category_model.dart';
import 'package:recook/models/country_list_model.dart';
import 'package:recook/models/view_goods_model.dart';

class HomeDao {
  static Future getCategories(
      {@required OnSuccess<List<FirstCategory>> success,
      @required OnFailure failure}) async {
    ResultData res = await HttpManager.post(GoodsApi.categories, {});

    if (!res.result) {
      failure(res.code, res.msg);
    } else {
      CategoryModel model = CategoryModel.fromJson(res.data);
      if (model.code == HttpStatus.SUCCESS) {
        success(model.data, model.code, model.msg);
      } else {
        failure(HttpStatus.FAILURE, model.msg);
      }
    }
  }

    //进口专区 选择国家
  static Future<List<CountryListModel>> getCountryList() async {
    ResultData result =
        await HttpManager.post(APIV2.userAPI.getCountryList, {});
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => CountryListModel.fromJson(e))
            .toList();
      }
      else{
        return [];
      }
    }else{
      return [];
    }
  }

      //进口专区 搜索国家
  static Future<List<CountryListModel>> findCountryList(
    String text
  ) async {
    ResultData result =
        await HttpManager.post(APIV2.userAPI.findCountry, {
          "name":text
        });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => CountryListModel.fromJson(e))
            .toList();
      }
      else{
        return [];
      }
    }
    else{
      return [];
    }
  }

      //进口专区 国家下的分类
      
  static Future<List<CategoryListModel>> getCategoryList(
    int countryId
  ) async {
    ResultData result =
        await HttpManager.post(APIV2.userAPI.getCategoryList, {
          "country_id":countryId
        });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => CategoryListModel.fromJson(e))
            .toList();
      }
      else{
        return [];
      }
    }
    else{
      return [];
    }
  }

      //进口专区 获取进口商品列表
  static Future<List<ViewGoodsModel>> getViewGoods(
    int countryId,int categoryId,int page
  ) async {
    ResultData result =
        await HttpManager.post(APIV2.userAPI.getViewGoods, {
          "country_id":countryId,
          "category_id":categoryId,
          "page":{
            "limit":15,
            "page":page,
          }
        });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => ViewGoodsModel.fromJson(e))
            .toList();
      }
      else{
        return [];
      }
    }
    else{
      return [];
    }
  }


  //获取京东商品类目
  static Future<List<FirstCategory>> getJDCategoryList() async {
    ResultData result =
    await HttpManager.post(APIV2.goodsAPI.getJDCategoryList, {});
    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => FirstCategory.fromJson(e))
            .toList();
      }
      else{
        return [];
      }
    }else{
      return [];
    }
  }

  //获取京东商品类目
  static Future<num> getJDStock(num skuId,String address) async {
    ResultData result =
    await HttpManager.post(APIV2.goodsAPI.getJDStock, {
      'sku_id':skuId,
      'address':address,
      'quantity':1
    });
    if (result.data != null) {
      if (result.data['data'] != null) {
        return result.data['data']["stock_state"];
      }
      else{
        return -1;
      }
    }else{
      return -1;
    }
  }



}
