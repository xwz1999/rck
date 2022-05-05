
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/user/functions/user_benefit_func.dart';
import 'package:recook/pages/user/model/pifa_benefit_model.dart';
import 'package:recook/pages/user/model/user_accumulate_model.dart';
import 'package:recook/pages/user/pifa_benefit_detail_page.dart';
import 'package:recook/widgets/bottom_time_picker.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';

enum PifaBenefit {
  ///批发收益
  piFa,

  ///店铺收益
  dianPu,

  ///自购收益
  self,

  ///分享
  guide,
}

class PifaBenefitPage extends StatefulWidget {
  final String type;
  final String shopName;
  final int shopId;
  final bool isDetail;

  PifaBenefitPage({
    Key key,
    @required this.type,
    this.shopName,
    this.shopId,
    this.isDetail,
  }) : super(key: key);

  @override
  _PifaBenefitPageState createState() => _PifaBenefitPageState();
}

class _PifaBenefitPageState extends State<PifaBenefitPage> {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);

  String _title = '';

  ///是自购和导购

  String _all = '0.00';

  String _notAmount = '0.00';

  ///未到账收益

  String _amount = '0.00';

  ///到账收益

  bool _selfChoose = true; //选择自营补贴
  bool _guideChoose = false;

  ///累计收益
  ///
  UserAccumulateModel _model = UserAccumulateModel.zero();
  DateTime _date = DateTime.now();
  String formatType = 'yyyy-MM'; //时间选择器按钮样式
  String TableformatType = 'M月d日'; //时间样式

  PifaBenefitModel _models; //自购导购未到已到收益
  PifaBenefit _type;
  bool isSelfAndGuide = false;

  ///是否是自购分享收益

  @override
  void initState() {
    super.initState();
    _title = widget.type;
    if (widget.type == '批发收益') {
      _type = PifaBenefit.piFa;
    } else if (widget.type == '品牌补贴') {
      _type = PifaBenefit.dianPu;
    } else if (widget.type == '分享收益') {
      // isSelfAndGuide = false;
      _type = PifaBenefit.self;

      ///默认为自购收益
    }
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

  Widget _buildTag(String text, String amount) {
    return Row(
      children: [
        Text(
          text ?? '',
          style: TextStyle(color: Color(0xFF999999), fontSize: 14.rsp),
          textAlign: TextAlign.center,
        ),
        Column(
          children: [
            5.hb,
            Text(
              amount ?? '0.00',
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

  Widget _buildCard() {
    String CumulativeText = '累计$_title';

    return Container(
      margin:
          EdgeInsets.only(left: 30.rw, right: 30.rw, top: 20.rw, bottom: 20.rw),
      clipBehavior: Clip.antiAlias,
      height: isSelfAndGuide ? 146.rw : 96.rw,
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
                  padding: EdgeInsets.only(top: 0.rw),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CumulativeText.text.color(Color(0xFF3A3943)).make(),
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
                  margin: EdgeInsets.only(left: 5.rw, right: 5.rw),
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
          if (_type == PifaBenefit.piFa) {
            _models = await UserBenefitFunc.getPifaBenefit();
          } else if (_type == PifaBenefit.dianPu) {
            _models = await UserBenefitFunc.getBenefit(5);
          } else if (_type == PifaBenefit.self) {
            _models = await UserBenefitFunc.getBenefit(6);
          }
          if (_models != null) {
            _all = _models.all.toStringAsFixed(2);
            _notAmount = _models.weiDaoZ.toStringAsFixed(2);
            _amount = _models.yiDaoZ.toStringAsFixed(2);
          }

          setState(() {});
          _refreshController.refreshCompleted();
        },
        body: Column(
          children: [
            _buildCard(),
            _type != PifaBenefit.piFa
                ? Row(
                    children: [
                      30.wb,
                      _buildTag('累计未到账：', _notAmount),
                      Spacer(),
                      _buildTag('累计已到账：', _amount),
                      15.wb,
                    ],
                  )
                : SizedBox(),
            20.hb,
            //_notSelfNotGUide ? _buildMidCard() : SizedBox(),
            SizedBox(
              height: 45.rw,
              child: _type == PifaBenefit.piFa
                  ? _buildTableTitle1()
                  : _buildTitle1(),
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
    return _models.entry == null
        ? SizedBox()
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: _models.entry.length,
            itemBuilder: (context, i) {
              PifaBenefitModel userIncomeModel = _models;
              return _type == PifaBenefit.piFa
                  ? _buildTableBody(userIncomeModel.entry[i], i)
                  : _buildTable(userIncomeModel.entry[i], i);
            },
          );
  }

  _buildTableTitle1() {
    String tableText = '收益';
    return Row(
      children: [
        Container(
          height: 88.w,
          width: 200.w,
          color: Colors.white,
          child: Text(
            _type == PifaBenefit.piFa ? '实体店铺' : '日期',
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
          width: 260.w,
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

  _buildTableBody(Entry detail, int num) {
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
                  detail.name,
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
                  detail.amount.toStringAsFixed(2),
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
                width: 260.w,
                color: Colors.white,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 60.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        (detail.income + detail.notIncome).toStringAsFixed(2),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xffD5101A),
                          fontSize: 16.rsp,
                        ),
                      ).centered(),
                    ),
                    Icon(Icons.keyboard_arrow_right,
                        size: 22, color: Color(0xff999999)),
                    20.wb
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
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
                  detail.name,
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
                  detail.notIncome.toStringAsFixed(2),
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
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 60.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        detail.income.toStringAsFixed(2),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xffD5101A),
                          fontSize: 16.rsp,
                        ),
                      ).centered(),
                    ),
                    Icon(Icons.keyboard_arrow_right,
                        size: 22, color: Color(0xff999999)),
                    20.wb
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
