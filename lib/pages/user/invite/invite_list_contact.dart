/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-02  11:09 
 * remark    : 
 * ====================================================
 */

import 'package:recook/models/invite_list_model.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';

abstract class InviteListPresenterI
    extends MvpListViewPresenterI<InviteModel, InviteListViewI, InviteListModelI> {
  getInviteList(int userId, int page, String searchCond);
}

abstract class InviteListModelI extends MvpModel {
  getInviteList(int? userId, int page, String searchCond);
}

abstract class InviteListViewI extends MvpView {
  failure(String? msg);
}
