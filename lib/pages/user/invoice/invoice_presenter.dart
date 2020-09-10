import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/user/invoice/models/invoice_bill_list_model.dart';
import 'package:recook/pages/user/invoice/models/invoice_detail_model.dart';
import 'package:recook/pages/user/invoice/models/invoice_get_bill_model.dart';
import 'package:recook/pages/user/invoice/models/invoice_title_list_model.dart';
import 'package:recook/widgets/toast.dart';


class InvoicePresenter {
  Future<List<InvoiceGetBillModel>> getInvoice({int page = 0}) async {
    ResultData resultData = await HttpManager.post(InvoiceApi.canGetBill, {
      'userId': UserManager.instance.user.info.id,
      'page': page,
      'startTime': getParsedDate(DateTime.now()),
      'endTime': getParsedDate(
        DateTime.now().subtract(
          Duration(days: 60),
        ),
      ),
    });
    return resultData.data['data'] == null
        ? []
        : (resultData.data['data'] as List)
            .map((e) => InvoiceGetBillModel.fromJson(e))
            .toList();
  }

  Future<List<InvoiceTitleListModel>> getInvoiceTitleList() async {
    ResultData resultData = await HttpManager.post(InvoiceApi.letterHeadList, {
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
    String name,
    String taxNum, {
    String addr,
    String phone,
    String bank,
    String bankNum,
    int defaultValue = 0,
  }) async {
    Map<String, dynamic> param = {
      'uid': UserManager.instance.user.info.id,
      'type': type,
      "name": name,
      "default": defaultValue,
    };
    if (type == 1) {
      param.putIfAbsent('taxnum', () => taxNum);
      param.putIfAbsent('phone', () => phone);
      param.putIfAbsent('address', () => addr);
      param.putIfAbsent('bank', () => bankNum);
    }
    await HttpManager.post(InvoiceApi.addLetterHead, param);
  }

  Future updateLetterHead(
    int type,
    String name,
    int id,
    String taxNum, {
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
      "default": defaultValue,
    };
    if (type == 1) {
      param.putIfAbsent('taxnum', () => taxNum);
      param.putIfAbsent('phone', () => phone);
      param.putIfAbsent('address', () => addr);
      param.putIfAbsent('bank', () => bankNum);
    }
    await HttpManager.post(InvoiceApi.addLetterHead, param);
  }

  Future<bool> createBill({
    List<int> ids,
    String buyername,
    String taxnum,
    String addr,
    String telephone,
    String phone,
    String email,
    String account,
    String message,
  }) async {
    ResultData resultData = await HttpManager.post(InvoiceApi.createbill, {
      'goodsDetailId': ids,
      'buyername': buyername,
      'taxnum': taxnum,
      'address': addr,
      'telephone': telephone,
      'phone': phone,
      'email': email,
      'account': account,
      'message': message,
    });
    if (resultData.data['code'] == 'FAIL') {
      Toast.showError(resultData.data['msg']);
      return false;
    } else
      return true;
  }

  Future<List<InvoiceBillListModel>> getBillList({int page = 0}) async {
    ResultData resultData = await HttpManager.post(InvoiceApi.getBillList, {
      'userId': UserManager.instance.user.info.id,
      'page': page,
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
