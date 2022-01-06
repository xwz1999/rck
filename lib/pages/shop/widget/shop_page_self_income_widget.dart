import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/shop/model/shop_self_income_model.dart';
import 'package:jingyaoyun/pages/shop/widget/shop_page_bar_card_widget.dart';
import 'package:jingyaoyun/pages/shop/widget/shop_page_income_widget.dart';
import 'package:jingyaoyun/widgets/bottom_time_picker.dart';

class ShopPageSelfIncomeWidget extends StatefulWidget {
  ShopPageSelfIncomeWidget({Key key}) : super(key: key);

  @override
  _ShopPageSelfIncomeWidgetState createState() => _ShopPageSelfIncomeWidgetState();
}

class _ShopPageSelfIncomeWidgetState extends ShopPageIncomeWidgetState<ShopPageSelfIncomeWidget> {

  String _selectTime = "";
  ShopSelfIncomeModel _shopSelfIncomeModel;
  @override
  void initState() { 
    super.initState();
    DateTime time = DateTime.now();
    _selectTime = "${time.year.toString()}-${time.month.toString().padLeft(2, "0")}";
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
                left: 0, right: 0, top: 0,
                height: 200/375*ScreenUtil().screenWidth,
                child: Image.asset(ShopImageName.income_appbar_bg, fit: BoxFit.fill,),
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
                          click: (){
                            showTimePickerBottomSheet(
                              submit: (time, type) {
                                Navigator.maybePop(context);
                                _selectTime = "${time.year.toString()}-${time.month.toString().padLeft(2, "0")}";
                                setState(() {});
                                _getIncomeDetail();
                              },
                              timePickerTypes: [BottomTimePickerType.BottomTimePickerMonth]
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  ShopPageIncomeCardWidget(
                    headModel: ShopPageIncomeCardModel("预估收益(瑞币)", _shopSelfIncomeModel!=null? _shopSelfIncomeModel.data.totalIncome.toStringAsFixed(2): "0.00"),
                    subModels: [
                      ShopPageIncomeCardModel("销售额(元)", _shopSelfIncomeModel!=null? _shopSelfIncomeModel.data.totalAmount.toStringAsFixed(2):"0.00" ),
                      ShopPageIncomeCardModel("订单数(笔)", _shopSelfIncomeModel!=null? _shopSelfIncomeModel.data.totalOrderCount.toString():"0" ),
                    ],
                  ),
                  Container(height: 10,),
                  cellWidget(incomeStyle: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w400 )),
                  _shopSelfIncomeModel !=null 
                  && _shopSelfIncomeModel.data.incomes!=null
                  && _shopSelfIncomeModel.data.incomes.length>0 ? Column(
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

  _widgetList(){
    List<Widget> widgetList = [];
    widgetList = _shopSelfIncomeModel.data.incomes.map((model){
      DateTime time = DateTime.parse(model.date);
      return cellWidget(
        time: "${time.month}月${time.day}日",
        orderNum: model.orderCount.toString(),
        income: model.income.toStringAsFixed(2),
        sales: model.amount.toStringAsFixed(2)
      );
    }).toList();
    widgetList.add(noMoreDataView());
    return widgetList;
  }

  _getIncomeDetail() async {
    ResultData resultData = await HttpManager.post(ShopApi.shop_self_income, {
      "userId": UserManager.instance.user.info.id,
      "month": TextUtils.isEmpty(_selectTime)? "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padRight(2, "0")}" : _selectTime,
    });
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    ShopSelfIncomeModel model = ShopSelfIncomeModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    _shopSelfIncomeModel = model;
    // _teamIncomeModel = model;
    setState(() {});
  }

}
