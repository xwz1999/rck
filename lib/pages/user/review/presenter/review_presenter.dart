import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/user/review/models/order_review_list_model.dart';

class ReviewPresenter {
  Future<List<OrderReviewListModel>> getReviewList(
      {@required int status}) async {
    ResultData resultData = await HttpManager.post(OrderApi.orderReview, {
      'userId': UserManager.instance.user.info.id,
      'status': status,
    });

    return resultData == null
        ? []
        : resultData.data['data'] == null
            ? []
            : (resultData.data['data'] as List)
                .map((e) => OrderReviewListModel.fromJson(e))
                .toList();
  }
}
