import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/order_prepay_model.dart';
import 'package:recook/pages/buy_tickets/add_used_passager_page.dart';
import 'package:recook/pages/buy_tickets/models/passager_model.dart';
import 'package:recook/pages/buy_tickets/models/pay_need_model.dart';
import 'package:recook/pages/buy_tickets/models/submit_order_model.dart';
import 'package:recook/pages/home/classify/order_prepay_page.dart';
import 'package:recook/utils/date/date_utils.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'functions/passager_func.dart';
import 'models/airline_model.dart';

class AirplaneDetailPage extends StatefulWidget {
  final List<Airline> airline;
  final String fromText; //出发地
  final String toText; //目的地
  final DateTime originDate; //出发日期
  final int airlineindex;
  final AirSeat airSeat;
  final String itemId;
  AirplaneDetailPage(
      {Key key,
      this.airline,
      this.fromText,
      this.toText,
      this.originDate,
      this.airlineindex,
      this.airSeat,
      this.itemId})
      : super(key: key);

  @override
  _AirplaneDetailPageState createState() => _AirplaneDetailPageState();
}

class _AirplaneDetailPageState extends State<AirplaneDetailPage> {
  List<PassagerModel> _passengerList = [];
  List<PassagerModel> _ChoosePassengerList = [];
  String _contactNum = '';
  String _contactName = '';
  Airline airline;
  AirSeat airSeat;
  DateTime _dateNow = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);

  @override
  void initState() {
    super.initState();
    airline = widget.airline[widget.airlineindex];
    airSeat = widget.airSeat;
    // _passengerList.add(PassagerModel(name: '更多'));
    initData();

    // _passengerList
    //     .add(Item(item: '张伟', choice: false, num: '12345678901234567890'));
    // _passengerList
    //     .add(Item(item: '欧阳青青', choice: false, num: '12345678901234567'));
    // _passengerList
    //     .add(Item(item: '小星星', choice: false, num: '12345678901234567890'));
    // _passengerList
    //     .add(Item(item: '吕小树', choice: false, num: '12345678901234567890'));
  }

  initData() {
    Future.delayed(Duration.zero, () async {
      _passengerList =
          await PassagerFunc.getPassagerList(UserManager.instance.user.info.id);
      if (_passengerList == null) {
        _passengerList = [];
      }

      if (_passengerList.length > 0) {
        for (var i = 0; i < _passengerList.length; i++) {
          _passengerList[i].choice = false;
        }
      }
      _ChoosePassengerList = [];
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBackground: Color(0xFFF9F9FB),
        elevation: 0,
        title: widget.fromText + '-' + widget.toText,
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD5101A),
            Color(0x03FE2E39),
          ],
          stops: [0.0, 0.5],
        )),
        child: _bodyWidget(),
      ),
      bottomNavigationBar: SafeArea(child: _bottomTool(true)),
    );
  }

  _bodyWidget() {
    return Container(
      child: Column(
        children: [
          _information(),
          _choosePassenger(),
        ],
      ),
    );
  }

  _bottomTool(bool bottom) {
    return Container(
      height: 50.rw,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              30.wb,
              Text(
                "订单金额",
                style: TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
              ),
              Container(
                padding: EdgeInsets.only(top: 3.rw),
                child: Text(
                  "￥",
                  style: TextStyle(fontSize: 10.rsp, color: Color(0xFFD5101A)),
                ),
              ),
              Text(
                (_ChoosePassengerList.length *
                        (airline.adultFuelTax +
                            airline.adultAirportTax +
                            airSeat.parPrice))
                    .toString(),
                style: TextStyle(fontSize: 18.rsp, color: Color(0xFFD5101A)),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  bottom ? Get.bottomSheet(_bottomSheet()) : Get.back();
                },
                child: Row(
                  children: [
                    Text(
                      "明细",
                      style:
                          TextStyle(fontSize: 14.rsp, color: Color(0xFF999999)),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.rw),
                      child: !bottom
                          ? Icon(CupertinoIcons.chevron_down,
                              size: 16.rw, color: Color(0xFF999999))
                          : Icon(CupertinoIcons.chevron_up,
                              size: 16.rw, color: Color(0xFF999999)),
                    ),
                  ],
                ),
              ),
              20.wb,
              CustomImageButton(
                height: 34.rw,
                width: 99.rw,
                title: "提交订单",
                boxDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFF37211),
                      Color(0xFFF84A06),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(22.rw)),
                ),
                backgroundColor: Color(0xFFC92219),
                color: Colors.white,
                fontSize: 14.rsp,
                onPressed: () async {
                  Function cancel = ReToast.loading();
                  if (_ChoosePassengerList.length <= 0) {
                    Alert.show(
                        context,
                        NormalTextDialog(
                          type: NormalTextDialogType.normal,
                          title: "提示",
                          content: "请您先选择乘客",
                          items: ["确认"],
                          listener: (index) {
                            Alert.dismiss(context);
                          },
                        ));
                  } else if (_contactNum == '') {
                    Alert.show(
                        context,
                        NormalTextDialog(
                          type: NormalTextDialogType.normal,
                          title: "提示",
                          content: "请您先输入联系电话",
                          items: ["确认"],
                          listener: (index) {
                            Alert.dismiss(context);
                          },
                        ));
                  } else if (_contactName == '') {
                    Alert.show(
                        context,
                        NormalTextDialog(
                          type: NormalTextDialogType.normal,
                          title: "提示",
                          content: "请您先输入联系人姓名",
                          items: ["确认"],
                          listener: (index) {
                            Alert.dismiss(context);
                          },
                        ));
                  } else {
                    print(airline.orgCity +
                        airline.dstCity +
                        widget.fromText +
                        widget.toText +
                        airline.depTime +
                        airline.arriTime);
                    SubmitOrderModel submitOrderModel =
                        await PassagerFunc.submitAirOrder(
                            _getTitle(1),
                            1,
                            (_ChoosePassengerList.length *
                                (airline.adultFuelTax +
                                    airline.adultAirportTax +
                                    airSeat.parPrice)),
                            airline.orgCity,
                            airline.dstCity,
                            airline.depTime,
                            airline.arriTime,
                            airline.orgCityName,
                            airline.dstCityName,
                            airline.flightCompanyName + airline.flightNo,
                            _getUserId(),
                            _contactNum,
                            widget.fromText,
                            widget.toText,
                            DateUtil.formatDate(widget.originDate,
                                format: 'yyyy-MM-dd'));
                    if (submitOrderModel == null) {
                      cancel();
                      Alert.show(
                          context,
                          NormalTextDialog(
                            type: NormalTextDialogType.normal,
                            title: "提示",
                            content: "提交订单失败！",
                            items: ["确认"],
                            listener: (index) {
                              Alert.dismiss(context);
                            },
                          ));
                    } else {
                      //跳转到支付页面
                      //Get.to(page)
                      Data data = Data(
                          submitOrderModel.id,
                          submitOrderModel.userId,
                          double.parse(submitOrderModel.amountMoney.toString()),
                          submitOrderModel.status,
                          submitOrderModel.createdTime);

                      PayNeedModel payNeedModel = PayNeedModel(
                          id: submitOrderModel.userId,
                          lfOrderId: submitOrderModel.id,
                          seatCode: airSeat.seatCode,
                          passagers: _getPassagerText(),
                          itemId: widget.itemId,
                          contactName: _contactName,
                          contactTel: _contactNum,
                          date: DateUtil.formatDate(widget.originDate,
                              format: 'yyyy-MM-dd'),
                          from: airline.orgCity,
                          to: airline.dstCity,
                          companyCode: airline.flightCompanyCode,
                          flightNo: airline.flightNo);

                      OrderPrepayModel resultModel =
                          OrderPrepayModel("SUCCESS", data, "");
                      AppRouter.pushAndReplaced(
                          context, RouteName.ORDER_PREPAY_PAGE,
                          arguments: OrderPrepayPage.setArguments(resultModel,
                              goToOrder: false,
                              canUseBalance: true,
                              fromTo: airline.orgCityName +
                                  '--' +
                                  airline.dstCityName,
                              payNeedModel: payNeedModel));
                      cancel();
                    }

                    //if(submitOrderModel)
                  }

                  //Get.to(AirplaneDetailPage());
                },
              ),
              30.wb
            ],
          )
        ],
      ),
    );
  }

  _getPassagerText() {
    String Passager = '';
    for (var i = 0; i < _ChoosePassengerList.length; i++) {
      if (Passager == '') {
        Passager = _ChoosePassengerList[i].id.toString() +
            ',' +
            _ChoosePassengerList[i].phone +
            ',' +
            _ChoosePassengerList[i].residentIdCard;
      } else {
        Passager = Passager +
            ';' +
            _ChoosePassengerList[i].id.toString() +
            ',' +
            _ChoosePassengerList[i].phone +
            ',' +
            _ChoosePassengerList[i].residentIdCard;
      }
    }
  }

  _getTitle(int goods_type) {
    String user = '';
    if (_ChoosePassengerList.length > 0) {}
    for (var i = 0; i < _ChoosePassengerList.length; i++) {
      if (user == '') {
        user = user + _ChoosePassengerList[i].name;
      } else {
        user = user + ',' + _ChoosePassengerList[i].name;
      }
    }
    return '飞机票' +
        ',' +
        airline.orgCityName +
        '-' +
        airline.dstCityName +
        ',' +
        user;
  }

  _getUserId() {
    String userId = '';
    for (var i = 0; i < _ChoosePassengerList.length; i++) {
      if (userId == '') {
        userId = userId + _ChoosePassengerList[i].id.toString();
      } else {
        userId = userId + ',' + _ChoosePassengerList[i].id.toString();
      }
    }
    return userId;
  }

  _bottomSheet() {
    return Container(
      height: 205.rw,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22.rw), topRight: Radius.circular(22.rw)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.rw, vertical: 20.rw),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "明细",
                      style:
                          TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
                    ),
                    Text(
                      "￥" +
                          airSeat.parPrice.toString() +
                          ' * ' +
                          _ChoosePassengerList.length.toString(),
                      style:
                          TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
                    ),
                  ],
                ),
                39.hb,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "机建",
                      style:
                          TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
                    ),
                    Text(
                      "￥" +
                          airline.adultAirportTax.toString() +
                          ' * ' +
                          _ChoosePassengerList.length.toString(),
                      style:
                          TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
                    ),
                  ],
                ),
                39.hb,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "燃油",
                      style:
                          TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
                    ),
                    Text(
                      "￥" +
                          airline.adultFuelTax.toString() +
                          ' * ' +
                          _ChoosePassengerList.length.toString(),
                      style:
                          TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _bottomTool(false)
        ],
      ),
    );
  }

  _contract() {
    return Container(
      margin: EdgeInsets.only(top: 10.rw),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.rw)),
        color: Colors.white,
      ),
      height: 42.rw,
      child: Row(
        children: [
          20.wb,
          Container(
            padding: EdgeInsets.only(top: 2.rw),
            child: Image.asset(
              R.ASSETS_TICKET_PHONE_ICON_PNG,
              width: 10.rw,
              height: 10.rw,
            ),
          ),
          10.wb,
          Text(
            "联系电话",
            style: TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
          ),
          20.wb,
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 20.rw, bottom: 4.rw),
              hintText: '用于接收取票信息',
              border: InputBorder.none,
              hintStyle:
                  AppTextStyle.generate(14 * 2.sp, color: Color(0xff666666)),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11)
            ],
            style: AppTextStyle.generate(14 * 2.sp),
            maxLength: 11,
            maxLines: 1,
            onChanged: (text) {
              _contactNum = text;
            },
          ).expand(),
        ],
      ),
    );
  }

  _contractName() {
    return Container(
      margin: EdgeInsets.only(top: 10.rw),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.rw)),
        color: Colors.white,
      ),
      height: 42.rw,
      child: Row(
        children: [
          20.wb,
          Container(
            padding: EdgeInsets.only(top: 2.rw),
            child: Image.asset(
              R.ASSETS_TICKET_PHONE_ICON_PNG,
              width: 10.rw,
              height: 10.rw,
            ),
          ),
          10.wb,
          Text(
            "联系人姓名",
            style: TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
          ),
          20.wb,
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 5.rw, bottom: 4.rw),
              hintText: '用于接收取票信息',
              border: InputBorder.none,
              hintStyle:
                  AppTextStyle.generate(14 * 2.sp, color: Color(0xff666666)),
            ),
            style: AppTextStyle.generate(14 * 2.sp),
            maxLength: 11,
            maxLines: 1,
            onChanged: (text) {
              _contactName = text;
            },
          ).expand(),
        ],
      ),
    );
  }

  _information() {
    return Container(
      margin: EdgeInsets.only(top: 10.rw, left: 10.rw, right: 10.rw),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.rw)),
        color: Colors.white,
      ),
      height: 177.rw,
      child: Column(
        children: [
          20.hb,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  DateUtil.formatDate(widget.originDate, format: 'MM月dd日') +
                      " " +
                      getDayWeek(widget.originDate),
                  style: TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
                ),
              )
            ],
          ),
          20.hb,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    airline.depTime,
                    style:
                        TextStyle(fontSize: 24.rsp, color: Color(0xFF333333)),
                  ),
                  Text(
                    airline.orgCityName,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
                  ),
                ],
              ),
              40.wb,
              Container(
                //height: 53.rw,
                margin: EdgeInsets.only(bottom: 25.rw),
                child: Column(
                  children: [
                    Text(
                      DateUtilss.getTimeReduce(
                          airline.depTime, airline.arriTime),
                      style:
                          TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
                    ),
                    10.hb,
                    Image.asset(
                      R.ASSETS_TICKET_GOTO2_ICON_PNG,
                      width: 68.rw,
                      height: 7.rw,
                    ),
                  ],
                ),
              ),
              40.wb,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    airline.arriTime,
                    style:
                        TextStyle(fontSize: 24.rsp, color: Color(0xFF333333)),
                  ),
                  Text(
                    airline.dstCityName,
                    style:
                        TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
                  ),
                ],
              ),
            ],
          ),
          10.hb,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                airline.flightCompanyName + airline.flightNo,
                style: TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
              ),
              20.wb,
              Text(
                _getPlaneNameByType(airline.planeType),
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12.rsp, color: Color(0xFF666666)),
              ),
            ],
          ),
          30.hb,
          Divider(
            color: Color(0x80DEE4E7),
            height: 1.rw,
            thickness: rSize(0.5),
            indent: 15.rw,
            endIndent: 15.rw,
          ),
          30.hb,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "成人¥" + airSeat.parPrice.toString() + '，',
                style: TextStyle(fontSize: 14.rsp, color: Color(0xFF666666)),
              ),
              Text(
                "机建+燃油 ¥" +
                    (airline.adultFuelTax + airline.adultAirportTax).toString(),
                style: TextStyle(fontSize: 14.rsp, color: Color(0xFF666666)),
              ),
              20.wb,
            ],
          ),
        ],
      ),
    );
  }

  _choosePassenger() {
    return Container(
      margin: EdgeInsets.only(top: 10.rw),
      padding: EdgeInsets.symmetric(horizontal: 10.rw),
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: 330.rw),
            padding: EdgeInsets.symmetric(horizontal: 15.rw),
            height: _getHeight(
                _passengerList.length - 1, _ChoosePassengerList.length),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.rw)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                _choosePassenger1(),
              ],
            ),
          ),
          _contract(),
          _contractName()
        ],
      ),
    ).expand();
  }

  _getPlaneNameByType(String type) {
    String first = type.substring(0, 1);
    if (first == "7") {
      return '波音' + type;
    } else if (first == '3') {
      return '空客' + type;
    } else {
      return type;
    }
  }

  getDayWeek(DateTime date) {
    //获取当天是周几
    if (date == _dateNow) {
      return '今天';
    } else if (date == _dateNow.add(new Duration(days: 1))) {
      return '明天';
    } else if (date == _dateNow.add(new Duration(days: 2))) {
      return '后天';
    } else {
      return DateUtil.getWeekday(date, languageCode: 'zh', short: true);
    }
  }

  _getHeight(int top, int bottom) {
    if (top <= 4) {
      if (bottom == 0) {
        return 98.rw;
      } else {
        return 105.rw + bottom * 31.rw;
      }
    } else if (top > 4) {
      if (bottom <= 8) {
        return 105.rw + bottom * 31.rw + (top ~/ 4) * 55.rw;
      } else {
        return 105.rw + 8 * 31.rw + (top ~/ 4) * 55.rw;
      }
    }
  }

  Widget _moreBtn(VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          width: 68.rw,
          height: 38.rw,
          padding: EdgeInsets.only(top: 2.rw),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(3.rw)),
              border: Border.all(color: Color(0xFF999999), width: 0.5.rw)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                R.ASSETS_TICKET_ADD_ICON_PNG,
                width: 16.rw,
                height: 16.rw,
              ),
              10.wb,
              Container(
                padding: EdgeInsets.only(bottom: 3.rw),
                child: Text(
                  "更多",
                  style: TextStyle(fontSize: 14.rsp, color: Color(0xFFD5101A)),
                ),
              )
            ],
          )),
    );
  }

  Widget _getItemContainer(
      PassagerModel item, index, VoidCallback onPressed, bool selected) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          width: 68.rw,
          height: 38.rw,
          padding: EdgeInsets.only(top: 2.rw),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(3.rw)),
              border: Border.all(
                  color: selected ? Color(0xFFD5101A) : Color(0xFF999999),
                  width: 0.5.rw)),
          child: Column(
            mainAxisAlignment:
                selected ? MainAxisAlignment.end : MainAxisAlignment.center,
            children: [
              Text(
                item.name,
                style: TextStyle(fontSize: 14.rsp, color: Color(0xFF666666)),
              ),
              !selected ? 5.hb : SizedBox(),
              selected
                  ? Container(
                      //color: Colors.yellow,
                      margin: EdgeInsets.only(left: 10.rw),
                      alignment: Alignment.bottomRight,
                      width: 68.rw,
                      child: Container(
                        alignment: Alignment.center,
                        width: 14.rw,
                        height: 10.rw,
                        decoration: BoxDecoration(
                          color: Color(0xFFD5101A),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(3.rw),
                              bottomRight: Radius.circular(3.rw)),
                        ),
                        child: Icon(CupertinoIcons.check_mark,
                            size: 10, color: Colors.white),
                      ),
                    )
                  : SizedBox(),
            ],
          )),
    );
  }

  _getPassengerItem(PassagerModel item, index, VoidCallback onPressed) {
    return Container(
      padding: EdgeInsets.only(top: 10.rw),
      child: Row(
        children: [
          Container(
            width: 80.rw,
            child: Text(
              item.name,
              style: TextStyle(
                  fontSize: 16.rsp,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold),
            ),
          ),
          20.wb,
          Container(
            width: 200.rw,
            child: Text(
              _getCardId(item.residentIdCard),
              style: TextStyle(fontSize: 16.rsp, color: Color(0xFF666666)),
            ),
          ),
          30.wb,
          GestureDetector(
            onTap: () async {
              String code = await Get.to(AddUsedPassagerPage(
                type: 2,
                item: item,
              ));
              if (code == 'SUCCESS') {
                initData();
              }
            },
            child: Image.asset(
              R.ASSETS_TICKET_EDIT_ICON_PNG,
              width: 14.rw,
              height: 14.rw,
            ),
          )
        ],
      ),
    );
  }

  _choosePassenger1() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 10.rw),
            alignment: Alignment.centerLeft,
            child: Text(
              "选择乘客",
              style: TextStyle(
                  fontSize: 16.rsp,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverToBoxAdapter(child: 20.hb),
        SliverGrid(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return index == _passengerList.length
                  ? _moreBtn(() async {
                      String code = await Get.to(AddUsedPassagerPage(type: 1));
                      if (code == 'SUCCESS') {
                        initData();
                      }
                    })
                  : _getItemContainer(_passengerList[index], index, () {
                      setState(() {
                        _passengerList[index].choice =
                            !_passengerList[index].choice;
                        if (_passengerList[index].choice) {
                          _ChoosePassengerList.add(_passengerList[index]);
                        } else {
                          if (_ChoosePassengerList.indexOf(
                                  _passengerList[index]) !=
                              -1) {
                            _ChoosePassengerList.removeAt(
                                _ChoosePassengerList.indexOf(
                                    _passengerList[index]));
                          }
                        }
                        setState(() {});
                      });
                    }, _passengerList[index].choice);
            }, childCount: _passengerList.length + 1),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10.rw,
              mainAxisSpacing: 10.rw,
              childAspectRatio: 1.789,
            )),
        SliverToBoxAdapter(child: 20.hb),
        SliverList(
          delegate: _ChoosePassengerList.length != 0
              ? SliverChildBuilderDelegate((content, index) {
                  return _getPassengerItem(_ChoosePassengerList[index], index,
                      () {
                    setState(() {
                      _ChoosePassengerList[index].choice =
                          !_ChoosePassengerList[index].choice;
                      for (var i = 0; i < _ChoosePassengerList.length; i++) {
                        if (_ChoosePassengerList[i].choice) {
                          _ChoosePassengerList.add(_ChoosePassengerList[i]);
                        }
                      }
                    });
                  });
                }, childCount: _ChoosePassengerList.length)
              : SliverChildBuilderDelegate((content, index) {
                  return SizedBox();
                }, childCount: 0),
        ),
        SliverToBoxAdapter(child: 20.hb),
      ],
    ).expand();
  }

  _getCardId(String id) {
    if (id.length > 5) {
      String hear = id.substring(0, 4);
      String foot = id.substring(id.length - 3);
      String newId = '';
      if (id.length > 7) {
        for (var i = 0; i < id.length - 7; i++) {
          newId += '*';
        }
      }
      return hear + newId + foot;
    }
    return id;
  }
}

class Item {
  String item;
  bool choice;
  String num;
  Item({
    this.item,
    this.choice,
    this.num,
  });
}
