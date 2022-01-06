import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/shop/widget/shop_page_bar_card_widget.dart';
import 'package:jingyaoyun/pages/shop/widget/shop_page_income_widget.dart';
import 'package:jingyaoyun/pages/user/model/user_self_income_model.dart';
import 'package:jingyaoyun/utils/text_utils.dart';
import 'package:jingyaoyun/widgets/bottom_time_picker.dart';

class UserPageShareIncomeWidget extends StatefulWidget {
  UserPageShareIncomeWidget({Key key}) : super(key: key);

  @override
  _UserPageShareIncomeWidgetState createState() =>
      _UserPageShareIncomeWidgetState();
}

class _UserPageShareIncomeWidgetState
    extends ShopPageIncomeWidgetState<UserPageShareIncomeWidget> {
  String _selectTime = "";
  UserSelfIncomeModel _incomeModel;
  @override
  void initState() {
    super.initState();
    DateTime time = DateTime.now();
    _selectTime =
        "${time.year.toString()}-${time.month.toString().padLeft(2, "0")}";
    _getIncomeDetail();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return ListView(
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                height: 170.0 / 345 * (ScreenUtil().screenWidth - 30) + 30,
                child: Container(
                  color: AppColor.blackColor,
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: ShopPageIncomeCardWidget(
                      headModel: ShopPageIncomeCardModel(
                          "累计收益(瑞币)",
                          _incomeModel != null
                              ? _incomeModel.data.myShopping.historyIncome
                                  .toStringAsFixed(2)
                              : "0.00"),
                      subModels: [
                        ShopPageIncomeCardModel(
                            "销售额(元)",
                            _incomeModel != null
                                ? _incomeModel.data.myShopping.amount
                                    .toStringAsFixed(2)
                                : "0.00"),
                        // ShopPageIncomeCardModel("提成比例(%)", _incomeModel!=null? (_incomeModel.data.totalAmount*100).toStringAsFixed(2):"0.00" ),
                        ShopPageIncomeCardModel(
                            "订单数(笔)",
                            _incomeModel != null
                                ? _incomeModel.data.myShopping.orderNum
                                    .toString()
                                : "0"),
                      ],
                    ),
                  ),
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
                        Spacer(),
                        Text(
                          "当月收益(瑞币):${_incomeModel == null ? "0" : _incomeModel.data.coinNum.toString()}",
                          style:
                              TextStyle(color: Color(0xff999999), fontSize: 14),
                        )
                      ],
                    ),
                  ),
                  cellWidget(
                      income: "结算收益",
                      incomeStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                  _incomeModel != null &&
                          _incomeModel.data.list != null &&
                          _incomeModel.data.list.length > 0
                      ? Column(
                          children: _widgetList(),
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

  _widgetList() {
    List<Widget> widgetList = [];
    widgetList = _incomeModel.data.list.map((model) {
      DateTime time = DateTime.parse(model.time);
      return cellWidget(
          time: "${time.month}月${time.day}日",
          orderNum: model.orderNum.toString(),
          income: model.historyIncome.toStringAsFixed(2),
          sales: model.amount.toStringAsFixed(2));
    }).toList();
    widgetList.add(noMoreDataView());
    return widgetList;
  }

  _getIncomeDetail() async {
    ResultData resultData = await HttpManager.post(UserApi.share_income, {
      "orderBy": "desc",
      "userId": UserManager.instance.user.info.id,
      "date": TextUtils.isEmpty(_selectTime)
          ? "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padRight(2, "0")}"
          : _selectTime,
    });
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    UserSelfIncomeModel model = UserSelfIncomeModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    _incomeModel = model;
    setState(() {});
  }
}
