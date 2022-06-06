/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/19  4:01 PM 
 * remark    : 
 * ====================================================
 */

import 'package:recook/models/material_list_model.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';

abstract class FocusPresenterI extends MvpListViewPresenterI<MaterialModel, FocusViewI, FocusModelI>{
  fetchList(int userId, int page,);
}

abstract class FocusModelI extends MvpModel{
  fetchList(int? userId, int page,);
}

abstract class FocusViewI extends MvpView {

}

