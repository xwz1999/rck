/*
 * ====================================================
 * package   : redux
 * author    : Created by nansi.
 * time      : 2019/5/5  3:48 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/models/user_brief_info_model.dart';
import 'package:recook/models/user_model.dart';
import 'package:recook/redux/openinstall_state.dart';
import 'package:recook/redux/theme_redux.dart';
import 'package:recook/redux/user_brief_redux.dart';
import 'package:recook/redux/user_redux.dart';

class RecookState {
  User? user;
  ThemeData? themeData;
  UserBrief? userBrief;
  Openinstall? openinstall;
  int? goodsId;
  RecookState({this.user, this.themeData, this.userBrief, this.openinstall, this.goodsId});
}

RecookState appReducer(RecookState state, action){
  return RecookState(
      user : UserReducer(state.user, action),
      themeData: ThemeDataReducer(state.themeData, action),
      userBrief: UserBriefReducer(state.userBrief, action),
      openinstall: OpeninstallReducer(state.openinstall, action),
      goodsId: 0,
  );
}
