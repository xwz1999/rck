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
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/category_model.dart';

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
}
