import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:common_utils/common_utils.dart';
import 'package:recook/pages/user/model/user_benefit_day_team_model.dart';
import 'package:recook/pages/user/model/user_benefit_month_team_model.dart';
import 'package:recook/pages/user/user_partner_card.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/pages/user/functions/user_benefit_func.dart';
import 'package:recook/pages/user/model/user_benefit_extra_detail_model.dart';
import 'package:recook/pages/user/model/user_benefit_month_detail_model.dart';
import 'package:recook/pages/user/model/user_benefit_sub_model.dart';
import 'package:recook/pages/user/widget/user_group_card.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/animated_rotate.dart';
import 'package:recook/widgets/bottom_time_picker.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_painters/round_background_painter.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/pages/shop/widget/shop_page_income_widget.dart';
import 'package:recook/utils/tool/list_widget_ext.dart';

class UserBenefitShopPage extends StatefulWidget {
  final String receivedType;
  final int teamType;
  final DateTime date;

  UserBenefitShopPage(
      {Key key,
      @required this.receivedType,
      @required this.teamType,
      @required this.date})
      : super(key: key);

  @override
  _UserBenefitShopPageState createState() => _UserBenefitShopPageState();
}

class _UserBenefitShopPageState extends State<UserBenefitShopPage> {
  DateTime _date = DateTime.now();
  String _subsidy = '0'; //比例
  String _salesVolume = '0.00'; //销售额
  String _count = '0'; //订单数
  String _amount = '0.00'; //补贴
  String _title = '';
  UserBenefitDayTeamModel _dayModel;
  UserBenefitMonthTeamModel _monthModel;
  String _formatType = 'MM-dd'; //时间选择器按钮样式
  List<UserIncomeDay> _userIncomeDaylist; //到账收益团队列表
  Timer _timer;

  bool _sortGroup = false;
  bool _sortOrder = false;
  bool _sortMoney = true;

  bool _isOver = false;

  GSRefreshController _refreshController = GSRefreshController();

  ///头部卡片
  Widget _buildCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.rw, vertical: 10.rw),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ('当日未到账补贴(瑞币)')
                      .text
                      .color(Colors.black54)
                      .size(16.rsp)
                      .make(),
                  _amount.text.color(Color(0xFF333333)).size(34.rsp).make(),
                ],
              ),
              Spacer(),
              Image.asset(
                UserLevelTool.currentMedalImagePath(),
                height: 55.rw,
                width: 55.rw,
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Container(
                child: Column(
                  children: [
                    '销售额(元)'.text.color(Colors.black54).size(15.rsp).make(),
                    20.hb,
                    _salesVolume.text
                        .color(Color(0xFF333333))
                        .size(16.rsp)
                        .make(),
                  ],
                ),
              ).expand(),
              50.wb,
              Container(
                child: Column(
                  children: [
                    '品牌推广补贴(%)'.text.color(Colors.black54).size(15.rsp).make(),
                    20.hb,
                    _subsidy.text.color(Color(0xFF333333)).size(16.rsp).make(),
                  ],
                ),
              ),
              50.wb,
              Container(
                child: Column(
                  children: [
                    ('订单数(笔)').text.color(Colors.black54).size(15.rsp).make(),
                    20.hb,
                    _count.text.color(Color(0xFF333333)).size(16.rsp).make(),
                  ],
                ),
              ).expand(),
            ],
          ),
          20.hb,
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.rw),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.rw),
            color: Color.fromRGBO(166, 166, 173, 0.43),
            blurRadius: 6.rw,
          )
        ],
        image: DecorationImage(
          image: AssetImage(UserLevelTool.currentCardImagePath()),
          fit: BoxFit.cover,
        ),
      ),
      height: 172.rw,
      width: double.infinity,
      margin: EdgeInsets.only(left: 15.rw, right: 15.rw, top: 48.rw),
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
              timePickerTypes: widget.receivedType == '未到账'
                  ? [BottomTimePickerType.BottomTimePickerDay]
                  : [BottomTimePickerType.BottomTimePickerMonth],
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

  ///背景条
  _buildBackBar() {
    return Container(
      height: 10.rw,
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 7.rw),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.rw),
            color: Colors.black.withOpacity(0.24),
            blurRadius: 4.rw,
          ),
        ],
        color: Color(0xFFE3E3E3),
        borderRadius: BorderRadius.circular(5.rw),
      ),
      child: Container(
        height: 4.rw,
        margin: EdgeInsets.symmetric(horizontal: 4.rw),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2.rw),
              color: Colors.black.withOpacity(0.39),
              blurRadius: 4.rw,
            ),
          ],
          color: Color(0xFFBBBBBB),
          borderRadius: BorderRadius.circular(5.rw),
        ),
      ),
    );
  }

  Widget _buildGroupItems() {
    if (_monthModel == null && _dayModel == null) return SizedBox();

    return Stack(
      children: [
        _buildBackBar(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15.rw, vertical: 6.rw),
          child: <Widget>[
            20.hb,
            Row(
              children: [
                15.wb,
                '$_title贡献榜'
                    .text
                    .size(14.rsp)
                    .color(Color(0xFF333333))
                    .bold
                    .make(),
                MaterialButton(
                  padding: EdgeInsets.all(4.rw),
                  minWidth: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Icon(
                    Icons.help_outline,
                    size: 12.rw,
                    color: Color(0xFFA5A5A5),
                  ),
                  onPressed: () {
                    Alert.show(
                      context,
                      NormalContentDialog(
                        title: '店铺贡献榜图标定义',
                        content:
                            Image.asset(R.ASSETS_USER_CARD_DESCRIPTION_WEBP),
                        items: ["确认"],
                        listener: (index) => Alert.dismiss(context),
                      ),
                    );
                  },
                ),
                Spacer(),
                Row(
                  children: [
                    MaterialButton(
                      minWidth: 0,
                      padding: EdgeInsets.all(4.rw),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () {
                        setState(() {
                          _sortGroup = true;
                          _sortOrder = false;
                          _sortMoney = false;
                          if (widget.receivedType == '已到账' &&
                              widget.teamType == 1) {
                            //第一个本人默认不变 对后续的进行排序
                            List<UserIncomeMonth> userIncome = _monthModel
                                .userIncome
                                .sublist(1, _monthModel.userIncome.length);
                            userIncome
                                .sort((a, b) => b.count.compareTo(a.count));
                            _monthModel.userIncome.replaceRange(
                                1, _monthModel.userIncome.length, userIncome);
                          } else if (widget.receivedType == '已到账' &&
                              widget.teamType != 1) {
                            _monthModel.userIncome
                                .sort((a, b) => b.count.compareTo(a.count));
                          } else if (widget.receivedType == '未到账' &&
                              widget.teamType == 1) {
                            //第一个本人默认不变 对后续的进行排序
                            List<UserIncomeDay> userIncome = _userIncomeDaylist
                                .sublist(1, _userIncomeDaylist.length);

                            userIncome
                                .sort((a, b) => b.count.compareTo(a.count));
                            try {
                              _userIncomeDaylist.replaceRange(
                                  1, _userIncomeDaylist.length, userIncome);
                            } catch (e) {
                              print(e);
                            }
                          } else if (widget.receivedType == '未到账' &&
                              widget.teamType != 1) {
                            _userIncomeDaylist
                                .sort((a, b) => b.count.compareTo(a.count));
                          }
                        });
                      },
                      child: !_sortGroup
                          ? Image.asset(
                              R.ASSETS_USER_ICON_SORT_GROUP_PNG,
                              height: 17.rw,
                              width: 17.rw,
                            )
                          : Image.asset(
                              R.ASSETS_USER_ICON_SORT_GROUP_C_PNG,
                              height: 17.rw,
                              width: 17.rw,
                            ),
                    ),
                    11.wb,
                    MaterialButton(
                      minWidth: 0,
                      padding: EdgeInsets.all(4.rw),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () {
                        setState(() {
                          _sortGroup = false;
                          _sortOrder = true;
                          _sortMoney = false;
                          if (widget.receivedType == '已到账' &&
                              widget.teamType == 1) {
                            //第一个本人默认不变 对后续的进行排序
                            List<UserIncomeMonth> userIncome = _monthModel
                                .userIncome
                                .sublist(1, _monthModel.userIncome.length);
                            userIncome.sort((a, b) =>
                                b.order_count.compareTo(a.order_count));
                            _monthModel.userIncome.replaceRange(
                                1, _monthModel.userIncome.length, userIncome);
                          } else if (widget.receivedType == '已到账' &&
                              widget.teamType != 1) {
                            _monthModel.userIncome.sort((a, b) =>
                                b.order_count.compareTo(a.order_count));
                          } else if (widget.receivedType == '未到账' &&
                              widget.teamType == 1) {
                            //第一个本人默认不变 对后续的进行排序
                            List<UserIncomeDay> userIncome = _userIncomeDaylist
                                .sublist(1, _userIncomeDaylist.length);
                            userIncome.sort((a, b) =>
                                b.order_count.compareTo(a.order_count));
                            _userIncomeDaylist.replaceRange(
                                1, _userIncomeDaylist.length, userIncome);
                          } else if (widget.receivedType == '未到账' &&
                              widget.teamType != 1) {
                            _userIncomeDaylist.sort((a, b) =>
                                b.order_count.compareTo(a.order_count));
                          }
                        });
                      },
                      child: !_sortOrder
                          ? Image.asset(
                              R.ASSETS_USER_ICON_SORT_ORDER_PNG,
                              height: 17.rw,
                              width: 17.rw,
                            )
                          : Image.asset(
                              R.ASSETS_USER_ICON_SORT_ORDER_C_PNG,
                              height: 17.rw,
                              width: 17.rw,
                            ),
                    ),
                    11.wb,
                    MaterialButton(
                      padding: EdgeInsets.all(4.rw),
                      minWidth: 0,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () {
                        setState(() {
                          _sortGroup = false;
                          _sortOrder = false;
                          _sortMoney = true;

                          if (widget.receivedType == '已到账' &&
                              widget.teamType == 1) {
                            //第一个本人默认不变 对后续的进行排序
                            List<UserIncomeMonth> userIncome = _monthModel
                                .userIncome
                                .sublist(1, _monthModel.userIncome.length);
                            userIncome
                                .sort((a, b) => b.amount.compareTo(a.amount));
                            _monthModel.userIncome.replaceRange(
                                1, _monthModel.userIncome.length, userIncome);
                          } else if (widget.receivedType == '已到账' &&
                              widget.teamType != 1) {
                            _monthModel.userIncome
                                .sort((a, b) => b.amount.compareTo(a.amount));
                          } else if (widget.receivedType == '未到账' &&
                              widget.teamType == 1) {
                            //第一个本人默认不变 对后续的进行排序
                            List<UserIncomeDay> userIncome = _userIncomeDaylist
                                .sublist(1, _userIncomeDaylist.length);
                            userIncome
                                .sort((a, b) => b.amount.compareTo(a.amount));
                            _userIncomeDaylist.replaceRange(
                                1, _userIncomeDaylist.length, userIncome);
                          } else if (widget.receivedType == '未到账' &&
                              widget.teamType != 1) {
                            _userIncomeDaylist
                                .sort((a, b) => b.amount.compareTo(a.amount));
                          }
                        });
                      },
                      child: _sortMoney
                          ? Image.asset(
                              R.ASSETS_USER_ICON_SORT_MONEY_C_PNG,
                              height: 17.rw,
                              width: 17.rw,
                            )
                          : Image.asset(
                              R.ASSETS_USER_ICON_SORT_MONEY_PNG,
                              height: 17.rw,
                              width: 17.rw,
                            ),
                    ),
                    16.wb,
                  ],
                )
              ],
            ),
            10.hb,
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              //reverse: _itemReverse,
              children: widget.receivedType == '已到账'
                  ? _monthModel.userIncome
                      .map((e) {
                        return UserPartnerCard(
                            userId: e.userId,
                            headImgUrl: e.headImgUrl,
                            nickname: e.nickname,
                            phone: e.phone ?? '',
                            wechatNo: e.wechatNo ?? '',
                            remarkName: e.remarkName ?? '',
                            count: e.count ?? '',
                            roleLevel: e.roleLevel ?? '',
                            amount: e.amount ?? '',
                            order_count: e.order_count ?? '');
                      })
                      .toList()
                      .sepWidget(
                          separate: Divider(
                        indent: 100.w,
                        endIndent: 50.w,
                        color: Color(0xFFEEEEEE),
                        height: rSize(1),
                        thickness: rSize(1),
                      ))
                  : _userIncomeDaylist
                      .map((e) {
                        return UserPartnerCard(
                            userId: e.userId,
                            headImgUrl: e.headImgUrl,
                            nickname: e.nickname,
                            phone: e.phone ?? '',
                            wechatNo: e.wechatNo ?? '',
                            remarkName: e.remarkName ?? '',
                            count: e.count ?? '',
                            roleLevel: e.roleLevel ?? '',
                            amount: e.amount ?? '',
                            order_count: e.order_count ?? '');
                      })
                      .toList()
                      .sepWidget(
                          separate: Divider(
                        indent: 100.w,
                        endIndent: 50.w,
                        color: Color(0xFFEEEEEE),
                        height: rSize(1),
                        thickness: rSize(1),
                      )),
            ),
          ].column(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(5.rw)),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2.rw),
                blurRadius: 4.rw,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildDateBtn() {
    return Container(
      padding: EdgeInsets.only(top: 10.rw),
      child: Row(
        children: [
          30.wb,
          MaterialButton(
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
                  timePickerTypes: [BottomTimePickerType.BottomTimePickerDay]);
            },
            height: 28.rw,
            child: Row(
              children: [
                DateUtil.formatDate(_date, format: _formatType)
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
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget noMoreDataView({String text, Widget icon}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          icon != null
              ? icon
              : Image.asset(
                  ShopImageName.shop_page_smile,
                  width: 22,
                  height: 12,
                ),
          Container(
            height: 10,
          ),
          Text(
            TextUtils.isEmpty(text) ? "这是我最后的底线" : text,
            style: TextStyle(color: Color(0xff666666), fontSize: 12),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _date = widget.date;
    if (widget.receivedType == '未到账') {
      _formatType = 'MM-dd';
    } else if (widget.receivedType == '已到账') {
      _formatType = 'yyyy-MM';
    }

    if (widget.teamType == 1) {
      _title = '自营店铺';
    } else if (widget.teamType == 2) {
      _title = '分销店铺';
    } else if (widget.teamType == 3) {
      _title = '代理店铺';
    }
    Future.delayed(
      Duration(milliseconds: 300),
      () => _refreshController.requestRefresh(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        appBackground: AppColor.blackColor,
        themeData: AppThemes.themeDataMain.appBarTheme,
        elevation: 0,
        title: _title,
        bottom: widget.receivedType == '已到账'
            ? PreferredSize(
                child: '每月1日结算上月$_title'
                    .text
                    .size(14.rsp)
                    .color(Color(0xFF333333))
                    .make()
                    .centered()
                    .material(color: Color(0xFFFAFAFA)),
                preferredSize: Size.fromHeight(24.rw),
              )
            : PreferredSize(
                child: SizedBox(),
                preferredSize: Size.fromHeight(0.rw),
              ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshWidget(
              noData: 'part',
              controller: _refreshController,
              color: Colors.white,
              onLoadMore: () {
                _refreshController.loadNoData();
              },
              onRefresh: () async {
                //已到账 月收益
                if (widget.receivedType == '已到账') {
                  switch (widget.teamType) {
                    case 1:
                      _monthModel = await UserBenefitFunc.selfReceicedMonth(
                          DateUtil.formatDate(_date, format: 'yyyy-MM'));
                      break;
                    case 2:
                      _monthModel =
                          await UserBenefitFunc.distributionReceicedMonth(
                              DateUtil.formatDate(_date, format: 'yyyy-MM'));
                      break;
                    case 3:
                      _monthModel = await UserBenefitFunc.agentReceicedMonth(
                          DateUtil.formatDate(_date, format: 'yyyy-MM'));
                      break;
                    default:
                      {}
                      break;
                  }
                  _subsidy = _monthModel.ratio.toString(); //比例
                  _salesVolume =
                      _monthModel.salesVolume.toStringAsFixed(2); //销售额
                  _count = _monthModel.order_count.toString(); //订单数
                  _amount = _monthModel.amount.toStringAsFixed(2); //补贴
                  _isOver = true;
                } else if (widget.receivedType == '未到账') {
                  //未到账 日收益

                  _dayModel = await UserBenefitFunc.teamNotReceicedDay(
                      DateUtil.formatDate(_date, format: 'yyyy-MM-dd'));
                  if (widget.teamType == 1) {
                    _subsidy = _dayModel.team.ratio.toString();
                    _salesVolume =
                        _dayModel.team.salesVolume.toStringAsFixed(2);
                    _count = _dayModel.team.order_count.toString();
                    _amount = _dayModel.team.amount.toStringAsFixed(2); //补贴
                  } else if (widget.teamType == 2) {
                    _subsidy = _dayModel.recommend.ratio.toString();
                    _salesVolume =
                        _dayModel.recommend.salesVolume.toStringAsFixed(2);
                    _count = _dayModel.recommend.order_count.toString();
                    _amount =
                        _dayModel.recommend.amount.toStringAsFixed(2); //补贴
                  } else if (widget.teamType == 3) {
                    _subsidy = _dayModel.reward.ratio.toString();
                    _salesVolume =
                        _dayModel.reward.salesVolume.toStringAsFixed(2);
                    _count = _dayModel.reward.order_count.toString();
                    _amount = _dayModel.reward.amount.toStringAsFixed(2); //补贴
                  }
                  _isOver = true;
                }

                if (_isOver) {
                  if (widget.teamType == 1 && widget.receivedType == '未到账') {
                    _userIncomeDaylist = _dayModel.teamList;
                  } else if (widget.teamType == 2 &&
                      widget.receivedType == '未到账') {
                    _userIncomeDaylist = _dayModel.recommendList;
                  } else if (widget.teamType == 3 &&
                      widget.receivedType == '未到账') {
                    _userIncomeDaylist = _dayModel.rewardList;
                  }
                }

                setState(() {});
                _refreshController.refreshCompleted();
              },
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          child: CustomPaint(painter: RoundBackgroundPainter()),
                        ),
                        _buildDateBtn(),
                        _buildCard(),
                      ],
                    ),
                    13.hb,
                    _buildGroupItems(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
