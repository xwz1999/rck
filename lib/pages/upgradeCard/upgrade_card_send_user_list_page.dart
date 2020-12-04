import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/invite_list_model.dart';
import 'package:recook/pages/upgradeCard/upgrade_child_invite_page.dart';
import 'package:recook/widgets/SearchBarTextFieldWidget.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';

class UpgradeCardSendUserListPage extends StatefulWidget {
  final Map arguments;
  const UpgradeCardSendUserListPage({Key key, this.arguments}) : super(key: key);
  static setArguments({bool isUpCard=true , String code=""}){
    return {
      "isUpCard": isUpCard,
      "code": code
    };
  }

  @override
  State<StatefulWidget> createState() {
    return _UpgradeCardSendUserListPageState();
  }
}

class _UpgradeCardSendUserListPageState
    extends BaseStoreState<UpgradeCardSendUserListPage> {

  UpgradeChildInvitePageController _controller;
  bool isUpCard = false;
  String code = "";
  @override
  void initState() { 
    super.initState();
    isUpCard = widget.arguments["isUpCard"];
    code = widget.arguments["code"];
    _controller = UpgradeChildInvitePageController();
  }
  
  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
        appBar: CustomAppBar(
          themeData: AppThemes.themeDataGrey.appBarTheme,
          title: "团队赠送",
          elevation: 0,
        ),
        backgroundColor: AppColor.frenchColor,
        body: Listener(
          onPointerDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: _body(),
        ));
  }

  _body() {
    // Navigator.pop(context, true);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          height: 34,
          child: SearchBarTextFieldWidget(
            textChangeLinster: (text) {
              _controller.refresh(text);
            },
            barTitle: "请输入昵称/备注/手机号",
            radius: 17,
          ),
        ),
        Expanded(
          child: UpgradeChildInvitePage(
            itemClick: (InviteModel inviteMode){
              Alert.show(
                context,
                NormalContentDialog(
                  type: NormalTextDialogType.delete,
                  title: "赠送提示",
                  content: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 15,),
                      children: [
                        TextSpan(text:isUpCard?'将赠送一张晋升卡给\n':'将赠送一张保障卡给\n',),
                        TextSpan(text: inviteMode.nickname, style: TextStyle(color: Colors.red)),
                      ]
                    ),
                    textAlign: TextAlign.center,
                  ),
                  items: ["确认"],
                  listener: (index) {
                    Alert.dismiss(context);
                    _sendCode(inviteMode.userId.toString());
                  },
                  deleteItem: "取消",
                  deleteListener: () {
                    Alert.dismiss(context);
                  },
                ));
            },
            controller: _controller,
            userId: UserManager.instance.user.info.id,
          ),
        ),
      ],
    );
  }

  _sendCode(String givenUserId) async {
    ResultData resultData = await HttpManager.post(UserApi.give_code, {
      "userId": UserManager.instance.user.info.id,
      "codeId": code.toString(),
      "givenUserID": int.parse(givenUserId)
    });

    if (!resultData.result) {
      GSDialog.of(context).showError(context, resultData.msg);
      return;
    }
    // UpgradeCardModel model = UpgradeCardModel.fromJson(resultData.data);
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      GSDialog.of(context).showError(context, model.msg);
      return;
    }
    Navigator.pop(context, true);
  }
}
