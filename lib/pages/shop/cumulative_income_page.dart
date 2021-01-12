import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/app_image_resources.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/team_income_model.dart';
import 'package:recook/pages/user/functions/user_benefit_func.dart';
import 'package:recook/pages/user/model/user_accumulate_model.dart';
import 'package:recook/pages/user/user_page_sub_income_page.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/bottom_time_picker.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/dashed_rect.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class CumulativeIncomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CumulativeIncomePageState();
  }
}

class _CumulativeIncomePageState extends BaseStoreState<CumulativeIncomePage>
    with TickerProviderStateMixin {
  //user new api
  //
  TeamIncomeModel _teamIncomeModel;
  bool _noData = false;

  String _selectYear;

  ///累计收益
  ///
  UserAccumulateModel _model = UserAccumulateModel.zero();

  ///自购收益
  double get _purchase => _model?.data?.purchaseAmount ?? 0;

  ///导购收益
  double get _guide => _model?.data?.guideAmount ?? 0;

  ///团队收益
  double get _team => _model?.data?.teamAmount ?? 0;

  ///推荐奖励
  double get _recommand => _model?.data?.recommendAmount ?? 0;

  ///平台奖励收益
  double get _reward => _model?.data?.rewardAmount ?? 0;

  double get _allAmount => _purchase + _guide + _team + _recommand + _reward;

  @override
  void initState() {
    _selectYear = DateTime.now().year.toString();
    _getShopIncome();
    _getAccumulate();
    super.initState();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        appBackground: AppColor.blackColor,
        themeData: AppThemes.themeDataMain.appBarTheme,
        elevation: 0,
        title: "累计收益",
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      color: AppColor.frenchColor,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 200 / 375 * ScreenUtil.screenWidthDp,
            child: Image.asset(
              ShopImageName.income_appbar_bg,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  _barWidget(),
                  _selectTimeWidget(),
                  _infoWidgetV2(),
                  _infoWidget(),
                ],
              ))
        ],
      ),
    );
  }

  _showTimePickerBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: 350 + MediaQuery.of(context).padding.bottom,
            child: BottomTimePicker(
              timePickerTypes: [BottomTimePickerType.BottomTimePickerYear],
              cancle: () {
                Navigator.maybePop(context);
              },
              submit: (time, type) {
                Navigator.maybePop(context);
                _selectYear = time.year.toString();
                setState(() {});
                _getShopIncome();
              },
            ));
      },
    ).then((val) {
      if (mounted) {}
    });
  }

  _selectTimeWidget() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
      height: 50,
      child: Row(
        children: <Widget>[
          TimeSelectTitleWidget(
            title: _selectYear,
            click: () {
              _showTimePickerBottomSheet();
            },
          ),
          Spacer(),
          Container(
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "年度收益:",
                style: TextStyle(
                  color: Color(0xff999999),
                  fontSize: 14,
                ),
              ),
              TextSpan(
                  text: _teamIncomeModel == null
                      ? "0.00"
                      : _teamIncomeModel.data.yearIncome?.toStringAsFixed(2),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColor.redColor,
                      fontSize: 14)),
            ])),
          ),
        ],
      ),
    );
  }

  _barWidget() {
    double width = ScreenUtil.screenWidthDp - 30;
    double height = 170.0 / 345 * width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      width: width,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 40,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "收益汇总",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenAdapterUtils.setSp(14))),
                TextSpan(
                    text: "(瑞币)",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: ScreenAdapterUtils.setSp(10))),
              ]),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(5.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(UserLevelTool.currentCardImagePath()),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: _textColumn(
                      titleText: "累计收益",
                      infoText: _allAmount.toStringAsFixed(2),
                      infoFontSize: 24,
                    ),
                  ),
                  20.hb,
                  GridView(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 5.w,
                      childAspectRatio: 110 / 70,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _buildGridColumn(
                        context,
                        title: '自购收益',
                        value: _purchase.toStringAsFixed(2),
                        index: 0,
                      ),
                      _buildGridColumn(
                        context,
                        title: '导购收益',
                        value: _guide.toStringAsFixed(2),
                        index: 1,
                      ),
                      ..._teamIncomeModel?.data?.roleVisable ?? false
                          ? [
                              _buildGridColumn(
                                context,
                                title: '团队收益',
                                value: _team.toStringAsFixed(2),
                                index: 2,
                              )
                            ]
                          : [],
                      _buildGridColumn(
                        context,
                        title: "推荐收益",
                        value: _recommand.toStringAsFixed(2),
                        index: 3,
                      ),
                      _buildGridColumn(
                        context,
                        title: "平台奖励",
                        value: _reward.toStringAsFixed(2),
                        index: 4,
                      ),
                    ],
                  ),
                  // Container(
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       _teamIncomeModel != null &&
                  //               _teamIncomeModel.data.roleVisable
                  //           ? Spacer()
                  //           : Container(),
                  //       _teamIncomeModel != null &&
                  //               _teamIncomeModel.data.roleVisable
                  //           ? _textColumn(
                  //               titleText: "团队收益",
                  //               infoText: _teamIncomeModel == null
                  //                   ? "0.00"
                  //                   : _teamIncomeModel
                  //                       .data.accumulateIncome.team
                  //                       ?.toStringAsFixed(2),
                  //               infoColor: UserLevelTool.roleLevelEnum(
                  //                           _teamIncomeModel
                  //                               ?.data?.roleLevel) ==
                  //                       UserRoleLevel.Master
                  //                   ? Colors.black26
                  //                   : Colors.black)
                  //           : Container(),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ).box.withShadow([
            BoxShadow(
              color: Color(0x8FA6A6AD),
              offset: Offset(0, 2.w),
              blurRadius: 6.w,
            )
          ]).make(),
        ],
      ),
    );
  }

  _infoWidgetV2() {
    return Container(
      constraints: BoxConstraints(minHeight: 200),
      decoration: BoxDecoration(
          image: DecorationImage(
        // centerSlice: Rect.fromLTRB(30, 90, 30, 30),
        centerSlice: Rect.fromLTWH(30, 100, 30, 1),
        image: AssetImage(R.ASSETS_SHOP_PAGE_INCOME_PAGE_BG_PNG),
      )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          10.hb,
          [
            64.hb,
            30.wb,
            '月度收益'.text.size(14).black.bold.make(),
            Spacer(),
            '共${3}期收益'.text.size(14).color(Colors.black38).make(),
            30.wb,
          ].row(),
          DashedRect(
            color: Color(0xFFE6E6E6),
          ).pSymmetric(h: 15.w),
          20.hb,
          ...<Widget>[
            _buildInfoItem(isFirst: true),
            _buildInfoItem(),
            _buildInfoItem(),
            _buildInfoItem(),
            _buildInfoItem(),
          ].sepWidget(separate: 20.hb),
          30.hb,
        ],
      ),
    );
  }

  _buildInfoItem({
    int month,
    int benefit,
    bool isFirst = false,
  }) {
    return [
      VxBox(
        child: Column(
          children: [
            Row(),
          ],
        ),
      )
          //TODO unknown height
          .height(168.w)
          .color(Color(0xFFF7F8FA))
          .padding(EdgeInsets.all(15.w))
          .margin(EdgeInsets.symmetric(horizontal: 30.w))
          .withRounded(value: 5.w)
          .make(),
      isFirst
          ? SizedBox()
          : Positioned(
              left: 40.w,
              top: -30.w,
              child: Container(
                height: 40.w,
                width: 3.w,
                decoration: BoxDecoration(
                  color: Color(0xFFD5101A),
                  borderRadius: BorderRadius.circular(3.w),
                ),
              ),
            ),
      isFirst
          ? SizedBox()
          : Positioned(
              right: 40.w,
              top: -30.w,
              child: Container(
                height: 40.w,
                width: 3.w,
                decoration: BoxDecoration(
                  color: Color(0xFFD5101A),
                  borderRadius: BorderRadius.circular(3.w),
                ),
              ),
            ),
    ].stack(clip: Clip.none);
  }

  _infoWidget() {
    double width = ScreenUtil.screenWidthDp;
    double height = 140 * width / 375;
    return Container(
      constraints: BoxConstraints(
        minHeight: height,
        minWidth: width,
      ),
      decoration: BoxDecoration(
          image: DecorationImage(
        // centerSlice: Rect.fromLTRB(30, 90, 30, 30),
        centerSlice: Rect.fromLTWH(30, 100, 30, 1),
        image: AssetImage(R.ASSETS_SHOP_PAGE_INCOME_PAGE_BG_PNG),
      )),
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 30),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              height: 60,
              child: Row(
                children: <Widget>[
                  Text(
                    "月度收益",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Text(
                    _teamIncomeModel == null
                        ? ""
                        : "共${_teamIncomeModel.data.incomes.length}期收益",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black26,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              width: double.infinity,
              child: DashedRect(
                color: Color(0xffe6e6e6),
                strokeWidth: 2,
                gap: 5,
              ),
            ),
            _teamIncomeModel == null ||
                    !(_teamIncomeModel.data.incomes != null &&
                        _teamIncomeModel.data.incomes.length > 0)
                ? Container(
                    width: 140,
                    height: 130,
                    child: Image.asset(ShopImageName.income_nodata),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                  )
                : Container(
                    child: Column(children: _itemList()),
                  )
          ],
        ),
        // height: height+500,
      ),
    );
  }

  _itemList() {
    List<Widget> widgetList = [];
    for (var i = 0; i < _teamIncomeModel.data.incomes.length; i++) {
      widgetList.add(_itemWidget(_teamIncomeModel.data.incomes[i],
          isFirst: i == 0,
          isLast: i == _teamIncomeModel.data.incomes.length - 1));
    }
    return widgetList;
  }

  _itemWidget(Incomes income, {bool isFirst = false, bool isLast = false}) {
    // DateTime time = DateTime.parse(income.month);
    DateFormat sourceFormat = DateFormat("yyyy-MM");
    DateTime time = sourceFormat.parse(income.month);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      height: 130,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 10,
            bottom: 10,
            child: Container(
              padding: EdgeInsets.all(13),
              decoration: BoxDecoration(
                  color: Color(0xfff7f8fa),
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: time.month.toString(),
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        TextSpan(
                          text: "月",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        )
                      ])),
                      Spacer(),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: "总收益:",
                          style: TextStyle(color: Colors.black26, fontSize: 14),
                        ),
                        TextSpan(
                          text: income.totalIncome.toStringAsFixed(2),
                          style:
                              TextStyle(color: AppColor.redColor, fontSize: 14),
                        )
                      ])),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      _textColumn(
                        titleColor: Color(0xff666666),
                        titleAligment: Alignment.centerLeft,
                        titleText: "自购收益",
                        infoText: income.myIncome.toStringAsFixed(2),
                      ),
                      Spacer(),
                      _textColumn(
                        titleColor: Color(0xff666666),
                        titleAligment: Alignment.centerLeft,
                        titleText: "导购收益",
                        infoText: income.shareIncome.toStringAsFixed(2),
                      ),
                      _teamIncomeModel.data.roleVisable
                          ? Spacer()
                          : Container(),
                      _teamIncomeModel.data.roleVisable
                          ? _textColumn(
                              titleColor: UserLevelTool.roleLevelEnum(
                                          _teamIncomeModel?.data?.roleLevel) ==
                                      UserRoleLevel.Master
                                  ? Colors.black26
                                  : Color(0xff666666),
                              titleAligment: Alignment.centerLeft,
                              titleText: "团队收益",
                              infoText: income.teamIncome < 0
                                  ? "未结算"
                                  : income.teamIncome.toStringAsFixed(2),
                              infoColor: UserLevelTool.roleLevelEnum(
                                          _teamIncomeModel?.data?.roleLevel) ==
                                      UserRoleLevel.Master
                                  ? Colors.black26
                                  : income.teamIncome < 0
                                      ? AppColor.redColor
                                      : Colors.black,
                              infoFontSize: income.teamIncome < 0 ? 12 : 16)
                          : Container()
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
              left: 10,
              top: 0,
              width: 3,
              height: 19,
              child: Offstage(
                  offstage: isFirst,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(2),
                            bottomRight: Radius.circular(2)),
                        color: AppColor.redColor),
                  ))),
          Positioned(
              right: 10,
              top: 0,
              width: 3,
              height: 19,
              child: Offstage(
                  offstage: isFirst,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(2),
                            bottomRight: Radius.circular(2)),
                        color: AppColor.redColor),
                  ))),
          Positioned(
              left: 10,
              bottom: 0,
              width: 3,
              height: 19,
              child: Offstage(
                  offstage: isLast,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2)),
                        color: AppColor.redColor),
                  ))),
          Positioned(
              right: 10,
              bottom: 0,
              width: 3,
              height: 19,
              child: Offstage(
                  offstage: isLast,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2)),
                        color: AppColor.redColor),
                  ))),
        ],
      ),
    );
  }

  _getShopIncome() async {
    ResultData resultData = await HttpManager.post(ShopApi.shop_addup_income, {
      "userId": UserManager.instance.user.info.id,
      "year": TextUtils.isEmpty(_selectYear)
          ? DateTime.now().year.toString()
          : _selectYear,
    });
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    TeamIncomeModel model = TeamIncomeModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    _teamIncomeModel = model;
    setState(() {});
  }

  _getAccumulate() async {
    _model = await UserBenefitFunc.accmulate();
    setState(() {});
  }

  _textColumn(
      {String titleText = "",
      Color titleColor = Colors.black54,
      double titleFontSize = 14,
      Alignment titleAligment = Alignment.centerLeft,
      String infoText = "",
      Color infoColor = Colors.black,
      double infoFontSize = 20,
      Alignment infoAligment = Alignment.centerLeft}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: titleAligment,
          child: Text(
            titleText,
            style: TextStyle(color: titleColor, fontSize: titleFontSize),
          ),
        ),
        Container(height: 5),
        Container(
          alignment: infoAligment,
          child: Text(
            infoText,
            style: TextStyle(color: infoColor, fontSize: infoFontSize),
          ),
        )
      ],
    );
  }
}

_buildGridColumn(
  BuildContext context, {
  String title,
  String value,
  int index,
}) {
  return MaterialButton(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    padding: EdgeInsets.zero,
    onPressed: () {
      _goToNextPage(index, context);
    },
    child: Align(
      child: <Widget>[
        [
          title.text.color(Color(0xff3a3943)).size(14.sp).make(),
          CustomImageButton(
            child: Image.asset(R.ASSETS_SHOP_HELPER_PNG,
                width: 12.w, height: 12.w),
            onPressed: () => _openQuestDialog(index, title, context),
          ),
        ].row(),
        3.hb,
        value.text.color(Color(0xFF333333)).size(20.sp).make(),
      ].column(
        crossAlignment: CrossAxisAlignment.start,
        alignment: MainAxisAlignment.center,
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

_goToNextPage(int index, BuildContext context) {
  switch (index) {
    case 0:
      break;
    case 1:
      break;
    case 2:
      AppRouter.push(context, RouteName.USER_PAGE_SUB_INCOME_PAGE,
          arguments: UserPageSubIncomesPage.setArguments(
              UserPageSubIncomesPageType.UserPageTeamIncome));
      break;
    case 3:
      break;
  }
}

_openQuestDialog(int index, String title, BuildContext context) {
  String content = '';
  switch (index) {
    case 0:
      content = '您本人下单并确认收货后，您获得的佣金。';
      break;
    case 1:
      content = '''您的直属会员下单并确认收货后，您获得的佣金。


直属会员：您的团队成员中，若某个会员与您之间的链路没有店主或店铺角色，则该会员称为您的直属会员。''';
      break;
    case 2:
      content = '每月22日结算您团队上一个自然月确认收货的订单，按团队销售额的3%计算收益。';
      break;
    case 3:
      content = '每月22日结算您推荐的团队上一个自然月确认收货的订单，按团队销售额的4%计算收益。';
      break;
    case 4:
      content = '每月22日结算您可获取平台奖励的团队的上一个自然月确认收货的订单，按团队销售额的5%计算收益。';
      break;
  }
  showDialog(
    context: context,
    child: NormalContentDialog(
      title: title,
      content: content.text.color(Color(0xFF333333)).make(),
      items: [],
      deleteItem: '确定',
      type: NormalTextDialogType.delete,
      listener: (_) => Navigator.pop(context),
      deleteListener: () => Navigator.pop(context),
    ),
  );
}

/*
@override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        themeData: AppThemes.themeDataGrey.appBarTheme,
        elevation: 0,
        title: "累计收入",
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: TabBar(
            controller: _tabController,
            unselectedLabelColor: Colors.black,
            labelColor: AppColor.themeColor,
            indicatorColor: AppColor.themeColor,
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: false,
            labelPadding: EdgeInsets.all(0),
            labelStyle: AppTextStyle.generate(14, fontWeight: FontWeight.w500),
            tabs: [
              Tab(text:"团队收入", ),
              Tab(text:"提成收入", ),
          ]),
        ),
      ),
      body: CacheTabBarView(
        controller: _tabController,
        children: <Widget>[
          TeamIncomeWidget(),
          CommissionIncomeWidget(),
          // Container()
          // FocusPage(),
          // // FocusPage(),
          // RecommendPage(),
      ],),
    );
  }
*/
