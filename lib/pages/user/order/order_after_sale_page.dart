import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/order_after_sales_list_model.dart';
import 'package:jingyaoyun/models/order_detail_model.dart';
import 'package:jingyaoyun/models/order_list_model.dart';
import 'package:jingyaoyun/pages/user/mvp/order_list_contact.dart';
import 'package:jingyaoyun/pages/user/mvp/order_list_presenter_impl.dart';
import 'package:jingyaoyun/pages/user/order/after_sales_item.dart';
import 'package:jingyaoyun/pages/user/order/order_list_controller.dart';
import 'package:jingyaoyun/pages/user/order/order_list_page.dart';
import 'package:jingyaoyun/pages/user/order/order_return_status_page.dart';
import 'package:jingyaoyun/utils/app_router.dart';
import 'package:jingyaoyun/utils/mvp.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:jingyaoyun/widgets/progress/sc_dialog.dart';

enum OrderAfterSaleType { userPage, shopPage }

class OrderAfterSalePage extends StatefulWidget {
  final Map arguments;
  final int initIndex;
  const OrderAfterSalePage({Key key, this.arguments, this.initIndex = 0})
      : super(key: key);
  static setArguments(OrderAfterSaleType afterSaleType,
      OrderPositionType positionType, OrderListController controller) {
    return {
      "afterSaleType": afterSaleType,
      "positionType": positionType,
      "controller": controller
    };
  }

  @override
  State<StatefulWidget> createState() {
    return _OrderAfterSalePageState();
  }
}

class _OrderAfterSalePageState extends BaseStoreState<OrderAfterSalePage>
    with MvpListViewDelegate<OrderAfterSalesModel>, TickerProviderStateMixin
    implements OrderListViewI {
  TabController _tabController;
  OrderAfterSaleType _afterSaleType = OrderAfterSaleType.userPage;
  OrderPositionType _positionType = OrderPositionType.onlineOrder;

  OrderAfterSalesListPresenterImpl _presenter;
  MvpListViewController<OrderAfterSalesModel> _controller;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: widget.initIndex);
    if (widget.arguments.containsKey("positionType") &&
        widget.arguments["positionType"] != null) {
      _positionType = widget.arguments["positionType"];
    }
    if (widget.arguments.containsKey("controller") &&
        widget.arguments["controller"] != null) {
      OrderListController listController = widget.arguments["controller"];
      listController.refresh = () {
        if (mounted && _controller != null) {
          _controller.requestRefresh();
        }
      };
    }
    _afterSaleType = widget.arguments["afterSaleType"];
    _presenter = OrderAfterSalesListPresenterImpl();
    _presenter.attach(this);
    _controller = MvpListViewController();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    Widget body = MvpListView<OrderAfterSalesModel>(
      delegate: this,
      controller: _controller,
      pageSize: 10,
      itemClickListener: (index) {},
      itemBuilder: (context, index) {
        List<OrderAfterSalesModel> orderModels = _controller.getData();
        OrderAfterSalesModel orderModel = orderModels[index];
        return AfterSalesItem(orderModel, () {
          AppRouter.push(context, RouteName.ORDER_RETURN_DETAIL,
              arguments: OrderReturnStatusPage.setArguments(
                  orderModel.orderGoodsId, orderModel.asId));
        });
      },
      refreshCallback: () {
        if (_afterSaleType == OrderAfterSaleType.shopPage) {
          _presenter.getShopAfterSalesList(UserManager.instance.user.info.id, 0,
              _positionType, _tabController.index + 1);
        } else {
          _presenter.getAfterSalesList(
              UserManager.instance.user.info.id, 0, _tabController.index + 1);
        }
      },
      loadMoreCallback: (page) {
        if (_afterSaleType == OrderAfterSaleType.shopPage) {
          _presenter.getShopAfterSalesList(UserManager.instance.user.info.id,
              page, _positionType, _tabController.index + 1);
        } else {
          _presenter.getAfterSalesList(UserManager.instance.user.info.id, page,
              _tabController.index + 1);
        }
      },
      noDataView: noDataView("没有订单数据哦~"),
    );

    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        background: Colors.white,
        appBackground: Colors.white,
        elevation: 0,
        themeData: AppThemes.themeDataGrey.appBarTheme,
        title: '售后商品',
      ),
      body: SafeArea(
          bottom: true,
          top: false,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: TabBar(
                  onTap: (index) {
                    //todo 列表刷新数据正常，列表刷新显示有问题，暂时使用pushReplacement解决
                    Navigator.pushReplacement(context,
                        PageRouteBuilder(pageBuilder: (context, animation, _) {
                      return FadeTransition(
                        opacity: animation,
                        child: OrderAfterSalePage(
                          arguments: widget.arguments,
                          initIndex: index,
                        ),
                      );
                    }));
                    _controller.requestRefresh();
                  },
                  indicatorColor: AppColor.themeColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(
                      color: AppColor.blackColor, fontSize: 16 * 2.sp),
                  unselectedLabelStyle:
                      TextStyle(color: Color(0xff333333), fontSize: 16 * 2.sp),
                  labelColor: AppColor.blackColor,
                  unselectedLabelColor: AppColor.greyColor,
                  controller: _tabController,
                  tabs: <Widget>[Tab(text: "售后中"), Tab(text: "已完成")],
                ),
              ),
              Expanded(
                child: body,
              )
            ],
          )),
    );
  }

  @override
  applyInvoiceSuccess() {}

  @override
  cancelOrderSuccess(OrderModel order) {}

  @override
  deleteOrderSuccess(int orderId) {}

  @override
  failure(String msg) {
    GSDialog.of(context).showError(globalContext, msg);
  }

  @override
  getOrderDetailSuccess(OrderDetailModel detail) {}

  @override
  MvpListViewPresenterI<OrderAfterSalesModel, MvpView, MvpModel>
      getPresenter() {
    return _presenter;
  }

  @override
  void onAttach() {}

  @override
  void onDetach() {}

  @override
  refundSuccess(msg) {}

  @override
  confirmReceiptSuccess(model) {}
}
