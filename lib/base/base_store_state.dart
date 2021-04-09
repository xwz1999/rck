/*
 * ====================================================
 * package   : base
 * author    : Created by nansi.
 * time      : 2019/5/5  3:46 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/redux/recook_state.dart';
import 'package:recook/utils/app_router.dart';
import 'package:recook/utils/print_util.dart';
import 'package:recook/widgets/progress/sc_dialog.dart';

abstract class BaseStoreState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  BuildContext globalContext;

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    globalContext = context;
    return baseBuild(context);
  }

  @mustCallSuper
  @override
  void dispose() {
    DPrint.printf(" ${this.runtimeType} 销毁了");
    super.dispose();
  }

  Widget baseBuild(BuildContext context) {
    if (needStore()) {
      return StoreBuilder<RecookState>(
          builder: (BuildContext context, Store<RecookState> store) {
        return buildContext(context, store: store);
      });
    } else {
      return buildContext(context);
    }
  }

  Widget buildContext(BuildContext context, {store});

  bool needStore() => false;

  Store<RecookState> getStore() {
    return StoreProvider.of<RecookState>(globalContext);
  }

  Color getCurrentThemeColor() {
    return getStore().state.themeData.appBarTheme.color;
  }

  Color getCurrentAppItemColor() {
    return getStore().state.themeData.appBarTheme.iconTheme.color;
  }

  Widget loadingWidget() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(getCurrentThemeColor()),
          strokeWidth: 1.0,
        ),
      ),
    );
  }

  Widget loadingView() {
    return Center(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: rSize(15), vertical: rSize(12)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(rSize(10))),
          color: Colors.black87,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _getIndicator(context),
            SizedBox(
              height: rSize(8),
            ),
            Text("loading...")
          ],
        ),
      ),
    );
  }

  Widget _getIndicator(BuildContext context) {
    return Platform.isIOS
        ? CupertinoActivityIndicator(
            animating: true,
            radius: ScreenAdapterUtils.setWidth(12.0),
          )
        : CircularProgressIndicator(
            strokeWidth: ScreenAdapterUtils.setWidth(2.0),
            valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
          );
  }

  noDataView(String text, {Widget icon}) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon ??
              Image.asset(
                R.ASSETS_NODATA_PNG,
                width: rSize(80),
                height: rSize(80),
              ),
//          Icon(AppIcons.icon_no_data_search,size: rSize(80),color: Colors.grey),
          SizedBox(
            height: 8,
          ),
          Text(
            text,
            style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                color: Colors.grey),
          ),
          SizedBox(
            height: rSize(30),
          )
        ],
      ),
    );
  }

  Future<R> push<R extends Object>(String routeName, {arguments}) async {
    return AppRouter.push(globalContext, routeName, arguments: arguments);
  }

  pop([T result]) {
    return Navigator.pop(globalContext, result);
  }

  Future<Null> showError(String error,
      {Duration duration = const Duration(milliseconds: 1000)}) async {
    return GSDialog.of(globalContext)
        .showError(globalContext, error, duration: duration);
  }

  Future<Null> showSuccess(String success) async {
    return GSDialog.of(globalContext).showSuccess(globalContext, success);
  }

  showLoading(String loading) {
    GSDialog.of(globalContext).showLoadingDialog(globalContext, loading);
  }

  dismissLoading() {
    GSDialog.of(globalContext).dismiss(globalContext);
  }

  @override
  bool get wantKeepAlive => false;
}
