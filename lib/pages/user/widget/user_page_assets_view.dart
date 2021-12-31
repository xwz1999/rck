import 'package:flutter/material.dart';

import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/pages/user/user_page_sub_income_page.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

class UserPageAssetsView extends StatefulWidget {
  UserPageAssetsView({Key key}) : super(key: key);

  @override
  _UserPageAssetsViewState createState() => _UserPageAssetsViewState();
}

class _UserPageAssetsViewState extends BaseStoreState<UserPageAssetsView> {
  
  @override
  Widget buildContext(BuildContext context, {store}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _itemList(),
      ),
    );
  }

  _itemList(){
    UserRoleLevel userRoleLevel = UserLevelTool.currentRoleLevelEnum();
    UserLevel userLevle = UserLevelTool.currentUserLevelEnum();
    Container item0 = _itemWidget(
      click: () => AppRouter.push(context, RouteName.USER_PAGE_SUB_INCOME_PAGE, arguments: UserPageSubIncomesPage.setArguments(UserPageSubIncomesPageType.UserPageSelfIncome)),
      icon: "assets/cell_icon_save_money.png", title: "自购收益", 
      titles: ["订单(笔)", "销售额(元)", "累计收益(瑞币)"],
      infos: [
        getStore().state.userBrief.myShopping.orderNum.toInt().toString(), 
        getStore().state.userBrief.myShopping.amount.toDouble().toStringAsFixed(2), 
        getStore().state.userBrief.myShopping.historyIncome.toDouble().toStringAsFixed(2)
      ]
    );
    Container item1 =  _itemWidget(
      click: () => AppRouter.push(context, RouteName.USER_PAGE_SUB_INCOME_PAGE, arguments: UserPageSubIncomesPage.setArguments(UserPageSubIncomesPageType.UserPageShareIncome)),
      titles: ["订单(笔)", "销售额(元)", "累计收益(瑞币)"],
      infos: [
        getStore().state.userBrief.shareIncome.orderNum.toInt().toString(), 
        getStore().state.userBrief.shareIncome.amount.toDouble().toStringAsFixed(2), 
        getStore().state.userBrief.shareIncome.historyIncome.toDouble().toStringAsFixed(2)
      ],
      icon: "assets/cell_icon_share_make_money.png", title: "导购收益");
    Container item2 =  _itemWidget(
      click: () => AppRouter.push(context, RouteName.USER_PAGE_SUB_INCOME_PAGE, arguments: UserPageSubIncomesPage.setArguments(UserPageSubIncomesPageType.UserPageTeamIncome)),
      titles: ["团队销售额(元)", "累计收益(瑞币)", "团队成员(人)"],
      infos: [
        getStore().state.userBrief.teamIncome.orderNum.toDouble().toStringAsFixed(2), 
        getStore().state.userBrief.teamIncome.amount.toDouble().toStringAsFixed(2), 
        getStore().state.userBrief.teamIncome.historyIncome.toInt().toString()
      ],
      icon: "assets/cell_icon_team_benefits.png", title: "团队收益");
    if (userRoleLevel == UserRoleLevel.Vip || userRoleLevel == UserRoleLevel.Vip) {
      return <Widget>[];
    }
    if (userRoleLevel == UserRoleLevel.Master && ( userLevle != UserLevel.Second && userLevle != UserLevel.First)) {
      return <Widget>[item0, item1];
    }
    return <Widget>[item0, item1, item2];
  }

  _itemWidget({icon = "", title = "", Function click,List<String> titles, List<String> infos,}){
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      height: 111,
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _titleWidget(icon: icon, title: title, click: click),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            height: 1, color: Color(0xffeeeeee),
          ),
          _contentWidget(titles: titles, infos: infos),
        ],
      ),
    );
  }

  _titleWidget({icon = "", title = "", Function click}){
    return Container(
      padding: EdgeInsets.only(left: 8, right: 10),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(icon, width: 28, height: 28,),
          Container(width: 3,),
          Text(title, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
          Spacer(),
          CustomImageButton(
            title: "查看明细",
            style: TextStyle(color: Color(0xff999999),fontSize: 12 ),
            direction: Direction.horizontal,
            onPressed: (){
              if (click!=null) click();
            },
          ),
          Icon(Icons.keyboard_arrow_right, size: 20, color: AppColor.greyColor,),
        ],
      ),
    );
  }
  _contentWidget({List<String> titles, List<String> infos,}){
    if (titles == null) titles = ["", "", ""];
    if (infos == null) infos = ["", "", ""];
    while (titles.length<3) {
      titles.add("");
    }
    while (infos.length<3) {
      infos.add("");
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14), height: 70,
      child: Flex(
        direction: Axis.horizontal, 
        children: <Widget>[
          Expanded(child: _columnTitleInfo(titles[0], infos[0]),),
          Expanded(child: _columnTitleInfo(titles[1], infos[1]),),
          Expanded(child: _columnTitleInfo(titles[2], infos[2]),),
        ],  
      ),
    );
  }
  _columnTitleInfo(title, info){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title.toString(), style: TextStyle(color: Color(0xff999999), fontSize: 12),),
        Container(height: 5,),
        Text(info.toString(), style: TextStyle(color: Colors.black, fontSize: 16),)
      ],
    );
  }

  

}
