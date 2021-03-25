import 'package:flutter/material.dart';
import 'package:recook/pages/user/functions/user_func.dart';
import 'package:recook/pages/user/invite/group_invite_card.dart';
import 'package:recook/pages/user/model/user_common_model.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:recook/constants/header.dart';

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
    int value = 0;
    _models.forEach((element) {
      value += element.count;
    });
    return value;
  }

  GSRefreshController _refreshController = GSRefreshController.auto();

  _renderShitTab(String name, UsersMode mode) {
    bool same = mode == usersMode;
    return MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minWidth: double.infinity,
      child: name.text
          .size(14.sp)
          .color(same ? Colors.black : Color(0xFFA3A3A3))
          .make(),
      onPressed: () {
        usersMode = mode;
        _refreshController.requestRefresh();
        setState(() {});
      },
    ).expand();
  }

  String get _renderTitle {
    switch (usersMode) {
      case UsersMode.MY_GROUP:
        return '我的自营店铺';
      case UsersMode.MY_RECOMMEND:
        return '我的分销店铺';
      case UsersMode.MY_REWARD:
        return '我的代理店铺';
    }
  }

  Widget get _renderShitVerticalLine => Container(
        height: 20.w,
        width: 1.w,
        color: Color(0xFF979797),
      );

  _renderTopCard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4.w),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 76.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(UserLevelTool.currentCardImagePath()),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              UserLevelTool.currentMedalImagePath(),
              height: 56.w,
              width: 56.w,
            ),
          ),
          Row(
            children: [
              50.hb,
              _renderShitTab('自营店铺', UsersMode.MY_GROUP),
              _renderShitVerticalLine,
              _renderShitTab('分销店铺', UsersMode.MY_RECOMMEND),
              _renderShitVerticalLine,
              _renderShitTab('代理店铺', UsersMode.MY_REWARD),
            ],
          ),
        ],
      ),
    ).pSymmetric(h: 36.w, v: 10.w);
  }

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
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
              hintText: '请输入昵称/备注/手机号/微信号',
              hintStyle: TextStyle(
                fontSize: 12.sp,
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
    ).pSymmetric(h: 15.w, v: 10.w);
  }

  _renderShitLine() {
    return Container(
      height: 10.w,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFE3E3E3),
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.w),
            blurRadius: 4.w,
            color: Colors.black.withOpacity(0.2451),
          )
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      alignment: Alignment.center,
      child: Container(
        height: 4.w,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: Color(0xFF6A6A6A).withOpacity(0.3178),
          borderRadius: BorderRadius.circular(2.w),
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
              _renderTitle.text.bold.size(14.sp).black.make(),
              MaterialButton(
                padding: EdgeInsets.all(4.w),
                minWidth: 0,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Icon(
                  Icons.help_outline,
                  size: 12.w,
                  color: Color(0xFFA5A5A5),
                ),
                onPressed: () {
                  Alert.show(
                    context,
                    NormalContentDialog(
                      title: '店铺贡献榜图标定义',
                      content: Image.asset(R.ASSETS_USER_CARD_DESCRIPTION_PNG),
                      items: ["确认"],
                      listener: (index) => Alert.dismiss(context),
                    ),
                  );
                },
              ),
              Spacer(),
              Image.asset(
                R.ASSETS_USER_ICON_GROUP_PNG,
                width: 12.w,
                height: 12.w,
              ),
              _allGroupCount.toString().text.size(12.sp).black.make(),
              20.wb,
            ],
          ),
          ..._models.map((e) => GroupInviteCard(model: e)).toList(),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(2.w)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.w),
            blurRadius: 4.w,
            color: Colors.black.withOpacity(0.1089),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '我的店铺',
      whiteBg: true,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) =>
            [SliverToBoxAdapter(child: _renderTopCard())],
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
        ),
      ).material(color: AppColor.frenchColor),
    );
  }
}
