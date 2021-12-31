/*
 * ====================================================
 * package   : redux
 * author    : Created by nansi.
 * time      : 2019/5/5  4:19 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:redux/redux.dart';

import 'package:jingyaoyun/constants/styles.dart';

enum AppTheme{
  AppThemeDataLight,
  AppThemeDataMain,
}


final ThemeDataReducer = combineReducers<ThemeData>(
    [TypedReducer<ThemeData, UpdateThemeDataAction>(_reducer)]);


ThemeData _reducer(ThemeData state, action) {

  switch (action.state) {
    case AppTheme.AppThemeDataLight:
      state = AppThemes.themeDataGrey;
      break;
    case AppTheme.AppThemeDataMain:
      state = AppThemes.themeDataMain;
      break;
    default:
      state = AppThemes.themeDataGrey;
  }
  return state;
}


class UpdateThemeDataAction {
  final AppTheme state;

  UpdateThemeDataAction(this.state);
}
