/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-08  10:02 
 * remark    : 
 * ====================================================
 */

import 'package:recook/base/http_result_model.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/coupon_list_model.dart';

class CouponListImpl {

  static Future<CouponListModel> getCouponList(int userID, int brandId) async {
    ResultData res = await HttpManager.post(
        GoodsApi.coupon_list, {
          "userId": userID,
      "brandId":brandId
        });

    CouponListModel model = CouponListModel.fromJson(res.data);
    return model;
  }

  static Future<BaseModel> receiveCoupon(int userID, int couponID) async {
    ResultData res = await HttpManager.post(
        GoodsApi.coupon_receive, {"userID": userID, "couponID":couponID});

    BaseModel model = BaseModel.fromJson(res.data);
    return model;
//    return model;
  }

  static Future<HttpResultModel<CouponListModel>> getReceiveCouponList(int userID) async {
    ResultData res = await HttpManager.post(
        GoodsApi.coupon_user_list, {"userId": userID});

    if (!res.result) {
      return HttpResultModel(res.code, null, res.msg, false);
    }

    CouponListModel model = CouponListModel.fromJson(res.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
//    return model;
  }


}
