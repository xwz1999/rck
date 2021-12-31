/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/19  4:01 PM 
 * remark    : 
 * ====================================================
 */

import 'package:jingyaoyun/models/material_list_model.dart';
import 'package:jingyaoyun/utils/mvp.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view_contact.dart';

abstract class RecommendPresenterI extends MvpListViewPresenterI<MaterialModel, RecommendViewI, RecommendModelI>{
  fetchList(int userId, int page,);
}

abstract class RecommendModelI extends MvpModel{
  fetchList(int userId, int page,);
}

abstract class RecommendViewI extends MvpView {

}

