/*
 * ====================================================
 * package   : pages.user
 * author    : Created by nansi.
 * time      : 2019/5/13  2:17 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:recook/pages/goods/report_form/report_form_page.dart';
import 'package:recook/pages/user/user_benefit_currency_pag.dart';
import 'package:recook/pages/user/user_benefit_page.dart';
import 'package:recook/pages/user/user_benefit_sub_page.dart';
import 'package:recook/pages/user/user_old_history_benefit_page.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/shop_summary_model.dart';
import 'package:recook/models/user_brief_info_model.dart';
import 'package:recook/models/user_model.dart';
import 'package:recook/pages/upgradeCard/function/user_card_function.dart';
import 'package:recook/pages/user/functions/user_benefit_func.dart';
import 'package:recook/pages/user/model/user_income_data_model.dart';
import 'package:recook/pages/user/order/order_after_sale_page.dart';
import 'package:recook/pages/user/order/order_center_page.dart';
import 'package:recook/pages/user/user_history_benefit_page.dart';
import 'package:recook/pages/user/widget/capital_view.dart';
import 'package:recook/pages/user/widget/money_view.dart';
import 'package:recook/pages/user/widget/order_central_view.dart';
import 'package:recook/pages/user/widget/other_item_view_v2.dart';
import 'package:recook/pages/user/widget/shop_check_view.dart';
import 'package:recook/pages/user/widget/shop_manager_view.dart';
import 'package:recook/pages/user/widget/user_app_bar_v2.dart';
import 'package:recook/redux/recook_state.dart';
import 'package:recook/third_party/wechat/wechat_utils.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/utils/versionInfo/version_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/widgets/toast.dart';

import 'benefit_view_gen.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends BaseStoreState<UserPage> {
  bool _weChatLoginLoading = false;
  GSRefreshController _refreshController;
  String _capital; //提现金额
  bool _isFirstLoad = true;
  double _allBenefitAmount = 0;

  double _target = 100;
  double _amount = 0;
  int _cardType = 0;
  int _cardCount = 0;
  bool get _fullCheck {
    // bool isGold = UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Gold;
    // bool isSilver = UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Silver;

    if (_cardType == 1 || _cardType == 2) return true;
    return false;
  }

  // GlobalKey<ShopBenefitViewState> _shopBenefitKey =
  //     GlobalKey<ShopBenefitViewState>();
  UseerIncomeDataModel _userIncomeDataModel;
  @override
  bool get wantKeepAlive => true;

  @override
  bool needStore() {
    return true;
  }

  @override
  void initState() {
    super.initState();
    _refreshController = GSRefreshController(initialRefresh: true);
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      if (_isFirstLoad) {
        _isFirstLoad = false;
      } else {
        return;
      }
      // VersionTool.checkVersionInfo(context);
      // _showUpDateAlert();
    });
  }

  @override
  void deactivate() {
    DPrint.printf("userpage deactivate");
    super.deactivate();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 245, 247),
      body: _bodyWidget(context, store),
    );
  }

  Widget _buildNestedScrollView(
      BuildContext context, Store<RecookState> store) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(child: UserAppBarV2()),
        ];
      },
      body: _buildRefreshScrollView(context, store),
    );
    // return Container(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: <Widget>[
    //       UserAppBarV2(),
    //       // Container(
    //       //   height: 160 + ScreenUtil.statusBarHeight,
    //       //   child: UserAppBar(
    //       //     withdrawListener: () {
    //       //       AppRouter.push(context, RouteName.USER_CASH_WITHDRAW_PAGE,
    //       //           arguments: UserCashWithdrawPage.setArguments(
    //       //               amount: getStore().state.userBrief.balance.toDouble()));
    //       //     },
    //       //     userListener: () {
    //       //       push(RouteName.USER_INFO_PAGE);
    //       //     },
    //       //   ),
    //       // ),
    //       Expanded(
    //         child: _buildRefreshScrollView(context, store),
    //       ),
    //     ],
    //   ),
    // );
  }

  _updateUserBriefInfo() {
    UserManager.instance.updateUserBriefInfo(getStore()).then((success) {
      if (success) {
        if (UserManager.instance.user.info.roleLevel !=
            getStore().state.userBrief.roleLevel) {
          UserManager.instance.user.info.roleLevel =
              getStore().state.userBrief.roleLevel;
          UserManager.instance.refreshUserRole.value =
              !UserManager.instance.refreshUserRole.value;
          UserManager.updateUserInfo(getStore());
        }
        _refreshController.refreshCompleted();
      }
    });
  }

  ///更新累计收益
  _updateAllAmount() {
    UserBenefitFunc.accmulate().then((value) {
      _allBenefitAmount = value.data.allAmount;
    });
  }

  _updateCheck() async {
    ///yeah, this is sh*t code,but its a simple way.
    ResultData result = await HttpManager.post(
      APIV2.userAPI.userCheck,
      {'month': DateUtil.formatDate(DateTime.now(), format: 'yyyy-MM')},
    );
    if (result.data != null && result.data['data'] != null) {
      _amount = (result.data['data']['amount'] ?? 0) + .0;
      _target = (result.data['data']['needAmount'] ?? 100) + .0;
    }
  }

  _updateNewBenefit() async {
    ResultData result = await HttpManager.post(APIV2.benefitAPI.incomeData, {});
    if (result.data != null && result.data['data'] != null) {
      _userIncomeDataModel = UseerIncomeDataModel.fromJson(result.data['data']);
    }
  }

  Widget _buildRefreshScrollView(
      BuildContext context, Store<RecookState> store) {
    return Stack(
      children: <Widget>[
        // Container(color: AppColor.themeColor,height: 60*2.h),
        RefreshWidget(
          headerTriggerDistance: rSize(80),
          color: Colors.black,
          controller: _refreshController,
          releaseText: "松开更新个人数据",
          idleText: "下拉更新个人数据",
          refreshingText: "正在更新个人数据...",
          onRefresh: () async {
            VersionTool.checkVersionInfo(context);
            // _shopBenefitKey.currentState.updateBenefit();
            _updateUserBriefInfo();
            _updateAllAmount();
            await _updateCheck();
            _cardCount = await UserCardFunction.count();
            await _updateNewBenefit();
            setState(() {});
          },
          body: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            // physics: BouncingScrollPhysics(),
            children: <Widget>[
              MoneyView(
                listener: _moneyViewListener,
                wechatListener: _wechatBindinghandle,
              ),
              CapitalView(cardCount: _cardCount),
              UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.Vip
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: _buildDetailReward(),
                    )
                  : SizedBox(),
              SizedBox(
                height: AppConfig.getShowCommission() ? 10 : 0,
              ),
              // UserPageAssetsView(),
              ...[
                _renderBenefitCard(
                  leadingPath: R.ASSETS_USER_PINK_BUYER_WEBP,
                  title: '自购收益',
                  alertTitle: '自购收益',
                  alertContent: '您本人下单并确认收货后，您获得的佣金。'.text.black.make(),
                  title1: '未到账收益(瑞币)',
                  title3: '已到账收益(瑞币)',
                  content1:
                      _userIncomeDataModel?.purchase?.expectAmountValue ?? '0',
                  content2:
                      _userIncomeDataModel?.purchase?.expectCountValue ?? '0',
                  content3: _userIncomeDataModel?.purchase?.amountValue ?? '0',
                  content4: _userIncomeDataModel?.purchase?.countValue ?? '0',
                ),
                _renderBenefitCard(
                  leadingPath: R.ASSETS_USER_PINK_SHARE_WEBP,
                  title: '导购收益',
                  alertTitle: '导购收益',
                  alertContent: '会员通过您导购的商品链接，购买并确认收货的佣金收益'.text.black.make(),
                  title1: '未到账收益(瑞币)',
                  title3: '已到账收益(瑞币)',
                  content1:
                      _userIncomeDataModel?.guide?.expectAmountValue ?? '0',
                  content2:
                      _userIncomeDataModel?.guide?.expectCountValue ?? '0',
                  content3: _userIncomeDataModel?.guide?.amountValue ?? '0',
                  content4: _userIncomeDataModel?.guide?.countValue ?? '0',
                ),
                if (_userIncomeDataModel?.hasTeamValue ?? false)
                  _renderBenefitCard(
                    leadingPath: R.ASSETS_USER_PINK_GROUP_WEBP,
                    title: '店铺补贴',
                    alertTitle: '店铺补贴',
                    alertContent: Builder(
                      builder: (context) {
                        //role == UserRoleLevel.Diamond_1 || role == UserRoleLevel.Diamond_2 || role == UserRoleLevel.Diamond_3
                        UserRoleLevel role =
                            UserLevelTool.currentRoleLevelEnum();

                        final part1 = [
                          TextSpan(
                            text: '自营店铺补贴',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text:
                                  '：每月1日结算您自营店铺上一个自然月确认收货的订单，按自营店铺销售额的3%计算补贴。\n'),
                        ];
                        final part2 = [
                          TextSpan(
                            text: '分销店铺补贴',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text:
                                  '：每月1日结算您分销店铺上一个自然月确认收货的订单，按分销店铺销售额的4%计算补贴。\n'),
                        ];
                        final part3 = [
                          TextSpan(
                            text: '代理店铺补贴',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text:
                                  '：每月1日结算您代理店铺上一个自然月确认收货的订单，按代理店铺销售额的5%计算补贴。\n'),
                        ];
                        return Text.rich(TextSpan(
                          children: [
                            ...part1,
                            if (role == UserRoleLevel.Gold ||
                                role == UserRoleLevel.Silver ||
                                role == UserRoleLevel.Diamond_1 ||
                                role == UserRoleLevel.Diamond_2 ||
                                role == UserRoleLevel.Diamond_3)
                              ...part2,
                            if (role == UserRoleLevel.Diamond_1 ||
                                role == UserRoleLevel.Diamond_2 ||
                                role == UserRoleLevel.Diamond_3)
                              ...part3,
                          ],
                          style: TextStyle(
                            color: Color(0xFF333333),
                          ),
                        ));
                      },
                    ),
                    title1: '未到账补贴(瑞币)',
                    title3: '已到账补贴(瑞币)',
                    content1:
                        _userIncomeDataModel?.team?.expectAmountValue ?? '0',
                    content2:
                        _userIncomeDataModel?.team?.expectCountValue ?? '0',
                    content3: _userIncomeDataModel?.team?.amountValue ?? '0',
                    content4: _userIncomeDataModel?.team?.countValue ?? '0',
                  ),
              ].sepWidget(separate: 20.hb),
              20.w.heightBox,
              // ShopBenefitView(key: _shopBenefitKey),
              UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Gold ||
                      UserLevelTool.currentRoleLevelEnum() ==
                          UserRoleLevel.Silver
                  ? ShopCheckView(
                      target: _fullCheck ? _amount : _target,
                      amount: _amount,
                    )
                  : SizedBox(),
              OrderCentralView(
                clickListener: (int index) {
                  if (index == 4) {
                    AppRouter.push(context, RouteName.USER_REVIEW_PAGE);
                    return;
                  }
                  if (index == 5) {
                    AppRouter.push(
                        context, RouteName.ORDER_AFTER_SALE_GOODS_LIST,
                        arguments: OrderAfterSalePage.setArguments(
                            OrderAfterSaleType.userPage, null, null));
                    return;
                  }
                  push(RouteName.ORDER_LIST_PAGE,
                      arguments: OrderCenterPage.setArguments(index));
                },
              ),
              20.w.heightBox,
              ShopManagerView(),

              // OtherItemView(),
              OtherItemViewV2(),
            ],
          ),
        ),
      ],
    );
  }

  Future<ShopSummaryModel> _getShopSummary() async {
    ResultData resultData = await HttpManager.post(ShopApi.shop_index, {
      "userId": UserManager.instance.user.info.id,
    });
    if (!resultData.result) {
      if (mounted) {
        showError(resultData.msg);
      }
      return null;
    }
    ShopSummaryModel model = ShopSummaryModel.fromJson(resultData.data);
    // String jsonString = jsonEncode(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      if (mounted) {
        showError(model.msg);
      }
      return null;
    }
    return model;
  }

  Widget _renderBenefitCard({
    @required String leadingPath,
    @required String title,
    @required String alertTitle,
    @required Widget alertContent,
    @required String title1,
    @required String title3,
    @required String content1,
    @required String content2,
    @required String content3,
    @required String content4,
    UserBenefitPageType type = UserBenefitPageType.SELF,
  }) {
    if (title == "自购收益") {
      type = UserBenefitPageType.SELF;
    } else if (title == "导购收益") {
      type = UserBenefitPageType.GUIDE;
    } else if (title == "店铺补贴") {
      type = UserBenefitPageType.TEAM;
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          18.w.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              14.w.widthBox,
              Image.asset(
                leadingPath,
                width: 32.rw,
                height: 32.rw,
              ),
              title.text.size(16.rsp).black.make(),
              MaterialButton(
                padding: EdgeInsets.all(4.rw),
                minWidth: 0,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Icon(
                  Icons.help_outline,
                  size: 12.rw,
                  color: Color(0xFFA5A5A5),
                ),
                onPressed: () {
                  Alert.show(
                      context,
                      NormalContentDialog(
                        title: alertTitle,
                        content: alertContent,
                        items: ["确认"],
                        listener: (index) {
                          Alert.dismiss(context);
                        },
                      ));
                },
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  //Get.to(ReportFormPage()); //加载报表数据
                },
                child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        '图表分析'
                            .text
                            .size(12.rsp)
                            .color(Color(0xFF999999))
                            .make(),
                        Container(
                          padding: EdgeInsets.only(top: 2.rw),
                          child: Icon(
                            Icons.chevron_right_outlined,
                            size: 16.rw,
                            color: Color(0xFFA5A5A5),
                          ),
                        ),
                      ],
                    )),
              ),
              29.w.widthBox,
            ],
          ),
          8.w.heightBox,
          Divider(
            indent: 32.w,
            endIndent: 32.w,
            color: Color(0xFFEEEEEE),
            height: 2.w,
            thickness: 2.w,
          ),
          18.w.heightBox,
          Row(
            children: [
              Row(
                children: [
                  40.w.widthBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomImageButton(
                        onPressed: () {
                          Get.to(() => UserBenefitCurrencyPage(
                              type: type, receivedType: "未到账"));
                        },
                        child: Column(
                          children: [
                            title1.text
                                .color(Color(0xFF999999))
                                .size(12.rsp)
                                .make(),
                            20.w.heightBox,
                            content1.text.black.size(16.rsp).make(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomImageButton(
                        onPressed: () {
                          Get.to(() => UserBenefitCurrencyPage(
                              type: type, receivedType: "未到账"));
                        },
                        child: Column(
                          children: [
                            '订单数'
                                .text
                                .color(Color(0xFF999999))
                                .size(12.rsp)
                                .make(),
                            20.w.heightBox,
                            content2.text.black.size(16.rsp).make(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  32.w.widthBox,
                ],
              ).expand(),
              Container(
                height: 28.rw,
                width: 1.rw,
                color: Color(0xFFEEEEEE),
              ),
              Row(
                children: [
                  32.w.widthBox,
                  CustomImageButton(
                    onPressed: () {
                      Get.to(() => UserBenefitCurrencyPage(
                          type: type, receivedType: "已到账"));
                    },
                    child: Column(
                      children: [
                        title3.text
                            .color(Color(0xFF999999))
                            .size(12.rsp)
                            .make(),
                        20.w.heightBox,
                        content3.text.black.size(16.rsp).make(),
                      ],
                    ),
                  ),
                  Spacer(),
                  CustomImageButton(
                    onPressed: () {
                      Get.to(() => UserBenefitCurrencyPage(
                          type: type, receivedType: "已到账"));
                    },
                    child: Column(
                      children: [
                        '订单数'.text.color(Color(0xFF999999)).size(12.rsp).make(),
                        20.w.heightBox,
                        content4.text.black.size(16.rsp).make(),
                      ],
                    ),
                  ),
                  48.w.widthBox,
                ],
              ).expand(),
            ],
          ),
          30.w.heightBox,
        ],
      ),
    );
  }

  _buildDetailReward() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
          height: 40,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/shop_page_appbar_detail_bg.png',
                    fit: BoxFit.cover,
                  )),
              AppConfig.getShowCommission()
                  ? CustomImageButton(
                      onPressed: () {
                        Get.to(() => UserHistoryBenefitPage());
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        height: 40,
                        child: Row(
                          children: <Widget>[
                            Text(
                              "累计收益",
                              style: AppTextStyle.generate(16,
                                  fontWeight: FontWeight.w700),
                            ),
                            MaterialButton(
                              padding: EdgeInsets.only(top: 3, left: 4),
                              minWidth: 0,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              child: Icon(
                                Icons.schedule,
                                size: 12.rw,
                                color: Color(0xFFA5A5A5),
                              ),
                              onPressed: () {
                                //Get.to(() => UserOldHistoryBenefitPage());
                                Alert.show(
                                    context,
                                    NormalTextDialog(
                                      title: "累计收益",
                                      content: "您的账户使用至今所有已到账收益之和",
                                      items: ["确认"],
                                      listener: (index) {
                                        Alert.dismiss(context);
                                      },
                                    ));
                              },
                            ),
                            Spacer(),
                            Text(_allBenefitAmount.toStringAsFixed(2),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18)),
                            Icon(Icons.keyboard_arrow_right,
                                size: 22, color: Color(0xff999999)),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          )),
    );
  }

  Widget _bodyWidget(BuildContext context, Store<RecookState> store) {
    if (UserManager.instance.haveLogin) {
      // 登录了就渲染用户界面
      return _buildNestedScrollView(context, store);
    } else {
      //没登录就渲染一个登录按钮
      return ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: rSize(120)),
                width: rSize(70),
                height: rSize(70),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 1.0 / 1.0,
                    child: Image.asset(AppImageName.recook_icon_300,
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              Container(
                height: 150,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 100),
                child: CustomImageButton(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  title: " 登录 ",
                  backgroundColor: AppColor.themeColor,
                  color: Colors.white,
                  fontSize: 16 * 2.sp,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  onPressed: () {
                    AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                  },
                ),
              ),
            ],
          )
        ],
      );
    }
  }

  _moneyViewListener(int index) {
    switch (index) {
      case 0: //我的余额
        push(RouteName.BALANCE_PAGE);
        break;
      case 1: //提现
        _withdrawMoney();
        break;
      case 2: //查看订单明细
        push(RouteName.USER_BILLING_DETAILS);
        break;
      case 3: //未到账
        // push(RouteName.RUI_COIN_PAGE);
        break;
      case 4: //累计收入
        // push(RouteName.RUI_COIN_PAGE);
        break;
    }
  }

  _withdrawMoney() {
    //getStore().state.userBrief.monthSaleAmount.toStringAsFixed(2)
    double amount = getStore().state.userBrief.balance;
    // double amount = 0.0;
    if (amount < 10) {
      //少于十元
      Alert.show(
          context,
          NormalTextDialog(
            title: "提现",
            content: "可用余额少于10元无法提现",
            items: ["取消"],
            listener: (int index) {
              Alert.dismiss(context);
            },
          ));
    } else {
      if (!UserManager.instance.user.info.realInfoStatus) {
        //如果用户没有实名认证让用户跳转实名认证
        Toast.showError("未实名认证用户无法提现,请先进行实名认证!");
        AppRouter.push(context, RouteName.USER_VERIFY).then((success) {
          if (success is bool) {
            if (success) {
              //实名认证成功
              GSDialog.of(context).showSuccess(context, "实名认证成功");
              setState(() {
                UserManager.instance.user.info.realInfoStatus = true;
              });
              UserManager.updateUserInfo(getStore());
            }
          }
        });
        return;
      }
      Alert.show(
          context,
          NormalContentDialog(
            title: "提现",
            content: _capitalText(),
            items: ["确认提现", "取消"],
            listener: (int index) {
              // Alert.dismiss(context);
              if (index == 0) {
                // 提现
                if (TextUtils.isEmpty(_capital) ||
                    double.parse(_capital) < 10) {
                  //提现金额不能小于10元
                  Toast.showError("提现金额不能小于10元");
                } else if (double.parse(_capital) > amount) {
                  //提现 -> double.parse(capital) 大于余额
                  Toast.showError("提现金额大于余额,当前余额:${amount.toStringAsFixed(2)}");
                } else {
                  //正常提现
                  _withdrawAmount(double.parse(_capital));
                  _capital = null;
                  Alert.dismiss(context);
                }
              } else {
                Alert.dismiss(context);
              }
            },
          ));
    }
  }

  _withdrawAmount(double amount) async {
    //取款
    ResultData resultData = await HttpManager.post(UserApi.withdraw,
        {"amount": amount, "userId": UserManager.instance.user.info.id});
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code == HttpStatus.SUCCESS) {
      //提款成功
      // getStore().state.userBrief.asset.fund -= amount;
      // showSuccess(model.msg);
      GSDialog.of(globalContext).showSuccess(globalContext, model.msg,
          duration: Duration(milliseconds: 3000));
    } else {
      showError(model.msg);
    }
  }

  Container _capitalText() {
    return Container(
      margin:
          EdgeInsets.only(top: rSize(10), right: rSize(20), left: rSize(20)),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[500], width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(3))),
      child: TextField(
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black, fontSize: 16 * 2.sp),
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        cursorColor: Colors.black,
        onChanged: (String number) {
          _capital = number.toString();
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
              left: rSize(10), top: rSize(13), bottom: rSize(14)),
          border: InputBorder.none,
          hintText: "请输入提现金额",
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15 * 2.sp),
        ),
      ),
    );
  }

  _showUpDateAlert() async {
    if (!UserManager.instance.haveLogin) return;

    VersionInfo versionInfo = getStore().state.userBrief.versionInfo;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (versionInfo == null) {
      return;
    }
    //当前版本小于服务器版本
    if (int.parse(packageInfo.buildNumber) < versionInfo.build) {
      Alert.show(
          context,
          NormalTextDialog(
            title: "发现新版本",
            content: "${versionInfo.desc}",
            items: ["确认", "取消"],
            listener: (int index) async {
              Alert.dismiss(context);
              if (index == 0) {
                String _url = WebApi.androidUrl;
                if (Platform.isIOS) _url = WebApi.iOSUrl;
                if (await canLaunch(_url)) {
                  launch(_url);
                  if (Theme.of(context).platform == TargetPlatform.iOS) {
                    Future.delayed(
                        const Duration(seconds: 3), () => closeWebView());
                  }
                }
              }
            },
          ));
    }
  }

  _wechatBindinghandle() {
    DPrint.printf("微信登录");
    if (!WeChatUtils.isInstall) {
      showError("没有检测到微信！请先安装！");
      return;
    }
    //GSDialog.of(context).showLoadingDialog(context, "正在请求数据...");
    WeChatUtils.wxLogin((WXLoginResult result) {
      if (result.errCode == -2) {
        Toast.showInfo('用户取消登录');
      } else if (result.errCode != 0) {
        GSDialog.of(context).dismiss(context);
        Toast.showInfo(result.errStr);
      } else {
        if (!_weChatLoginLoading) {
          _weChatLoginLoading = true;
          _weChatLogin(result.code);
        }
      }
    });
  }

  _weChatLogin(String code) async {
    GSDialog.of(context).showLoadingDialog(context, "登录中...");
    ResultData resultData = await HttpManager.post(UserApi.wx_binding,
        {'userId': UserManager.instance.user.info.id, 'code': code});
    GSDialog.of(context).dismiss(context);

    _weChatLoginLoading = false;
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    UserModel model = UserModel.fromJson(resultData.data);
    print(model);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    UserManager.updateUser(model.data, getStore());
    setState(() {});
    showSuccess('绑定成功!');
  }
}
