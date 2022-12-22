import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/user/model/company_info_model.dart';
import 'package:recook/pages/user/model/contact_info_model.dart';
import 'package:recook/pages/user/model/user_balance_history_model.dart';
import 'package:recook/pages/user/model/user_balance_info_model.dart';

class UserBalanceFunc {
  static Future<UserBalanceInfoModel> info() async {
    ResultData result = await HttpManager.post(APIV2.userAPI.balanceInfo, {});
    return UserBalanceInfoModel.fromJson(result.data);
  }

  static Future<UserBalanceHistoryModel> history({
    required String month,
    required int status,
  }) async {
    ResultData result =
        await HttpManager.post(APIV2.userAPI.balanceMonthHistory, {
      'date': month,
      'status': status,
    });
    return UserBalanceHistoryModel.fromJson(result.data);
  }



  static Future<CompanyInfoModel?> getDepositRecordList() async {
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
static Future<CompanyInfoModel?> getCompanyInfo() async {
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


  static Future<ContactInfoModel?> getContractInfo() async {
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


  static Future<bool> applyWithdrawal(num? amount,num tax, {String? logisticsName,String? waybillCode}  ) async {
    Map<String, dynamic> params = {
      "amount": amount,
      'tax':tax,
    };
    if (logisticsName != null) {
      params.putIfAbsent("logistics_name", () => logisticsName);

    }
    if (waybillCode != null) {
      params.putIfAbsent("waybill_code", () => waybillCode);

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
