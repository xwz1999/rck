import 'dart:math';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:recook/pages/user/model/user_income_model1.dart';
import 'package:recook/pages/user/user_benefit_sub_page.dart';
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

enum UserBenefitCurrencyPageType {
  ///自购收益
  SELF,

  ///导购收益
  GUIDE,

  ///店铺补贴
  SUBSIDY
}

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
  String _count = '';

  bool _itemReverse = false;

  bool yearChoose = false; //0为年 1为月
  bool monthChoose = true; //0为年 1为月
  ///累计收益
  ///
  UserAccumulateModel _model = UserAccumulateModel.zero();
  DateTime _date = DateTime.now();

  UserIncomeModel1 _models; //自购导购未到已到收益
  UserBenefitExtraDetailModel _extraDetailModel;

  _chooseMonth() {
    return CustomImageButton(
      height: 50.w,
      onPressed: () {
        setState(() {
          yearChoose = false;
          monthChoose = true;
        });
      },
      child: Text('未到账明细(月)',
          style: TextStyle(
              fontSize: 14.rsp,
              color: getColor(monthChoose),
              fontWeight: getWeight(monthChoose))),
    ).expand();
  }

  _chooseYear() {
    return CustomImageButton(
      height: 50.w,
      onPressed: () {
        setState(() {
          yearChoose = true;
          monthChoose = false;
        });
      },
      child: Text('未到账明细(年)',
          style: TextStyle(
              fontSize: 14.rsp,
              color: getColor(yearChoose),
              fontWeight: getWeight(yearChoose))),
    ).expand();
  }

  _renderDivider() {
    return Container(
      height: 22.rw,
      width: 1.rw,
      color: Color(0xFF979797),
    );
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

//团队
  Widget _buildGroupItems() {
    if (_extraDetailModel == null) return SizedBox();
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15.rw, vertical: 6.rw),
          child: <Widget>[
            20.hb,
            Row(
              children: [
                15.wb,
                '团队贡献榜'.text.size(14.rsp).color(Color(0xFF333333)).bold.make(),
                Spacer(),
                '团队人数:${_extraDetailModel.data.count}'
                    .text
                    .size(14.rsp)
                    .color(Color(0xFF333333))
                    .bold
                    .make(),
                10.wb,
                MaterialButton(
                  minWidth: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {
                    setState(() {
                      _itemReverse = !_itemReverse;
                    });
                  },
                  child: AnimatedRotate(
                    child: Image.asset(
                      R.ASSETS_ASCSORT_PNG,
                      height: 15.rw,
                      width: 15.rw,
                    ),
                    angle: _itemReverse ? 0 : pi,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15.rw),
                ),
              ],
            ),
            10.hb,
            // ListView(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   reverse: _itemReverse,
            //   children: _extraDetailModel.data.userIncome.map((e) {
            //     bool hasExtraName = TextUtil.isEmpty(e.remarkName);
            //     return UserGroupCard(
            //       id: e.userId,
            //       isRecommend: false,
            //       shopRole: UserLevelTool.roleLevelEnum(e.roleLevel),
            //       wechatId: e.wechatNo ?? '',
            //       name: '${e.nickname}${hasExtraName ? '' : e.remarkName}',
            //       groupCount: e.count,
            //       phone: e.phone ?? '',
            //       headImg: e.headImgUrl ?? '',
            //       remarkName: e.remarkName ?? '',
            //     );
            //   }).toList(),
            // ),
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
              timePickerTypes: monthChoose == true
                  ? [BottomTimePickerType.BottomTimePickerMonth]
                  : [BottomTimePickerType.BottomTimePickerYear],
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

  ///中间的按钮
  Widget _buildMidCard() {
    if (_extraDetailModel == null) return SizedBox();
    return VxBox(
      child: [
        '$_title\(元)'.text.color(Colors.black54).size(18).make(),
        (_extraDetailModel.data.amount ?? 0.0)
            .toStringAsFixed(2)
            .text
            .color(Color(0xFF333333))
            .size(24)
            .make(),
        36.hb,
        [
          [
            '销售额(元)'.text.color(Colors.black54).size(14).make(),
            (_extraDetailModel.data.salesVolume ?? 0.0)
                .toStringAsFixed(2)
                .text
                .color(Color(0xFF333333))
                .size(16)
                .make(),
          ].column(crossAlignment: CrossAxisAlignment.start),
          Spacer(),
          [
            '提成比例(%)'.text.color(Colors.black54).size(14).make(),
            (_extraDetailModel.data.ratio ?? 0.0)
                .toStringAsFixed(2)
                .text
                .color(Color(0xFF333333))
                .size(16)
                .make(),
          ].column(),
        ].row(),
      ].column(crossAlignment: CrossAxisAlignment.start),
    )
        .withRounded(value: 5.rw)
        .white
        .padding(EdgeInsets.symmetric(horizontal: 15.rw, vertical: 20.rw))
        .margin(EdgeInsets.symmetric(horizontal: 16.rw, vertical: 10.rw))
        .make();
  }

  Widget _buildTag() {
    // if(_models.isEmpty)return SizedBox()
    String benefitValue = '';
    String text = '本月收益';
    //benefitValue = _models.data.data.amount.toStringAsFixed(2);

    // if (widget.type == UserBenefitPageType.SELF) {
    //   _models.forEach((element) => benefitValue += element.purchaseAmount);
    // }
    // if (widget.type == UserBenefitPageType.GUIDE)
    //   _models.forEach((element) => benefitValue += element.guideAmount);

    if (widget.receivedType == '未到账' && yearChoose == true) {
      text = '本年未到账收益：';
    } else if (widget.receivedType == '未到账' && monthChoose == true) {
      text = '本月未到账收益：';
    } else if (widget.receivedType == '已到账' && yearChoose == true) {
      text = '本年到账收益：';
    } else if (widget.receivedType == '已到账' && monthChoose == true) {
      text = '本月到账收益：';
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
        )
      ],
    );
    // return '当月收益(瑞币)：${benefitValue.toStringAsFixed(2)}'
    //     .text
    //     .color(Color(0xFF999999))
    //     .size(16.rsp)
    //     .make();
  }

  Widget _buildCard() {
    return Container(
      clipBehavior: Clip.antiAlias,
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
                    '累计未到账收益(瑞币)'.text.black.make(),
                    8.hb,
                    (_all ?? '').text.black.size(34.rsp).make(),
                  ],
                ).expand(),
                Image.asset(
                  UserLevelTool.currentMedalImagePath(),
                  width: 56.w,
                  height: 56.w,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.rw),
            child: Row(
              children: [
                _chooseMonth(),
                _renderDivider(),
                _chooseYear(),
                _buildTable(),
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
          // UserBenefitSubModel model =
          //     await UserBenefitFunc.subInfo(widget.type);

          // _amount = model.data.amount.toStringAsFixed(2);
          // _salesVolume = model.data.salesVolume.toStringAsFixed(2);
          // _count = model.data.count.toStringAsFixed(0);
          int BenefitType = 0;
          if (widget.type == UserBenefitPageType.SELF) {
            BenefitType = 1;
          } else if (widget.type == UserBenefitPageType.GUIDE) {
            BenefitType = 2;
          }

          if (!_notSelfNotGUide) {
            if (widget.receivedType == '已到账') {
              if (yearChoose == true) {
                _models = await UserBenefitFunc.receicedIncome(
                    DateUtil.formatDate(_date, format: 'yyyy'), BenefitType);
              } else if (monthChoose == true) {
                _models = await UserBenefitFunc.receicedIncome(
                    DateUtil.formatDate(_date, format: 'yyyyMM'), BenefitType);
              }
            } else if (widget.receivedType == '未到账') {
              if (yearChoose == true) {
                _models = await UserBenefitFunc.notReceicedIncome(
                    DateUtil.formatDate(_date, format: 'yyyy'), BenefitType);
              } else if (monthChoose == true) {
                _models = await UserBenefitFunc.notReceicedIncome(
                    DateUtil.formatDate(_date, format: 'yyyyMM'), BenefitType);
              }
            }
          } else {
            //团队补贴
          }
          _amount = _models.data?.amount?.toStringAsFixed(2);
          _all = _models.data?.all?.toStringAsFixed(2);
          print(_models?.data?.amount?.toStringAsFixed(2));
          print(_models?.data?.all?.toStringAsFixed(2));
          setState(() {});
          _refreshController.refreshCompleted();
        },
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30.rw, vertical: 20.rw),
          children: [
            _buildCard(),
            Row(
              children: [
                Column(
                  children: [
                    16.hb,
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
                            timePickerTypes: [
                              BottomTimePickerType.BottomTimePickerMonth
                            ]);
                      },
                      height: 28.rw,
                      child: Row(
                        children: [
                          DateUtil.formatDate(_date, format: 'yyyy-MM')
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
                Spacer(),
                Column(
                  children: [
                    15.hb,
                    _notSelfNotGUide ? SizedBox() : _buildTag(),
                  ],
                ),
                15.wb,
              ],
            ),
            //_notSelfNotGUide ? _buildMidCard() : SizedBox(),
            _notSelfNotGUide ? _buildGroupItems() : _buildTable(),
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

  ///表格标题
  _buildTableTitle(String title, [bool red = false, bool bold = true]) =>
      SizedBox(
        height: 45.rw,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: red ? Color(0xFFD5101A) : Color(0xFF333333),
            fontSize: 16.rsp,
          ),
        ).centered(),
      );

  ///表格内容
  _buildTableItem(String value, [bool red = false]) =>
      _buildTableTitle(value, red, false);
  TableRow _buildTableRow({
    DateTime date,
    num volume,
    int count,
    num benefit,
  }) {
    return TableRow(
      children: [
        _buildTableItem(DateUtil.formatDate(date, format: 'M月dd日')),
        _buildTableItem(volume.toStringAsFixed(2)),
        _buildTableItem(count.toString()),
        _buildTableItem(benefit.toStringAsFixed(2), true),
      ],
    );
  }

  ///表格
  ///
  ///自购收益和导购收益的列表
  _buildTable() {
    //if (_models.isEmpty) return SizedBox();
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: Color(0xFFEEEEEE), width: 1.rw),
      ),
      children: [
        TableRow(
          children: [
            _buildTableTitle('日期'),
            _buildTableTitle('销售额'),
            _buildTableTitle('订单数'),
            _buildTableTitle('结算收益'),
          ],
        ),
        // ..._models.map((e) {
        //   num amount = 0;
        //   num salesVolume = 0;
        //   int count = 0;
        //   if (widget.type == UserBenefitPageType.SELF) {
        //     amount = e.purchaseAmount;
        //     salesVolume = e.purchaseSalesVolume;
        //     count = e.purchaseCount;
        //   }
        //   if (widget.type == UserBenefitPageType.GUIDE) {
        //     amount = e.guideAmount;
        //     salesVolume = e.guideSalesVolume;
        //     count = e.guideCount;
        //   }

        //   return _buildTableRow(
        //     date: e.day,
        //     volume: salesVolume,
        //     count: count,
        //     benefit: amount,
        //   );
        // }).toList(),
      ],
    ).material(color: Colors.white).pSymmetric(v: 10.rw);
  }
}
