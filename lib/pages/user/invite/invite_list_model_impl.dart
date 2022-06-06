/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-02  11:13 
 * remark    : 
 * ====================================================
 */

import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/user/invite/invite_list_contact.dart';

class InviteListModelImpl extends InviteListModelI {
  @override
  Future<ResultData> getInviteList(int? userId, int page, String searchCond) async {

    ResultData resultData = await HttpManager.post(UserApi.invite, {"userId": userId, "SearchCond": searchCond,"page": page});
    return resultData;
  }

}
