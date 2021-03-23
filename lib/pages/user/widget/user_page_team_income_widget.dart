import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/app_image_resources.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/shop/widget/shop_page_income_widget.dart';
import 'package:recook/pages/user/model/user_team_income_model.dart';
import 'package:recook/utils/text_utils.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/bottom_time_picker.dart';
import 'package:recook/widgets/custom_painters/round_background_painter.dart';
import 'package:recook/widgets/sort_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class UserPageTeamIncomeWidget extends StatefulWidget {
  UserPageTeamIncomeWidget({Key key}) : super(key: key);

  @override
  _UserPageTeamIncomeWidgetState createState() =>
      _UserPageTeamIncomeWidgetState();
}

class _UserPageTeamIncomeWidgetState
    extends ShopPageIncomeWidgetState<UserPageTeamIncomeWidget> {
  String _selectTime = "";
  UserTeamIncomeModel _incomeModel;
  
  @override
  void initState() {
    super.initState();
    DateTime time = DateTime.now();
    _selectTime =
        "${time.month == 1 ? (time.year - 1).toString() : time.year.toString()}-${time.month == 1 ? "12" : (time.month - 1).toString().padLeft(2, "0")}";
    _getIncomeDetail();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return ListView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      children: <Widget>[
        Container(
          height: 30,
          color: Color.fromRGBO(22, 24, 43, 1),
        ),
        Container(
          child: Stack(
            children: <Widget>[
              // Positioned(
              //   left: 0,
              //   top: 0,
              //   right: 0,
              //   height: 170.0 / 345 * (ScreenUtil.screenWidthDp - 30) + 30,
              //   child: Container(
              //     color: AppColor.blackColor,
              //   ),
              // ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CustomPaint(painter: RoundBackgroundPainter()),
              ),
              Column(
                children: <Widget>[
                  _buildCard(),
                  // Container(
                  //   padding: EdgeInsets.symmetric(vertical: 15),
                  //   child: ShopPageIncomeCardWidget(
                  //     headModel: ShopPageIncomeCardModel(
                  //         "累计收益(瑞币)",
                  //         _incomeModel != null
                  //             ? _incomeModel.data.teamIncome.historyIncome
                  //                 .toStringAsFixed(2)
                  //             : "0.00"),
                  //     subModels: [
                  //       ShopPageIncomeCardModel(
                  //           "销售额(元)",
                  //           _incomeModel != null
                  //               ? _incomeModel.data.teamIncome.teamAmount
                  //                   .toStringAsFixed(2)
                  //               : "0.00"),
                  //       // ShopPageIncomeCardModel("提成比例(%)", _incomeModel!=null? (_incomeModel.data.totalAmount*100).toStringAsFixed(2):"0.00" ),
                  //       ShopPageIncomeCardModel(
                  //           "团队成员(人)",
                  //           _incomeModel != null
                  //               ? _incomeModel.data.teamIncome.memberNum
                  //                   .toString()
                  //               : "0"),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: 50,
                    child: Row(
                      children: <Widget>[
                        TimeSelectTitleWidget(
                          title: _selectTime,
                          click: () {
                            showTimePickerBottomSheet(
                                submit: (time, type) {
                                  Navigator.maybePop(context);
                                  _selectTime =
                                      "${time.year.toString()}-${time.month.toString().padLeft(2, "0")}";
                                  setState(() {});
                                  _getIncomeDetail();
                                },
                                timePickerTypes: [
                                  BottomTimePickerType.BottomTimePickerMonth
                                ]);
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildMidCard(),
                  Column(
                    children: <Widget>[
                      _pageWidget(),
                      noMoreDataView(),
                    ],
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  _buildCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.w),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  '累计收益(瑞币)'.text.color(Colors.black54).size(16.sp).make(),
                  (_incomeModel?.data?.teamIncome?.historyIncome
                              ?.toStringAsFixed(2) ??
                          '0.00')
                      .text
                      .color(Color(0xFF333333))
                      .size(34.sp)
                      .make(),
                ],
              ),
              Spacer(),
              Image.asset(
                UserLevelTool.currentMedalImagePath(),
                height: 55.w,
                width: 55.w,
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  '销售额(元)'.text.color(Colors.black54).size(16.sp).make(),
                  (_incomeModel?.data?.teamIncome?.teamAmount
                              ?.toStringAsFixed(2) ??
                          '0.00')
                      .text
                      .color(Color(0xFF333333))
                      .size(24.sp)
                      .make(),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  '团队人数(人)'.text.color(Colors.black54).size(16.sp).make(),
                  (_incomeModel?.data?.teamIncome?.memberNum?.toString() ?? '0')
                      .text
                      .color(Color(0xFF333333))
                      .size(24.sp)
                      .make(),
                ],
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.w),
            color: Color.fromRGBO(166, 166, 173, 0.43),
            blurRadius: 6.w,
          )
        ],
        image: DecorationImage(
          image: AssetImage(UserLevelTool.currentCardImagePath()),
          fit: BoxFit.cover,
        ),
      ),
      height: 170.w,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
    );
  }

  _buildMidCard() {
    return VxBox(
            child: <Widget>[
      '团队收益(元)'.text.color(Colors.black54).size(18.sp).make(),
      6.hb,
      (_incomeModel?.data?.incomeDetail?.income?.toStringAsFixed(2) ?? '0.00')
          .text
          .color(Color(0xFF333333))
          .size(24.sp)
          .make(),
      36.hb,
      Row(
        children: [
          Column(
            children: [
              '销售额(元)'.text.color(Colors.black54).size(14.sp).make(),
              (_incomeModel?.data?.incomeDetail?.amount?.toStringAsFixed(2) ??
                      '0.00')
                  .text
                  .color(Color(0xFF333333))
                  .size(16.sp)
                  .make()
            ],
          ),
          Spacer(),
          Column(
            children: [
              '提成比例(%)'.text.color(Colors.black54).size(14.sp).make(),
              (_incomeModel?.data?.incomeDetail?.percent?.toStringAsFixed(2) ??
                      '0.00')
                  .text
                  .color(Color(0xFF333333))
                  .size(16.sp)
                  .make()
            ],
          ),
        ],
      ),
    ].column(
      crossAlignment: CrossAxisAlignment.start,
    ))
        .padding(EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.w))
        .margin(EdgeInsets.symmetric(horizontal: 15))
        .color(Colors.white)
        .withRounded(value: 5.w)
        .make();
  }

  _pageWidget() {
    double width = ScreenUtil.screenWidthDp;
    double height = 170 * width / 375;
    return Container(
        constraints: BoxConstraints(
          minHeight: height,
          minWidth: width,
        ),
        decoration: BoxDecoration(
            image: DecorationImage(
          // centerSlice: Rect.fromLTRB(30, 90, 30, 30),
          centerSlice: Rect.fromLTWH(30, 140, 40, 1),
          image: AssetImage(
            UserImageName.income_page_bg,
          ),
        )),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          margin: EdgeInsets.only(top: 30, bottom: 30),
          child: Column(
            children: <Widget>[
              // Container(
              //   height: 75,
              //   child: Column(
              //     children: <Widget>[
              //       Container(
              //         height: 30,
              //         alignment: Alignment.centerLeft,
              //         child: Text(
              //           "收益明细",
              //           style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 14,
              //               fontWeight: FontWeight.w500),
              //         ),
              //       ),
              //       Spacer(),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         // crossAxisAlignment: CrossAxisAlignment.start,
              //         children: <Widget>[
              //           textColumn(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               titleText: "结算收益(瑞币)",
              //               infoText: _incomeModel == null
              //                   ? "0.00"
              //                   : _incomeModel.data.incomeDetail.income
              //                       .toStringAsFixed(2),
              //               infoAligment: Alignment.bottomLeft),
              //           textColumn(
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               titleText: "销售额(元)",
              //               infoText: _incomeModel == null
              //                   ? "0.00"
              //                   : _incomeModel.data.incomeDetail.amount
              //                       .toStringAsFixed(2),
              //               infoAligment: Alignment.bottomLeft),
              //           textColumn(
              //               crossAxisAlignment: CrossAxisAlignment.end,
              //               titleText: "提成比例(%)",
              //               infoText: _incomeModel == null
              //                   ? "0.00"
              //                   : _incomeModel.data.incomeDetail.percent
              //                       .toStringAsFixed(2),
              //               infoAligment: Alignment.bottomLeft),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                margin: EdgeInsets.only(top: 30),
                height: 40,
                child: Row(
                  children: <Widget>[
                    Text(
                      "团队贡献榜",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    SortWidget(
                      sortType: SortType.SortAscending,
                      onChange: (sortType) => _sortChange(sortType),
                    )
                  ],
                ),
              ),
              Column(
                children: _widgetList(),
              )
            ],
          ),
        ));
  }

  _sortChange(sortType) {
    if (_incomeModel == null ||
        _incomeModel.data == null ||
        _incomeModel.data.billboard == null) {
      return;
    }
    if (sortType == SortType.SortAscending) {
      // 升序
      _incomeModel.data.billboard.sort((left, right) {
        if (left.amount > right.amount) {
          return 1;
        }
        return 0;
      });
    } else {
      // 降序
      _incomeModel.data.billboard.sort((left, right) {
        if (left.amount > right.amount) {
          return 0;
        }
        return 1;
      });
    }
    setState(() {});
  }

  _widgetList() {
    List<Widget> widgetList = [];
    if (_incomeModel == null ||
        _incomeModel.data == null ||
        _incomeModel.data.billboard == null) {
      widgetList.add(noDataView(""));
      return widgetList;
    }
    widgetList = _incomeModel.data.billboard.map((model) {
      return memberWidget(
          url: model.headImgUrl,
          name: model.username,
          phone: model.mobile,
          amount: model.amount.toStringAsFixed(2),
          roleLevel: model.roleLevel.toInt());
    }).toList();
    return widgetList;
  }

  _getIncomeDetail() async {
    ResultData resultData = await HttpManager.post(UserApi.team_income, {
      // "userId": 109,
      // "date": "2020-06"
      "userId": UserManager.instance.user.info.id,
      "date": TextUtils.isEmpty(_selectTime)
          ? "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padRight(2, "0")}"
          : _selectTime,
    });
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    UserTeamIncomeModel model = UserTeamIncomeModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    _incomeModel = model;
    setState(() {});
  }
}
