import 'package:flutter/material.dart';

import 'package:common_utils/common_utils.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/user/functions/user_balance_func.dart';
import 'package:recook/pages/user/model/user_balance_history_model.dart';
import 'package:recook/pages/user/model/user_balance_info_model.dart';
import 'package:recook/pages/user/user_cash_withdraw_page.dart';
import 'package:recook/widgets/bottom_time_picker.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:recook/widgets/refresh_widget.dart';

class UserBalancePage extends StatefulWidget {
  UserBalancePage({Key key}) : super(key: key);

  @override
  _UserBalancePageState createState() => _UserBalancePageState();
}

class _UserBalancePageState extends State<UserBalancePage> {
  UserBalanceInfoModel _model = UserBalanceInfoModel.zero();
  UserBalanceHistoryModel _historyModel = UserBalanceHistoryModel.zero();

  ///查询的月份
  DateTime _date = DateTime.now();

  String get _month => DateUtil.formatDate(_date, format: 'yyyy-MM');

  /// 余额类型 1=订单支付 2=订单退款 3=提现 4=提现失败 5=瑞币转入
  int _status = 0;

  //overlay entry
  OverlayEntry _entry;
  Map<int, String> get _statusMap => {
        0: '全部',
        1: '订单支付',
        2: '订单退款',
        3: '提现',
        4: '提现失败',
        5: '瑞币转入',
      };
  String get _statusValue {
    return _statusMap[_status];
  }

  GSRefreshController _refreshController = GSRefreshController();

  _buildListItem(ListItem item) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      width: double.infinity,
      height: 60,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(right: 30),
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.comment,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 13),
                        ),
                        Container(
                          height: 3,
                        ),
                        Text(
                          item.createdAt,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      item.amount.toStringAsFixed(2),
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
              )),
          Container(
            height: 1,
            color: AppColor.frenchColor,
          )
        ],
      ),
    );
  }


  _buildOverlay() {
    return GestureDetector(
      onTap: () {
        _entry?.remove();
        _entry = null;
      },
      child: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.bottomCenter,
        child: Container(
          alignment: Alignment.topCenter,
          child: GridView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.rw,
              mainAxisSpacing: 10.rw,
              childAspectRatio: 2,
            ),
            children: _statusMap.entries.map((e) {
              bool _same = e.key == _status;
              return MaterialButton(
                onPressed: () {
                  _entry?.remove();
                  _entry = null;
                  _status = e.key;
                  setState(() {});
                  _refreshController.requestRefresh();
                },
                child: _same
                    ? e.value.text.red500.make()
                    : e.value.text.black.make(),
              );
            }).toList(),
          ).material(color: Colors.white),
          height: MediaQuery.of(context).size.height -
              214.rw -
              MediaQuery.of(context).padding.top,
          width: MediaQuery.of(context).size.width,
          color: Colors.black26,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    UserBalanceFunc.info().then((model) => setState(() => _model = model));
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _refreshController.requestRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: RecookScaffold(
        title: '我的余额',
        whiteBg: true,
        actions: [
          CustomImageButton(
            padding: EdgeInsets.symmetric(horizontal: 16.rw),
            onPressed: () {
              AppRouter.push(context, RouteName.USER_CASH_WITHDRAW_PAGE,
                  arguments: UserCashWithdrawPage.setArguments(
                      amount:
                          UserManager.instance.userBrief.balance.toDouble()));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/rui_page_balance.png",
                  width: 12.rw,
                  height: 12.rw,
                ),
                3.wb,
                '余额提现'.text.size(10.rsp).black.make(),
              ],
            ),
          ),
        ],
        body: Column(
          children: [
            VxBox(
              child: [
                16.wb,
                104.hb,
                [
                  '可使用(元)'.text.size(14.rsp).color(Color(0xFF333333)).make(),
                  4.hb,
                  (_model?.data?.balance ?? 0.0)
                      .toStringAsFixed(2)
                      .text
                      .size(30)
                      .color(Color(0xFFD40000))
                      .make(),
                ].column(crossAlignment: CrossAxisAlignment.start),
                Spacer(),
                [
                  '累计提现(元)'.text.size(14.rsp).color(Color(0xFF333333)).make(),
                  4.hb,
                  (_model?.data?.totalWithdraw ?? 0.0)
                      .toStringAsFixed(2)
                      .text
                      .size(30)
                      .black
                      .make(),
                ].column(crossAlignment: CrossAxisAlignment.end),
                16.wb,
              ].row(),
            ).color(Colors.white).make(),
            <Widget>[
              64.hb,
              16.wb,
              MaterialButton(
                color: Colors.white,
                shape: StadiumBorder(),
                elevation: 0,
                onPressed: () {
                  _entry = OverlayEntry(builder: (context) => _buildOverlay());
                  Overlay.of(context).insert(_entry);
                },
                child: [
                  _statusValue.text.color(Color(0xFF333333)).size(13.rsp).make(),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFFBEBEBE),
                  ),
                ].row(),
              ),
              Spacer(),
              MaterialButton(
                color: Colors.white,
                shape: StadiumBorder(),
                elevation: 0,
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: false,
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                          height: 350 + MediaQuery.of(context).padding.bottom,
                          child: BottomTimePicker(
                            timePickerTypes: [
                              BottomTimePickerType.BottomTimePickerMonth
                            ],
                            cancle: () {
                              Navigator.maybePop(context);
                            },
                            submit: (time, type) {
                              Navigator.maybePop(context);
                              _date = time;
                              setState(() {});
                              _refreshController.requestRefresh();
                            },
                          ));
                    },
                  ).then((val) {
                    if (mounted) {}
                  });
                },
                child: [
                  '${_date.year}年${_date.month}月'
                      .text
                      .color(Color(0xFF333333))
                      .size(13.rsp)
                      .make(),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFFBEBEBE),
                  ),
                ].row(),
              ),
              16.wb,
            ].row().material(color: Color(0xFFF5F5F5)),
            RefreshWidget(
              controller: _refreshController,
              onRefresh: () async {
                _historyModel = await UserBalanceFunc.history(
                    month: _month, status: _status);
                _refreshController.refreshCompleted();
                setState(() {});
              },
              body: ListView.separated(
                itemBuilder: (context, index) =>
                    _buildListItem(_historyModel.data.list[index]),
                separatorBuilder: (context, index) => Divider(
                  color: Color(0xFFE9E9E9),
                  height: 1.rw,
                  thickness: 1.rw,
                ),
                itemCount: _historyModel?.data?.list?.length ?? 0,
              ),
            ).material(color: Color(0xFFF9F9FB)).expand(),
          ],
        ),
      ),
      onWillPop: () async {
        _entry?.remove();
        return true;
      },
    );
  }
}
