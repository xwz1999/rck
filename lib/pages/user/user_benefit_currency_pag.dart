import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/shop/order/shop_order_detail_page.dart';
import 'package:recook/pages/user/order/order_detail_page.dart';
import 'package:recook/pages/user/user_benefit_shop_page.dart';
import 'package:recook/pages/user/user_benefit_sub_page.dart';
import 'package:recook/pages/user/widget/user_group_card.dart';
import 'package:recook/widgets/animated_rotate.dart';
import 'package:recook/widgets/bottom_time_picker.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/user/functions/user_benefit_func.dart';
import 'package:recook/pages/user/model/user_accumulate_model.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';

import 'model/user_benefit_extra_detail_model.dart';
import 'model/user_income_model.dart';
import 'package:velocity_x/velocity_x.dart';

class UserBenefitCurrencyPage extends StatefulWidget {
  final UserBenefitPageType type;
  final String receivedType;
  UserBenefitCurrencyPage(
      {Key key, @required this.type, @required this.receivedType})
      : super(key: key);

  @override
  _UserBenefitCurrencyPageState createState() =>
      _UserBenefitCurrencyPageState();
}

class _UserBenefitCurrencyPageState extends State<UserBenefitCurrencyPage> {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);
  Map<UserBenefitPageType, String> _typeTitleMap = {
    UserBenefitPageType.SELF: '自购收益',
    UserBenefitPageType.GUIDE: '导购收益',
    UserBenefitPageType.TEAM: '店铺补贴',
  };
  String get _title => _typeTitleMap[widget.type];

  ///不是自购和导购
  bool get _notSelfNotGUide =>
      widget.type != UserBenefitPageType.SELF &&
      widget.type != UserBenefitPageType.GUIDE;

  String _amount = '';
  String _all = '';
  String _selfALL = '0.00';
  String _distributionALL = '0.00';
  String _agentALL = '0.00';

  bool _itemReverse = false;

  bool _yearChoose = false; //0为年 1为月
  bool _monthChoose = true; //0为年 1为月

  bool _selfChoose = true; //选择自营补贴
  bool _distributionChoose = false; //选择分销补贴
  bool _agentChoose = false; //选择代理补贴

  ///累计收益
  ///
  UserAccumulateModel _model = UserAccumulateModel.zero();
  DateTime _date = DateTime.now();
  String formatType = 'yyyy-MM'; //时间选择器按钮样式
  String TableformatType = 'M月d日'; //时间样式

  int team_level = 1;
  String _TformatType = 'yyyy-MM'; //团队时间样式
  String _TTableformatType = 'M月d日'; //团队表格时间样式

  UserIncomeModel _models; //自购导购未到已到收益
  bool _onload = true;
  List _gone = [];

  _chooseMonth() {
    String MonthText = '';
    if (widget.receivedType == '未到账') {
      MonthText = '未到账明细(月)';
    } else if (widget.receivedType == '已到账') {
      MonthText = '已到账明细(月)';
    }
    return CustomImageButton(
      onPressed: () {
        _yearChoose = false;
        _monthChoose = true;
        formatType = 'yyyy-MM';
        TableformatType = 'M月d日';

        _refreshController.requestRefresh();
        setState(() {});
      },
      child: Text(MonthText,
          style: TextStyle(
              fontSize: 14.rsp,
              color: getColor(_monthChoose),
              fontWeight: getWeight(_monthChoose))),
    ).expand();
  }

  _chooseYear() {
    String YearText = '';

    if (widget.receivedType == '未到账') {
      YearText = '未到账明细(年)';
    } else if (widget.receivedType == '已到账') {
      YearText = '已到账明细(年)';
    }
    return CustomImageButton(
      onPressed: () {
        _yearChoose = true;
        _monthChoose = false;
        formatType = 'yyyy';
        TableformatType = 'M月';

        _refreshController.requestRefresh();
        setState(() {});
      },
      child: Text(YearText,
          style: TextStyle(
              fontSize: 14.rsp,
              color: getColor(_yearChoose),
              fontWeight: getWeight(_yearChoose))),
    ).expand();
  }

  _chooseSelf() {
    if (widget.receivedType == '未到账') {
      _TformatType = 'yyyy-MM';
      _TTableformatType = 'M月d日';
    } else if (widget.receivedType == '已到账') {
      _TformatType = 'yyyy';
      _TTableformatType = 'M月';
    }

    return CustomImageButton(
      onPressed: () {
        _selfChoose = true;
        _distributionChoose = false;
        _agentChoose = false;
        team_level = 1;
        _refreshController.requestRefresh();
        setState(() {});
      },
      child: widget.receivedType == '已到账'
          ? Column(
              children: [
                10.hb,
                Text('自营补贴',
                        style: TextStyle(
                            fontSize: 14.rsp,
                            color: getColor(_selfChoose),
                            fontWeight: getWeight(_selfChoose)))
                    .expand(),
                Text(_selfALL,
                        style: TextStyle(
                            fontSize: 14.rsp,
                            color: getColor(_selfChoose),
                            fontWeight: getWeight(_selfChoose)))
                    .expand(),
              ],
            )
          : Text('自营补贴',
                  style: TextStyle(
                      fontSize: 14.rsp,
                      color: getColor(_selfChoose),
                      fontWeight: getWeight(_selfChoose)))
              .expand(),
    ).expand();
  }

  _chooseDistribution() {
    return CustomImageButton(
      onPressed: () {
        _selfChoose = false;
        _distributionChoose = true;
        _agentChoose = false;
        team_level = 2;
        _refreshController.requestRefresh();
        setState(() {});
      },
      child: widget.receivedType == '已到账'
          ? Column(
              children: [
                10.hb,
                Text('分销补贴',
                        style: TextStyle(
                            fontSize: 14.rsp,
                            color: getColor(_distributionChoose),
                            fontWeight: getWeight(_distributionChoose)))
                    .expand(),
                Text(_distributionALL,
                        style: TextStyle(
                            fontSize: 14.rsp,
                            color: getColor(_distributionChoose),
                            fontWeight: getWeight(_distributionChoose)))
                    .expand(),
              ],
            )
          : Text('分销补贴',
                  style: TextStyle(
                      fontSize: 14.rsp,
                      color: getColor(_distributionChoose),
                      fontWeight: getWeight(_distributionChoose)))
              .expand(),
    ).expand();
  }

  _chooseAgent() {
    return CustomImageButton(
      onPressed: () {
        _selfChoose = false;
        _distributionChoose = false;
        _agentChoose = true;
        team_level = 3;
        _refreshController.requestRefresh();
        setState(() {});
      },
      child: widget.receivedType == '已到账'
          ? Column(
              children: [
                10.hb,
                Text('团队补贴',
                        style: TextStyle(
                            fontSize: 14.rsp,
                            color: getColor(_agentChoose),
                            fontWeight: getWeight(_agentChoose)))
                    .expand(),
                Text(_agentALL,
                        style: TextStyle(
                            fontSize: 14.rsp,
                            color: getColor(_agentChoose),
                            fontWeight: getWeight(_agentChoose)))
                    .expand(),
              ],
            )
          : Text('团队补贴',
                  style: TextStyle(
                      fontSize: 14.rsp,
                      color: getColor(_agentChoose),
                      fontWeight: getWeight(_agentChoose)))
              .expand(),
    ).expand();
  }

  _renderDivider() {
    return Container(
      height: 20.rw,
      width: 1.rw,
      color: Color(0xFF979797),
    );
  }

  ///时间选择器
  showTimePickerBottomSheet(
      {List<BottomTimePickerType> timePickerTypes,
      Function(DateTime, BottomTimePickerType) submit}) {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: 350 + MediaQuery.of(context).padding.bottom,
            child: BottomTimePicker(
              timePickerTypes: !_notSelfNotGUide
                  ? _monthChoose == true
                      ? [BottomTimePickerType.BottomTimePickerMonth]
                      : [BottomTimePickerType.BottomTimePickerYear]
                  : timePickerTypes,
              cancle: () {
                Navigator.maybePop(context);
              },
              submit: submit != null
                  ? submit
                  : (time, type) {
                      Navigator.maybePop(context);
                      _date = time;
                      setState(() {});
                    },
            ));
      },
    ).then((val) {
      if (mounted) {}
    });
  }

  Widget _buildTag() {
    String benefitValue = '';
    String text = '本月收益';

    if (_notSelfNotGUide) {
      if (widget.receivedType == '未到账') {
        text = '本月未到账补贴：';
      } else {
        text = '本年已到账补贴：';
      }
    } else {
      if (widget.receivedType == '未到账' && _yearChoose == true) {
        text = '本年未到账收益：';
      } else if (widget.receivedType == '未到账' && _monthChoose == true) {
        text = '本月未到账收益：';
      } else if (widget.receivedType == '已到账' && _yearChoose == true) {
        text = '本年已到账收益：';
      } else if (widget.receivedType == '已到账' && _monthChoose == true) {
        text = '本月已到账收益：';
      }
    }

    return Row(
      children: [
        Text(
          text ?? '',
          style: TextStyle(color: Color(0xFF999999), fontSize: 16.rsp),
          textAlign: TextAlign.center,
        ),
        Column(
          children: [
            5.hb,
            Text(
              _amount ?? '',
              style: TextStyle(color: Color(0xFFD5101A), fontSize: 16.rsp),
              textAlign: TextAlign.center,
            )
          ],
        ),
        20.wb
      ],
    );
    // return '当月收益(瑞币)：${benefitValue.toStringAsFixed(2)}'
    //     .text
    //     .color(Color(0xFF999999))
    //     .size(16.rsp)
    //     .make();
  }

  Widget _buildCard() {
    String CumulativeText = '';
    if (widget.receivedType == '未到账') {
      CumulativeText = '累计未到账收益(瑞币)';
    } else if (widget.receivedType == '已到账') {
      CumulativeText = '累计已到账收益(瑞币)';
    }
    //print(UserManager.instance.userBrief.roleLevel.toString() + '等级');
    return Container(
      margin:
          EdgeInsets.only(left: 30.rw, right: 30.rw, top: 20.rw, bottom: 20.rw),
      clipBehavior: Clip.antiAlias,
      height: 146.rw,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFA6A6AD).withOpacity(0.41),
            offset: Offset(0, 2.rw),
            blurRadius: 6.rw,
          ),
        ],
        borderRadius: BorderRadius.circular(4.rw),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(UserLevelTool.currentCardImagePath()),
              ),
            ),
            padding: EdgeInsets.only(
                top: 20.rw, bottom: 10.rw, left: 20.rw, right: 20.rw),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CumulativeText.text.color(Color(0xFF3A3943)).make(),
                    8.hb,
                    (_all ?? '').text.black.size(34.rsp).make(),
                  ],
                ).expand(),
                Image.asset(
                  UserLevelTool.currentMedalImagePath(),
                  width: 48.rw,
                  height: 48.rw,
                ),
              ],
            ),
          ),
          Container(
            height: 50.rw,
            child: Row(
              children: [
                _notSelfNotGUide ? _chooseSelf() : SizedBox(),
                _notSelfNotGUide ? _renderDivider() : SizedBox(),
                _notSelfNotGUide ? _chooseDistribution() : SizedBox(),
                _notSelfNotGUide ? _renderDivider() : SizedBox(),
                _notSelfNotGUide ? _chooseAgent() : SizedBox(),
                !_notSelfNotGUide ? _chooseMonth() : SizedBox(),
                !_notSelfNotGUide ? _renderDivider() : SizedBox(),
                !_notSelfNotGUide ? _chooseYear() : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        appBackground: Color(0xFF16182B),
        leading: RecookBackButton(white: true),
        elevation: 0,
        title: Text(
          _title,
          style: TextStyle(
            fontSize: 18.rsp,
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshWidget(
        controller: _refreshController,
        onRefresh: () async {
          int BenefitType = 0;

          if (widget.type == UserBenefitPageType.SELF) {
            BenefitType = 1;
          } else if (widget.type == UserBenefitPageType.GUIDE) {
            BenefitType = 2;
          }

          if (!_notSelfNotGUide) {
            if (widget.receivedType == '已到账') {
              if (_yearChoose == true) {
                formatType = 'yyyy';
                _models = await UserBenefitFunc.receicedIncome(
                    DateUtil.formatDate(_date, format: 'yyyy'), BenefitType);
              } else if (_monthChoose == true) {
                formatType = 'yyyy-MM';
                _models = await UserBenefitFunc.receicedIncome(
                    DateUtil.formatDate(_date, format: 'yyyyMM'), BenefitType);
              }
            } else if (widget.receivedType == '未到账') {
              if (_yearChoose == true) {
                formatType = 'yyyy';
                _models = await UserBenefitFunc.notReceicedIncome(
                    DateUtil.formatDate(_date, format: 'yyyy'), BenefitType);
              } else if (_monthChoose == true) {
                formatType = 'yyyy-MM';
                _models = await UserBenefitFunc.notReceicedIncome(
                    DateUtil.formatDate(_date, format: 'yyyyMM'), BenefitType);
              }
            }
            _onload = false;
          } else {
            //团队补贴

            if (widget.receivedType == '未到账') {
              formatType = 'yyyy';
              _models = await UserBenefitFunc.teamNotReceicedIncome(team_level);
            } else if (widget.receivedType == '已到账') {
              formatType = 'yyyy-MM';
              _models = await UserBenefitFunc.teamReceicedIncome(
                  int.parse(DateUtil.formatDate(_date, format: 'yyyy')));

              _selfALL = _models?.team?.toStringAsFixed(2);
              _distributionALL = _models?.recommend?.toStringAsFixed(2);
              _agentALL = _models?.reward?.toStringAsFixed(2);
            }

            _onload = false;
          }
          _amount = _models?.amount?.toStringAsFixed(2);
          _all = _models?.all?.toStringAsFixed(2);
          //对隐藏列表全部置为隐藏
          for (int i = 0; i < _models?.detail?.length; i++) {
            _gone.add(true);
          }
          for (int i = 0; i < _gone.length; i++) {
            _gone[i] = true;
          }

          print(_models?.amount?.toStringAsFixed(2));
          print(_models?.all?.toStringAsFixed(2));
          setState(() {});
          _refreshController.refreshCompleted();
        },
        body: Column(
          children: [
            _buildCard(),
            Row(
              children: [
                28.wb,
                Column(
                  children: [
                    !_notSelfNotGUide
                        ? MaterialButton(
                            shape: StadiumBorder(),
                            elevation: 0,
                            color: Colors.white,
                            onPressed: () {
                              showTimePickerBottomSheet(
                                  submit: (time, type) {
                                    Navigator.maybePop(context);
                                    _date = time;
                                    _refreshController.requestRefresh();
                                    setState(() {});
                                  },
                                  timePickerTypes: [
                                    BottomTimePickerType.BottomTimePickerMonth
                                  ]);
                            },
                            height: 28.rw,
                            child: Row(
                              children: [
                                DateUtil.formatDate(_date, format: formatType)
                                    .text
                                    .black
                                    .size(14.rsp)
                                    .make(),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          )
                        : widget.receivedType == '未到账'
                            ? Container(
                                padding: EdgeInsets.only(left: 30.w),
                                child: DateUtil.formatDate(_date,
                                        format: _TformatType)
                                    .text
                                    .black
                                    .size(14.rsp)
                                    .make(),
                              )
                            : MaterialButton(
                                shape: StadiumBorder(),
                                elevation: 0,
                                color: Colors.white,
                                onPressed: () {
                                  showTimePickerBottomSheet(
                                      submit: (time, type) {
                                        Navigator.maybePop(context);
                                        _date = time;
                                        _refreshController.requestRefresh();
                                        setState(() {});
                                      },
                                      timePickerTypes: [
                                        BottomTimePickerType
                                            .BottomTimePickerYear
                                      ]);
                                },
                                height: 28.rw,
                                child: Row(
                                  children: [
                                    DateUtil.formatDate(_date,
                                            format: _TformatType)
                                        .text
                                        .black
                                        .size(14.rsp)
                                        .make(),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              )
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    _onload ? SizedBox() : _buildTag(),
                  ],
                ),
                15.wb,
              ],
            ),
            20.hb,
            //_notSelfNotGUide ? _buildMidCard() : SizedBox(),
            SizedBox(
              height: 45.rw,
              child: _buildTableTitle1(),
            ),
            Expanded(
                child: Container(
              child: _onload ? SizedBox() : _buildTableList(),
            ))
          ],
        ),
      ),
    );
  }

  getColor(bool tip) {
    if (tip == true) {
      return Colors.black;
    } else {
      return Colors.grey;
    }
  }

  getWeight(bool tip) {
    if (tip == true) {
      return FontWeight.bold;
    } else {
      return FontWeight.normal;
    }
  }

  _buildTableList() {
    return new ListView.builder(
      itemCount: _models.detail.length,
      itemBuilder: (context, i) {
        UserIncomeModel userIncomeModel = _models;
        return _buildTableBody(userIncomeModel.detail[i], i);
      },
    );
  }

  _buildTableTitle1() {
    String tableText = '';
    if (_notSelfNotGUide) {
      if (widget.receivedType == '未到账') {
        tableText = '未到账补贴(瑞币)';
      } else if (widget.receivedType == '已到账') {
        tableText = '已到账补贴(瑞币)';
      }
    } else {
      if (widget.receivedType == '未到账') {
        tableText = '未到账收益(瑞币)';
      } else if (widget.receivedType == '已到账') {
        tableText = '已到账收益(瑞币)';
      }
    }

    return Row(
      children: [
        Container(
          height: 88.w,
          width: 150.w,
          color: Colors.white,
          child: Text(
            '日期',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
              fontSize: 16.rsp,
            ),
          ).centered(),
        ),
        Container(
          height: 88.w,
          width: 180.w,
          color: Colors.white,
          child: Text(
            '销售额',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
              fontSize: 16.rsp,
            ),
          ).centered(),
        ),
        Container(
          height: 88.w,
          width: 100.w,
          color: Colors.white,
          child: Text(
            '订单数',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
              fontSize: 16.rsp,
            ),
          ).centered(),
        ),
        Container(
          height: 88.w,
          width: 320.w,
          color: Colors.white,
          child: Text(
            tableText,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
              fontSize: 16.rsp,
            ),
          ).centered(),
        ),
      ],
    );
  }

  _buildTableBody(var detail, int num) {
    String _time = detail.date.toString() + '000'; //dart语言时间戳要求13位

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (!_notSelfNotGUide) {
              if (detail.count > 1) {
                _gone[num] = !_gone[num];
                setState(() {});
              } else if (detail.count == 1) {
                AppRouter.push(context, RouteName.SHOP_ORDER_DETAIL,
                    arguments: OrderDetailPage.setArguments(
                        detail.detail[0].id)); //只有一条数据时，第二层也会有一条
              }
            } else {
              int type = 0;
              if (widget.receivedType == '未到账') {
                type = 1;
              } else {
                type = 2;
              }
              Get.to(UserBenefitShopPage(teamType: type));
            }
          },
          child: Row(
            children: [
              Container(
                height: 88.w,
                width: 150.w,
                color: Colors.white,
                child: Text(
                  DateUtil.formatDate(
                      DateTime.fromMillisecondsSinceEpoch(int.parse(_time)),
                      format: TableformatType),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                    fontSize: 16.rsp,
                  ),
                ).centered(),
              ),
              Container(
                height: 45.rw,
                width: 180.w,
                color: Colors.white,
                child: Text(
                  detail.sale.toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                    fontSize: 16.rsp,
                  ),
                ).centered(),
              ),
              Container(
                height: 88.w,
                width: 100.w,
                color: Colors.white,
                child: Text(
                  detail.count.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                    fontSize: 16.rsp,
                  ),
                ).centered(),
              ),
              Container(
                height: 88.w,
                width: 320.w,
                color: Colors.white,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 60.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        detail.coin.toStringAsFixed(2),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xffD5101A),
                          fontSize: 16.rsp,
                        ),
                      ).centered(),
                    ),
                    !_notSelfNotGUide
                        ? detail.count > 1
                            ? _gone[num]
                                ? Icon(Icons.keyboard_arrow_right,
                                    size: 22, color: Color(0xff999999))
                                : Icon(Icons.keyboard_arrow_down,
                                    size: 22, color: Color(0xff999999))
                            : SizedBox()
                        : SizedBox(),
                    20.wb
                  ],
                ),
              )
            ],
          ),
        ),
        !_notSelfNotGUide
            ? Offstage(
                offstage: _gone[num],
                child: Column(
                  children: [
                    ..._models.detail[num].detail.map(
                      (e) {
                        return _buildHideBody(
                            e.id, e.date, e.sale, e.count, e.coin);
                      },
                    ),
                  ],
                  //itemCount: _models.detail[index].detail.length,
                  //return _buildHideBody(_models.detail[num].detail[index]);
                ),
              )
            : SizedBox()
      ],
    );
  }

  _buildHideBody(
    num id,
    num date,
    num sale,
    num count,
    num coin,
  ) {
    String _time = date.toString() + '000'; //dart语言时间戳要求13位
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            AppRouter.push(context, RouteName.SHOP_ORDER_DETAIL,
                arguments: OrderDetailPage.setArguments(id));
          },
          child: Row(
            children: [
              Container(
                height: 88.w,
                width: 150.w,
                color: Color(0xFFF2F8FF),
                child: Text(
                  _yearChoose
                      ? DateUtil.formatDate(
                          DateTime.fromMillisecondsSinceEpoch(int.parse(_time)),
                          format: 'M月d日')
                      : DateUtil.formatDate(
                          DateTime.fromMillisecondsSinceEpoch(int.parse(_time)),
                          format: 'HH:mm:ss'),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                    fontSize: 12.rsp,
                  ),
                ).centered(),
              ),
              Container(
                height: 45.rw,
                width: 180.w,
                color: Color(0xFFF2F8FF),
                child: Text(
                  sale.toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                    fontSize: 12.rsp,
                  ),
                ).centered(),
              ),
              Container(
                height: 88.w,
                width: 100.w,
                color: Color(0xFFF2F8FF),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                    fontSize: 12.rsp,
                  ),
                ).centered(),
              ),
              Container(
                height: 88.w,
                width: 320.w,
                color: Color(0xFFF2F8FF),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        coin.toStringAsFixed(2),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xffD5101A),
                          fontSize: 12.rsp,
                        ),
                      ).centered(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
