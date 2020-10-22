import 'package:redux/redux.dart';

class Openinstall {
  String channelCode;
  String bindData;
  String code;
  String goodsid;
  String date;
  String type;
  String itemId;
  Openinstall(this.channelCode, this.bindData);

  Openinstall.empty() {
    this.channelCode = "";
    this.bindData = "";
    this.code = "";
    this.date = "";
  }
}

final OpeninstallReducer = combineReducers<Openinstall>(
    [TypedReducer<Openinstall, UpdateOpeninstallAction>(UpdateOpeninstall)]);

Openinstall UpdateOpeninstall(Openinstall openinstall, action) {
  openinstall = action.openinstall;
  return openinstall;
}

class UpdateOpeninstallAction {
  final Openinstall openinstall;
  UpdateOpeninstallAction(this.openinstall);
}
