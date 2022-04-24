import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/gen/assets.gen.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/user/functions/user_balance_func.dart';
import 'package:jingyaoyun/pages/user/model/user_balance_history_model.dart';
import 'package:jingyaoyun/pages/user/model/user_balance_info_model.dart';
import 'package:jingyaoyun/pages/user/model/user_income_data_model.dart';
import 'package:jingyaoyun/pages/user/user_cash_withdraw_page.dart';
import 'package:jingyaoyun/widgets/bottom_time_picker.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/image_scaffold.dart';
import 'package:jingyaoyun/widgets/no_data_view.dart';
import 'package:jingyaoyun/widgets/recook/recook_scaffold.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';

typedef MyCallBack = Function(String string);

class UserBalanceDetailPage extends StatefulWidget {
  UserBalanceDetailPage({Key key}) : super(key: key);

  @override
  _UserBalanceDetailPageState createState() => _UserBalanceDetailPageState();
}

class _UserBalanceDetailPageState extends State<UserBalanceDetailPage> {
  UserBalanceInfoModel _model = UserBalanceInfoModel.zero();
  UserBalanceHistoryModel _historyModel = UserBalanceHistoryModel.zero();

  ///查询的月份
  DateTime _date = DateTime.now();

  String get _month => DateUtil.formatDate(_date, format: 'yyyy-MM');

  /// 余额类型 1=订单支付 2=订单退款 3=提现 4=提现失败 5=瑞币转入
  int _status = 0;

  List _chooseItems = ['全部明细', '分享收益', '开店补贴', '订单支付', '订单退款', '提现成功', '提现失败','服务收益'];

  String _choose = '全部明细';

  GSRefreshController _refreshController = GSRefreshController();

  num _allBenefitAmount = 0;
  UserIncomeDataModel _userIncomeDataModel;


  bool _onLoad = true;///首次加载数据

  _buildListItem(ListItem item) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      width: double.infinity,
      height: 76.rw,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 30),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      _getImage(item.incomeType),
                      width: 44.rw,
                      height: 44.rw,
                    ),
                    24.wb,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTitle(item.incomeType) +
                              (item.orderId != 0
                                  ? item.orderId.toString()
                                  : ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(0xFF333333), fontSize: 16.rsp),
                        ),
                        Container(
                          height: 3,
                        ),
                        Text(
                          item.createdAt,
                          style: TextStyle(
                              color: Color(0xFF999999), fontSize: 12.rsp),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Text(
                    (item.amount>0?'+':'')+   item.amount.toStringAsFixed(2),
                  style: TextStyle(
                      color: item.amount < 0
                          ? Color(0xFF333333)
                          : Color(0xFFD5101A),
                      fontSize: 16.rsp,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
          Container(
            height: 1,
            color: AppColor.frenchColor,
          ),
        ],
      ),
    );
  }

  _getTitle(int type) {
    switch (type) {
      case 1:
        return '订单支付';
      case 2:
        return '订单退款';
      case 3:
        return '余额提现';
      case 4:
        return '提现失败';
      case 12:
        return '分享收益';
      case 14:
        return '开店补贴';
      case 17:
        return '批发收益';
      case 20:
        return '服务收益';
        default:
        return '批发收益';

    }
  }

  _getImage(int type) {
    switch (type) {
      case 1:
        return Assets.orderPay.path;
      case 2:
        return Assets.orderRefund.path;
      case 3:
        return Assets.withdrawalSuccess.path;
      case 4:
        return Assets.withdrawalFail.path;
      case 12:
        return Assets.shareSubsidy.path;
      case 20:
        return Assets.shareSubsidy.path;
      case 14:
        return Assets.shopSubsidy.path;
      case 17:
        return Assets.orderPay.path;
        default:
          return Assets.orderPay.path;

    }
  }

  void _showCupertinoPicker(BuildContext cxt, MyCallBack callback) {
    String item;

    final picker = CupertinoPicker(
        itemExtent: 30.rw,
        magnification: 1.1,
        //offAxisFraction: -0.6,
        //looping: true,
        backgroundColor: Colors.white,
        onSelectedItemChanged: (position) {
          print('The position is $position');
          item = _chooseItems[position];
        },
        children: [
          ..._chooseItems
              .mapIndexed(
                (e, index) => Container(
                  alignment: Alignment.center,
                  child: Text(
                    e,
                    style:
                        TextStyle(color: Color(0xFF999999), fontSize: 14.rsp),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
              .toList()
        ]);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.white,
          height: 282.rw,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 80.w,
                child: NavigationToolbar(
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 16.rw,
                          ),
                          child: Text(
                            '取消',
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 14.rsp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    middle: Text(
                      '变动明细',
                      style: TextStyle(
                          color: Color(0xFF111111),
                          fontSize: 16.rsp,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        callback(item);
                      },
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 16.rw,
                          ),
                          child: Text(
                            '确认',
                            style: TextStyle(
                              color: Color(0xFFD5101A),
                              fontSize: 14.rsp,
                            ),
                          ),
                        ),
                      ),
                    )

                    // _buildButton(
                    //   title: Text(
                    //     '确认',
                    //     style: TextStyle(
                    //       color: Color(0xFFD5101A),
                    //       fontSize: 14.rsp,
                    //     ),
                    //   ),
                    //   onPressed: callback(item),
                    // ),
                    ),
              ),
              Expanded(child: picker),
            ],
          ),
        );
      },
    );
  }

  _updateNewBenefit() async {
    ResultData result = await HttpManager.post(APIV2.benefitAPI.incomeData, {});
    if (result.data != null && result.data['data'] != null) {
      _userIncomeDataModel = UserIncomeDataModel.fromJson(result.data['data']);

      ///累计收益
      _allBenefitAmount = _userIncomeDataModel.total;
    }
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
    return ImageScaffold(
      systemStyle: SystemUiOverlayStyle.light,
      path: Assets.withdrawalBg.path,
      bodyColor: Color(0xFFF9F9F9),
      appbar: Container(
        color: Colors.transparent,
        height: kToolbarHeight + MediaQuery.of(context).padding.top,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RecookBackButton(
              white: true,
            ),
            Text(
              '余额明细',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.rsp,
              ),
            ),
            IconButton(
                icon: Icon(
                  AppIcons.icon_back,
                  size: 17,
                  color: Colors.transparent,
                ),
                onPressed: () {}),
          ],
        ),
      ),
      body: Flexible(
        child: Column(
          children: [
            60.hb,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.rw),
              child: Container(
                alignment: Alignment.center,
                height: 86.rw,
                padding: EdgeInsets.symmetric(horizontal: 16.rw),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.rw),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      color: Color(0x4FD93F37),
                      blurRadius: 16.rw,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          '可提现(元)'
                              .text
                              .size(12.rsp)
                              .color(Color(0xFF070707))
                              .make(),
                          12.hb,
                          TextUtils.getCount1((_model?.data?.balance ?? 0.0))
                              .text
                              .size(20.rsp)
                              .color(Color(0xFF333333))
                              .make(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          '累计收益(元)'
                              .text
                              .size(12.rsp)
                              .color(Color(0xFF070707))
                              .make(),
                          12.hb,
                          TextUtils.getCount1(
                                  (_allBenefitAmount ?? 0.0))
                              .text
                              .size(20.rsp)
                              .color(Color(0xFF333333))
                              .make(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            40.hb,
            Row(
              children: [
                MaterialButton(
                    color: Colors.transparent,
                    shape: StadiumBorder(),
                    elevation: 0,
                    onPressed: () {
                      // _entry = OverlayEntry(builder: (context) => _buildOverlay());
                      // Overlay.of(context).insert(_entry);
                      _showCupertinoPicker(context, (String item) {
                        Get.back();
                        if (item != null) {
                          _choose = item;
                        } else {
                          _choose = '全部明细';
                        }
                        switch(_choose){
                          case '全部明细':
                            _status = 0;
                           break;
                          case '分享收益':
                            _status = 12;
                            break;
                          case '开店补贴':
                            _status = 14;
                            break;
                          case '服务收益':
                            _status = 20;
                            break;
                          case '订单支付':
                            _status = 1;
                            break;
                          case '订单退款':
                            _status = 2;
                            break;
                          case '提现成功':
                            _status = 3;
                            break;
                          case '提现失败':
                            _status = 4;
                            break;
                        }


                        setState(() {});
                        _refreshController.requestRefresh();
                      });
                    },
                    child: Row(
                      children: [
                        _choose.text
                            .color(Color(0xFF111111))
                            .size(16.rsp)
                            .make(),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF333333),
                        ),
                      ],
                    )),
                Spacer(),
                MaterialButton(
                  color: Colors.transparent,
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
                              yearChoose: true,
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
                    DateUtil.formatDate(_date, format: 'yyyy-MM')
                        .text
                        .color(Color(0xFF111111))
                        .size(16.rsp)
                        .make(),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF333333),
                    ),
                  ].row(),
                ),
              ],
            ),
            Flexible(
              child: RefreshWidget(
                color: Color(0xFF666666),
                controller: _refreshController,
                onRefresh: () async {
                  _historyModel = await UserBalanceFunc.history(
                      month: _month, status: _status);
                  _updateNewBenefit();
                  _refreshController.refreshCompleted();
                  _onLoad = false;
                  setState(() {});
                },
                body:
                _onLoad?SizedBox():
                _historyModel.data.list == null || _historyModel.data.list.length == 0
                    ? NoDataView(title:'没有数据哦～' ,):
                ListView.separated(
                  itemBuilder: (context, index) =>
                      _buildListItem(_historyModel.data.list[index]),
                  separatorBuilder: (context, index) => Divider(
                    color: Color(0xFFE9E9E9),
                    height: 1.rw,
                    thickness: 1.rw,
                  ),
                  itemCount: _historyModel?.data?.list?.length ?? 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
