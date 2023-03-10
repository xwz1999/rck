

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/PayInfoModel.dart';
import 'package:jingyaoyun/models/alipay_order_model.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/order_prepay_model.dart';
import 'package:jingyaoyun/models/pay_result_model.dart';
import 'package:jingyaoyun/models/recook_fund_model.dart';
import 'package:jingyaoyun/pages/home/classify/mvp/order_mvp/order_presenter_impl.dart';
import 'package:jingyaoyun/pages/user/order/order_center_page.dart';
import 'package:jingyaoyun/pages/user/order/order_detail_page.dart';
import 'package:jingyaoyun/third_party/alipay/alipay_utils.dart';
import 'package:jingyaoyun/third_party/wechat/wechat_utils.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/keyboard/bottom_keyboard_widget.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';

class OrderPrepayPage extends StatefulWidget {
  final Map arguments;

  const OrderPrepayPage({Key key, this.arguments}) : super(key: key);

  static setArguments(OrderPrepayModel model,
      {bool goToOrder = false,
      bool canUseBalance = true,
      String fromTo = '',
      }) {
    return {
      "model": model,
      "goToOrder": goToOrder,
      "canUseBalance": canUseBalance,
      "fromTo": fromTo,

    };
  }

  @override
  State<StatefulWidget> createState() {
    return _OrderPrepayPageState();
  }
}

class _OrderPrepayPageState extends BaseStoreState<OrderPrepayPage>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  OrderPresenterImpl _presenter;
  OrderPrepayModel _model;
  int _defaultPayIndex = 1;
  RecookFundModel _recookFundModel;

  /// 取消支付后是否跳转到订单界面，从预览订单进来的会调到订单，订单列表继续支付进来的只会pop
  bool _goToOrder;
  String _fromTo;

  bool _canUseBalance = true;

  /// 用于辅助判断 app 从后台进入前台时，是否需要向后台验证订单状态
  bool _clickPay = false;
  BottomKeyBoardController _bottomKeyBoardController =
      BottomKeyBoardController();
//  @override
//  bool needStore() {
//    return true;
//  }

  ///生命周期锁
  ///
  ///防止在复制验证码阶段中被生命周期检测
  bool _lifecycleLock = false;

  @override
  void initState() {
    super.initState();
    // FlutterUnionPay.listen((result) {
    //   switch (result.status) {
    //     case PaymentStatus.CANCEL:
    //       Toast.showError('银联取消支付');
    //       break;
    //     case PaymentStatus.SUCCESS:
    //       Toast.showSuccess('支付成功');
    //       break;
    //     case PaymentStatus.FAIL:
    //       Toast.showError('银联支付失败');
    //       break;
    //   }
    // });
    UserManager.instance.setPassword.addListener(_setPassword);
    WidgetsBinding.instance.addObserver(this);
    _presenter = OrderPresenterImpl();
    _model = widget.arguments["model"];
    _goToOrder = widget.arguments["goToOrder"];
    _fromTo = widget.arguments["fromTo"];

    _canUseBalance = widget.arguments['canUseBalance'] ?? true;
    _presenter
        .queryRecookPayFund(UserManager.instance.user.info.id)
        .then((HttpResultModel<RecookFundModel> model) {
      if (!model.result) {
        showError(model.msg);
        return;
      }
      setState(() {
        if (model.data.data.amount > _model.data.actualTotalAmount) {
          _defaultPayIndex = 0;
        }
        //在保税仓或海外仓商品时，无法使用余额支付
        if (!_canUseBalance) {
          _defaultPayIndex = 1;
        }
        _recookFundModel = model.data;
      });
    });
  }

  _setPassword() {
    if (_recookFundModel != null) {
      _recookFundModel.data.havePassword = true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    UserManager.instance.setPassword.removeListener(_setPassword);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    DPrint.printf(state);
    //TODO 每次应用进入后台返回前台都会进行订单验证操作，这里需要重写
    if (state == AppLifecycleState.resumed && !_lifecycleLock) {
      DPrint.printf("app 进入前台了");
     _verifyPayStatus() ;
      _clickPay = false;
    }
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          themeData: AppThemes.themeDataGrey.appBarTheme,
          title: "订单支付",
        ),
        backgroundColor: AppColor.frenchColor,
        body: _buildBody(context),
      ),
      onWillPop: () {
        _fromTo == ''
            ? Alert.show(
                context,
                NormalTextDialog(
                  type: NormalTextDialogType.delete,
                  title: "确认要离开收银台?",
                  content: "您的订单在生成后20分钟内未支付将被取消，请尽快完成支付。",
                  items: ["继续支付"],
                  listener: (index) {
                    Alert.dismiss(context);
                  },
                  deleteItem: "确认离开",
                  deleteListener: () {
                    _updateUserBrief();
                    Alert.dismiss(context);
                    if (_goToOrder) {
                      AppRouter.pushAndReplaced(
                          globalContext, RouteName.ORDER_DETAIL,
                          arguments:
                              OrderDetailPage.setArguments(_model.data.id));
                      return;
                    }
                    Navigator.pop(context);
                  },
                ))
            : Alert.show(
                context,
                NormalTextDialog(
                  type: NormalTextDialogType.delete,
                  title: "确认要离开收银台?",
                  content: "您的订单将在您退出收银台后取消,请尽快支付！",
                  items: ["继续支付"],
                  listener: (index) {
                    Alert.dismiss(context);
                  },
                  deleteItem: "确认离开",
                  deleteListener: () async {
                    //_updateUserBrief();
                    Alert.dismiss(context);


                    //设置飞机票为取消

                    Navigator.pop(context);
                    Navigator.pop(context);

                  },
                ));
        return Future.value(false);
      },
    );
  }

  ListView _buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        _priceView(),
        Text(
          "创建时间: ${_model.data.createdAt}",
          textAlign: TextAlign.center,
          style: AppTextStyle.generate(15 * 2.sp, color: Colors.grey),
        ),
        _fromTo != ''
            ? Text(
                _fromTo,
                textAlign: TextAlign.center,
                style: AppTextStyle.generate(15 * 2.sp, color: Colors.grey),
              )
            : SizedBox(),
        Container(
          height: rSize(50),
        ),
        _fromTo == ''
            ? _payTile(
                "",
                Image.asset(
                  AppSvg.svg_balance_pay,
                  width: rSize(30),
                  height: rSize(30),
                ),
                0,
                widgetTitle: RichText(
                  text: TextSpan(
                      text: "余额支付 ",
                      style: AppTextStyle.generate(17 * 2.sp),
                      children: [
                        TextSpan(
                            style: AppTextStyle.generate(14 * 2.sp,
                                color: Colors.grey),
                            text:
                                "(可用余额: ￥${_recookFundModel == null ? "--" : _recookFundModel.data.amount})")
                      ]),
                ),
                enable: _recookFundModel != null &&
                    (_recookFundModel.data.amount >=
                        _model.data.actualTotalAmount) &&
                    _canUseBalance)
            : SizedBox(),
        _payTile(
            "微信支付",
            Icon(
              AppIcons.icon_pay_wechat,
              color: Color.fromARGB(255, 67, 170, 97),
            ),
            1),
        _payTile(
            "支付宝支付",
            Icon(
              AppIcons.icon_pay_alipay,
              color: Color.fromARGB(255, 17, 142, 228),
            ),
            2),
        //TODO 由于退款原因，暂时隐藏该支付方式
        // _fromTo == ''
        //     ? _payTile(
        //         "云闪付支付",
        //         Image.asset(
        //           R.ASSETS_UNION_PAY_PNG,
        //           height: rSize(30),
        //         ),
        //         3)
        //     : SizedBox(),
        Container(
          margin:
              EdgeInsets.symmetric(horizontal: rSize(40), vertical: rSize(150)),
          child: CustomImageButton(
            title: "确认支付",
            fontSize: 16 * 2.sp,
            padding: EdgeInsets.symmetric(vertical: rSize(8)),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            backgroundColor: AppColor.themeColor,
            color: Colors.white,
            onPressed: () {
              _submit();
            },
          ),
        )
      ],
    );
  }

  Container _priceView() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              style:
                  AppTextStyle.generate(22 * 2.sp, fontWeight: FontWeight.w500),
              text: "￥",
              children: [
                TextSpan(
                    style: AppTextStyle.generate(33 * 2.sp,
                        fontWeight: FontWeight.w500),
                    text: _model.data.actualTotalAmount.toString())
              ])),
    );
  }

  _payTile(String title, Widget icon, int index,
      {Widget widgetTitle, bool enable = true}) {
    return CustomImageButton(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.only(left: rSize(15)),
        child: Row(
          children: <Widget>[
            icon,
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    top: rSize(17), bottom: rSize(17), right: rSize(15)),
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.grey[400], width: 0.5))),
                margin: EdgeInsets.only(left: rSize(15)),
                child: Row(
                  children: <Widget>[
                    widgetTitle ??
                        Text(
                          title,
                          style: AppTextStyle.generate(17 * 2.sp),
                        ),
                    Spacer(),
                    Icon(
                      _defaultPayIndex == index
                          ? AppIcons.icon_check_circle
                          : AppIcons.icon_circle,
                      color: _defaultPayIndex == index
                          ? AppColor.themeColor
                          : Colors.grey[300],
                      size: rSize(20),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onPressed: !enable
          ? () {
              if (!_canUseBalance) {
                ReToast.err(text: '订单含跨境商品，无法使用余额支付');
              } else {
                ReToast.err(text: '余额不足');
              }
            }
          : () {
              setState(() {
                _defaultPayIndex = index;
              });
            },
    );
  }

  _submit() {
    showLoading("");
    if (_model.data.actualTotalAmount == 0) {
      // _zeroPay();
      // _recookPay();
      _submitPassword();
      return;
    }

    _clickPay = true;
    switch (_defaultPayIndex) {
      case 0:
        // _recookPay();
        _fromTo == '' ? _submitPassword() : SizedBox();
        break;
      case 1:
        _fromTo == '' ? _weChatPay(context) : _weChatPayLifang(context);
        break;
      case 2:
        _fromTo == '' ? _aliPay(context) : _aliPayLifang(context);
        break;
      case 3:
        _fromTo == '' ? _unionPay(context) : SizedBox();
        break;
    }
  }

  _zeroPay() async {
    HttpResultModel<BaseModel> resultModel = await _presenter
        .createZeroPayOrder(UserManager.instance.user.info.id, _model.data.id);
    if (!resultModel.result) {
      showError(resultModel.msg);
      return;
    }
    _updateUserBrief();
    showSuccess("订单支付成功").then((value) {
      AppRouter.pushAndReplaced(globalContext, RouteName.ORDER_LIST_PAGE,
          arguments: OrderCenterPage.setArguments(2));
    });
  }

  _aliPay(BuildContext context) async {
    HttpResultModel<AlipayOrderModel> resultModel = await _presenter
        .createAliPayOrder(UserManager.instance.user.info.id, _model.data.id);
    dismissLoading();
    if (!resultModel.result) {
      GSDialog.of(context).showError(context, resultModel.msg);
      return;
    }
    AliPayUtils.callAliPay(resultModel.data.data.orderString);
  }

  _aliPayLifang(BuildContext context) async {
    HttpResultModel<AlipayOrderModel> resultModel =
        await _presenter.createAliPayOrderLifang(
            UserManager.instance.user.info.id, _model.data.id);
    dismissLoading();
    if (!resultModel.result) {
      GSDialog.of(context).showError(context, resultModel.msg);
      return;
    }
    AliPayUtils.callAliPay(resultModel.data.data.orderString);
  }

  _weChatPay(BuildContext context) async {
    HttpResultModel<PayInfoModel> resultModel = await _presenter
        .createWeChatOrder(UserManager.instance.user.info.id, _model.data.id);
    GSDialog.of(context).dismiss(context);
    if (!resultModel.result) {
      GSDialog.of(context).showError(context, resultModel.msg);
      return;
    }
    PayInfoModel wxPayModel = resultModel.data;
    WeChatUtils.pay(
        appId: wxPayModel.payInfo.appid,
        partnerId: wxPayModel.payInfo.partnerid,
        prepayId: wxPayModel.payInfo.prepayid,
        packageValue: wxPayModel.payInfo.package,
        nonceStr: wxPayModel.payInfo.noncestr,
        timeStamp: int.parse(wxPayModel.payInfo.timestamp),
        sign: wxPayModel.payInfo.sign,
        listener: (WXPayResult result) {});
  }

  _weChatPayLifang(BuildContext context) async {
    HttpResultModel<PayInfoModel> resultModel =
        await _presenter.createWeChatOrderLifang(
            UserManager.instance.user.info.id, _model.data.id);
    GSDialog.of(context).dismiss(context);
    if (!resultModel.result) {
      GSDialog.of(context).showError(context, resultModel.msg);
      return;
    }
    PayInfoModel wxPayModel = resultModel.data;
    WeChatUtils.pay(
        appId: wxPayModel.payInfo.appid,
        partnerId: wxPayModel.payInfo.partnerid,
        prepayId: wxPayModel.payInfo.prepayid,
        packageValue: wxPayModel.payInfo.package,
        nonceStr: wxPayModel.payInfo.noncestr,
        timeStamp: int.parse(wxPayModel.payInfo.timestamp),
        sign: wxPayModel.payInfo.sign,
        listener: (WXPayResult result) {});
    // String msg = await PassagerFunc.airOrderPayLifang(
    //     _payNeedModel.lfOrderId,
    //     _payNeedModel.seatCode,
    //     _payNeedModel.passagers,
    //     _payNeedModel.itemId,
    //     _payNeedModel.contactName,
    //     _payNeedModel.contactTel,
    //     _payNeedModel.date,
    //     _payNeedModel.from,
    //     _payNeedModel.to,
    //     _payNeedModel.companyCode,
    //     _payNeedModel.flightNo);
    // if (msg == 'ok') {
    //   ReToast.success(text: '购票成功');
    //   Navigator.pop(context);
    //   Navigator.pop(context);
    //   Navigator.pop(context);
    // } else {
    //   ReToast.success(text: '购票失败');
    //   Navigator.pop(context);
    //   Navigator.pop(context);
    //   Navigator.pop(context);
    // }
  }

  _unionPay(BuildContext context) async {
    ResultData resultData =
        await HttpManager.post("/v1/pay/unionpay/order/create", {
      "orderId": _model.data.id,
      "userId": UserManager.instance.user.info.id,
    });
    dismissLoading();
    if (!TextUtil.isEmpty(resultData?.data['data']['tn'] ?? null)) {
      // FlutterUnionPay.pay(
      //   tn: resultData?.data['data']['tn'],
      //   mode: AppConfig.debug ? PaymentEnv.DEVELOPMENT : PaymentEnv.PRODUCT,
      //   scheme: "RecookUnionPay",
      // );
    }
  }

  _unionPayLifang(BuildContext context) async {
    ResultData resultData = await HttpManager.post(
        "/v2/app/liFang_ticketing/order_pay/pay/unionpay_order", {
      "orderId": _model.data.id,
      "userId": UserManager.instance.user.info.id,
    });
    dismissLoading();
    if (!TextUtil.isEmpty(resultData?.data['data']['tn'] ?? null)) {
      // FlutterUnionPay.pay(
      //   tn: resultData?.data['data']['tn'],
      //   mode: AppConfig.debug ? PaymentEnv.DEVELOPMENT : PaymentEnv.PRODUCT,
      //   scheme: "RecookUnionPay",
      // );
    }
  }

  // 密码支付
  _submitPassword() {
    _lifecycleLock = true;
    dismissLoading();
    if (!_recookFundModel.data.havePassword) {
      // if (true) {
      //未设置密码 先设置密码
      // 创建密码
      Alert.show(
          context,
          NormalTextDialog(
            type: NormalTextDialogType.delete,
            // title: "支付密码",
            content: "您当前未设置支付密码,请先设置 支付密码,或更换支付方式。",
            items: ["更换支付方式"],
            listener: (index) {
              _lifecycleLock = false;
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
              _recookPay(password);
            },
            forgetPassword: () {
              Navigator.pop(context);
              forgetPassword = true;
            },
          ),
        );
        // return BottomKeyBoardWidget(
        //   close: (){
        //     Navigator.pop(context);
        //   },
        //   passwordReturn: (password){
        //     // Navigator.pop(context);
        //     // DPrint.printf(password);
        //     // showError(password);
        //     _recookPay(password);
        //   },
        //   forgetPassword: (){
        //     Navigator.pop(context);
        //     forgetPassword = true;
        //   },
        // );
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

  _recookPay(password) async {
    showLoading("");
    HttpResultModel<BaseModel> resultModel =
        await _presenter.createRecookPayOrder(
            UserManager.instance.user.info.id, _model.data.id, password);
    dismissLoading();
    if (!resultModel.result) {
      _bottomKeyBoardController.clearPassWord();
      showError(resultModel.msg, duration: Duration(milliseconds: 2000));
      return;
    }
    UserManager.instance.refreshShoppingCart.value = true;
    Navigator.pop(context);
    _updateUserBrief();
    showSuccess("订单支付成功").then((value) {
      AppRouter.pushAndReplaced(globalContext, RouteName.ORDER_LIST_PAGE,
          arguments: OrderCenterPage.setArguments(2));
    });
  }

  _verifyPayStatus() async {
    GSDialog.of(_scaffoldKey.currentContext)
        .showLoadingDialog(_scaffoldKey.currentContext, "正在验证订单...");

    await Future.delayed(Duration(seconds: 1));

    HttpResultModel<PayResult> resultModel =
        await _presenter.verifyOrderPayStatus(_model.data.id);

    GSDialog.of(_scaffoldKey.currentContext)
        .dismiss(_scaffoldKey.currentContext);

    if (!resultModel.result) {
      GSDialog.of(_scaffoldKey.currentContext)
          .showError(_scaffoldKey.currentContext, resultModel.msg);
      return;
    }

    if (resultModel.data.status == 0) {
//      Navigator.popUntil(context, ModalRoute.withName(RouteName.ORDER_LIST_PAGE));
      if (_goToOrder) {
        AppRouter.pushAndReplaced(globalContext, RouteName.ORDER_DETAIL,
            arguments: OrderDetailPage.setArguments(_model.data.id));
      } else {
        Navigator.pop(context);
      }
      return;
    }
    UserManager.instance.refreshShoppingCart.value = true;
    _updateUserBrief();
    AppRouter.pushAndReplaced(globalContext, RouteName.ORDER_LIST_PAGE,
        arguments: OrderCenterPage.setArguments(2));
  }


  _updateUserBrief() {
    UserManager.instance.updateUserBriefInfo(getStore());
  }
}
