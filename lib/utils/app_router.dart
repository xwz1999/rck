import 'package:flutter/material.dart';
import 'package:jingyaoyun/pages/aftersale/choose_after_sale_type_page.dart';
import 'package:jingyaoyun/pages/business/publish_business_district_page.dart';
import 'package:jingyaoyun/pages/home/barcode/fail_barcode_page.dart';
import 'package:jingyaoyun/pages/home/barcode/input_barcode_page.dart';
import 'package:jingyaoyun/pages/home/barcode/photos_fail_barcode_page.dart';
import 'package:jingyaoyun/pages/home/classify/brandgoods_list_page.dart';
import 'package:jingyaoyun/pages/home/classify/commodity_detail_page.dart';
import 'package:jingyaoyun/pages/home/classify/evaluation_list_page.dart';
import 'package:jingyaoyun/pages/home/classify/goods_list_page.dart';
import 'package:jingyaoyun/pages/home/classify/order_prepay_page.dart';
import 'package:jingyaoyun/pages/home/classify/order_preview_page.dart';
import 'package:jingyaoyun/pages/home/home_page.dart';
import 'package:jingyaoyun/pages/home/newuserDiscount/new_user_discount_page.dart';
import 'package:jingyaoyun/pages/home/search_page.dart';
import 'package:jingyaoyun/pages/home/widget/goods_hot_list_page.dart';
import 'package:jingyaoyun/pages/home/widget/goods_list_temp_page.dart';
import 'package:jingyaoyun/pages/login/input_invitation_code_page.dart';
import 'package:jingyaoyun/pages/login/login_page.dart';
import 'package:jingyaoyun/pages/login/phone_login_page.dart';
import 'package:jingyaoyun/pages/login/wechat_bind_page.dart';
import 'package:jingyaoyun/pages/login/wechat_input_invitecode_page.dart';
import 'package:jingyaoyun/pages/shop/member_benefits_page.dart';
import 'package:jingyaoyun/pages/shop/order/shop_order_center_page.dart';
import 'package:jingyaoyun/pages/shop/order/shop_order_detail_page.dart';
import 'package:jingyaoyun/pages/shopping_cart/shopping_cart_page.dart';
import 'package:jingyaoyun/pages/store/modify_info_page.dart';
import 'package:jingyaoyun/pages/store/store_detail_page.dart';
import 'package:jingyaoyun/pages/store/store_page.dart';
import 'package:jingyaoyun/pages/tabBar/TabbarWidget.dart';
import 'package:jingyaoyun/pages/user/account_and_safety/account_and_safety_page.dart';
import 'package:jingyaoyun/pages/user/account_and_safety/delete_account_page.dart';
import 'package:jingyaoyun/pages/user/address/new_address_page.dart';
import 'package:jingyaoyun/pages/user/address/receiving_address_page.dart';
import 'package:jingyaoyun/pages/user/balance_page.dart';
import 'package:jingyaoyun/pages/user/cash_withdraw_history_page.dart';
import 'package:jingyaoyun/pages/user/cash_withdraw_result_page.dart';
import 'package:jingyaoyun/pages/user/invite/invite_search_page.dart';
import 'package:jingyaoyun/pages/user/invite/user_invite_detail.dart';
import 'package:jingyaoyun/pages/user/invoice/Invoice_with_goods_page.dart';
import 'package:jingyaoyun/pages/user/invoice/invoice_add_title_page.dart';
import 'package:jingyaoyun/pages/user/invoice/invoice_detail_page.dart';
import 'package:jingyaoyun/pages/user/invoice/invoice_history_page.dart';
import 'package:jingyaoyun/pages/user/invoice/invoice_page.dart';
import 'package:jingyaoyun/pages/user/invoice/invoice_upload_done_page.dart';
import 'package:jingyaoyun/pages/user/invoice/invoice_usually_used_page.dart';
import 'package:jingyaoyun/pages/user/my_coupon_list_page.dart';
import 'package:jingyaoyun/pages/user/my_favorites_page.dart';
import 'package:jingyaoyun/pages/user/order/after_sales_log_page.dart';
import 'package:jingyaoyun/pages/user/order/invoice_add_page.dart';
import 'package:jingyaoyun/pages/user/order/invoice_list_page.dart';
import 'package:jingyaoyun/pages/user/order/logistic_detail_page.dart';
import 'package:jingyaoyun/pages/user/order/order_after_sale_page.dart';
import 'package:jingyaoyun/pages/user/order/order_center_page.dart';
import 'package:jingyaoyun/pages/user/order/order_detail_page.dart';
import 'package:jingyaoyun/pages/user/order/order_logistics_list_page.dart';
import 'package:jingyaoyun/pages/user/order/order_return_address_page.dart';
import 'package:jingyaoyun/pages/user/order/order_return_status_page.dart';
import 'package:jingyaoyun/pages/user/order/publish_evaluation_page.dart';
import 'package:jingyaoyun/pages/user/order/refund_goods_page.dart';
import 'package:jingyaoyun/pages/user/order/return_goods_page.dart';
import 'package:jingyaoyun/pages/user/qrcode/user_info_qrcode_page.dart';
import 'package:jingyaoyun/pages/user/review/review_page.dart';
import 'package:jingyaoyun/pages/user/rui_coin_page.dart';
import 'package:jingyaoyun/pages/user/rui_transfer_to_balance_page.dart';
import 'package:jingyaoyun/pages/user/setting_page.dart';
import 'package:jingyaoyun/pages/user/user_cash_withdraw_page.dart';
import 'package:jingyaoyun/pages/user/user_info_address_page.dart';
import 'package:jingyaoyun/pages/user/user_info_page.dart';
import 'package:jingyaoyun/pages/user/user_set_password.dart';
import 'package:jingyaoyun/pages/user/user_set_password_again.dart';
import 'package:jingyaoyun/pages/user/user_set_password_varcode.dart';
import 'package:jingyaoyun/pages/user/user_verify.dart';
import 'package:jingyaoyun/pages/user/user_verify_result.dart';
import 'package:jingyaoyun/pages/welcome/welcome_widget.dart';
import 'package:jingyaoyun/utils/navigator_utils.dart';
import 'package:jingyaoyun/widgets/barcodeScan.dart';
import 'package:jingyaoyun/widgets/bussiness_cooperation_page.dart';
import 'package:jingyaoyun/widgets/custom_route.dart';
import 'package:jingyaoyun/widgets/pic_swiper.dart';
import 'package:jingyaoyun/widgets/result_page.dart';
import 'package:jingyaoyun/widgets/share_page/share_goods_poster_page.dart';
import 'package:jingyaoyun/widgets/share_page/share_url_poster_page.dart';
import 'package:jingyaoyun/widgets/text_page.dart';
import 'package:jingyaoyun/widgets/weather_page/weather_city_page.dart';
import 'package:jingyaoyun/widgets/webView.dart';

import '../pages/user/invoice/invoice_detail_infomation_page.dart';

//????????????

//??????????????????

class RouteName {
  /// ????????????
  static const String AFTER_SALES_LOG_PAGE = "/AfterSalesLogPage";

  /// ??????????????????
  static const String CHOOSE_AFTER_SALE_TYPE_PAGE = '/ChooseAfterSaleTypePage';
  //????????????
  static const String TEXTPAGE = "/TextPage";
  //
  static const String LOGIN = "/login";
  static const String PHONE_LOGIN = "/phoneLogin";
  static const String INPUT_INVITATION = "/inputInvitation";
  static const String WECHAT_BIND = '/WeChatBindPage';
  static const String WECHAT_INPUT_INVITATION = "/WeChatInputInviteCodePage";

  static const String TAB_BAR = "/tabbar";
  static const String WELCOME_PAGE = "/welcomePage";

  // ??????????????????
  static const String WEATHER_CITY_PAGE = "/WeatherCityPage";

  /// ??????
  static const String HOME = "/home";
  //  ????????????
  static const String SELLING_POINT_PAGE = "/SellingPointPage";
  //  ????????????
  static const String PURCHASE_RANKING_PAGE = "/PurchaseRankingPage";
  //  ????????????
  static const String NEW_USER_DISCOUNT_PAGE = "/NewUserDiscountPage";
  // ????????????
  static const String GOODS_HOT_LIST = "/GoodsHotListPage";

  //????????????(????????????)
  static const String GOODS_LIST_TEMP = "/GoodsListTempPage";

  // ????????????
  static const String GOODS_LIST_PAGE = "/GoodsList";
  static const String BRANDGOODS_LIST_PAGE = "/BrandGoodsListPage";
  // ????????????
  static const String COMMODITY_PAGE = "/commodityPage";

  // ????????????
  static const String GOODS_ORDER_PAGE = "/goodsOrderPage";

  // ????????????????????????
  static const String ORDER_PREPAY_PAGE = "/orderPrepayPage";

  // ?????????
  static const String GOODS_SHOPPING_CART = "/goodsShoppingCart";

  // ????????????
  static const String EVALUATION_LIST_PAGE = "/evaluationListPage";

  static const String SEARCH = "/search";

  /// ??????
  // ????????????
  static const String BUSINESS_DISTRICT_PUBLISH_PAGE =
      "/PublishBusinessDistrictPage";

  //????????????
  static const String Member_BENEFITS_PAGE = "/memberBenefitsPage";
  // ????????????
  static const String SHOP_RECOMMEND_UPGRADE_PAGE = "/shopRecommendUpgradePage";
  // ???????????????
  static const String SHOP_UPGRADE_CODE_PAGE = "/shopUpgradeCodePage";

  /// ?????????
  // ????????????
  static const String STORE_PAGE = "/storePage";
  static const String STORE_DETAIL_PAGE = "/storeDetailPage";

  // ????????????
  static const String MODIFY_DETAIL_PAGE = "/modifyDetailPage";
  static const String RUI_COIN_PAGE = "/ruiCoinPage";
  static const String RUI_TRANSFER_BALANCE_PAGE = "/ruiTransferToBalancePage";
  static const String BALANCE_PAGE = "/balancePage";
  static const String USER_CASH_WITHDRAW_PAGE = "/UserCashWithdrawPage";
  static const String CASH_WITHDRAW_HISTORY_PAGE = "/CashWithdrawHistoryPage";
  static const String CASH_WITHDRAW_RESULT_PAGE = "/CashWithdrawResultPage";

  /// ????????????
  static const String SETTING_PAGE = "/settingPage";
  static const String USER_INFO_PAGE = "/userInfoPage";
  static const String USER_INFO_QRCODE_PAGE = "/userInfoQRCodePage";
  static const String USER_VERIFY = "/userVerify";
  static const String USER_VERIFY_RESULT = "/userVerifyResult";
  static const String USER_INVITE = "/InvitePage";
  static const String USER_INVITE_DETAIL = "/InvitePageDetail";
  static const String USER_INVITE_SEARCH = "/UserInviteSearch";
  static const String USER_BILLING_DETAILS = "/UserBillingDetails";
  static const String USER_SET_PASSWORD_VARCODE = "/UserSetPasswordVarCode";

  ///????????????????????????
  static const String USER_REVIEW_PAGE = "/UserReviewPage";

  ///???????????????
  static const String ACCOUNT_AND_SAFETY_PAGE = "AccountAndSafetyPage";

  ///????????????
  static const String USER_DELETE_ACCOUNT_PAGE = "/UserDeleteAccountPage";
  static const String USER_SET_PASSWORD = "/UserSetPassword";
  static const String USER_SET_PASSWORD_AGAIN = "/UserSetPasswordAgain";
  static const String USER_INFO_ADDRESS_PAGE = "/UserInfoAddressPage";
  static const String USER_PAGE_SUB_INCOME_PAGE = "/UserPageSubIncomePage";

  //??????
  ///??????????????????
  static const String USER_INVOICE = "/UserInvoice";

  ///????????????????????????
  static const String USER_INVOICE_GOODS = "/UserInvoiceGoods";

  ///??????????????????
  static const String USER_INVOICE_DETAIL = "/UserInvoiceDetail";

  ///????????????
  static const String USER_INVOICE_UPLOAD_DONE = "/UserInvoiceUploadDone";

  ///????????????
  static const String USER_INVOICE_HISTORY = "/UserInvoiceHistory";

  ///??????????????????
  static const String USER_INVOICE_USUALLY_USED = "/UserInvoiceUsuallyUsed";

  ///??????????????????
  static const String USER_INVOICE_ADD_TITLE = "/UserInvoiceAddTitle";

  ///??????????????????
  static const String USER_INVOICE_DETAIL_INFOMATION =
      "/UserInvoiceDetailInfomation";

  // ????????????
  static const String RECEIVING_ADDRESS_PAGE = "/receivingAddressPage";
  static const String NEW_ADDRESS_PAGE = "/newAddressPage";

  // ??????
  static const String MY_FAVORITE_PAGE = "/myFavoritePage";

  // ?????????
  static const String MY_COUPON_PAGE = "/myCouponPage";

  // ????????????
  static const String ORDER_REFUND = "/orderReturnGoodsPage";
  static const String ORDER_LIST_PAGE = "/orderListPage";
  static const String ORDER_DETAIL = "/orderDetailPage";
  static const String ORDER_RETURN = "/orderReturnPage";
  static const String ORDER_RETURN_DETAIL = "/orderReturnDetailPage";
  static const String ORDER_RETURN_ADDRESS = "/orderReturnAddressPage";
  static const String ORDER_LOGISTIC = "/orderLogisticsPage";
  static const String ORDER_LOGISTIC_DETAIL = "/orderLogisticsDetailPage";
  static const String ORDER_INVOICE_LIST = "/orderInvoiceListPage";
  static const String ORDER_INVOICE_ADD = "/orderInvoiceAddPage";
  static const String ORDER_EVALUATION = "/orderEvaluationPage";
  static const String ORDER_AFTER_SALE_GOODS_LIST = '/OrderAfterSalePage';

  //????????????
  static const String PIC_SWIPER = "/PicSwiper";

  //??????
  static const String WEB_VIEW_PAGE = "/WebViewPage";
  //???????????????
  static const String BARCODE_SCAN = "/BarcodeScanPage";
  static const String BARCODE_INPUT = "/BarcodeInputPage";
  static const String BARCODE_FAIL = "/BarcodeFail";
  static const String BARCODE_PHOTOSFAIL = "/BarcodePhotosFail";
  //??????
  //????????????
  static const String CUMULATIVE_INCOME = "/CumulativeIncomePage";
  static const String SHOP_PAGE_SUB_INCOME_PAGE = "/ShopPageSubIncomePage";
  //????????????
  static const String COMMISSION_INFO = "/ShopCommissionInfoPage";
  //????????????
  static const String PERFORMANCE_INFO = "/ShopPerformanceInfoPage";
  //??????????????????
  static const String SHOP_ORDER_LIST_PAGE = "/ShopOrderCenterPage";
  //??????????????????
  static const String SHOP_ORDER_DETAIL = "/ShopOrderDetailPage";
  // ????????????
  static const String RESULT_PAGE = "/ResultPage";
  // ?????????
  static const String UPGRADE_CARD_PAGE = "/UpgradeCardPage";
  static const String UPGRADE_CARD_SEND_USER_LIST_PAGE =
      "/UpgradeCardSendUserListPage";

  static const String SHARE_GOODS_POSTER_PAGE = "/ShareGoodsPosterPage";
  static const String SHARE_URL_POSTER_PAGE = "/ShareUrlPosterPage";

  //????????????
  ///????????????
  static const String REDEEM_LOTTERY_PAGE = "/ReddemLotteryPage";

  ///??????????????????
  static const String LOTTERY_HELP_PAGE = "/LotteryHelpPage";

  ///??????????????????
  static const String LOTTERY_ORDER_PAGE = "/LotteryOrderPage";

  ///????????????
 static const  String BUSSINESS_COOPERATION_PAGE="/BussinessCooperationPage";
}

typedef RouteBuilder = Widget Function(BuildContext context,
    {Object arguments});

/// ?????????????????????
final Map<String, RouteBuilder> _routes = {
  /// ????????????
  RouteName.AFTER_SALES_LOG_PAGE: (context, {arguments}) => AfterSalesLogPage(
        arguments: arguments,
      ),

  /// ??????????????????
  RouteName.CHOOSE_AFTER_SALE_TYPE_PAGE: (context, {arguments}) =>
      ChooseAfterSaleTypePage(
        arguments: arguments,
      ),
  // ????????????
  RouteName.TEXTPAGE: (context, {arguments}) => TextPage(
        arguments: arguments,
      ),
  //
  // ??????
  RouteName.LOGIN: (context, {arguments}) => LoginPage(),
  // ??????????????????
  RouteName.PHONE_LOGIN: (context, {arguments}) => PhoneLoginPage(),
  // ???????????????
  RouteName.INPUT_INVITATION: (context, {arguments}) => InvitationCodePage(
        argument: arguments,
      ),
  RouteName.WECHAT_BIND: (context, {arguments}) => WeChatBindPage(
        argument: arguments,
      ),
  RouteName.WECHAT_INPUT_INVITATION: (context, {arguments}) =>
      WeChatInputInviteCodePage(argument: arguments),
  // tabbar
  RouteName.TAB_BAR: (context, {arguments}) => TabBarWidget(),

  RouteName.WELCOME_PAGE: (context, {arguments}) => WelcomeWidget(),
  RouteName.WEATHER_CITY_PAGE: (context, {arguments}) => WeatherCityPage(
        arguments: arguments,
      ),
  // ??????
  RouteName.HOME: (context, {arguments}) => HomePage(),
  // ????????????
  RouteName.NEW_USER_DISCOUNT_PAGE: (context, {arguments}) =>
      NewUserDiscountPage(),
  // ????????????
  RouteName.GOODS_HOT_LIST: (context, {arguments}) => GoodsHotListPage(),
  //????????????(????????????)
  RouteName.GOODS_LIST_TEMP: (context, {arguments}) =>
      GoodsListTempPage(arguments: arguments),
  // ????????????
  RouteName.GOODS_LIST_PAGE: (context, {arguments}) => GoodsListPage(
        arguments: arguments,
      ),
  RouteName.BRANDGOODS_LIST_PAGE: (context, {arguments}) =>
      BrandGoodsListPage(argument: arguments),
  // ????????????
  RouteName.SEARCH: (context, {arguments}) => SearchPage(),
  // ????????????
  RouteName.COMMODITY_PAGE: (context, {arguments}) => CommodityDetailPage(
        arguments: arguments,
      ),
  // ??????????????????
  RouteName.GOODS_ORDER_PAGE: (context, {arguments}) => GoodsOrderPage(
        arguments: arguments,
      ),
  // ???????????????
  RouteName.ORDER_PREPAY_PAGE: (context, {arguments}) => OrderPrepayPage(
        arguments: arguments,
      ),
  // ?????????
  RouteName.GOODS_SHOPPING_CART: (context, {arguments}) => ShoppingCartPage(
        needSafeArea: true,
      ),
  RouteName.EVALUATION_LIST_PAGE: (context, {arguments}) => EvaluationListPage(
        arguments: arguments,
      ),

  // ????????????
  RouteName.Member_BENEFITS_PAGE: (context, {arguments}) =>
      MemberBenefitsPage(),


  // ????????????
  RouteName.STORE_PAGE: (context, {arguments}) => StorePage(),
  // ????????????
  RouteName.STORE_DETAIL_PAGE: (context, {arguments}) => StoreDetailPage(),
  // ??????????????????
  RouteName.MODIFY_DETAIL_PAGE: (context, {arguments}) => ModifyInfoPage(
        arguments: arguments,
      ),

  // ??????????????????
  RouteName.BUSINESS_DISTRICT_PUBLISH_PAGE: (context, {arguments}) =>
      PublishBusinessDistrictPage(
        arguments: arguments,
      ),

  /******* ??????   ********/
  RouteName.SETTING_PAGE: (context, {arguments}) => SettingPage(),
  RouteName.USER_INFO_PAGE: (context, {arguments}) => UserInfoPage(),
  RouteName.USER_INFO_QRCODE_PAGE: (context, {arguments}) =>
      UserInfoQrCodePage(),
  // ????????????
  RouteName.USER_VERIFY: (context, {arguments}) => VerifyPage(
        arguments: arguments,
      ),
  RouteName.USER_VERIFY_RESULT: (context, {arguments}) => VerifyResultPage(
        arguments: arguments,
      ),
  RouteName.USER_INVITE_DETAIL: (context, {arguments}) => UserInviteDetail(
        arguments: arguments,
      ),
  RouteName.USER_INVITE_SEARCH: (context, {arguments}) => InviteSearchPage(),
  //??????????????????
  RouteName.USER_SET_PASSWORD_VARCODE: (context, {arguments}) =>
      UserSetPasswordVarCode(),
  RouteName.USER_DELETE_ACCOUNT_PAGE: (context, {arguments}) =>
      DeleteAccountPage(),
  RouteName.USER_REVIEW_PAGE: (context, {arguments}) => ReviewPage(),
  RouteName.ACCOUNT_AND_SAFETY_PAGE: (context, {arguments}) =>
      AccountAndSafetyPage(),
  RouteName.USER_SET_PASSWORD: (context, {arguments}) => UserSetPassword(),
  RouteName.USER_SET_PASSWORD_AGAIN: (context, {arguments}) =>
      UserSetPasswordAgain(
        arguments: arguments,
      ),
  RouteName.USER_INFO_ADDRESS_PAGE: (context, {arguments}) =>
      UserInfoAddressPage(
        arguments: arguments,
      ),
  // ??????
  RouteName.RUI_COIN_PAGE: (context, {arguments}) => RuiCoinPage(),
  RouteName.RUI_TRANSFER_BALANCE_PAGE: (context, {arguments}) =>
      RuiCoinTransferToBalancePage(
        arguments: arguments,
      ),
  RouteName.USER_CASH_WITHDRAW_PAGE: (context, {arguments}) =>
      UserCashWithdrawPage(
        arguments: arguments,
      ),
  RouteName.CASH_WITHDRAW_HISTORY_PAGE: (context, {arguments}) =>
      CashWithdrawHistoryPage(),
  RouteName.CASH_WITHDRAW_RESULT_PAGE: (context, {arguments}) =>
      CashWithdrawResultPage(
        arguments: arguments,
      ),
  //??????
  RouteName.BALANCE_PAGE: (context, {arguments}) => BalancePage(),
  RouteName.MY_FAVORITE_PAGE: (context, {arguments}) => MyFavoritesPage(),
  RouteName.MY_COUPON_PAGE: (context, {arguments}) => MyCouponListPage(),

  // ????????????
  RouteName.RECEIVING_ADDRESS_PAGE: (context, {arguments}) =>
      ReceivingAddressPage(
        arguments: arguments,
      ),
  // ??????????????????
  RouteName.NEW_ADDRESS_PAGE: (context, {arguments}) => NewAddressPage(
        arguments: arguments,
      ),
  // ????????????
  RouteName.ORDER_LIST_PAGE: (context, {arguments}) => OrderCenterPage(
        arguments: arguments,
      ),
  // ????????????
  RouteName.ORDER_DETAIL: (context, {arguments}) => OrderDetailPage(
        arguments: arguments,
      ),
  // ??????
  RouteName.ORDER_RETURN: (context, {arguments}) => GoodsReturnPage(
        arguments: arguments,
      ),
  // ??????
  RouteName.ORDER_REFUND: (context, {arguments}) => RefundGoodsPage(
        arguments: arguments,
      ),
  // ??????????????????
  RouteName.ORDER_RETURN_DETAIL: (context, {arguments}) =>
      OrderReturnStatusPage(
        arguments: arguments,
      ),
  // ??????????????????
  RouteName.ORDER_RETURN_ADDRESS: (context, {arguments}) =>
      OrderReturnAddressPage(
        arguments: arguments,
      ),

  // ????????????
  RouteName.ORDER_LOGISTIC: (context, {arguments}) => OrderLogisticsListPage(
        arguments: arguments,
      ),
  // ????????????
  RouteName.ORDER_LOGISTIC_DETAIL: (context, {arguments}) => LogisticDetailPage(
        arguments: arguments,
      ),
  // ????????????
  RouteName.ORDER_INVOICE_LIST: (context, {arguments}) => InvoiceListPage(),
  // ????????????
  RouteName.ORDER_INVOICE_ADD: (context, {arguments}) => InvoiceAddPage(),

  RouteName.ORDER_EVALUATION: (context, {arguments}) => PublishEvaluationPage(
        arguments: arguments,
      ),
  //????????????
  RouteName.ORDER_AFTER_SALE_GOODS_LIST: (context, {arguments}) =>
      OrderAfterSalePage(
        arguments: arguments,
      ),
  //????????????
  RouteName.PIC_SWIPER: (context, {arguments, index, pics}) =>
      PicSwiper(arguments: arguments),
  //webview
  RouteName.WEB_VIEW_PAGE: (context, {arguments}) => WebViewPage(
        arguments: arguments,
      ),
  //???????????????
  RouteName.BARCODE_SCAN: (context, {arguments}) => BarcodeScanPage(),
  RouteName.BARCODE_INPUT: (context, {arguments}) => InputBarcodePage(),
  RouteName.BARCODE_PHOTOSFAIL: (context, {arguments}) =>
      PhotosFailBarcodePage(arguments: arguments),
  RouteName.BARCODE_FAIL: (context, {arguments}) =>
      FailBarcodePage(arguments: arguments),

  //??????????????????
  RouteName.SHOP_ORDER_LIST_PAGE: (context, {arguments}) => ShopOrderCenterPage(
        arguments: arguments,
      ),
  //??????????????????
  RouteName.SHOP_ORDER_DETAIL: (context, {arguments}) => ShopOrderDetailPage(
        arguments: arguments,
      ),
  // ??????????????????
  RouteName.RESULT_PAGE: (context, {arguments}) =>
      ResultPage(arguments: arguments),
  RouteName.SHARE_GOODS_POSTER_PAGE: (context, {arguments}) =>
      ShareGoodsPosterPage(
        arguments: arguments,
      ),
  RouteName.SHARE_URL_POSTER_PAGE: (context, {arguments}) => ShareUrlPosterPage(
        arguments: arguments,
      ),
  RouteName.USER_INVOICE: (context, {arguments}) => InvoicePage(),
  RouteName.USER_INVOICE_GOODS: (context, {arguments}) =>
      InvoiceWithGoodsPage(),
  RouteName.USER_INVOICE_DETAIL: (context, {arguments}) =>
      InvoiceDetailPage(arguments: arguments),
  RouteName.USER_INVOICE_UPLOAD_DONE: (context, {arguments}) =>
      InvoiceUploadDonePage(),
  RouteName.USER_INVOICE_HISTORY: (context, {arguments}) =>
      InvoiceHistoryPage(),
  RouteName.USER_INVOICE_USUALLY_USED: (contex, {arguments}) =>
      InvoiceUsuallyUsedPage(),
  RouteName.USER_INVOICE_ADD_TITLE: (contex, {arguments}) =>
      InvoiceAddTitlePage(arguments: arguments),
  RouteName.USER_INVOICE_DETAIL_INFOMATION: (contex, {arguments}) =>
      InvoiceDetailInfomationPage(arguments: arguments),

  RouteName.BUSSINESS_COOPERATION_PAGE:(context,{arguments}) =>BussinessCooperationPage(),
};

///  ?????????????????????
///
class AppRouter {
  static bool canPop(context) {
    return Navigator.canPop(context);
  }

  static Future popAndPushNamed(BuildContext context, String routeName,
      {arguments}) {
    return NavigatorUtils.popAndPushNamed(context, routeName,
        arguments:
            RouteArguments(type: AnimationType.push, arguments: arguments));
  }

  ///
  /// [Future] ????????????pop???????????????
  /// [routeName] ?????????
  ///
  static Future<T> push<T extends Object>(
      BuildContext context, String routeName,
      {arguments}) {
    return NavigatorUtils.modelRoute<T>(context, routeName,
        arguments:
            RouteArguments(type: AnimationType.push, arguments: arguments));
  }

  static Future<T> fade<T extends Object>(
      BuildContext context, String routeName,
      {arguments}) {
    return NavigatorUtils.modelRoute<T>(context, routeName,
        arguments:
            RouteArguments(type: AnimationType.fade, arguments: arguments));
  }

  ///
  ///materialRoute ???????????????
  ///
  static Future pushAndReplaced(BuildContext context, String routeName,
      {arguments}) {
    return NavigatorUtils.pushReplacement(context, routeName,
        arguments:
            RouteArguments(type: AnimationType.push, arguments: arguments));
  }

  ///
  ///materialRoute ???????????????
  ///
  static Future fadeAndReplaced(BuildContext context, String routeName,
      {arguments}) {
    return NavigatorUtils.pushReplacement(context, routeName,
        arguments:
            RouteArguments(type: AnimationType.fade, arguments: arguments));
  }

  // ????????????????????????
  static Future pushAndRemoveUntil(BuildContext context, String routeName,
      {arguments}) {
    return NavigatorUtils.pushNamedAndRemoveUntil(context, routeName,
        arguments:
            RouteArguments(type: AnimationType.push, arguments: arguments));
  }

  static Future fadeAndRemoveUntil(BuildContext context, String routeName,
      {arguments}) {
    return NavigatorUtils.pushNamedAndRemoveUntil(context, routeName,
        arguments:
            RouteArguments(type: AnimationType.fade, arguments: arguments));
  }

  ///
  /// [Future] ????????????pop???????????????
  /// [routeName] ?????????
  ///
  static Future model(BuildContext context, String routeName, {arguments}) {
    return NavigatorUtils.modelRoute(context, routeName,
        arguments:
            RouteArguments(type: AnimationType.model, arguments: arguments));
  }

  // ???????????????????????????
  static Future modelAndReplaced(BuildContext context, String routeName,
      {arguments}) {
    return NavigatorUtils.pushReplacement(context, routeName,
        arguments:
            RouteArguments(type: AnimationType.model, arguments: arguments));
  }

  // ????????????????????????????????????
  static Future modelAndRemoveUntil(BuildContext context, String routeName,
      {arguments}) {
    return NavigatorUtils.pushNamedAndRemoveUntil(context, routeName,
        arguments:
            RouteArguments(type: AnimationType.model, arguments: arguments));
  }
}

/// ??????????????????????????????
Route onGenerateRoute(RouteSettings settings) {
  String name = settings.name;
  RouteBuilder pageBuilder = _routes[name];
  RouteArguments arguments = settings.arguments;

  switch (arguments.type) {
    case AnimationType.model:
      {
        return CustomRoute(
            builder: (context) {
              return pageBuilder(context, arguments: arguments.arguments);
            },
            type: AnimationType.model);
      }
    case AnimationType.push:
      {
        return MaterialPageRoute(builder: (context) {
          return pageBuilder(context, arguments: arguments.arguments);
        });
      }

    case AnimationType.fade:
      {
        // return MaterialPageRoute(builder: (context) {
        //   return pageBuilder(context, arguments: arguments.arguments);
        // });
        return CustomRoute(
            builder: (context) {
              return pageBuilder(context, arguments: arguments.arguments);
            },
            type: AnimationType.fade);
      }
  }
}

/// ??????????????????????????????
class RouteArguments {
  // ????????????
  AnimationType type;

  // ????????????
  dynamic arguments;

  RouteArguments({this.type = AnimationType.push, this.arguments});
}
