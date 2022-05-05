import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/pages/user/withdraw_rule_page.dart';


import 'package:jingyaoyun/utils/storage/hive_store.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/keyboard/bottom_keyboard_widget.dart';

import 'package:jingyaoyun/widgets/webView.dart';

import 'model/withdraw_amount_model.dart';

class UserCashWithdrawPage extends StatefulWidget {
  final Map arguments;

  const UserCashWithdrawPage({Key key, this.arguments}) : super(key: key);

  static setArguments({num amount = 0}) {
    return {
      'amount': amount,
    };
  }

  @override
  _UserCashWithdrawPageState createState() => _UserCashWithdrawPageState();
}

class _UserCashWithdrawPageState extends BaseStoreState<UserCashWithdrawPage> {
  //
  TextEditingController _amountTextEditController;
  FocusNode _amountContentFocusNode = FocusNode();

  ///支付宝账号
  TextEditingController _accountTextEditController;
  TextEditingController _bankAccountTextEditController;
  FocusNode _accountFocusNodeController = FocusNode();
  BottomKeyBoardController _bottomKeyBoardController =
      BottomKeyBoardController();
  bool _isCashToAlipay = true;
  bool _isAgreeTheProtocol = false;
  bool _isNeedUserVerify = true;
  WithdrawAmountModel _model;
  // 是否需要实名认证
  @override
  void initState() {
    super.initState();
    _isNeedUserVerify = !UserManager.instance.user.info.realInfoStatus;
    _amountTextEditController = TextEditingController();
    String lastAlipayAccount = HiveStore.appBox.get('last_alipay') ?? '';
    String lastBankAccount = HiveStore.appBox.get('last_bank_ccount') ?? '';
    _accountTextEditController = TextEditingController(text: lastAlipayAccount);
    _bankAccountTextEditController =
        TextEditingController(text: lastBankAccount);


    getAllAmount();
  }

  /// 获取税费
  Future<WithdrawAmountModel> getAllAmount(
      ) async {
    ///channel 1 购物车购买 0直接购买
    ResultData res = await HttpManager.post(APIV2.userAPI.allAmount, {
    });

    WithdrawAmountModel model;


    if(res.data!=null){
      // if(res.data['code']=='FAIL'){
      //   ReToast.err(text: res.data['msg']);
      // }

      if(res.data['data']!=null){
        _model = WithdrawAmountModel.fromJson(res.data['data']);

      }else
        _model = null;
    }else
      _model = null;


    setState(() {

    });
    return model;
  }


  @override
  void dispose() {
    _amountTextEditController?.dispose();
    _accountTextEditController?.dispose();
    _bankAccountTextEditController?.dispose();
    super.dispose();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        // actions: <Widget>[
        //   CustomImageButton(
        //     padding: EdgeInsets.only(right: 16),
        //     title: "提现记录",
        //     color: Colors.black,
        //     fontSize: 15,
        //     onPressed: () {
        //       AppRouter.push(context, RouteName.CASH_WITHDRAW_HISTORY_PAGE);
        //     },
        //   )
        // ],
        themeData: AppThemes.themeDataGrey.appBarTheme,
        elevation: 0,
        title: "提现",
        background: Colors.white,
        appBackground: Colors.white,
      ),
      body: Listener(
        onPointerDown: (event) {
          _accountFocusNodeController.unfocus();
          _amountContentFocusNode.unfocus();
        },
        child: Container(
          color: Colors.white,
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              _isNeedUserVerify ? _verifyWidget() : Container(),
              Container(
                height: 1.rw,
                color: Color(0xFFE9E9E9),
              ),
              _contentWidget()
              // IgnorePointer(
              //   ignoring: _isNeedUserVerify,
              //   child: !_isNeedUserVerify ? _contentWidget() :
              //   ColorFiltered(
              //     colorFilter: ColorFilter.mode(Colors.grey, BlendMode.color),
              //     child: _contentWidget(),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  _verifyWidget() {
    Color goldColor = Color(0xffe9a213);
    return GestureDetector(
      onTap: () {
        AppRouter.pushAndReplaced(
          context,
          RouteName.USER_VERIFY,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: Color(0xfffff5e1),
        width: double.infinity,
        height: 30,
        child: Row(
          children: <Widget>[
            Image.asset(
              "assets/laba_gold.png",
              width: 17,
              height: 15,
            ),
            Container(
              width: 13,
            ),
            Text(
              '请先做实名认证再提现',
              style: TextStyle(color: goldColor, fontSize: 13),
            ),
            Spacer(),
            Text(
              '去认证',
              style: TextStyle(color: goldColor, fontSize: 13),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 20,
              color: goldColor,
            ),
          ],
        ),
      ),
    );
  }

  _contentWidget() {
    return Container(
      width: double.infinity,
      color: Colors.white,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          20.hb,
          _amountWidget(),
          20.hb,
          Container(
            height: 1.rw,
            color: Color(0xFFE9E9E9),
          ),
          _alipayOrCardWidget(),
          Container(
            height: 1.rw,
            color: Color(0xFFE9E9E9),
          ),
          _withdrawAlertWidget(),
          _bottomWidget(),
        ],
      ),
    );
  }

   _amountWidget() {
    double amount = widget.arguments['amount'];
    Container con = Container(
      padding: EdgeInsets.symmetric(horizontal: 17),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Row(
            children: [
              Text(
                "提现金额(元)",
                style: TextStyle(color: Color(0xFF333333), fontSize: 14.rsp),
              ),
              Spacer(),
              Text(
                  _model==null?'¥0':   '¥'+ _model.balance.toStringAsFixed(2),
                style: TextStyle(color: Color(0xFF333333), fontSize: 14.rsp,fontWeight: FontWeight.bold),
              ),
            ],
          ),
          12.hb,
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  Get.to(()=>WithdrawRulePage(type: 1,));
                },
                child: Row(
                  children: [
                    Text(
                      "需缴税费金额",
                      style: TextStyle(color: Color(0xFF333333), fontSize: 14.rsp),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(top: 2.rw),
                      child: Icon(
                        Icons.help_outline,
                        size: 12,
                        color: Color(0xff666666),
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(),
              Text(
                _model==null?'¥0':'¥'+_model.taxAmount.toStringAsFixed(2),
                style: TextStyle(color: Color(0xFF333333), fontSize: 14.rsp,fontWeight: FontWeight.bold),
              ),
            ],
          ),
          12.hb,
          Row(
            children: [
              Text(
                "实际提现金额",
                style: TextStyle(color: Color(0xFF333333), fontSize: 14.rsp),
              ),
              Spacer(),
              Text(
                _model==null?'¥0': '¥'+_model.actualAmount.toStringAsFixed(2),
                style: TextStyle(color: Color(0xFF333333), fontSize: 14.rsp,fontWeight: FontWeight.bold),
              ),
            ],
          ),

          // Row(
          //   children: [
          //     Container(
          //       height: 40,
          //       alignment: Alignment.bottomLeft,
          //       child: Row(
          //         children: [
          //           Text(
          //             "提现金额(元)",
          //             style: TextStyle(color: Colors.black, fontSize: 16),
          //           ),
          //
          //           Offstage(
          //             offstage:
          //             !(!TextUtils.isEmpty(_amountTextEditController.text) &&
          //                 double.parse(_amountTextEditController.text) < 10),
          //             child: Text(
          //               "(提现金额至少10元)",
          //               style: TextStyle(
          //                   fontSize: 12 * 2.sp, color: AppColor.themeColor),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          // Expanded(
          //   child: Row(
          //     children: <Widget>[
          //       Text(
          //         "¥",
          //         style: TextStyle(
          //             color: Colors.black,
          //             fontSize: 24.rsp,
          //             fontWeight: FontWeight.w400),
          //       ),
          //       Expanded(
          //         child: CupertinoTextField(
          //           keyboardType: TextInputType.numberWithOptions(signed: true),
          //           inputFormatters: [AmountFormat()],
          //           controller: _amountTextEditController,
          //           textInputAction: TextInputAction.done,
          //           onSubmitted: (_submitted) {
          //             _amountContentFocusNode.unfocus();
          //             setState(() {});
          //           },
          //           focusNode: _amountContentFocusNode,
          //           onChanged: (text) {
          //             setState(() {});
          //           },
          //           placeholder: "本次最多可转出${amount.toStringAsFixed(2)}元",
          //           placeholderStyle: TextStyle(
          //               color: Color(0xffcccccc),
          //               fontSize: 20.rsp,
          //               fontWeight: FontWeight.w300),
          //           decoration: BoxDecoration(color: Colors.white.withAlpha(0)),
          //           style: TextStyle(
          //               color: Colors.black,
          //               textBaseline: TextBaseline.ideographic),
          //         ),
          //       ),
          //       CustomImageButton(
          //         onPressed: () {
          //           _amountTextEditController.text = amount.toStringAsFixed(2);
          //           setState(() {});
          //         },
          //         title: "全部",
          //         style: TextStyle(color: AppColor.themeColor, fontSize: 16),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
    return Container(
      child: con,
    );
  }

  _getTax(String text) {
    if (text.isEmpty) {
      return '';
    } else {
      double price = double.parse(text);
      double tax = price / (1.13) * 0.13 * 1.12;
      return tax.toStringAsFixed(2);
    }
  }

  _getReal(String before, String tax) {
    if (before.isEmpty || tax.isEmpty) {
      return '';
    } else {
      double b = double.parse(before);
      double t = double.parse(tax);
      return (b - t).toStringAsFixed(2);
    }
  }

  _buttonWidget(String title, {isSelect = false, Function click}) {
    return CustomImageButton(
      title: title,
      style:
          TextStyle(color: isSelect ? Colors.black : Colors.grey, fontSize: 16),
      direction: Direction.horizontal,
      contentSpacing: 5,
      icon: Image.asset(
        isSelect
            ? "assets/cash_type_select_yes.png"
            : "assets/cash_type_select_no.png",
        width: 14,
        height: 14,
      ),
      onPressed: click,
    );
  }

  _alipayOrCardWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 60,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _buttonWidget(
                    "提现到支付宝",
                    isSelect: _isCashToAlipay,
                    click: () {
                      _isCashToAlipay = true;
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  height: 13,
                  width: 1.rw,
                  color: Color(0xFFE9E9E9),
                ),
                Expanded(
                  child: _buttonWidget("提现到银行卡", isSelect: !_isCashToAlipay,
                      click: () {
                    _isCashToAlipay = false;
                    setState(() {});
                  }),
                )
              ],
            ),
          ),
          Container(
            height: 1.rw,
            color:Color(0xFFE9E9E9),
          ),
          UserManager.instance.user.info.realInfoStatus &&
                  !TextUtils.isEmpty(UserManager.instance.user.info.realName)
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      Text("姓名：${UserManager.instance.user.info.realName}",
                          style: TextStyle(color: Colors.black, fontSize: 14)),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                            color: Color(0xffFFECE3),
                            borderRadius: BorderRadius.circular(2)),
                        child: Text(
                            _isCashToAlipay ? "只能提现到本人支付宝账户" : "只能提现到本人银行卡账户",
                            style: TextStyle(
                              color: AppColor.themeColor,
                              fontSize: 10,
                            )),
                      ),
                    ],
                  ))
              : Container(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.rw,),
            height: 50.rw,
            child: CupertinoTextField(
              padding: EdgeInsets.all(0),
              keyboardType: TextInputType.text,
              controller: _isCashToAlipay
                  ? _accountTextEditController
                  : _bankAccountTextEditController,
              textInputAction: TextInputAction.done,
              onSubmitted: (_submitted) {
                _accountFocusNodeController.unfocus();
                setState(() {});
              },
              focusNode: _accountFocusNodeController,
              onChanged: (text) {
                setState(() {});
              },
              placeholder:
                  _isCashToAlipay ? "输入支付宝账号(提现仅限本人账号)" : "输入银行卡账号(提现仅限本人账号)",
              placeholderStyle: TextStyle(
                  color: Color(0xffcccccc),
                  fontSize: 14,
                  fontWeight: FontWeight.w300),
              decoration: BoxDecoration(color: Colors.white.withAlpha(0)),
              style: TextStyle(
                  color: Colors.black, textBaseline: TextBaseline.ideographic),
            ),
          ),
        ],
      ),
    );
  }

  _withdrawAlertWidget() {
    return Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        width: double.infinity,
        height: 30,
        padding: EdgeInsets.only(
          left: 18,
        ),
        margin: EdgeInsets.only(bottom: 10),
        child: Container(
          child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (content) {
                      return WithdrawAlertWidget(dismissClick: () {
                        Navigator.pop(context);
                      });
                    });
              },
              child: Row(
                children: [
                  Text(
                    '提现小助手 ',
                    style: TextStyle(color: Color(0xff666666), fontSize: 10),
                  ),
                  Icon(
                    Icons.help_outline,
                    size: 12,
                    color: Color(0xff666666),
                  ),
                ],
              )),
        ));
  }

  _bottomWidget() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.vertical,
        children: <Widget>[
          Text.rich(
            TextSpan(
                style: TextStyle(color: AppColor.greyColor, fontSize: 10),
                children: [
                  TextSpan(text: "申请提现,将在"),
                  TextSpan(
                    text: "每月10号,25号",
                    style: TextStyle(color: Colors.black, fontSize: 10),
                  ),
                  TextSpan(text: "审核,审核成功后，预计3个工作日到账，实际以银行为准"),
                ]),
            maxLines: 2,
          ),
          Container(
            height: 20,
          ),
          CustomImageButton(
            onPressed: !_isAgreeTheProtocol ||
                    TextUtils.isEmpty(_isCashToAlipay
                        ? _accountTextEditController.text
                        : _bankAccountTextEditController.text)||_model==null||_model.actualAmount==-1
                ? null
                : () {
                    if (_isNeedUserVerify) {
                      AppRouter.pushAndReplaced(
                        context,
                        RouteName.USER_VERIFY,
                      );
                      return;
                    }
                    _submitPassword();
                  },
            borderRadius: BorderRadius.circular(3),
            height: 45,
            width: double.infinity,
            title: "申请提现",
            backgroundColor: AppColor.themeColor,
            style: TextStyle(color: Colors.white, fontSize: 17 * 2.sp),
            disableStyle:
                TextStyle(color: Color(0xffbfbfbf), fontSize: 17 * 2.sp),
          ),
          Container(
            height: 10,
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                child: Icon(
                  _isAgreeTheProtocol
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  size: 16,
                  color:
                      _isAgreeTheProtocol ? AppColor.themeColor : Colors.grey,
                ),
                onTap: () {
                  _isAgreeTheProtocol = !_isAgreeTheProtocol;
                  setState(() {});
                },
              ),
              CustomImageButton(
                onPressed: () {
                  _isAgreeTheProtocol = !_isAgreeTheProtocol;
                  setState(() {});
                },
                direction: Direction.horizontal,
                style: TextStyle(color: Colors.grey, fontSize: 10),
                child: ExtendedText.rich(
                  TextSpan(
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                      children: [
                        TextSpan(text: "请同意"),
                        WidgetSpan(
                            child: GestureDetector(
                          onTap: () {
                            // print("object");
                            AppRouter.push(
                              context,
                              RouteName.WEB_VIEW_PAGE,
                              arguments: WebViewPage.setArguments(
                                  url: WebApi.argumentsUrl,
                                  title: "《共享经济合作伙伴协议》",
                                  hideBar: true),
                            );
                          },
                          child: Text("《共享经济合作伙伴协议》",
                              style: TextStyle(
                                  color: Color(0xffD5101A),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300)),
                        )),
                        TextSpan(text: "后进行提现")
                      ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 密码支付
  _submitPassword() {
    if (!UserManager.instance.user.info.isSetPayPwd) {
      //未设置密码 先设置密码
      // 创建密码
      Alert.show(
          context,
          NormalTextDialog(
            type: NormalTextDialogType.delete,
            // title: "支付密码",
            content: "您当前未设置支付密码,请先设置支付密码。",
            items: ["取消"],
            listener: (index) {
              Alert.dismiss(context);
            },
            deleteItem: "设置密码",
            deleteListener: () {
              Alert.dismiss(context);
              AppRouter.push(context, RouteName.USER_SET_PASSWORD_VARCODE);
            },
          ));
      // AppRouter.push(context, RouteName.USER_SET_PASSWORD);
    } else {
      //输入密码
      _showPasswordBottomSheet();
    }
  }

  _showPasswordBottomSheet() {
    bool forgetPassword = false;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 220.0 + 190.0,
          child: BottomKeyBoardWidget(
            controller: _bottomKeyBoardController,
            close: () {
              Navigator.pop(context);
            },
            passwordReturn: (password) {
              Navigator.pop(context);
              String account = _accountTextEditController.text;
              String bankAccount = _bankAccountTextEditController.text;
              withdraw(
               _model.actualAmount,
                password,
                alipay: _isCashToAlipay ? account : "",
                bankAccount: _isCashToAlipay ? "" : bankAccount,
              );

              if (_isCashToAlipay) {
                HiveStore.appBox
                    .put('last_alipay', _accountTextEditController.text);
              } else {
                HiveStore.appBox.put(
                    'last_bank_ccount', _bankAccountTextEditController.text);
              }
            },
            forgetPassword: () {
              Navigator.pop(context);
              forgetPassword = true;
            },
          ),
        );
      },
    ).then((val) {
      if (mounted) {
        if (forgetPassword) {
          AppRouter.push(context, RouteName.USER_SET_PASSWORD_VARCODE);
          // AppRouter.push(context, RouteName.USER_SET_PASSWORD);
        }
      }
    });
  }

  withdraw(amount, password, {alipay = "", bankAccount = ""}) async {
    Map requestMap = {
      "userId": UserManager.instance.user.info.id,
      "amount": amount,
      "password": password
    };
    if (!TextUtils.isEmpty(alipay)) {
      requestMap.putIfAbsent("alipay", () => (alipay));
    } else {
      requestMap.putIfAbsent("bankAccount", () => (bankAccount));
    }
    ResultData resultData =
        await HttpManager.post(UserApi.balance_withdraw, requestMap);
    if (!resultData.result) {
      _bottomKeyBoardController.clearPassWord();
      // Toast.showError(resultData.msg,);
      showError(resultData.msg, duration: Duration(milliseconds: 2000));
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      _bottomKeyBoardController.clearPassWord();
      // Toast.showError(model.msg,);
      showError(model.msg, duration: Duration(milliseconds: 2000));
      return;
    }
    getStore().state.userBrief.balance =
        getStore().state.userBrief.balance.toDouble() - num.parse(amount);
    if (getStore().state.userBrief.balance.toDouble() < 0) {
      getStore().state.userBrief.balance = 0;
    }
    AppRouter.pushAndReplaced(context, RouteName.CASH_WITHDRAW_HISTORY_PAGE);
    setState(() {});
  }
}

class WithdrawAlertWidget extends StatelessWidget {
  final Function dismissClick;

  const WithdrawAlertWidget({Key key, this.dismissClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sHeight = MediaQuery.of(context).size.height;
    double height = sHeight - 130 - 90;
    TextStyle textStyle = TextStyle(
        color: Colors.black,
        fontSize: 12,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w400);
    TextStyle redTextStyle = TextStyle(
        color: Color(0xffF2294D),
        fontSize: 12,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w400);
    return GestureDetector(
      child: Center(
          child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: MediaQuery.of(context).size.width - 40,
          height: height < 500 ? height : 500,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _topWidget(context),
              Expanded(
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    _cellWidget(Text.rich(TextSpan(style: textStyle, children: [
                      TextSpan(
                        text: "提现需要审核，每个月的",
                      ),
                      TextSpan(text: "10日和25日", style: redTextStyle),
                      TextSpan(
                        text: "，是提现审核日\n",
                      ),
                      TextSpan(
                          text: "审核日当天17:00前申请提交,可在当天审核", style: redTextStyle),
                    ]))),
                    _cellWidget(Text.rich(TextSpan(style: textStyle, children: [
                      TextSpan(
                        text: "提现可以选择支付宝和储蓄卡，收款账户信息需要和您的真实姓名保持一致\n",
                      ),
                      TextSpan(
                          text:
                              "(你的真实姓名：${!TextUtils.isEmpty(UserManager.instance.user.info.realName) ? UserManager.instance.user.info.realName : ""}）",
                          style: redTextStyle),
                    ]))),
                    _cellWidget(Text.rich(TextSpan(style: textStyle, children: [
                      TextSpan(
                        text: "审核成功后，需要等待3个工作日，资金才会到达账户\n",
                      ),
                      TextSpan(
                          text:
                              "(你的真实姓名：${!TextUtils.isEmpty(UserManager.instance.user.info.realName) ? UserManager.instance.user.info.realName : ""}）",
                          style: redTextStyle),
                    ]))),
                    // _cellWidget(Text.rich(TextSpan(style: textStyle, children: [
                    //   TextSpan(
                    //     text: "单笔金额需",
                    //   ),
                    //   TextSpan(text: "大于10元", style: redTextStyle),
                    //   TextSpan(
                    //     text: "以上才可提现",
                    //   ),
                    // ])))
                  ],
                ),
              ),
              _bottomWidget(context),
            ],
          ),
        ),
      )),
      onTap: () {
        if (dismissClick != null) {
          dismissClick();
        }
      },
    );
  }

  _topWidget(BuildContext context) {
    double height = 335 / (MediaQuery.of(context).size.width) * 107;
    return Container(
      height: height,
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Image.asset('assets/withdraw_alert_top_bg.png',
              width: MediaQuery.of(context).size.width - 40,
              height: height,
              fit: BoxFit.fill),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("谨记小助手提示",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w300)),
                  Container(
                    height: 10,
                  ),
                  Text("大幅提升提现成功率",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _bottomWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      height: 75,
      child: CustomImageButton(
        height: 45,
        onPressed: () {
          if (dismissClick != null) {
            dismissClick();
          }
        },
        backgroundColor: AppColor.themeColor,
        borderRadius: BorderRadius.circular(25),
        title: "我知道了",
        style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  _cellWidget(textWidget) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            "assets/withdraw_alert_red_dialog.png",
            width: 17,
            height: 17,
            fit: BoxFit.fill,
          ),
          Expanded(child: textWidget),
        ],
      ),
    );
  }
  ///



}
