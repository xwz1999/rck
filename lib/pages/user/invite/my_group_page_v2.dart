import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/user/functions/user_func.dart';
import 'package:jingyaoyun/pages/user/invite/group_invite_card.dart';
import 'package:jingyaoyun/pages/user/model/user_common_model.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/recook/recook_scaffold.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class MyGroupPageV2 extends StatefulWidget {
  MyGroupPageV2({Key key}) : super(key: key);

  @override
  _MyGroupPageV2State createState() => _MyGroupPageV2State();
}

class _MyGroupPageV2State extends State<MyGroupPageV2> {
  TextEditingController _editingController = TextEditingController();
  List<UserCommonModel> _models = [];
  UsersMode usersMode = UsersMode.MY_GROUP;
  int get _allGroupCount {

      return _models.length;

  }

  UserRoleLevel role = UserLevelTool.currentRoleLevelEnum();

  GSRefreshController _refreshController = GSRefreshController.auto();

  // _renderShitTab(String name, UsersMode mode) {
  //   bool same = mode == usersMode;
  //   return MaterialButton(
  //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //     minWidth: double.infinity,
  //     child: name.text
  //         .size(14.rsp)
  //         .color(same ? Colors.black : Color(0xFFA3A3A3))
  //         .make(),
  //     onPressed: () {
  //       usersMode = mode;
  //       _refreshController.requestRefresh();
  //       setState(() {});
  //     },
  //   ).expand();
  // }

  // String get _renderTitle {
  //   switch (usersMode) {
  //     case UsersMode.MY_GROUP:
  //       return '我的自营店铺';
  //     case UsersMode.MY_RECOMMEND:
  //       return '我的分销店铺';
  //     case UsersMode.MY_REWARD:
  //       return '我的代理店铺';
  //   }
  //   return '';
  // }
  //
  // Widget get _renderShitVerticalLine => Container(
  //       height: 20.rw,
  //       width: 1.rw,
  //       color: Color(0xFF979797),
  //     );

  // _renderTopCard() {
  //   return Material(
  //     color: Colors.white,
  //     borderRadius: BorderRadius.circular(4.rw),
  //     clipBehavior: Clip.antiAlias,
  //     child: Column(
  //       children: [
  //         Container(
  //           height: 76.rw,
  //           decoration: BoxDecoration(
  //             image: DecorationImage(
  //               image: AssetImage(UserLevelTool.currentCardImagePath()),
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //           alignment: Alignment.center,
  //           child: Image.asset(
  //             UserLevelTool.currentMedalImagePath(),
  //             height: 56.rw,
  //             width: 56.rw,
  //           ),
  //         ),
  //         Row(
  //           children: [
  //             50.hb,
  //             _renderShitTab('自营店铺', UsersMode.MY_GROUP),
  //             role == UserRoleLevel.Diamond_1 || role == UserRoleLevel.Diamond_2
  //                 ? _renderShitVerticalLine
  //                 : SizedBox(),
  //             role == UserRoleLevel.Diamond_1 || role == UserRoleLevel.Diamond_2
  //                 ? _renderShitTab('分销店铺', UsersMode.MY_RECOMMEND)
  //                 : SizedBox(),
  //             role == UserRoleLevel.Diamond_1
  //                 ? _renderShitVerticalLine
  //                 : SizedBox(),
  //             role == UserRoleLevel.Diamond_1
  //                 ? _renderShitTab('代理店铺', UsersMode.MY_REWARD)
  //                 : SizedBox(),
  //           ],
  //         ),
  //       ],
  //     ),
  //   ).pSymmetric(h: 36.rw, v: 10.rw);
  // }

  _renderSearchBar() {
    return Material(
      color: Colors.white,
      shape: StadiumBorder(),
      child: Row(
        children: [
          34.hb,
          TextField(
            controller: _editingController,
            onEditingComplete: () {
              _refreshController.requestRefresh();
            },
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20.rw),
              hintText: '请输入手机号',
              hintStyle: TextStyle(
                fontSize: 12.rsp,
                color: Color(0xFF999999),
              ),
            ),
          ).expand(),
          Icon(
            Icons.search,
            color: Color(0xFF999999),
          ),
          20.wb,
        ],
      ),
    ).pSymmetric(h: 15.rw, v: 10.rw);
  }

  _renderShitLine() {
    return Container(
      height: 10.rw,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFE3E3E3),
        borderRadius: BorderRadius.circular(5.rw),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.rw),
            blurRadius: 4.rw,
            color: Colors.black.withOpacity(0.2451),
          )
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 6.rw),
      alignment: Alignment.center,
      child: Container(
        height: 4.rw,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.rw),
        decoration: BoxDecoration(
          color: Color(0xFF6A6A6A).withOpacity(0.3178),
          borderRadius: BorderRadius.circular(2.rw),
        ),
      ),
    );
  }

  Widget _renderShitList() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              54.hb,
              16.wb,
             "我的粉丝".text.bold.size(14.rsp).black.make(),
              // MaterialButton(
              //   padding: EdgeInsets.all(4.rw),
              //   minWidth: 0,
              //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //   child: Icon(
              //     Icons.help_outline,
              //     size: 12.rw,
              //     color: Color(0xFFA5A5A5),
              //   ),
              //   onPressed: () {
              //     Alert.show(
              //       context,
              //       NormalContentDialog(
              //         title: '店铺贡献榜图标定义',
              //         content: role == UserRoleLevel.Diamond_1 ||
              //                 role == UserRoleLevel.Diamond_2
              //             ? Image.asset(R.ASSETS_USER_CARD_DESCRIPTION_PNG)
              //             : Image.asset(R.ASSETS_USER_CARD_DESCRIPTION_WEBP),
              //         items: ["确认"],
              //         listener: (index) => Alert.dismiss(context),
              //       ),
              //     );
              //   },
              // ),
               Spacer(),
              Image.asset(
                R.ASSETS_USER_ICON_GROUP_PNG,
                width: 12.rw,
                height: 12.rw,
              ),
              _allGroupCount.toString().text.size(12.rsp).black.make(),
              20.wb,
            ],
          ),
          ..._models
              .map((e) => GroupInviteCard(
                  model: e, canTap: usersMode == UsersMode.MY_GROUP))
              .toList()
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.rw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(2.rw)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.rw),
            blurRadius: 4.rw,
            color: Colors.black.withOpacity(0.1089),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    HttpManager.post(APIV2.userAPI.userSaleAmount, {}).then((resultData) {
      if (resultData?.data != null &&
          resultData.data['data'] != null &&
          resultData.data['data'] != null) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '我的粉丝',
      whiteBg: true,
      // body:
      //   NestedScrollView(
        // headerSliverBuilder: (context, _) =>
        //     [SliverToBoxAdapter(child: _renderTopCard())],
        body: RefreshWidget(
          controller: _refreshController,
          onRefresh: () async {
            _models = await UserFunc.usersList(
              usersMode,
              keyword: _editingController.text,
            );
            _refreshController.refreshCompleted();
            setState(() {});
          },
          body: SingleChildScrollView(
            child: Column(
              children: [
                _renderSearchBar(),
                _renderShitLine(),
                _renderShitList(),
              ],
            ),
          ),
        // ),
      ).material(color: AppColor.frenchColor),
    );
  }
}
