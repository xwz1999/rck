import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/shop/model/shop_team_income_model.dart';
import 'package:recook/pages/shop/widget/shop_page_bar_card_widget.dart';
import 'package:recook/pages/shop/widget/shop_page_income_widget.dart';
import 'package:recook/widgets/bottom_time_picker.dart';
import 'package:recook/widgets/sort_widget.dart';

class ShopPageTeamIncomeWidget extends StatefulWidget {
  ShopPageTeamIncomeWidget({Key key}) : super(key: key);

  @override
  _ShopPageTeamIncomeWidgetState createState() =>
      _ShopPageTeamIncomeWidgetState();
}

class _ShopPageTeamIncomeWidgetState
    extends ShopPageIncomeWidgetState<ShopPageTeamIncomeWidget> {
  String _selectTime = "";
  ShopTeamIncomeModel _shopTeamIncomeModel;
  @override
  void initState() {
    super.initState();
    DateTime time = DateTime.now();
    _selectTime =
        "${time.year.toString()}-${time.month.toString().padLeft(2, "0")}-${time.day.toString().padLeft(2, "0")}";
    _getIncomeDetail();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return ListView(
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        Container(
          color: AppColor.frenchColor,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 200 / 375 * ScreenUtil.screenWidthDp,
                child: Container(
                  child: Image.asset(
                    ShopImageName.income_appbar_bg,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        TimeSelectTitleWidget(
                          color: Colors.white,
                          backgroundColor: Colors.white.withAlpha(0),
                          title: _selectTime,
                          click: () {
                            showTimePickerBottomSheet(
                                submit: (time, type) {
                                  Navigator.maybePop(context);
                                  if (type ==
                                      BottomTimePickerType
                                          .BottomTimePickerDay) {
                                    _selectTime =
                                        "${time.year.toString()}-${time.month.toString().padLeft(2, "0")}-${time.day.toString().padLeft(2, "0")}";
                                  } else if (type ==
                                      BottomTimePickerType
                                          .BottomTimePickerMonth) {
                                    _selectTime =
                                        "${time.year.toString()}-${time.month.toString().padLeft(2, "0")}";
                                  }
                                  setState(() {});
                                  _getIncomeDetail();
                                },
                                // type: BottomTimePickerType.BottomTimePickerMonth
                                timePickerTypes: [
                                  BottomTimePickerType.BottomTimePickerDay,
                                  BottomTimePickerType.BottomTimePickerMonth
                                ]);
                          },
                        ),
                      ],
                    ),
                  ),
                  ShopPageIncomeCardWidget(
                    headModel: ShopPageIncomeCardModel(
                        "预估收益(瑞币)",
                        _shopTeamIncomeModel != null
                            ? _shopTeamIncomeModel.data.income
                                .toStringAsFixed(2)
                            : "0.00"),
                    subModels: [
                      ShopPageIncomeCardModel(
                          "销售额(元)",
                          _shopTeamIncomeModel != null
                              ? _shopTeamIncomeModel.data.amount
                                  .toStringAsFixed(2)
                              : "0.00"),
                      ShopPageIncomeCardModel(
                          "提成比例(%)",
                          _shopTeamIncomeModel != null
                              ? (_shopTeamIncomeModel.data.percent * 100)
                                  .toStringAsFixed(2)
                              : "0.00"),
                      ShopPageIncomeCardModel(
                          "团队成员(人)",
                          _shopTeamIncomeModel != null
                              ? _shopTeamIncomeModel.data.memberCount.toString()
                              : "0"),
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                  _shopTeamIncomeModel != null &&
                          _shopTeamIncomeModel.data.members != null &&
                          _shopTeamIncomeModel.data.members.length > 0
                      ? Column(
                          children: <Widget>[
                            _pageWidget(),
                            noMoreDataView(),
                          ],
                        )
                      : noDataView(""),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  _pageWidget() {
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
          image: AssetImage(
            ShopImageName.income_page_bg,
          ),
        )),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          margin: EdgeInsets.only(top: 30, bottom: 30),
          child: Column(
            children: <Widget>[
              Container(
                height: 60,
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
    if (_shopTeamIncomeModel == null ||
        _shopTeamIncomeModel.data.members == null ||
        _shopTeamIncomeModel.data.members.length <= 0) {
      return;
    }
    List<Members> oldMember = _shopTeamIncomeModel.data.members;
    if (sortType == SortType.SortAscending) {
      // 升序
      _shopTeamIncomeModel.data.members.sort((left, right) {
        if (left.amount > right.amount) {
          return 1;
        }
        return 0;
      });
    } else {
      // 降序
      _shopTeamIncomeModel.data.members.sort((left, right) {
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
    widgetList = _shopTeamIncomeModel.data.members.map((model) {
      return memberWidget(
          url: model.headImgUrl,
          roleLevel: model.roleLevel.toInt(),
          name: model.nickname,
          amount: model.amount.toStringAsFixed(2));
    }).toList();
    return widgetList;
  }

  _getIncomeDetail() async {
    ResultData resultData = await HttpManager.post(ShopApi.shop_team_income, {
      "userId": UserManager.instance.user.info.id,
      // "date": "2020-06-01"
      "date": TextUtils.isEmpty(_selectTime) ? "" : _selectTime,
    });
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    ShopTeamIncomeModel model = ShopTeamIncomeModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    _shopTeamIncomeModel = model;
    // _teamIncomeModel = model;
    setState(() {});
  }
}
