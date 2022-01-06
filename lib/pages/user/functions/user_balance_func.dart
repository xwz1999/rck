import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/pages/user/model/user_balance_history_model.dart';
import 'package:jingyaoyun/pages/user/model/user_balance_info_model.dart';

class UserBalanceFunc {
  static Future<UserBalanceInfoModel> info() async {
    ResultData result = await HttpManager.post(APIV2.userAPI.balanceInfo, {});
    return UserBalanceInfoModel.fromJson(result.data);
  }

  static Future<UserBalanceHistoryModel> history({
    @required String month,
    @required int status,
  }) async {
    ResultData result =
        await HttpManager.post(APIV2.userAPI.balanceMonthHistory, {
      'date': month,
      'status': status,
    });
    return UserBalanceHistoryModel.fromJson(result.data);
  }
}
