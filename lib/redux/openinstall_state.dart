import 'package:redux/redux.dart';

class OpenInstall {
  String? channelCode;
  String? bindData;
  String? code;
  late String goodsid;
  String? date;
  String? type;
  String? itemId;
  OpenInstall(this.channelCode, this.bindData);

  OpenInstall.empty() {
    this.channelCode = "";
    this.bindData = "";
    this.code = "";
    this.date = "";
  }
}

final openInstallReducer = combineReducers<OpenInstall?>(
    [TypedReducer<OpenInstall?, UpdateOpenInstallAction>(updateOpenInstall)]);

OpenInstall? updateOpenInstall(OpenInstall? openInstall, action) {
  openInstall = action.openinstall;
  return openInstall;
}

class UpdateOpenInstallAction {
  final OpenInstall openInstall;
  UpdateOpenInstallAction(this.openInstall);
}
