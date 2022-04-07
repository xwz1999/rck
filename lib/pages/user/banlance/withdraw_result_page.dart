import 'dart:math';
import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/gen/assets.gen.dart';
import 'package:jingyaoyun/models/withdraw_historyc_model.dart';
import 'package:jingyaoyun/pages/user/functions/user_balance_func.dart';
import 'package:jingyaoyun/pages/user/model/company_info_model.dart';
import 'package:jingyaoyun/pages/user/model/contact_info_model.dart';

import 'package:jingyaoyun/pages/user/widget/recook_check_box.dart';
import 'package:jingyaoyun/pages/wholesale/func/wholesale_func.dart';
import 'package:jingyaoyun/pages/wholesale/models/wholesale_customer_model.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_customer_page.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/utils/amount_format.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:jingyaoyun/constants/header.dart';

class WithDrawResultPage extends StatefulWidget {
  final History history;

   WithDrawResultPage({
    Key key,
    this.history,
  }) : super(key: key);

  @override
  _WithDrawResultPageState createState() => _WithDrawResultPageState();
}

class _WithDrawResultPageState extends State<WithDrawResultPage>
    with TickerProviderStateMixin {
  CompanyInfoModel model =
      CompanyInfoModel(companyName: '', taxBank: '', taxNumber: '');
  ContactInfoModel _info =
      ContactInfoModel(address: '', email: '', name: '', mobile: '');

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      model = await UserBalanceFunc.getCompanyInfo();
      _info = await UserBalanceFunc.getContractInfo();
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
        backgroundColor: Color(0xFF3A3842),
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          appBackground: Color(0xFF3A3842),
          leading: RecookBackButton(
            white: true,
          ),
          elevation: 0,
          title: Text(
            "申请提现",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.rsp,
            ),
          ),
        ),
        body: _bodyWidget());
  }

  _bodyWidget() {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.rw),
          child: Container(
            padding: EdgeInsets.only(top: 12.rw, bottom: 12.rw),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.rw),
                  topRight: Radius.circular(8.rw)),
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                32.wb,
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icWithdrawalStep1Red.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "开发票",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    20.hb,
                    Image.asset(
                      Assets.icWithdrawalGotoRed.path,
                      width: 15.rw,
                      height: 15.rw,
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icWithdrawalStep2Red.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "申请提现",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    20.hb,
                    Image.asset(
                      Assets.icWithdrawalGotoRed.path,
                      width: 15.rw,
                      height: 15.rw,
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icWithdrawalStep3Red.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "平台审核",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    20.hb,
                    Image.asset(
                      (widget.history.state == 3 || widget.history.state == 99)
                          ? Assets.icWithdrawalGotoRed.path
                          : Assets.icWithdrawalGoto.path,
                      width: 15.rw,
                      height: 15.rw,
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      widget.history.state == 3
                          ? Assets.icWithdrawalStep5Success.path
                          : widget.history.state == 99
                              ? Assets.icWithdrawalStep4Fail.path
                              : Assets.icWithdrawalStep4.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      widget.history.state == 99 ? '审核驳回' : "打款到账",
                      style: TextStyle(
                        color: (widget.history.state == 3 ||
                                widget.history.state == 99)
                            ? Color(0xFF333333)
                            : Color(0xFFCDCDCD),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                32.wb,
              ],
            ),
          ),
        ),
        Container(
          child: Stack(
            children: [
              ClipRect(
                child: BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: new Container(
                    color: Colors.white.withOpacity(0.1),
                    width: double.infinity,
                    height: 56.rw,
                  ),
                ),
              ),
              Container(
                height: 56.rw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    32.wb,
                    Text(
                      "如有疑问，点击联系客服",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.rsp,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        WholesaleCustomerModel model =
                            await WholesaleFunc.getCustomerInfo();

                        Get.to(() => WholesaleCustomerPage(
                              model: model,
                            ));
                      },
                      child: Container(
                        height: 32.rw,
                        width: 32.rw,
                        padding: EdgeInsets.all(7.rw),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.rw)),
                        child: Image.asset(
                          Assets.icKefu.path,
                          width: 18.rw,
                          height: 18.rw,
                        ),
                      ),
                    ),
                    32.wb,
                  ],
                ),
              ),
            ],
          ),
        ),
        20.hb,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.rw),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.rw)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.hb,
                Padding(
                  padding: EdgeInsets.only(left: 16.rw, right: 16.rw),
                  child: _textItem('提现金额',
                      '¥' + TextUtils.getCount1((widget.history.amount ?? 0.0)),
                      isRed: true),
                ),
                35.hb,
                Padding(
                  padding: EdgeInsets.only(left: 16.rw, right: 16.rw),
                  child: _textItem(
                    '申请时间',
                    widget.history.createdAt==null?'': "${DateUtil.formatDate(DateTime.parse("${widget.history.createdAt.substring(0, 19)}"), format: 'yyyy-MM-dd HH:mm')}",
                  ),
                ),
                35.hb,
                Padding(
                  padding: EdgeInsets.only(left: 16.rw, right: 16.rw),
                  child: _textItem(
                      '开票方式', widget.history.tax == 1 ? '电子发票' : '纸质发票'),
                ),
                35.hb,
                Padding(
                  padding: EdgeInsets.only(
                    left: 16.rw,
                    right: 16.rw,
                    bottom: 35.w,
                  ),
                  child: widget.history.tax == 1
                      ? _textItem('邮箱地址', _info.email)
                      : _textItem('快递公司', widget.history.logisticsName),
                ),
                widget.history.tax == 1
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(
                            left: 16.rw, right: 16.rw, bottom: 35.w),
                        child: _textItem('快递单号', widget.history.waybillCode),
                      ),
                (widget.history.state == 3 || widget.history.state == 99)
                    ? Padding(
                        padding: EdgeInsets.only(
                            left: 16.rw, right: 16.rw, bottom: 35.w),
                        child: _textItem('申请时间',widget.history.createdAt==null?'': "${DateUtil.formatDate(DateTime.parse("${widget.history.createdAt.substring(0, 19)}"), format: 'yyyy-MM-dd HH:mm')}", ),
                      )
                    : SizedBox(),
                (widget.history.state == 3 || widget.history.state == 99)
                    ? Padding(
                  padding: EdgeInsets.only(
                      left: 16.rw, right: 16.rw, bottom: 35.w),
                  child: _textItem('审核时间',widget.history.processTime==null?'': "${DateUtil.formatDate(DateTime.parse("${(widget.history.processTime).substring(0, 19)}"), format: 'yyyy-MM-dd HH:mm')}",),
                )
                    : SizedBox(),
                ( widget.history.state == 99)
                    ? Padding(
                  padding: EdgeInsets.only(
                      left: 16.rw, right: 16.rw, bottom: 35.w),
                  child: _textItem('驳回原因', widget.history.proof),
                )
                    : SizedBox(),
              ],
            ),
          ),
        ),
        44.hb,
        model == null
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.rw),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "收款账户信息",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.rsp,
                            fontWeight: FontWeight.bold),
                      ),
                      40.hb,
                      _textItem1(
                        '账户名',
                        model.companyName,
                      ),
                      30.hb,
                      _textItem1('开户银行', model.taxBank),
                      30.hb,
                      _textItem1('银行账户', model.taxNumber),
                      30.hb,
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  _textItem(String title, String content, {bool isRed = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60.rw,
          child: Text(
            title,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 14.rsp,
            ),
          ),
        ),
        16.wb,
        Expanded(
          child: Text(
            content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              height: 1.4,
              color: isRed ? Color(0xFFD5101A) : Color(0xFF333333),
              fontSize: 14.rsp,
            ),
          ),
        ),
      ],
    );
  }

  _textItem1(
    String title,
    String content,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60.rw,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.rsp,
            ),
          ),
        ),
        16.wb,
        Expanded(
          child: Text(
            content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.rsp,
            ),
          ),
        ),
      ],
    );
  }
}
