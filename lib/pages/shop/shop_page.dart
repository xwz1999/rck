import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/shop_summary_model.dart';
import 'package:recook/pages/shop/invite_view.dart';
import 'package:recook/pages/shop/order/shop_order_center_page.dart';
import 'package:recook/pages/shop/shop_page_appbar_widget.dart';
import 'package:recook/pages/shop/shop_page_column_info_widget.dart';
import 'package:recook/pages/shop/shop_page_order_view.dart';
import 'package:recook/pages/shop/widget/shop_page_upgrade_alert.dart';
import 'package:recook/pages/shop/widget/shop_page_upgrade_progress_widget.dart';
import 'package:recook/pages/user/order/order_after_sale_page.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/refresh_widget.dart';

class ShopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShopPageState();
  }
}

class _ShopPageState extends BaseStoreState<ShopPage> {
  GSRefreshController _gsRefreshController;
  ShopSummaryModel _shopSummaryModel;

  String msgCode = "msgCode";

  @override
  void initState() {
    super.initState();
    _gsRefreshController = GSRefreshController(initialRefresh: true);
    UserManager.instance.refreshShopPage.addListener(() {
      _getShopSummary();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget buildContext(BuildContext context, {store}) {
    Scaffold scaffold = Scaffold(
      // backgroundColor: Color.fromARGB(255, 243, 245, 247),
      backgroundColor: Color(0xff3a3943),
      body: RefreshWidget(
          header: ClassicHeader(
            outerBuilder: (child) {
              return Container(
                child: child,
              );
            },
            height: ScreenUtil.statusBarHeight + kToolbarHeight,
            textStyle: TextStyle(
                fontSize: ScreenAdapterUtils.setSp(14), color: Colors.white),
            refreshingText: "正在努力获取数据...",
            completeText: "刷新完成",
            failedText: "网络出了一点问题呢",
            idleText: "下拉刷新",
            releaseText: "松开刷新",
          ),
          isInNest: true,
          // headerTriggerDistance: ScreenUtil.statusBarHeight+kToolbarHeight,
          color: Colors.black,
          onRefresh: () {
            _getShopSummary();
          },
          controller: _gsRefreshController,
          body: _shopSummaryModel == null
              ? Container(
                  color: AppColor.frenchColor,
                  child: noDataView(''),
                )
              : ListView(
                  physics: BouncingScrollPhysics(),
                  children: _bodyListWidget(),
                )),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: scaffold,
    );
  }

  _bodyListWidget() {
    List<Widget> listWidget = [];
    listWidget.add(ShopPageAppbarWidget(
      cumulativeIncome: () {
        push(RouteName.CUMULATIVE_INCOME);
      },
      shopSummaryModel: _shopSummaryModel,
    ));
    // listWidget.add(Container(
    //   height: 10,
    // ));
    listWidget.add(ShopPageColumnInfoWidget(
      shopSummaryModel: _shopSummaryModel,
    ));
    listWidget.add(Container(
      height: 10,
      color: AppColor.frenchColor,
    ));

    // 测试用
    // listWidget.add(
    // ShopPageUpgradeProgress(shopSummaryModel: _shopSummaryModel,)
    // );
    // 正式用
    if ((UserLevelTool.currentUserLevelEnum() == UserLevel.First ||
            UserLevelTool.currentUserLevelEnum() == UserLevel.Second) &&
        UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.Diamond &&
        UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.Vip) {
      listWidget.add(
        ShopPageUpgradeProgress(
          shopSummaryModel: _shopSummaryModel,
        ),
      );
    }

    // 邀请升级
    listWidget.add(InviteView(
        isDiamond:
            UserLevelTool.roleLevelEnum(_shopSummaryModel.data.roleLevel) ==
                UserRoleLevel.Diamond,
        shareListener: () =>
            ShareTool().inviteShare(context, customTitle: Container())));
    listWidget.add(Container(
      height: 10,
      color: AppColor.frenchColor,
    ));
    //订单中心
    listWidget.add(ShopPageOrderView(
      clickListener: (index) {
        if (index == 4) {
          AppRouter.push(context, RouteName.ORDER_AFTER_SALE_GOODS_LIST,
              arguments: OrderAfterSalePage.setArguments(
                  OrderAfterSaleType.shopPage, null, null));
          return;
        }
        push(RouteName.SHOP_ORDER_LIST_PAGE,
            arguments: ShopOrderCenterPage.setArguments(index));
      },
      shopSummaryModel: _shopSummaryModel,
    ));

    return listWidget;
  }

  _getShopSummary() async {
    ResultData resultData = await HttpManager.post(ShopApi.shop_index, {
      "userId": UserManager.instance.user.info.id,
    });
    if (_gsRefreshController.isRefresh()) {
      _gsRefreshController.refreshCompleted();
    }
    if (!resultData.result) {
      if (mounted) {
        showError(resultData.msg);
      }
      return;
    }
    ShopSummaryModel model = ShopSummaryModel.fromJson(resultData.data);
    // String jsonString = jsonEncode(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      if (mounted) {
        showError(model.msg);
      }
      return;
    }
    _shopSummaryModel = model;
    if (UserManager.instance.user.info.roleLevel !=
        _shopSummaryModel.data.roleLevel) {
      UserManager.instance.user.info.roleLevel =
          _shopSummaryModel.data.roleLevel;
      UserManager.instance.refreshUserRole.value =
          !UserManager.instance.refreshUserRole.value;
      UserManager.updateUserInfo(getStore());
    }
    if (mounted) setState(() {});
    if (model.data.upNotify.isNotify) {
      _showUpgradeAlert();
    }
  }

  _showUpgradeAlert() {
    showDialog(
        context: context,
        builder: (context) => GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: ShopPageUpgradeAlert(
                width: MediaQuery.of(context).size.width,
                userRoleLevel: UserLevelTool.roleLevelEnum(
                    _shopSummaryModel.data.roleLevel),
              ),
            ));
  }
}
