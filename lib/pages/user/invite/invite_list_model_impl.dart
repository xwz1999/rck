/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-02  11:13 
 * remark    : 
 * ====================================================
 */

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/pages/user/invite/invite_list_contact.dart';

class InviteListModelImpl extends InviteListModelI {
  @override
  Future<ResultData> getInviteList(int userId, int page, String searchCond) async {

    ResultData resultData = await HttpManager.post(UserApi.invite, {"userId": userId, "SearchCond": searchCond,"page": page});
    return resultData;
  }

}
