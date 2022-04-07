import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/pages/user/model/company_info_model.dart';
import 'package:jingyaoyun/pages/user/model/contact_info_model.dart';
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



  static Future<CompanyInfoModel> getDepositRecordList() async {
    ResultData result =
    await HttpManager.post(APIV2.userAPI.depositRecordList, {
    });

    if (result.data != null) {
      if (result.data['data'] != null) {

        return CompanyInfoModel.fromJson(
            result.data['data']);

      }
      else
        return null;
    }
    else
      return null;

  }

// //获取公司
static Future<CompanyInfoModel> getCompanyInfo() async {
  ResultData result =
  await HttpManager.post(APIV2.userAPI.getCompanyInfo, {
  });

  if (result.data != null) {
    if (result.data['data'] != null) {

        return CompanyInfoModel.fromJson(
            result.data['data']);

    }
    else
      return null;
  }
  else
    return null;

}


  static Future<ContactInfoModel> getContractInfo() async {
    ResultData result =
    await HttpManager.post(APIV2.userAPI.getContractInfo, {
    });

    if (result.data != null) {
      if (result.data['data'] != null) {

        return ContactInfoModel.fromJson(
            result.data['data']);

      }
      else
        return null;
    }
    else
      return null;

  }


  static Future<bool> applyWithdrawal(num amount,num tax, {String logistics_name,String waybill_code}  ) async {
    Map<String, dynamic> params = {
      "amount": amount,
      'tax':tax,
    };
    if (logistics_name != null) {
      params.putIfAbsent("logistics_name", () => logistics_name);

    }
    if (waybill_code != null) {
      params.putIfAbsent("waybill_code", () => waybill_code);

    }


    ResultData result =
    await HttpManager.post(APIV2.userAPI.applyWithdrawal,
        params);

    if (result.data != null) {
      if (result.data['code'] =='SUCCESS') {

        return true;
      }
      else
        return false;
    }
    else
      return false;

  }


  //充值申请
  static Future<ResultData> depositRecharge(num amount,String attach
      ) async {
    ResultData result = await HttpManager.post(APIV2.userAPI.depositRecharge, {
      "amount": amount,
      'attach': attach,
    });

    return result;
  }

}
