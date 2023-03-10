/*
 * ====================================================
 * package   : constants
 * author    : Created by nansi.
 * time      : 2019/5/22  10:53 AM 
 * remark    : 
 * ====================================================
 */

import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/utils/print_util.dart';

class Api {
  static String host;
  static String domain;
  static String cdnDomin;

  static const String domainPro = "https://jyyapi.reecook.cn";
  static const String domainDev = "https://testapi.zjycshop.com";
  // static const String domainDev = "http://192.168.2.68:8080/";
  // static const String domainDev = "https://api.reecook.cn";

  static const String cdnDominPro = "https://jyyapi.reecook.cn";
  static const String cdnDominDev = "https://testcdn.zjycshop.com";
  // static const String cdnDominDev = "https://cdn.reecook.cn";

  static toggleEnvironment(bool debug) {
    if (debug) {
      domain = domainDev;
      cdnDomin = cdnDominDev;
    } else {
      domain = domainPro;
      cdnDomin = cdnDominPro;
    }
    host = "$domain/api";
  }

  static String getImgUrl(String url, {bool print = false}) {
    if (!TextUtils.isEmpty(url) && url.startsWith("http")) {
      return url;
    }
    if (print) {
      // DPrint.printf("$domain/static$url");
      DPrint.printf("$cdnDomin/static$url");
    }
    // return "$domain/static$url";
    return "$cdnDomin/static$url";
  }

  static String getResizeImgUrl(String url, int width, {bool print = false}) {
    if (url.startsWith("http")) {
      return url;
    }
    String resizeUrl = "$domain/api/v1/static/photo/resize$url/$width";
    // String resizeUrl = "$cdnDomin/static$url";
    if (print) {
      DPrint.printf("resizeUrl --- $resizeUrl");
    }

    return resizeUrl;
  }
}

class CommonApi {
  static const String upload = "/v1/files/photo/upload";
}

class ShopApi {
  static const String shop_index = "/v1/shop/shop_index";
  static const String shop_addup_income = "/v1/shop/shop_addup_income";
  static const String shop_self_income = "/v1/shop/shop_self_income";
  static const String shop_share_income = "/v1/shop/shop_share_income";
  static const String shop_team_income = '/v1/shop/shop_team_income';
  // static const String shop_summary = "/v1/shop/summary";
  static const String role_query_up_code = "/v1/users/role/query_up_code";
  static const String role_query_rule = "/v1/users/role/query_rule";
  static const String team_income_sum_list = "/v1/wallet/income/team/sum/list";
  static const String income_sales_sum_list =
      "/v1/wallet/income/sales/sum/list";
  static const String income_sales_list = "/v1/wallet/income/sales/list";
  static const String income_team_list = "/v1/wallet/income/team/list";

  static const String order_list_all = "/v1/shop/secondary/order/list";
  static const String order_list_undelivered =
      "/v1/shop/secondary/order/undelivered/list";
  static const String order_list_delivered =
      "/v1/shop/secondary/order/unreceive/list";
  static const String order_list_receipt =
      "/v1/shop/secondary/order/receive/list";
  static const String order_list_aftersale =
      "/v1/shop/secondary/order/goods/after_sales/list";
  static const String order_detail = "/v1/shop/secondary/order/detail";
}

class UserApi {
  static const String version_info = "/v1/users/profile/versionInfo";
  static const String self_income = "/v1/users/profile/my_info/self";
  static const String share_income = "/v1/users/profile/my_info/share";
  static const String team_income = "/v1/users/profile/my_info/team";
  // static const String brief_info = "/v1/users/profile/brief";
  static const String brief_info = "/v1/users/profile/my_info";
  static const String mine_invite_list = "/v1/users/profile/invite/list";
  static const String updateAvatar = "/v1/users/profile/head_pic/update";
  static const String updateNickname = "/v1/users/profile/nickname/update";
  static const String updateGender = "/v1/users/profile/gender/update";
  static const String updateBirthday = "/v1/users/profile/birthday/update";
  static const String user_lottery = "/v1/users/profile/lottery";
  static const String user_do_lottery = "/v1/users/profile/do_lottery";

  static const String updateAddress = "/v1/users/profile/address/update";
  static const String updatePhone = "/v1/users/profile/phone/update";
  static const String updateWechatNo = "/v1/users/profile/wechat-no/update";

  static const String realInfo = "/v1/users/profile/real_info";
  static const String realBinding = "/v1/users/profile/info/real/binding";
  static const String invite = "/v1/users/profile/invite/list";
  static const String diamond_recommand_list =
      "/v1/users/profile/invite/diamond";
  static const String invite_count = "/v1/users/profile/invite/count";
  static const String invite_remark_name =
      "/v1/users/profile/invite/remark-name/update";

  static const String wx_register = "/v1/users/profile/wx/register";
  static const String wx_login = "/v1/users/profile/wx/login";
  static const String wx_invitation = "/v1/users/profile/wx/invitation";
  static const String wx_binding = "/v1/users/profile/mobile/wx/binding";

  static const String phone_login_send_sms = "/v1/messages/login/sms/send";
  static const String phone_register = "/v1/users/profile/mobile/register";
  static const String phone_login = "/v1/users/profile/mobile/login";
  static const String auto_login = "/v1/users/profile/auto/login";
  static const String launch = "/v1/application/launch";

  static const String address_list = "/v1/users/address/list";
  static const String address_set_default = "/v1/users/address/default/update";
  static const String address_delete = "/v1/users/address/remove";
  static const String address_update = "/v1/users/address/update";

  static const String address_whole_province_city = "/v1/region/all";
  static const String address_new_address = "/v1/users/address/add";

  static const String rui_coin_list = "/v1/wallet/coin/coin_list";
  static const String coin_to_balance = "/v1/wallet/coin/coin_to_balance";
  static const String balance_list = "/v1/wallet/balance/list";
  static const String withdraw = "/v1/wallet/balance/withdraw";
  static const String income_unaccounted_list = "/v1/wallet/income/own/list";
  static const String withdraw_list = "/v1/wallet/balance/withdraw_list";
  static const String withdraw_detail = "/v1/wallet/balance/withdraw_detail";
  static const String balance_withdraw = "/v1/wallet/balance/balance_withdraw";

  static const String verify_sms_send = "/v1/messages/verify/sms/send";
  static const String verify_sms = "/v1/messages/verify/sms";
  static const String password_save = "/v1/wallet/pay/password/save";

  /// ???????????????
  static const String query_up_code = "/v1/users/role/query_up_code";

  /// ??????????????????????????????
  static const String give_code = "/v1/users/role/give_code";

  /// ??????????????????
  static const String upgrade_by_code = "/v1/users/role/upgrade_by_code";

  /// ???????????????
  static const String keep_by_code = "/v1/users/role/keep_by_code";

  ///????????????
  static const String deleteAccount = "/v1/users/profile/userDestroy";

  ///????????????
  static const String userInfo = '/v2/app/command/user/info';
}

class GoodsApi {
  static const String categories = "/v1/goods/categories/all";
  static const String brand_goods_sort_comprehensive =
      "/v1/goods/list/brand/comprehension";
  static const String brand_goods_sort_price = "/v1/goods/list/brand/price";
  static const String brand_goods_sort_sales = "/v1/goods/list/brand/sales";

  static const String goods_search_list = "/v1/goods/search/list";
  static const String goods_sort_comprehensive = "/v1/goods/comprehensive/list";
  static const String goods_sort_price = "/v1/goods/price/list";
  static const String goods_sort_sales = "/v1/goods/sales/list";
  static const String goods_detail_info = "/v1/goods/detail/summary";
  static const String goods_detail_info_new = "/v1/goods/detail/summary_new"; //1.13.3?????? ???????????????????????? ?????????????????????????????????????????????
  static const String goods_detail_images = "/v1/goods/detail/photo";
  static const String goods_detail_moments =
      "/v1/goods/detail/moments_copy/list";
  static const String goods_detail_moments_create = "/v1/moment_copy/create";
  static const String goods_favorite_add = "/v1/goods/favorites/add";
  static const String goods_favorite_list = "/v1/goods/favorite/list";
  static const String goods_favorite_cancel = "/v1/goods/favorites/cancel";

  static const String goods_add_shopping_cart =
      "/v1/goods/shopping_trolley/add";
  static const String shopping_cart_list = "/v1/goods/shopping_trolley/list";
  static const String shopping_cart_delete =
      "/v1/goods/shopping_trolley/remove";
  static const String shopping_cart_update_quantity =
      "/v1/goods/shopping_trolley/quantity/update";
  static const String shopping_cart_submit_order =
      "/v1/order_preview/shopping_trolley/create";

  static const String coupon_list = "/v1/coupon/list";
  static const String coupon_receive = "/v1/coupon/receive/user";
  static const String coupon_user_list = "/v1/coupon/user/list";

  static const String goods_evaluation_list = "/v1/goods/evaluations/list";

  static const String goods_sell_point_list = "/v1/goods/list/today/maidian";
  static const String goods_purchase_ranking =
      "/v1/goods/list/purchase/ranking";

  static const String goods_code_search = '/v1/goods/code/search';

  static const String keyWords = '/v1/goods/keyWords/es';//??????
}

class OrderApi {
  static const String order_list_all = "/v1/order/list/all";
  static const String order_list_unpaid = "/v1/order/list/unpaid";
  static const String order_list_undelivered = "/v1/order/list/undelivered";
  static const String order_list_receipt = "/v1/order/list/receipt";
  static const String order_list_aftersale = "/v1/order/list/unevaluated";

  static const String order_detail = "/v1/order/detail";
  static const String order_cancel = "/v1/order/cancel";
  static const String order_confirm_receipt = "/v1/order/receipt/confirm";
  static const String order_delete = "/v1/order/delete";
  static const String order_refund = "/v1/order/refund";
  static const String order_return = "/v1/order/return";
  static const String order_after_sales_log = "/v1/order/after_sales/log";
  static const String order_after_sales_goods_list =
      '/v1/order/after_sales/goods/list';
  // static const String order_return_detail = '/v1/order/return/goods/detail';
  static const String after_sales_goods_detail =
      '/v1/order/after_sales/goods/detail';
  static const String order_return_address = '/v1/official/return_address';
  static const String after_sales_express_fill =
      '/v1/order/after_sales/express/fill';

  static const String order_coin_onoff = "/v1/order_preview/coin_onoff";
  static const String order_create_preview = "/v1/order_preview/create";
  static const String order_normal_submit = "/v1/order/submit";
  static const String order_change_address = "/v1/order_preview/addr/update";
  static const String order_change_shipping_method =
      "/v1/order_preview/shipping_method/update";
  static const String order_change_buyer_message =
      "/v1/order_preview/buyer_message/update";
  static const String order_store_list = "/v1/order_preview/store/list";

  static const String order_query_recook_pay_fund =
      "/v1/pay/recookpay/fund/query";
  static const String order_wechat_order_create = "/v1/pay/wxpay/order/create";
  static const String order_alipay_order_create = "/v1/pay/alipay/order/create";

  static const String order_recook_pay_order_create =
      "/v1/pay/recookpay/order/create";

  static const String order_verify_pay_status = "/v1/pay/order/query";
  static const String order_verify_pay_status_lifang =
      "/v2/app/liFang_ticketing/order_pay/pay/status";

  static const String order_pay_zero = "/v1/pay/zeropay/order/create";

  static const String order_wechat_order_create_lifang =
      "/v2/app/liFang_ticketing/order_pay/pay/wx_pay_order";
  static const String order_alipay_order_create_lifang =
      "/v2/app/liFang_ticketing/order_pay/pay/ali_pay_order";

  static const String express_company_list = "/v1/order/express/company/list";
  static const String express_logistic = "/v1/order/express/query";
  static const String return_reasons = "/v1/order/get_after_sales/resson";
  static const String invoice_apply = "/v1/order/invoice/apply";
  static const String invoice_list = "/v1/users/invoice/list";
  static const String invoice_add = "/v1/users/invoice/create";

  static const String evaluation_add = "/v1/order/evaluation/create";

  ///??????????????????
  static const String orderReview = "/v1/order/evaluation/orderEvaluationList";

  ///????????????????????????
  static const String addReview =
      "/v1/order/evaluation/createOrderEvaluationOne";

  ///????????????????????????
  static const String checkReview = "/v1/order/evaluation/evaluationDea";
}

class HomeApi {
  static const String notice_list = "/v1/users/notice/list";
  static const String banner_list = "/v1/diamond_show/list";
  static const String promotion_list = "/v1/goods/list/promotion";
  static const String promotion_goods_list = "/v1/goods/list/promotion/goods";
  static const String activity_list = "/v1/activity/list/query";
  static const String hot_sell_list = "/v1/goods/hot_sell/list";
  static const String recook_make = "/v1/goods/recook_make/list";
  static const String digital_list = "/v1/goods/digital/list";
  static const String home_live_list = "/v1/goods/home_live/list";
  static const String tehui_xinren = "/v1/goods/list/tehui/xinren";
  //show
  static const String showController = "/v1/show/get";
  ///??????????????????
  static const String preferentialList= '/v1/goods/recommend/list';
}

class AttentionApi {
  static const String attention_create = "/v1/attention/create";
  static const String attention_cancel = "/v1/attention/cancel";
  static const String attention_list = "/v1/attention/list/moment_copy";
  static const String attention_recommend_list =
      "/v1/attention/moment_copy/recommend/list";
}

class WebApi {
  static const String recookHttp = "https://reecook.cn/";
  // static const String inviteRegist = "${recookHttp}download.html?code=";
  static const String goodsDetail = "https://jyyh5.reecook.cn/#/goods/detail/";

  static const String inviteRegist =
      "https://jyyh5.reecook.cn/#/user/appRegister/";



  static const String invitePoster = "/v1/shop/share_photo/";
  static const String diamondsInviteRegist =
      "https://h5.reecook.cn/#/user/diamonds/";

  static const String testGoodsDetail =
      "http://testh5.reecook.cn/#/goods/detail/";

  ///???????????????????????????
  static const String testMiniQrcodeGoodsDetail =
      'http://testh5.reecook.cn/goods/detail';

  ///??????????????????
  static const String miniQrcodeGoodsDetail =
      'https://h5.reecook.cn/goods/detail';

  static const String testInviteRegist =
      "http://testh5.reecook.cn/#/user/appRegister/";
  static const String testDiamondsInviteRegist =
      "http://testh5.reecook.cn/#/user/diamonds/";

  static const String aboutUs = "${recookHttp}introduction.html";
  static const String businessCooperation = "${recookHttp}business.html";
  static const String argumentsUrl = "https://h5.reecook.cn/agreement.html";

  static const String privacy = "https://jyycdn.reecook.cn/privacy.html";//????????????
  static const String agreement = "https://jyycdn.reecook.cn/protocol.html";//????????????

  static const String feedback = "${recookHttp}feedback.html";
  static const String iOSUrl = "itms-apps://itunes.apple.com/app/id1601169177";
  // static const String iOSUrl = "https://apps.apple.com/app/id1477928534";
  static const String androidUrl =
      "https://a.app.qq.com/o/simple.jsp?pkgname=com.akuhome.jingyaoyun";

  ///???????????????????????????????????????
  static const String liveUrl = 'https://h5.reecook.cn/#/live/item/';

  ///???????????????????????????????????????
  static const String testLiveUrl = 'https://testh5.reecook.cn/#/live/item/';
}

class InvoiceApi {
  ///?????????????????????????????????
  static const String canGetBill = "/v1/order/bill/canGetBill";

  ///????????????????????????
  static const String letterHeadList = "/v1/order/bill/letterheadList";

  ///??????????????????
  static const String addLetterHead = "/v1/order/bill/addLetterhead";

  ///????????????
  static const String createbill = "/v1/order/bill/create";

  ///??????????????????
  static const String getBillList = "/v1/order/bill/getBillList";

  ///????????????
  static const String detail = "/v1/order/bill/getBillDetail";
}

class SystemApi {
  // String system;
  // ????????????
  factory SystemApi() => _getInstance();
  static SystemApi get instance => _getInstance();
  static SystemApi _instance;
  SystemApi._internal() {
    // ?????????
    // system = "";
  }
  static SystemApi _getInstance() {
    if (_instance == null) {
      _instance = new SystemApi._internal();
    }
    return _instance;
  }
}

///????????????API
class LotteryAPI {
  ///??????????????????
  static const String list = "/v1/ticket/list";

  ///????????????????????????
  static const String history = "/v1/ticket/history";

  ///??????????????????????????????
  static const String redeem_history = "/v1/ticket/order/list";

  ///????????????
  static const String redeem_shots = "/v1/ticket/bet";

  ///??????????????????
  static const String lottery_order_detail = "/v1/ticket/order/info";
}

///????????????
class LiveAPI {
  ///????????????
  static const String shopWindow = '/v1/live/cupboard/list';

  ///??????????????????
  static const String deleteShopWindow = '/v1/live/cupboard/delete';

  ///??????????????????
  static const String baseInfo = '/v1/live/user/baseinfo';

  ///????????????
  static const String followList = '/v1/live/user/follow/list';

  ///????????????
  static const String addFollow = '/v1/live/user/follow/add';

  ///????????????
  static const String cancelFollow = '/v1/live/user/follow/cancel';

  ///??????????????????
  static const String topicBaseInfo = '/v1/live/topic/info';

  ///????????????
  static const String topicList = '/v1/live/topic/follow/list';

  ///????????????
  static const String topicAddNew = '/v1/live/topic/add';

  ///????????????
  static const String addTopic = '/v1/live/topic/follow/add';

  /// ??????????????????
  static const String cancelTopic = '/v1/live/topic/follow/cancel';

  ///??????????????????
  static const String topicContentList = '/v1/live/topic/content/list';

  ///????????????
  static const String videoList = '/v1/live/short/list';

  ///????????????
  static const String activityList = '/v1/live/user/trend/list';

  ///??????????????????
  static const String activityReview = '/v1/live/user/trend/comment/list';

  ///????????????????????????
  static const String addActivityReview = '/v1/live/user/trend/comment/add';

  ///??????????????????
  static const String likeActivity = '/v1/live/user/trend/praise/add';

  ///????????????????????????
  static const String dislikeActivity = '/v1/live/user/trend/praise/cancel';

  ///??????????????????
  static const String likeComment = '/v1/live/user/trend/comment/praise/add';

  ///????????????????????????
  static const String dislikeComment =
      '/v1/live/user/trend/comment/praise/cancel';

  ///????????????
  static const String hotTopics = '/v1/live/topic/hot';

  ///???????????????????????????
  static const String topicSearchList = '/v1/live/topic/list';

  ///????????????
  static const String historyGoods = '/v1/live/order/history';

  ///????????????
  static const String goodsList = '/v1/live/goods/list';

  ///????????????
  static const String liveList = '/v1/live/live/list';

  ///??????????????????
  static const String liveAttentionList = '/v1/live/live/follow_list';

  ///?????????????????????????????????IM??????
  static const String tencentUser = '/v1/live/live/im/login_info';

  ///?????????????????????????????????IM??????
  static const String tencentUserNotLogin = '/v1/live/live/im/no_login_info';

  ///????????????????????????
  static const String startLive = '/v1/live/live/start';

  ///???????????????
  static const String liveStreamInfo = '/v1/live/live/live_info';

  ///??????????????????
  static const String livePlaybackInfo = '/v1/live/live/video_info';

  ///??????????????????
  static const String liveBrandList = '/v1/live/goods/brandlist';

  ///????????????????????????
  static const String liveBrandDetailList = '/v1/live/goods/brandgoodslist';

  ///????????????????????????
  static const String liveDataList = '/v1/live/live/data/list';

  ///????????????
  static const String exitLive = '/v1/live/live/stop';

  ///??????????????????
  static const String dataCount = '/v1/live/live/data/count';

  ///???????????????????????????
  static const String uploadKey = '/v1/live/short/upload_sign';

  ///???????????????
  static const String pushVideo = '/v1/live/short/publish';

  ///????????????????????????
  static const String liveDataDetail = '/v1/live/live/data/info';

  ///??????????????????????????????
  static const String activityVideoList = '/v1/live/user/live/list';

  ///????????????
  static const String liveLike = '/v1/live/live/praise/add';

  ///????????????
  static const String liveStartExplain = '/v1/live/live/explain';

  ///????????????
  static const String liveStopExplain = '/v1/live/live/un_explain';

  ///????????????
  static const String reportType = '/v1/live/live/report/types';

  ///??????
  static const String report = '/v1/live/live/report/submit';

  ///????????????
  static const String buyGoodsInform = '/v1/live/live/im/buy_goods';

  ///?????????????????????
  static const String getLiveUsers = '/v1/live/live/user_data';

  ///??????????????????????????????
  static const String getLiveInfo = '/v1/live/live/info';

  ///????????????
  static const String liveLicense = '/v1/live/live/license';

  ///??????????????????
  static const String liveAgree = '/v1/live/live/agree';

  static const String recordLive = '/v1/live/live/transcribe';

  ///??????????????????
  static const String hotGoods = '/v1/live/goods/hot';

  ///???????????????
  static const String cartList = '/v1/live/car/list';

  ///?????????????????????
  static const String addToCart = '/v1/live/car/add';

  ///?????????????????????
  static const String removeFromCart = '/v1/live/car/delete';
}
