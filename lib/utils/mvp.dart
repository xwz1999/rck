class MvpCallBack<T> {
  Function(T) onSuccessCallBack;
  Function(String) onFailCallBack;

  MvpCallBack(onSuccess(T data), onFail(String msg)) {
    onSuccessCallBack = onSuccess;
    onFailCallBack = onFail;
  }
}

abstract class MvpView {
  void onAttach() {}

  void onDetach() {}
}

abstract class MvpModel {
  void onAttach() {}

  void onDetach() {}
}

abstract class MvpPresenter<V extends MvpView, M extends MvpModel> {
  V _mView;
  M _mModel;

  void attach(MvpView view) {
    _mView = view;
    _mView?.onAttach();
    getModel()?.onDetach();
  }

  V getView() {
    return _mView;
  }

  M getModel() {
    if (_mModel == null) {
      _mModel = initModel();
    }
    return _mModel;
  }

  M initModel();

  detach() {
    _mView?.onDetach();
    _mView = null;
    _mModel?.onDetach();
    _mModel = null;
  }
}
