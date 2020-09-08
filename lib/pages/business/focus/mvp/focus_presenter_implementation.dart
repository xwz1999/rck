/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/20  1:31 PM 
 * remark    : 
 * ====================================================
 */

import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/material_list_model.dart';
import 'package:recook/pages/business/focus/mvp/focus_model_impl.dart';
import 'package:recook/pages/business/focus/mvp/focus_mvp_contact.dart';

class FocusPresenterImpl extends FocusPresenterI{
  @override
  FocusModelI initModel() {
    return FocusModelImpl();
  }


  @override
  fetchList(int userId,int page,) {
    getModel().fetchList(userId, page).then((ResultData response) {
      if (!response.result) {
        getRefreshView().refreshFailure(response.msg);
      } else {
//        getRefreshView().refreshSuccess([]);
        MaterialListModel model = MaterialListModel.fromJson(response.data);
        if (model.code == HttpStatus.SUCCESS) {
          if (page == 0) {
            getRefreshView().refreshSuccess(model.data);
          } else {
            getRefreshView().loadMoreSuccess(model.data);
          }
        } else {
          if (page == 0) {
            getRefreshView().refreshFailure(model.msg);
          } else {
            getRefreshView().loadMoreFailure(error : model.msg);
          }
        }
      }
    });
  }

  
}