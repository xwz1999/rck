import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/noticeList/perfect_information_widget.dart';
import 'package:recook/pages/user/mvp/user_presenter_impl.dart';
import 'package:recook/widgets/alert.dart';
import 'diamond_recommendation_widget.dart';

class NoticeListTool {

  static Future<bool> inputExpressInformation(BuildContext context) async {
    await showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) {
        return NormalTextDialog(
          type: NormalTextDialogType.delete,
          title: "温馨提示",
          content: "还有售后服务为填写物流信息,请尽快填写,以免超时!",
          items: ["去填写"],
          listener: (index) {
            DPrint.printf("xxxxxxxxxxxxx---- $index");
            Alert.dismiss(context);
          },
          deleteItem: "取消",
          deleteListener: () {
            Alert.dismiss(context);
          },
        );
      }).then((value){
        return true;
      }
    );
    return false;
  }

  // 钻石推荐
  static Future<bool> diamondRecommendation(BuildContext context, {String title = ""}) async {
    await showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) {
        return GestureDetector(
          onTap: (){
            Navigator.pop(context);
            return false;
          },
          child: DiamondRecommendationWidget(title: title),
        );
      }).then((value){
        return true;
      }
    );
    return false;
  }
  // 完善信息
  static Future<bool> perfectInformation(BuildContext context, store) async {
    await showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) {
        return PerfectInformationWidget(
          onClose: (){
            Navigator.pop(context);
            return false;
          },
          onSubmit: (text) async {
            await _updateUserNickname(text, context, store);
            Navigator.pop(context);
            return true;
          },
        );
      }).then((value){
        return false;
      }
    );
    return false;
  }
  static Future<bool> _updateUserNickname(String nickname,BuildContext context, store) async {
    HttpResultModel resultModel = await UserPresenterImpl().updateUserNickname(
        UserManager.instance.user.info.id, nickname);
    if (!resultModel.result) {
      await GSDialog.of(context).showError(context, resultModel.msg);
      return false;
    }
    UserManager.instance.user.info.nickname = nickname;
    UserManager.updateUserInfo(store);
    await GSDialog.of(context).showError(context, "修改成功");
    return true;
  }
}
