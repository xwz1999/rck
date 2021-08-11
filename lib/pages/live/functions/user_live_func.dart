import 'dart:convert';

import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/buy_tickets/models/air_items_list_model.dart';
import 'package:recook/pages/buy_tickets/models/air_order_model.dart';
import 'package:recook/pages/buy_tickets/models/air_order_pay_model.dart';
import 'package:recook/pages/buy_tickets/models/airline_model.dart';
import 'package:recook/pages/buy_tickets/models/airport_city_model.dart';
import 'package:recook/pages/buy_tickets/models/passager_model.dart';
import 'package:recook/pages/buy_tickets/models/submit_order_model.dart';
import 'package:recook/utils/storage/hive_store.dart';

class UserLiveFunc {


  //删除图文或者视频
  static Future<String> delImageOrVideo(
    int id
  ) async {
    ResultData result = await HttpManager.post(APIV2.userAPI.deleteImageOrVideo, {
      "id": id
    });

    if (result.data != null) {
      return result.data['code'];
    }
  }


}
