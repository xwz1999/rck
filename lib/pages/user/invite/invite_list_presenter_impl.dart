/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-02  11:12 
 * remark    : 
 * ====================================================
 */

import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/invite_list_model.dart';
import 'package:recook/pages/user/invite/invite_list_contact.dart';
import 'package:recook/pages/user/invite/invite_list_model_impl.dart';

class InviteListPresenterImpl extends InviteListPresenterI {
  @override
  InviteListModelI initModel() {
    return InviteListModelImpl();
  }

  @override
  getInviteList(int? userId, int page, String searchCond) async {
    ResultData resultData = await getModel()!.getInviteList(userId, page, searchCond);
    if (!resultData.result) {
      getView()?.failure(resultData.msg);
      return;
    }
    InviteListModel orderListModel = InviteListModel.fromJson(resultData.data);
    if (orderListModel.code != HttpStatus.SUCCESS) {
      getView()?.failure(orderListModel.msg);
      return;
    }
    if (page == 0) {
      getRefreshView()?.refreshSuccess(orderListModel.data);
    } else {
      getRefreshView()!.loadMoreSuccess(orderListModel.data);
    }
  }
  
}
