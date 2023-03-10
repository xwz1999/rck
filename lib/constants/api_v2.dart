class APIV2 {
  static UserAPI userAPI = UserAPI();
  static BenefitAPI benefitAPI = BenefitAPI();
  static _OrderAPI orderAPI = _OrderAPI();
  static _InvoiceAoi invoiceApi = _InvoiceAoi();
  static TicketAPI ticketAPI = TicketAPI();
  static GoodsAPI goodsAPI = GoodsAPI();
}

class UserAPI {
  ///我的收益
  String get userBenefit => '/v2/app/user/income';

  ///余额信息
  String get balanceInfo => '/v2/app/user/balance/info';

  ///月余额记录信息
  String get balanceMonthHistory => '/v2/app/user/balance/month_history';

  ///累计收益
  String get accumulate => '/v2/app/user/income/accumulate';

  //历史累计收益
  String get oldIncome => '/v2/app/user/income/history';

  ///年度月收益
  String get monthIncome => '/v2/app/user/income/month_income';

  ///累计自购收益
  String get selfIncome => '/v2/app/user/income/purchase_accumulate';

  ///累计导购收益
  String get guideIncome => '/v2/app/user/income/guide_accumulate';

  ///累计团队收益
  String get teamIncome => '/v2/app/user/income/team_income';

  ///累计推荐收益
  String get recommandIncome => '/v2/app/user/income/recommend_income';

  ///累计平台奖励
  String get platformIncome => '/v2/app/user/income/reward_income';

  ///月度日收益
  ///
  ///包含`自购收益`和`导购收益`
  String get monthDetail => '/v2/app/user/income/day_income';

  ///团队月收益详情
  String get groupDetail => '/v2/app/user/income/team_month_income';

  ///月推荐收益详情
  String get recommendDetail => '/v2/app/user/income/recommend_month_income';

  ///月平台奖励收益详情
  String get platformDetail => '/v2/app/user/income/reward_month_income';

  ///未到账收益
  String get notReceivedDetail => '/v2/app/user/income/nr/detail';

  ///到账收益
  String get receivedDetail => '/v2/app/user/income/detail';

  ///店铺未到账收益
  String get groupNotReceivedDetail => '/v2/app/user/income/team/nr/detail';

  ///店铺到账收益
  String get groupReceivedDetail => '/v2/app/user/income/team/detail';

  ///店铺未到账收益日
  String get groupNotReceivedDay => '/v2/app/user/income/day_expect_team';

  ///店铺自营已到账收益月
  String get groupSelfReceivedMonth => '/v2/app/user/income/team_month_income';

  ///店铺分销已到账收益月
  String get groupDistributionReceivedMonth =>
      '/v2/app/user/income/recommend_month_income';

  ///店铺代理已到账收益月
  String get groupAgentReceivedMonth =>
      '/v2/app/user/income/reward_month_income';

  ///我的团队列表
  String get myGroup => '/v2/app/user/team';

  ///我的推荐列表
  String get myRecommend => '/v2/app/user/recommend';

  ///我的奖励列表
  String get myReward => '/v2/app/user/reward';

  ///推荐升级钻石
  String get recommendDiamond => '/v2/app/user/recommend_diamond';

  ///用户角色变动
  String get userLottery => '/v2/app/user/lottery';

  ///确认角色变动
  String get agreeLottery => '/v2/app/user/lottery_agree';

  String get userCheck => '/v2/app/user/check';

  String get memberInfo => '/v2/app/user/member/info';

  ///角色卡列表
  String get userCard => '/v2/app/user/welfare/lists';

  ///使用角色卡
  String get useCard => '/v2/app/user/welfare/use';

  ///赠送角色卡
  String get giveCard => '/v2/app/user/welfare/give';

  ///角色卡通知列表
  String get userCardNoticeList => '/v2/app/user/welfare/notice/list';

  ///确认角色卡变动
  String get confirmUserCardChange => '/v2/app/user/welfare/notice/look';

  ///会员隐私开关
  String get securePhone => '/v2/app/user/secret';

  String get userSaleAmount => '/v2/app/user/sale';

  ///二维码扫描
  String get getScanResult => '/v2/app/operate/scan';

  ///注销短信发送
  String get getDeleteMessage => '/v2/app/message/destroy/send';

  ///注销账户
  String get deleteAccount => '/v2/app/user/operation/destroy';

  ///更新活跃人数
  String get activePeople => '/v2/app/evaluation/active_people';

  ///删除图文或者视频
  String get deleteImageOrVideo => '/v2/app/evaluation/del_image_video';

  ///上传极光id
  String get updateJId => '/v2/app/jPush/update_Id';

  ///选择进口国家
  String get getCountryList => '/v2/app/abroad/countryList';

  ///选择国家下的类目
  String get getCategoryList => '/v2/app/abroad/category_list';

  ///展示进口商品列表
  String get getViewGoods => '/v2/app/abroad/view_goods';

  ///获取金刚区
  String get getKingCion => '/v2/app/aku_school/king_coin_list';

  ///获取金刚区新
  String get getKingCionNew => '/v2/app/aku_school/king_coin_list_new';

  ///搜索国家
  String get findCountry => '/v2/app/abroad/search_country';

  ///阿库学院视频
  String get getAkuVideoList => '/v2/app/aku_school/school_list';

  ///阿库学院浏览量+1
  String get addHits => '/v2/app/aku_school/add_hits';

  ///获取购物车可能喜欢商品列表
  String get getLikeGoodsList => '/v2/app/shopping_cart/view_like_maybe';

  ///购物车找相似接口
  String get getSimilarGoodsList => '/v2/app/shopping_cart/view_like';

  ///解除微信绑定
  String get wechatUnboundhandle => '/v2/app/command/user/unbundling_wx';


  ///搜索栏的关键字
  String get getKeyWords => '/v2/app/aku_school/search_word';

  ///推荐用户审升级
  String get recommendUser => '/v2/app/apply/create';

  ///申请记录列表
  String get recommendUserList => '/v2/app/apply/list';


  ///发送验证码
  String get sendRecommendCode => '/v2/app/apply/send';


}

class BenefitAPI {
  ///日收益详情
  String get dayIncome => '/v2/app/user/income/day_incomes';

  ///月收益详情
  String get monthIncome => '/v2/app/user/income/month_incomes';

  ///日自购导购预估收益
  String get dayExpect => '/v2/app/user/income/day_expect';

  ///月自购导购预估收益
  String get monthExpect => '/v2/app/user/income/month_expect';

  ///日团队推荐平台预估收益
  String get dayExpectExtra => '/v2/app/user/income/day_expect_team';

  ///月团队推荐平台预估收益
  String get monthExpectExtra => '/v2/app/user/income/month_expect_team';

  ///会员收益数据
  String get incomeData => '/v2/app/user/profit';
}

class _OrderAPI {
  ///导购订单列表
  String get guideOrderList => '/v2/app/order/guide_lists';
}

class GoodsAPI {
  ///产品画像
  String get getProductPortrait =>
      '/v2/app/product_portrait/goods_detail_about';

  ///获取失踪儿童的信息
  String get getMissingChildrenInfo => '/v2/app/shopping_cart/missing_children';


  ///获取秒杀列表
  String get getSeckillList => '/v2/app/flash_sale/show_list';


  ///获取京东商品类目
  String get getJDCategoryList => '/v2/app/jcook/category';

  ///获取京东商品是否有库存
  String get getJDStock => '/v2/app/jcook/stock';



}

class _InvoiceAoi {
  ///用户可开票订单列表
  String get canInvoiceBill => '/v2/app/order/can_bill_list';

  ///显示用户抬头列表
  String get invoiceList => '/v2/app/order/invoice_user_list';

  ///添加常用开票抬头（包括修改功能）
  String get addInvocieTitle => '/v2/app/order/add_invoice_title';

  ///用户申请开票
  String get applyInvoice => '/v2/app/order/apply_invoice';

  ///获取用户开票记录
  String get invoiceRecord => '/v2/app/order/invoice_history';

  ///显示单个开票详情
  String get invoiceDetail => '/v2/app/order/invoice_one_detail';
}

class TicketAPI {
  ///常用乘客列表
  String get getPassagerList =>
      '/v2/app/liFang_ticketing/plane_ticket/air_user_list';

  ///增加常用乘客
  String get addPassager =>
      '/v2/app/liFang_ticketing/plane_ticket/air_user_add';

  ///删除常用乘客
  String get deletePassager =>
      '/v2/app/liFang_ticketing/plane_ticket/air_user_del';

  ///查询飞机票标准商品列表
  String get getAirTicketGoodsList =>
      '/v2/app/liFang_ticketing/plane_ticket/air_items_list';

  ///查询飞机票商品货源详情
  String get getAirTicketGoodsSource =>
      '/v2/app/liFang_ticketing/plane_ticket/air_item_detail';

  ///显示城市和机场站点
  String get getCityAirportList =>
      '/v2/app/liFang_ticketing/plane_ticket/airport_city';

  ///两个城市/站点之前的航线
  String get getAirLineList =>
      '/v2/app/liFang_ticketing/plane_ticket/airport_city_line';

  ///订单列表
  String get getAirOrderList =>
      '/v2/app/liFang_ticketing/plane_ticket/air_user_order_list';

  ///改变订单状态为取消订单
  String get changeOrderStatus =>
      '/v2/app/liFang_ticketing/plane_ticket/air_user_add_order_success';

  //提交订单接口
  String get submitAirOrder =>
      '/v2/app/liFang_ticketing/plane_ticket/air_user_add_order';

  //飞机票订单支付
  String get airOrderPayLifang =>
      '/v2/app/liFang_ticketing/plane_ticket/air_order_payBill';
}
