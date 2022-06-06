/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/18  2:09 PM 
 * remark    : 
 * ====================================================
 */

import 'package:recook/utils/mvp.dart';

abstract class MvpListViewPresenterI<T, V extends MvpView, M extends MvpModel> extends MvpPresenter<V,M>{
  MvpRefreshViewI<T?>? _mRefreshView;

  void attachRefreshView(MvpRefreshViewI view) {
    _mRefreshView = view as MvpRefreshViewI<T?>?;
    _mRefreshView?.onAttach();
  }

  MvpRefreshViewI<T?>? getRefreshView() {
    return _mRefreshView;
  }

  @override
  detach() {
    print("---- detach");
    _mRefreshView?.onDetach();
    _mRefreshView = null;
    super.detach();
  }
}

abstract class MvpRefreshViewI<T> extends MvpView{
  failure(String? msg);
  refreshSuccess(data);
  refreshFailure(String? error);
  loadMoreSuccess(List<T>? data);
  loadMoreWithNoMoreData();
  loadMoreFailure({String? error});
}
