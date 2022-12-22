import 'dart:ui';
import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/login/login_page.dart';
import 'package:recook/pages/user/banlance/withdraw_page_third.dart';
import 'package:recook/pages/user/functions/user_balance_func.dart';
import 'package:recook/pages/user/model/withdraw_amount_model.dart';
import 'package:recook/pages/user/widget/recook_check_box.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/toast.dart';

class WithDrawPageSecond extends StatefulWidget {
  final WithdrawAmountModel? amount;
  WithDrawPageSecond({
    Key? key, required this.amount,
  }) : super(key: key);

  @override
  _WithDrawPageSecondState createState() => _WithDrawPageSecondState();
}

class _WithDrawPageSecondState extends State<WithDrawPageSecond>
    with TickerProviderStateMixin {

  TextEditingController? _companyTextEditController;
  FocusNode _companyContentFocusNode = FocusNode();

  TextEditingController? _numberTextEditController;
  FocusNode _numberContentFocusNode = FocusNode();
  bool isElectronics = true;
  bool isPaper = false;

  String logistics = '';

  String logisticsNumber = '';

  @override
  void initState() {
    super.initState();

    _companyTextEditController = TextEditingController();
    _numberTextEditController = TextEditingController();
  }

  @override
  void dispose() {

    _companyTextEditController?.dispose();
    _numberTextEditController?.dispose();
    _companyContentFocusNode.dispose();
    _numberContentFocusNode.dispose();
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
                      Assets.icWithdrawalGoto.path,
                      width: 15.rw,
                      height: 15.rw,
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icWithdrawalStep3.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "平台审核",
                      style: TextStyle(
                        color: Color(0xFFCDCDCD),
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
                      Assets.icWithdrawalGoto.path,
                      width: 15.rw,
                      height: 15.rw,
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icWithdrawalStep4.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "打款到账",
                      style: TextStyle(
                        color: Color(0xFFCDCDCD),
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
                      onTap: () async{
                        // WholesaleCustomerModel? model =
                        // await WholesaleFunc.getCustomerInfo();
                        //
                        // Get.to(() => WholesaleCustomerPage(
                        //   model: model,
                        // ));
                        if (UserManager.instance!.user.info!.id == 0) {
                          Get.offAll(() => LoginPage());
                          Toast.showError('请先登录...');
                          return;
                        }
                        BytedeskKefu.startWorkGroupChat(context, AppConfig.WORK_GROUP_WID, "客服");
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
            height: 72.rw,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.rw)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.hb,
                      Padding(
                        padding: EdgeInsets.only(left: 16.rw),
                        child: Text(
                          '结算金额',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 14.rsp,
                          ),
                        ),
                      ),
                      10.hb,
                      Padding(
                        padding: EdgeInsets.only(left: 16.rw),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "¥",
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 18.rsp,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              TextUtils.getCount1(
                                  (widget.amount!.balance ?? 0.0))!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 18.rsp,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 40.rw,
                  width: 1.rw,

                  decoration: BoxDecoration(
                    gradient:LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[ Color(0x00EEEEEE),Color(0xFFE8E8E8), Color(0x00D8D8D8),],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.hb,
                      Padding(
                        padding: EdgeInsets.only(left: 16.rw),
                        child: Text(
                          "到账金额",
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 14.rsp,
                          ),
                        ),
                      ),
                      10.hb,
                      Padding(
                        padding: EdgeInsets.only(left: 16.rw),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "¥",
                              style: TextStyle(
                                  color: Color(0xFFD5101A),
                                  fontSize: 18.rsp,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              TextUtils.getCount1(
                                  (widget.amount!.actualAmount?? 0.0))!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(

                                  color: Color(0xFFD5101A),
                                  fontSize: 18.rsp,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        44.hb,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.rw),
          child: Container(
            width: double.infinity,
            height:isElectronics?46.rw: 120.rw,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.rw)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                22.hb,
                Padding(
                  padding: EdgeInsets.only(left: 16.rw),
                  child: Row(
                    children: [
                      Text(
                        "开票方式",
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14.rsp,
                        ),
                      ),
                      48.wb,
                      GestureDetector(
                        onTap: () {
                          isElectronics = !isElectronics;
                          isPaper = false;
                          setState(() {});
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              RecookCheckBox(
                                state: isElectronics,
                              ),
                              16.wb,
                              Text(
                                "电子发票",
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 14.rsp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      40.wb,
                      GestureDetector(
                        onTap: () {
                          isPaper = !isPaper;
                          isElectronics = false;
                          setState(() {});
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              RecookCheckBox(
                                state: isPaper,
                              ),
                              16.wb,
                              Text(
                                "纸质发票",
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 14.rsp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                isElectronics
                    ? Spacer()
                    : SizedBox(
                        height: 5.rw,
                      ),
                isElectronics
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(left: 16.rw, right: 16.rw),
                        child: Column(
                          children: [
                            Container(
                              height: 38.rw,
                              child: Row(
                                children: [
                                  Text(
                                    "快递公司",
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 14.rsp,
                                    ),
                                  ),
                                  40.wb,
                                  Expanded(
                                    child: CupertinoTextField(
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              signed: true),

                                      controller: _companyTextEditController,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_submitted) {
                                        _companyContentFocusNode.unfocus();
                                        setState(() {});
                                      },
                                      focusNode: _companyContentFocusNode,
                                      onChanged: (text) {
                                        setState(() {});
                                        logistics = text;
                                      },
                                      placeholder: '请输入快递公司',
                                      placeholderStyle: TextStyle(
                                          color: Color(0xffcccccc),
                                          fontSize: 14.rsp,
                                          height: 1.2,
                                          fontWeight: FontWeight.w300,
                                          textBaseline:
                                              TextBaseline.alphabetic),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(0)),
                                      style: TextStyle(
                                          color: Color(0xff333333),
                                          fontSize: 14.rsp,

                                          textBaseline:
                                              TextBaseline.alphabetic),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 38.rw,
                              child: Row(
                                children: [
                                  Text(
                                    "快递单号",
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 14.rsp,
                                    ),
                                  ),
                                  40.wb,
                                  Expanded(
                                    child: CupertinoTextField(
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              signed: true),

                                      controller: _numberTextEditController,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_submitted) {
                                        _numberContentFocusNode.unfocus();
                                        setState(() {});
                                      },
                                      focusNode: _numberContentFocusNode,
                                      onChanged: (text) {
                                        setState(() {});
                                        logisticsNumber = text;
                                      },
                                      placeholder: '请输入快递单号',
                                      placeholderStyle: TextStyle(
                                          color: Color(0xffcccccc),
                                          fontSize: 14.rsp,
                                          height: 1.2,
                                          fontWeight: FontWeight.w300),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(0)),
                                      style: TextStyle(
                                          color: Color(0xff333333),
                                          fontSize: 14.rsp,

                                          textBaseline:
                                              TextBaseline.ideographic),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
        ),
        72.hb,
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.rw,
          ),
          child: GestureDetector(
            onTap: () async {

              if(widget.amount!.balance!<=0){
                ReToast.err(text: '余额不足，无法提现');
              }
              else{
                bool apply = await UserBalanceFunc.applyWithdrawal(
                    UserManager.instance!.userBrief!.balance, isElectronics ? 1 : 2,
                    logisticsName: logistics, waybillCode: logisticsNumber);

                if (apply) {
                  ReToast.success(text: '提交成功');
                  Get.back();
                  Get.back();
                  Get.to(()=>WithDrawPageThird(amount: '¥'+ TextUtils.getCount1(
                      (widget.amount!.balance ?? 0.0))!,actualAmount: '¥'+ TextUtils.getCount1(
                      (widget.amount!.actualAmount ?? 0.0))!, type: isElectronics?'电子发票':'纸质发票', time: DateUtil.formatDate(DateTime.now(), format: 'yyyy-MM-dd HH:mm:ss'),
                    logistics: logistics,
                    logisticsNumber: logisticsNumber,

                  ));

                } else {
                  ReToast.success(text: '提交失败');
                }
              }

              //
              //
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 36.rw,
              decoration: BoxDecoration(
                  color: Color(0xFFD5101A),
                  borderRadius: BorderRadius.circular(18.rw)),
              child: Text(
                '提 交 申 请',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.rsp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // _textItem(String title, String content, {bool show = false}) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SizedBox(
  //         width: 60.rw,
  //         child: Text(
  //           title,
  //           style: TextStyle(
  //             color: Color(0xFF999999),
  //             fontSize: 14.rsp,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //       16.wb,
  //       Expanded(
  //         child: Text(
  //           content,
  //           maxLines: 3,
  //           overflow: TextOverflow.ellipsis,
  //           style: TextStyle(
  //             color: Color(0xFF333333),
  //             fontSize: 14.rsp,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //       show
  //           ? GestureDetector(
  //               onTap: () {
  //                 ClipboardData data = new ClipboardData(text: content);
  //                 Clipboard.setData(data);
  //                 ReToast.success(text: '复制成功');
  //               },
  //               child: Image.asset(
  //                 Assets.icWithdrawalCopy.path,
  //                 width: 16.rw,
  //                 height: 16.rw,
  //               ),
  //             )
  //           : SizedBox(),
  //     ],
  //   );
  // }
}
