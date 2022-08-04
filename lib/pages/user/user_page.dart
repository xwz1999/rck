import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/home/vip_shop_push_page.dart';
import 'package:recook/pages/user/model/user_income_data_model.dart';
import 'package:recook/pages/user/order/order_after_sale_page.dart';
import 'package:recook/pages/user/order/order_center_page.dart';
import 'package:recook/pages/user/pifa_benefit_page.dart';
import 'package:recook/pages/user/review/review_page.dart';
import 'package:recook/pages/user/user_benefit_sub_page.dart';
import 'package:recook/pages/user/widget/capital_view.dart';
import 'package:recook/pages/user/widget/order_central_view.dart';
import 'package:recook/pages/user/widget/other_item_view_v2.dart';
import 'package:recook/pages/user/widget/user_app_bar_v2.dart';
import 'package:recook/redux/recook_state.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:redux/redux.dart';
import 'package:velocity_x/velocity_x.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends BaseStoreState<UserPage> {
  GSRefreshController? _refreshController;
  bool _isFirstLoad = true;
  num? _allBenefitAmount = 0;
  UserIncomeDataModel? _userIncomeDataModel;

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
    WidgetsBinding.instance?.addPostFrameCallback((callback) {
      if (_isFirstLoad) {
        _isFirstLoad = false;
      } else {
        return;
      }
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
      BuildContext context, Store<RecookState>? store) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(child: UserAppBarV2()),
        ];
      },
      body: _buildRefreshScrollView(context, store),
    );
  }

  _updateUserBriefInfo() {
    UserManager.instance!.updateUserBriefInfo(getStore()).then((success) {
      if (success) {
        if (UserManager.instance!.user.info!.roleLevel !=
            getStore().state.userBrief!.roleLevel) {
          UserManager.instance!.user.info!.roleLevel =
              getStore().state.userBrief!.roleLevel as int?;
          UserManager.instance!.refreshUserRole.value =
              !UserManager.instance!.refreshUserRole.value;
          UserManager.updateUserInfo(getStore());
        }
        _refreshController!.refreshCompleted();
      }
    });
  }

  _updateNewBenefit() async {
    ResultData result = await HttpManager.post(APIV2.benefitAPI.incomeData, {});
    if (result.data != null && result.data['data'] != null) {
      _userIncomeDataModel = UserIncomeDataModel.fromJson(result.data['data']);

      ///累计收益
      _allBenefitAmount = _userIncomeDataModel!.total;
    }
  }

  Widget _buildRefreshScrollView(
      BuildContext context, Store<RecookState>? store) {
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
            // VersionTool.checkVersionInfo(context);
            _updateUserBriefInfo();
            await _updateNewBenefit();
            setState(() {});
          },
          body: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              CapitalView(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0,
                ),
                child: _buildDetailReward(),
              ),
              ...[
                UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary
                    ? _renderBenefitCard(
                        leadingPath: R.ASSETS_USER_PINK_SHARE_WEBP,
                        title: '店铺收益',
                        alertTitle: '店铺收益',
                        title1: '未到账收益',
                        title3: '已到账收益',
                        content1: _userIncomeDataModel?.eAmount5 ?? 0,
                        content2: _userIncomeDataModel?.eCount5 ?? 0,
                        content3: _userIncomeDataModel?.amount5 ?? 0,
                        content4: _userIncomeDataModel?.count5 ?? 0,
                      )
                    : _renderBenefitCard(
                        leadingPath: R.ASSETS_USER_PINK_SHARE_WEBP,
                        title: '分享补贴',
                        alertTitle: '分享补贴',
                        title1: '累计未到账收益',
                        title3: '累计已到账收益',
                        content1: _userIncomeDataModel?.eAmount2 ?? 0,
                        content2: _userIncomeDataModel?.eCount2 ?? 0,
                        content3: _userIncomeDataModel?.amount2 ?? 0,
                        content4: _userIncomeDataModel?.count2 ?? 0,
                      ),
                UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary
                    ? _renderBenefitCard(
                        leadingPath: R.ASSETS_USER_PINK_SHARE_WEBP,
                        title: '分享收益',
                        alertTitle: '分享收益',
                        title1: '未到账收益',
                        title3: '已到账收益',
                        content1: _userIncomeDataModel?.eAmount6 ?? 0,
                        content2: _userIncomeDataModel?.eCount6 ?? 0,
                        content3: _userIncomeDataModel?.amount6 ?? 0,
                        content4: _userIncomeDataModel?.count6 ?? 0,
                      )
                    : _renderBenefitCard(
                        leadingPath: R.ASSETS_USER_PINK_GROUP_WEBP,
                        title: '开店补贴',
                        alertTitle: '开店补贴',
                        title1: '累计未到账收益',
                        title3: '累计已到账收益',
                        content1: _userIncomeDataModel?.eAmount4 ?? 0,
                        content2: _userIncomeDataModel?.eCount4 ?? 0,
                        content3: _userIncomeDataModel?.amount4 ?? 0,
                        content4: _userIncomeDataModel?.count4 ?? 0,
                      ),
              ].sepWidget(separate: 1.hb),
              20.w.heightBox,
              OrderCentralView(
                clickListener: (int index) {
                  if (index == 4) {
                    // AppRouter.push(context, RouteName.USER_REVIEW_PAGE);

                    Get.to(() => ReviewPage());

                    return;
                  }
                  if (index == 5) {
                    // AppRouter.push(
                    //     context, RouteName.ORDER_AFTER_SALE_GOODS_LIST,
                    //     arguments: OrderAfterSalePage.setArguments(
                    //         OrderAfterSaleType.userPage, null, null));

                    Get.to(() => OrderAfterSalePage(
                          arguments: OrderAfterSalePage.setArguments(
                              OrderAfterSaleType.userPage, null, null),
                        ));
                    return;
                  }
                  Get.to(() => OrderCenterPage(
                        arguments: OrderCenterPage.setArguments(index),
                      ));
                },
              ),
              20.w.heightBox,
              UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary
                  ? GestureDetector(
                      onTap: () {
                        Get.to(() => VipShopPushPage());
                      },
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 10.rw, horizontal: 12.rw),
                        child: Stack(
                          children: [
                            Image.asset(
                              Assets.userExtensionBg.path,
                              fit: BoxFit.fitWidth,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  40.wb,
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      30.hb,
                                      RichText(
                                        text: TextSpan(
                                            text: "VIP店推广",
                                            style: AppTextStyle.generate(
                                                16 * 2.sp,
                                                color: Color(0xFFD5101A)),
                                            children: [
                                              TextSpan(
                                                  style: AppTextStyle.generate(
                                                      12 * 2.sp,
                                                      color: Color(0xFFD5101A)
                                                          .withOpacity(0.5)),
                                                  text: "    0元创业·轻松赚")
                                            ]),
                                      ),
                                      28.hb,
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.rw, horizontal: 4.rw),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(0xFFF14F49),
                                                Color(0xFFE21830),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(2.rw)),
                                        child: Text(
                                          '立即推广 >',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.rsp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
              20.w.heightBox,
              OtherItemViewV2(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderBenefitCard({
    required String leadingPath,
    required String title,
    required String alertTitle,
    Widget? alertContent,
    required String title1,
    required String title3,
    required num content1,
    required num content2,
    required num content3,
    required num content4,
    UserBenefitPageType type = UserBenefitPageType.SELF,
  }) {
    // if (title == "自购收益") {
    //   type = UserBenefitPageType.SELF;
    // } else if (title == "分享收益") {
    //   type = UserBenefitPageType.GUIDE;
    // } else if (title == "开店补贴") {
    //   type = UserBenefitPageType.TEAM;
    // } else if (title == "开店补贴") {
    //   type = UserBenefitPageType.PLATFORM;
    // }

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
              Spacer(),
              UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary
                  ? GestureDetector(
                      onTap: () {
                        Get.to(() => PifaBenefitPage(
                              type: title,
                              isDetail: false,
                            ));
                      },
                      child: Container(
                          color: Colors.transparent,
                          width: 100.rw,
                          height: 40.rw,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
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
                    )
                  : SizedBox(),
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
                        onPressed: () {},
                        child: Column(
                          children: [
                            title1.text
                                .color(Color(0xFF999999))
                                .size(12.rsp)
                                .make(),
                            20.w.heightBox,
                            '$content1'.text.black.size(16.rsp).make(),
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
                        onPressed: () {},
                        child: Column(
                          children: [
                            '订单数'
                                .text
                                .color(Color(0xFF999999))
                                .size(12.rsp)
                                .make(),
                            20.w.heightBox,
                            '$content2'.text.black.size(16.rsp).make(),
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
                    onPressed: () {},
                    child: Column(
                      children: [
                        title3.text
                            .color(Color(0xFF999999))
                            .size(12.rsp)
                            .make(),
                        20.w.heightBox,
                        '$content3'.text.black.size(16.rsp).make(),
                      ],
                    ),
                  ),
                  Spacer(),
                  CustomImageButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        '订单数'.text.color(Color(0xFF999999)).size(12.rsp).make(),
                        20.w.heightBox,
                        '$content4'.text.black.size(16.rsp).make(),
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
      child: Container(
          height: 50.rw,
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
              AppConfig.getShowCommission()!
                  ? CustomImageButton(
                      onPressed: () {
                        //Get.to(() => UserHistoryBenefitPage());
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 15.rw),
                        height: 50.rw,
                        child: Row(
                          children: <Widget>[
                            Text(
                              "累计总收益",
                              style: AppTextStyle.generate(16.rsp,
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
                            Text(_allBenefitAmount!.toStringAsFixed(2),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18)),
                            40.wb,
                            // Icon(Icons.keyboard_arrow_right,
                            //     size: 22, color: Color(0xff999999)),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          )),
    );
  }

  Widget _bodyWidget(BuildContext context, Store<RecookState>? store) {
    if (UserManager.instance!.haveLogin) {
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
                    child: Image.asset(Assets.icon.icLauncherPlaystore.path,
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              Container(
                height: 150.rw,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 100.rw),
                child: CustomImageButton(
                  padding: EdgeInsets.symmetric(vertical: 8.rw),
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
}
