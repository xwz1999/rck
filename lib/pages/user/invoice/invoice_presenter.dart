import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/user/invoice/models/invoice_bill_list_model.dart';
import 'package:recook/pages/user/invoice/models/invoice_detail_model.dart';
import 'package:recook/pages/user/invoice/models/invoice_get_bill_model.dart';
import 'package:recook/pages/user/invoice/models/invoice_title_list_model.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/toast.dart';

class InvoicePresenter {
  Future<List<InvoiceGetBillModel>> getInvoice(
      {int page = 0, int pageSize = 10}) async {
    ResultData resultData =
        await HttpManager.post(APIV2.invoiceApi.canInvoiceBill, {
      'user_id': UserManager.instance.user.info.id,
      'page_num': page,
      'page_size': pageSize
    });
    return resultData.data['data'] == null
        ? []
        : (resultData.data['data'] as List)
            .map((e) => InvoiceGetBillModel.fromJson(e))
            .toList();
  }

  Future<List<InvoiceTitleListModel>> getInvoiceTitleList() async {
    ResultData resultData =
        await HttpManager.post(APIV2.invoiceApi.invoiceList, {
      'uid': UserManager.instance.user.info.id,
    });
    return resultData.data['data'] == null
        ? []
        : (resultData.data['data'] as List)
            .map((e) => InvoiceTitleListModel.fromJson(e))
            .toList();
  }

  Future addLetterHead(
    int type,
    String name, {
    String taxNum,
    String addr,
    String phone,
    String bank,
    String bankNum,
    int defaultValue = 0,
  }) async {
    Map<String, dynamic> param = {
      'uid': UserManager.instance.user.info.id, //用户id
      'type': type,
      "name": name,
      "defaultValue": defaultValue,
    };
    if (type == 1) {
      param.putIfAbsent('taxnum', () => taxNum);
      param.putIfAbsent('phone', () => phone);
      param.putIfAbsent('address', () => addr);
      param.putIfAbsent('bank', () => bankNum);
    }
    await HttpManager.post(APIV2.invoiceApi.addInvocieTitle, param);
  }

  Future updateLetterHead(
    int type,
    String name,
    int id, {
    String taxNum,
    String addr,
    String phone,
    String bank,
    String bankNum,
    int defaultValue = 0,
  }) async {
    Map<String, dynamic> param = {
      'uid': UserManager.instance.user.info.id,
      'id': id,
      'type': type,
      "name": name,
      "defaultValue": defaultValue,
    };
    if (type == 1) {
      param.putIfAbsent('taxnum', () => taxNum);
      param.putIfAbsent('phone', () => phone);
      param.putIfAbsent('address', () => addr);
      param.putIfAbsent('bank', () => bankNum);
    }
    await HttpManager.post(APIV2.invoiceApi.addInvocieTitle, param);
  }

  ///invoice_status:开票状态，1：待开票 2：开票异常 3：开票中 4：开票失败 5：开票成功 用户申请开票，必传参数：1
  Future<bool> createBill({
    @required List<int> ids,
    @required String buyername,
    String taxnum,
    String addr,
    String telephone,
    String phone,
    String email,
    String account,
    @required int invoiceStatus,
    @required double totalAmount,
  }) async {
    ResultData resultData = await HttpManager.post(APIV2.invoiceApi.applyInvoice, {
      'user_id': UserManager.instance.user.info.id,
      'order_id': ids,
      'buyer_name': buyername,
      'tax_num': taxnum,
      'address': addr,
      'telephone': telephone,
      'phone': phone,
      'email': email,
      'account': account,
      'total_amount': totalAmount,
      'invoice_status': invoiceStatus,
    });
    if (resultData.data['code'] == 'FAIL') {
      ReToast.warning(text:resultData.data['msg']);
      return false;
    } else
      return true;
  }

  Future<List<InvoiceBillListModel>> getBillList() async {
    ResultData resultData = await HttpManager.post(APIV2.invoiceApi.invoiceRecord, {
      'uid': UserManager.instance.user.info.id,
      // 'page': page,
    });
    return resultData.data['data'] == null
        ? []
        : (resultData.data['data'] as List)
            .map((e) => InvoiceBillListModel.fromJson(e))
            .toList();
  }

  Future<InvoiceDetailModel> getDetailModel(int id) async {
    ResultData resultData =
        await HttpManager.post(InvoiceApi.detail, {'billId': id});
    return resultData.data['data'] == null
        ? null
        : InvoiceDetailModel.fromJson(resultData.data['data']);
  }

  getParsedDate(DateTime date) {
    int year = date.year;
    int month = date.month;
    int day = date.day;
    return '$year-$month-$day';
  }
}
