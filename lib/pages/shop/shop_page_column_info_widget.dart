import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/shop_summary_model.dart';
import 'package:recook/pages/shop/shop_page_sub_income_page.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_image_button.dart';

enum IncomeType { today, thisMonth, prevMonth }

class ShopPageColumnInfoWidget extends StatefulWidget {
  final ShopSummaryModel shopSummaryModel;

  ShopPageColumnInfoWidget({Key key, this.shopSummaryModel}) : super(key: key);

  @override
  _ShopPageColumnInfoWidgetState createState() =>
      _ShopPageColumnInfoWidgetState();
}

class _ShopPageColumnInfoWidgetState
    extends BaseStoreState<ShopPageColumnInfoWidget> {
  //
  String myIncomeIcon = "assets/cell_icon_save_money.png";
  String shopIncomeIcon = "assets/cell_icon_share_make_money.png";
  String teamIncomeIcon = "assets/cell_icon_team_benefits.png";

  IncomeType _myIncomeType = IncomeType.today;
  IncomeType _shopIncomeType = IncomeType.today;
  IncomeType _teamIncomType = IncomeType.today;

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Container(
      color: AppColor.frenchColor,
      child: Column(
        children: <Widget>[
          _cellWidget(
              typeSelectClick: (type) {
                _myIncomeType = type;
                setState(() {});
              },
              incomeType: _myIncomeType,
              icon: myIncomeIcon,
              title: "自购收益",
              titleClick: () {
                AppRouter.push(context, RouteName.SHOP_PAGE_SUB_INCOME_PAGE,
                    arguments: ShopPageSubIncomesPage.setArguments(
                        ShopPageSubIncomesPageType.ShopPageSelfIncome));
              },
              infosToDay: [
                widget.shopSummaryModel.data.myShoppingWithTime.today.orderNum
                    .toString(),
                widget.shopSummaryModel.data.myShoppingWithTime.today.amount
                    .toStringAsFixed(2),
                widget.shopSummaryModel.data.myShoppingWithTime.today
                    .historyIncome
                    .toStringAsFixed(2)
              ],
              infosThisMonth: [
                widget
                    .shopSummaryModel.data.myShoppingWithTime.thisMonth.orderNum
                    .toString(),
                widget.shopSummaryModel.data.myShoppingWithTime.thisMonth.amount
                    .toStringAsFixed(2),
                widget.shopSummaryModel.data.myShoppingWithTime.thisMonth
                    .historyIncome
                    .toStringAsFixed(2)
              ],
              infosPrevMonth: [
                widget
                    .shopSummaryModel.data.myShoppingWithTime.prevMonth.orderNum
                    .toString(),
                widget.shopSummaryModel.data.myShoppingWithTime.prevMonth.amount
                    .toStringAsFixed(2),
                widget.shopSummaryModel.data.myShoppingWithTime.prevMonth
                    .historyIncome
                    .toStringAsFixed(2)
              ],
              titles: [
                '订单(笔)',
                '销售额(元)',
                "预估收益(瑞币)"
              ]),
          _cellWidget(
              typeSelectClick: (type) {
                _shopIncomeType = type;
                setState(() {});
              },
              incomeType: _shopIncomeType,
              icon: shopIncomeIcon,
              title: "导购收益",
              titleClick: () {
                AppRouter.push(context, RouteName.SHOP_PAGE_SUB_INCOME_PAGE,
                    arguments: ShopPageSubIncomesPage.setArguments(
                        ShopPageSubIncomesPageType.ShopPageShareIncome));
              },
              infosToDay: [
                widget.shopSummaryModel.data.shareIncomeWithTime.today.orderNum
                    .toString(),
                widget.shopSummaryModel.data.shareIncomeWithTime.today.amount
                    .toStringAsFixed(2),
                widget.shopSummaryModel.data.shareIncomeWithTime.today
                    .historyIncome
                    .toStringAsFixed(2)
              ],
              infosThisMonth: [
                widget.shopSummaryModel.data.shareIncomeWithTime.thisMonth
                    .orderNum
                    .toString(),
                widget
                    .shopSummaryModel.data.shareIncomeWithTime.thisMonth.amount
                    .toStringAsFixed(2),
                widget.shopSummaryModel.data.shareIncomeWithTime.thisMonth
                    .historyIncome
                    .toStringAsFixed(2)
              ],
              infosPrevMonth: [
                widget.shopSummaryModel.data.shareIncomeWithTime.prevMonth
                    .orderNum
                    .toString(),
                widget
                    .shopSummaryModel.data.shareIncomeWithTime.prevMonth.amount
                    .toStringAsFixed(2),
                widget.shopSummaryModel.data.shareIncomeWithTime.prevMonth
                    .historyIncome
                    .toStringAsFixed(2)
              ],
              titles: [
                '订单(笔)',
                '销售额(元)',
                "预估收益(瑞币)"
              ]),
          UserLevelTool.currentUserLevelEnum() == UserLevel.Others &&
                  UserLevelTool.roleLevelEnum(
                          widget.shopSummaryModel.data.roleLevel) ==
                      UserRoleLevel.Master
              ? Container()
              : _cellWidget(
                  title2: "  上月  ",
                  typeSelectClick: (type) {
                    _teamIncomType = type;
                    setState(() {});
                  },
                  incomeType: _teamIncomType,
                  icon: teamIncomeIcon,
                  title: "团队收益",
                  titleClick: () {
                    AppRouter.push(context, RouteName.SHOP_PAGE_SUB_INCOME_PAGE,
                        arguments: ShopPageSubIncomesPage.setArguments(
                            ShopPageSubIncomesPageType.ShopPageTeamIncome));
                  },
                  infosToDay: [
                    widget.shopSummaryModel.data.teamIncomeWithTime.today.amount
                        .toStringAsFixed(2),
                    widget
                        .shopSummaryModel.data.teamIncomeWithTime.today.percent
                        .toString(),
                    widget.shopSummaryModel.data.teamIncomeWithTime.today
                        .historyIncome
                        .toStringAsFixed(2)
                  ],
                  infosThisMonth: [
                    widget.shopSummaryModel.data.teamIncomeWithTime.thisMonth
                        .amount
                        .toStringAsFixed(2),
                    widget.shopSummaryModel.data.teamIncomeWithTime.thisMonth
                        .percent
                        .toString(),
                    widget.shopSummaryModel.data.teamIncomeWithTime.thisMonth
                        .historyIncome
                        .toStringAsFixed(2)
                  ],
                  infosPrevMonth: [
                    widget.shopSummaryModel.data.teamIncomeWithTime.prevMonth
                        .amount
                        .toStringAsFixed(2),
                    widget.shopSummaryModel.data.teamIncomeWithTime.prevMonth
                        .percent
                        .toString(),
                    widget.shopSummaryModel.data.teamIncomeWithTime.prevMonth
                        .historyIncome
                        .toStringAsFixed(2)
                  ],
                  titles: ['团队销售额(元)', '预估提成比例(%)', "预估收益(瑞币)"],
                  titlesPrevMonth: ['团队销售额(元)', '预估提成比例(%)', "预估收益(瑞币)"],
                  msg: _teamIncomType == IncomeType.today
                      ? widget
                          .shopSummaryModel.data.teamIncomeWithTime.today.msg
                      : _teamIncomType == IncomeType.thisMonth
                          ? widget.shopSummaryModel.data.teamIncomeWithTime
                              .thisMonth.msg
                          : widget.shopSummaryModel.data.teamIncomeWithTime
                              .prevMonth.msg,
                ),
        ],
      ),
    );
  }

  _cellWidget(
      {icon = "",
      title = "",
      List<String> infosToDay,
      List<String> infosThisMonth,
      List<String> infosPrevMonth,
      Function titleClick,
      List<String> titles,
      List<String> titlesToDay,
      List<String> titlesThisMonth,
      List<String> titlesPrevMonth,
      String msg,
      IncomeType incomeType,
      Function typeSelectClick,
      String title0,
      String title1,
      String title2}) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            child: _titleWidget(
                title0: title0,
                title1: title1,
                title2: title2,
                icon: icon,
                title: title,
                click: titleClick,
                incomeType: incomeType,
                typeSelectClick: typeSelectClick),
          ),
          Container(
            height: 1,
            color: Color(0xffeeeeee),
          ),
          Container(
            height: 60,
            child: _contentWidget(
                titles: incomeType == IncomeType.today && titlesToDay != null
                    ? titlesToDay
                    : incomeType == IncomeType.thisMonth &&
                            titlesThisMonth != null
                        ? titlesThisMonth
                        : incomeType == IncomeType.prevMonth &&
                                titlesPrevMonth != null
                            ? titlesPrevMonth
                            : titles,
                infos: incomeType == IncomeType.today
                    ? infosToDay
                    : incomeType == IncomeType.thisMonth
                        ? infosThisMonth
                        : infosPrevMonth),
          ),
        ],
      ),
    );
  }

  _contentWidget({
    List<String> titles,
    List<String> infos,
  }) {
    if (titles == null) titles = ["", "", ""];
    if (infos == null) infos = ["", "", ""];
    while (titles.length < 3) {
      titles.add("");
    }
    while (infos.length < 3) {
      infos.add("");
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: 70,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            child: _columnTitleInfo(titles[0], infos[0]),
          ),
          Expanded(
            child: _columnTitleInfo(titles[1], infos[1]),
          ),
          Expanded(
            child: _columnTitleInfo(titles[2], infos[2]),
          ),
        ],
      ),
    );
  }

  _columnTitleInfo(title, info) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title.toString(),
          style: TextStyle(color: Color(0xff999999), fontSize: 12),
        ),
        Container(
          height: 5,
        ),
        Text(
          info.toString(),
          style: TextStyle(color: Colors.black, fontSize: 16),
        )
      ],
    );
  }

  _titleWidget(
      {icon = "",
      title = "",
      Function click,
      IncomeType incomeType,
      Function typeSelectClick,
      String title0,
      String title1,
      String title2}) {
    TextStyle selectStyle = TextStyle(
        color: Color(0xffd5101a), fontSize: 12, fontWeight: FontWeight.w400);
    TextStyle normalStyle = TextStyle(
        color: Color(0xff999999), fontSize: 12, fontWeight: FontWeight.w400);
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            icon,
            width: 28,
            height: 28,
          ),
          Container(
            width: 3,
          ),
          Text(
            title,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Container(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              if (typeSelectClick != null) {
                typeSelectClick(IncomeType.today);
              }
            },
            child: Text(
              !TextUtils.isEmpty(title0) ? title0 : '  今日  ',
              style: incomeType == IncomeType.today ? selectStyle : normalStyle,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (typeSelectClick != null) {
                typeSelectClick(IncomeType.thisMonth);
              }
            },
            child: Text(
              !TextUtils.isEmpty(title1) ? title1 : '  本月  ',
              style: incomeType == IncomeType.thisMonth
                  ? selectStyle
                  : normalStyle,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (typeSelectClick != null) {
                typeSelectClick(IncomeType.prevMonth);
              }
            },
            child: Text(
              !TextUtils.isEmpty(title2) ? title2 : '  上月  ',
              style: incomeType == IncomeType.prevMonth
                  ? selectStyle
                  : normalStyle,
            ),
          ),
          Spacer(),
          CustomImageButton(
            title: "查看明细",
            style: TextStyle(color: Color(0xff999999), fontSize: 12),
            direction: Direction.horizontal,
            onPressed: () {
              if (click != null) click();
            },
          ),
          Icon(
            Icons.keyboard_arrow_right,
            size: 20,
            color: Color(0xff999999),
          ),
        ],
      ),
    );
  }
}
