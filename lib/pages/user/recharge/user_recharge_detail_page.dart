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
import 'package:jingyaoyun/models/RechargehistoryModel.dart';
import 'package:jingyaoyun/models/withdraw_historyc_model.dart';
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
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:velocity_x/velocity_x.dart';

typedef MyCallBack = Function(String string);

class UserRechargeDetailPage extends StatefulWidget {
  UserRechargeDetailPage({Key key}) : super(key: key);

  @override
  _UserRechargeDetailPageState createState() => _UserRechargeDetailPageState();
}

class _UserRechargeDetailPageState extends State<UserRechargeDetailPage> {

  RechargeHistoryModel rechargeHistoryModel;
  ///查询的月份
  DateTime _date = DateTime.now();

  String get _start =>  DateTime(_date.year,_date.month,1).toIso8601String();
  
  String get _end => DateTime(_date.year,_date.month+1,1).toIso8601String();

  int _status = 0;

  List _chooseItems = ['全部明细', '订单支付', '订单取消', '预存款充值'];

  String _choose = '全部明细';

  GSRefreshController _refreshController = GSRefreshController(initialRefresh: true);


  int _page = 0;
  bool _onLoad = true;

  List<RechargeHistory> list = [];

  _buildListItem(RechargeHistory item) {
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
                      _getImage(item.kind),
                      width: 44.rw,
                      height: 44.rw,
                    ),
                    24.wb,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTitle(item.kind) +
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
        return '订单取消';
      case 3:
        return '预存款充值';
    }
  }

  _getImage(int type) {
    switch (type) {
      case 1:
        return Assets.icRechargeOrderPay.path;
      case 2:
        return Assets.icRechargeOrderCancle.path;
      case 3:
        return Assets.icRechargeF.path;
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


  @override
  void initState() {
    super.initState();
    _refreshController =
    GSRefreshController(initialRefresh: true);

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
              '交易明细',
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
                          '可使用(元)'
                              .text
                              .size(12.rsp)
                              .color(Color(0xFF070707))
                              .make(),
                          12.hb,
                        TextUtils.getCount1(( UserManager.instance.userBrief.deposit ?? 0.0))
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
                          '累计充值(元)'
                              .text
                              .size(12.rsp)
                              .color(Color(0xFF070707))
                              .make(),
                          12.hb,
                        TextUtils.getCount1(( UserManager.instance.userBrief.allDeposit ?? 0.0))
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
                    color: Colors.white,
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
                          case '订单支付':
                            _status = 1;
                            break;
                          case '订单取消':
                            _status = 2;
                            break;
                          case '预存款充值':
                            _status = 3;
                            break;
                        }
                        _refreshController.requestRefresh();
                        setState(() {});
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
                color: Color(0xFF999999),
                controller: _refreshController,
                onRefresh: () {
                  _page = 0;
                  getRechargeHistoryList(_status,_start,_end).then((models) {
                    setState(() {
                      list = models;
                      _onLoad = false;
                    });

                    _refreshController.refreshCompleted();
                  });
                },

                onLoadMore: () {
                  _page++;
                  if (list.length >=
                      rechargeHistoryModel.data.total) {
                    _refreshController.loadComplete();
                    _refreshController.loadNoData();
                  }else{
                    getRechargeHistoryList(_status,_start,_end).then((models) {
                      setState(() {
                        list.addAll(models);
                      });
                      _refreshController.loadComplete();
                    });
                  }

                },
                body:
                _onLoad?SizedBox():
                list == null ||list.length == 0
                    ? NoDataView(title:'没有数据哦～' ,):
                ListView.separated(
                  itemBuilder: (context, index) =>
                      _buildListItem(list[index]),
                  separatorBuilder: (context, index) => Divider(
                    color: Color(0xFFE9E9E9),
                    height: 1.rw,
                    thickness: 1.rw,
                  ),
                  itemCount: list.length ?? 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  Future<List<RechargeHistory>> getRechargeHistoryList(int kind,String start,String end) async {
    ResultData resultData =
    await HttpManager.post(APIV2.userAPI.depositRecordList, {
      'page': _page,
      'limit': 10,
      'start':start,
      'end':end,
      'kind':kind
    });
    if (!resultData.result) {
      Toast.showError(resultData.msg);
      return [];
    }
    RechargeHistoryModel model =
    RechargeHistoryModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      Toast.showError(model.msg);
      return [];
    }
    rechargeHistoryModel = model;
    return model.data.list;
  }
}
