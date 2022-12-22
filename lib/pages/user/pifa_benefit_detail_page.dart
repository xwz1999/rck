import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/user/functions/user_benefit_func.dart';
import 'package:recook/pages/user/pifa_benefit_page.dart';
import 'package:recook/widgets/bottom_time_picker.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';

import 'model/pifa_benefit_model.dart';

class PifaBenefitDetailPage extends StatefulWidget {
  final PifaBenefit? type;
  final String? shopName;
  final int? shopId;
  final bool? isDetail;

  PifaBenefitDetailPage({
    Key? key,
    required this.type,
    this.shopName,
    this.shopId,
    this.isDetail,
  }) : super(key: key);

  @override
  _PifaBenefitDetailPageState createState() => _PifaBenefitDetailPageState();
}

class _PifaBenefitDetailPageState extends State<PifaBenefitDetailPage> {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);
  String _title = '';

  String _all = '0.00';
  PifaBenefit? _type;
  bool _selfChoose = true; //选择自营补贴
  bool _guideChoose = false;

  String _notAmount = '0.00';

  ///未到账收益

  String _amount = '0.00';

  ///到账收益

  ///累计收益
  ///
  // UserAccumulateModel _model = UserAccumulateModel.zero();
  DateTime _date = DateTime.now();
  String formatType = 'yyyy-MM'; //时间选择器按钮样式

  PifaBenefitModel? _models; //自购导购未到已到收益

  bool isSelfAndGuide = false;

  ///是否是自购分享收益

  @override
  void initState() {
    super.initState();
    _type = widget.type;
    if (widget.type == PifaBenefit.piFa) {
      _title = '批发收益';
      formatType = 'yyyy';
    } else if (widget.type == PifaBenefit.dianPu) {
      _title = '店铺收益';
      formatType = 'yyyy-MM';
    } else if (widget.type == PifaBenefit.self) {
      _title = '自购分享收益';
      isSelfAndGuide = true;
      formatType = 'yyyy-MM';
    } else if (widget.type == PifaBenefit.guide) {
      _title = '自购分享收益';
      isSelfAndGuide = true;
      formatType = 'yyyy-MM';
    }
  }

  ///选择自购
  _chooseSelf() {
    String selfText = '自购收益';
    return CustomImageButton(
      onPressed: () {
        _guideChoose = false;
        _selfChoose = true;
        _type = PifaBenefit.self;
        _refreshController.requestRefresh();
        setState(() {});
      },
      child: Text(selfText,
          style: TextStyle(
              fontSize: 14.rsp,
              color: getColor(_selfChoose),
              fontWeight: getWeight(_selfChoose))),
    ).expand();
  }

  ///选择分享
  _chooseGuide() {
    String guideText = '分享收益';
    return CustomImageButton(
      onPressed: () {
        _guideChoose = true;
        _selfChoose = false;
        _type = PifaBenefit.guide;
        _refreshController.requestRefresh();
        setState(() {});
      },
      child: Text(guideText,
          style: TextStyle(
              fontSize: 14.rsp,
              color: getColor(_guideChoose),
              fontWeight: getWeight(_guideChoose))),
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
      {List<BottomTimePickerType>? timePickerTypes,
      Function(DateTime, BottomTimePickerType)? submit}) {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: 350 + MediaQuery.of(context).padding.bottom,
            child: BottomTimePicker(
              yearChoose: false,
              timePickerTypes: timePickerTypes,
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

  Widget _buildTag(String text,String amount) {

    return Row(
      children: [
        Text(
          text ,
          style: TextStyle(color: Color(0xFF999999), fontSize: 14.rsp),
          textAlign: TextAlign.center,
        ),
        Column(
          children: [
            5.hb,
            Text(
              amount ,
              style: TextStyle(color: Color(0xFFD5101A), fontSize: 14.rsp),
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
  //
  // Widget _buildTag() {
  //   String text = '本年收益：';
  //
  //   return Row(
  //     children: [
  //       Text(
  //         text ?? '',
  //         style: TextStyle(color: Color(0xFF999999), fontSize: 14.rsp),
  //         textAlign: TextAlign.center,
  //       ),
  //       Column(
  //         children: [
  //           5.hb,
  //           Text(
  //             _all ?? '0.00',
  //             style: TextStyle(color: Color(0xFFD5101A), fontSize: 14.rsp),
  //             textAlign: TextAlign.center,
  //           )
  //         ],
  //       ),
  //       20.wb
  //     ],
  //   );
  //   // return '当月收益(瑞币)：${benefitValue.toStringAsFixed(2)}'
  //   //     .text
  //   //     .color(Color(0xFF999999))
  //   //     .size(16.rsp)
  //   //     .make();
  // }

  Widget _buildCard() {
    String cumulativeText = '';
    if(_type==PifaBenefit.piFa){
      cumulativeText = '从VIP店铺${widget.shopName}获取收益';
    }else if(_type ==PifaBenefit.dianPu){
      cumulativeText = '本月店铺收益';
    }else if(_type ==PifaBenefit.self){
      cumulativeText = '本月自购收益';
    }else if(_type ==PifaBenefit.guide){
      cumulativeText = '本月分享收益';
    }


    return Container(
      margin:
          EdgeInsets.only(left: 30.rw, right: 30.rw, top: 20.rw, bottom: 20.rw),
      clipBehavior: Clip.antiAlias,
      height: isSelfAndGuide?146.rw :96.rw,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5.rw),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.rw),
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(R.ASSETS_BENEFIT_BG_PNG),
                ),
                color: Colors.transparent),
            padding: EdgeInsets.only(
                top: 20.rw, bottom: 10.rw, left: 20.rw, right: 20.rw),
            child: Row(
              children: [
                Container(
                  padding:EdgeInsets.only(top: 0.rw),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cumulativeText.text.color(Color(0xFF3A3943)).make(),
                      8.hb,
                      (_all).text.color(Color(0xFFD5101A)).size(28.rsp).make(),
                    ],
                  ),
                ).expand(),
              ],
            ),
          ).expand(),
          isSelfAndGuide
              ? Container(
                  height: 50.rw,
            color: Colors.white,
            margin: EdgeInsets.only(left: 5.rw,right: 5.rw),
                  child: Row(
                    children: [
                      _chooseSelf(),
                      _renderDivider(),
                      _chooseGuide(),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        appBackground: Color(0xFFF6F6F6),
        leading: RecookBackButton(white: false),
        elevation: 0,
        title: Text(
          _title,
          style: TextStyle(
            fontSize: 18.rsp,
            color: Color(0xFF070707),
          ),
        ),
      ),
      body: RefreshWidget(
        controller: _refreshController,
        onRefresh: () async {

          if(_type == PifaBenefit.piFa){
            _models = await UserBenefitFunc.getPifaBenefitDetail(
                widget.shopId, DateUtil.formatDate(_date, format: 'yyyy'));
          }else if(_type == PifaBenefit.dianPu){
            _models = await UserBenefitFunc.getBenefit(5,date: DateUtil.formatDate(_date, format: 'yyyyMM'));
          }else if(_type == PifaBenefit.self){
            _models = await UserBenefitFunc.getBenefit(6,date: DateUtil.formatDate(_date, format: 'yyyyMM'));
          }else if(_type == PifaBenefit.guide){
            _models = await UserBenefitFunc.getBenefit(8,date: DateUtil.formatDate(_date, format: 'yyyyMM'));
          }
          if (_models != null) {
            _all = _models!.all!.toStringAsFixed(2);
            _notAmount = _models!.weiDaoZ!.toStringAsFixed(2);
            _amount = _models!.yiDaoZ!.toStringAsFixed(2);
          }

          setState(() {});
          _refreshController.refreshCompleted();
        },
        body: Column(
          children: [
            20.hb,
            _type== PifaBenefit.piFa?SizedBox(): Row(
              children: [
                20.wb,
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
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Spacer(),
              ],
            ),
            _buildCard(),

            _type != PifaBenefit.piFa?Row(
              children: [
                30.wb,
                _buildTag('累计未到账：',_notAmount),
                Spacer(),
                _buildTag('累计已到账：',_amount),
                15.wb,
              ],
            ):
            Row(
              children: [
                28.wb,
                Column(
                  children: [
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
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )
                  ],
                ),
                Spacer(),
                _buildTag('本年收益：',_all),
                15.wb,
              ],
            ),
            20.hb,
            //_notSelfNotGUide ? _buildMidCard() : SizedBox(),
            SizedBox(
              height: 45.rw,
              child: _type==PifaBenefit.piFa? _buildTableTitle1():_buildTitle1(),
            ),
            Expanded(
                child: Container(
              child: _models == null ? SizedBox() : _buildTableList(),
            ))
          ],
        ),
      ),
    );
  }
  _buildTitle1() {
    return Row(
      children: [
        Container(
          height: 88.w,
          width: 200.w,
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
          width: 220.w,
          color: Colors.white,
          child: Text(
            '未到账收益',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
              fontSize: 16.rsp,
            ),
          ).centered(),
        ),
        Container(
          height: 88.w,
          width: 220.w,
          color: Colors.white,
          child: Text(
            '已到账收益',
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
  _buildTable(Entry detail, int num) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => PifaBenefitDetailPage(
              type: _type,
              shopId: detail.shopId,
              shopName: detail.name,
            ));
          },
          child: Row(
            children: [
              Container(
                height: 88.w,
                width: 200.w,
                color: Colors.white,
                child: Text(
                  detail.name!,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                    fontSize: 16.rsp,
                  ),
                ).centered(),
              ),
              Container(
                height: 45.rw,
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
                width: 220.w,
                color: Colors.white,
                child: Text(
                  detail.notIncome!.toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                    fontSize: 16.rsp,
                  ),
                ).centered(),
              ),
              Container(
                height: 88.w,
                width: 220.w,
                color: Colors.white,
                child: Text(
                  detail.income!.toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xffD5101A),
                    fontSize: 16.rsp,
                  ),
                ).centered(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildTableList() {
    return _models!.entry == null
        ? SizedBox()
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: _models!.entry!.length,
            itemBuilder: (context, i) {
              PifaBenefitModel? userIncomeModel = _models;
              return _type == PifaBenefit.piFa
                  ? _buildTableBody(userIncomeModel!.entry![i], i)
                  : _buildTable(userIncomeModel!.entry![i], i);
            },
          );
  }

  _buildTableTitle1() {
    String tableText = '收益';

    return Row(
      children: [
        Container(
          height: 88.w,
          width: 190.w,
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
          width: 205.w,
          color: Colors.white,
          child: Text(
            '批发额',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
              fontSize: 16.rsp,
            ),
          ).centered(),
        ),
        Container(
          height: 88.w,
          width: 115.w,
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
          width: 240.w,
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

  _buildTableBody(Entry detail, int num) {
    // String _time = detail.date.toString() + '000'; //dart语言时间戳要求13位

    return Row(
      children: [
        Container(
          height: 88.w,
          width: 190.w,
          color: Colors.white,
          child: Text(
            detail.name!,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
              fontSize: 16.rsp,
            ),
          ).centered(),
        ),
        Container(
          height: 45.rw,
          width: 205.w,
          color: Colors.white,
          child: Text(
            detail.amount!.toStringAsFixed(2),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
              fontSize: 16.rsp,
            ),
          ).centered(),
        ),
        Container(
          height: 88.w,
          width: 115.w,
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
          width: 240.w,
          color: Colors.white,
          child: Text(
            (detail.income! + detail.notIncome!).toStringAsFixed(2),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xffD5101A),
              fontSize: 16.rsp,
            ),
          ).centered(),
        ),
        // Container(
        //   height: 88.w,
        //   width: 280.w,
        //   color: Colors.white,
        //   alignment: Alignment.center,
        //   padding: EdgeInsets.only(left: 60.w),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Expanded(
        //         child: Text(
        //           detail.income.toStringAsFixed(2),
        //           style: TextStyle(
        //             fontWeight: FontWeight.w400,
        //             color: Color(0xffD5101A),
        //             fontSize: 16.rsp,
        //           ),
        //         ).centered(),
        //       ),
        //     ],
        //   ),
        // )
      ],
    );
  }
}
