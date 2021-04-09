import 'package:flutter/material.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/user/invite/user_invite_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/searchBar_view.dart';

class InvitePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _InvitePageState();
  }
}


class _InvitePageState extends BaseStoreState<InvitePage>{
  
  @override
  Widget buildContext(BuildContext context, {store}){
    return Scaffold(
      appBar: CustomAppBar(
        themeData: AppThemes.themeDataGrey.appBarTheme,
        title: "我的邀请",
        elevation: 0,
        backEvent: (){
          pop();
        },),
        backgroundColor: AppColor.frenchColor,
        // body: _buildBody(context),
        body: _body(),
    );
  }

  _body(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          height: 34,
          child: GestureDetector(
            onTap: (){
              AppRouter.push(context, RouteName.USER_INVITE_SEARCH);
            },
            child: SearchBarWidget(
              barTitle: "请输入昵称/备注/手机号",
              radius: 17,
            ),
          )
        ),
        Expanded(
          child: ChildInvitePage(userId: UserManager.instance.user.info.id,),
        ),
      ],
    );
  }


}
