/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-08  10:16 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/order_detail_model.dart';
import 'package:jingyaoyun/models/order_list_model.dart';
import 'package:jingyaoyun/pages/user/mvp/order_list_contact.dart';
import 'package:jingyaoyun/pages/user/mvp/order_list_presenter_impl.dart';
import 'package:jingyaoyun/pages/user/order/order_detail_state.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/toast.dart';

class ShopOrderDetailPage extends StatefulWidget {
  final Map arguments;

  const ShopOrderDetailPage({Key key, this.arguments}) : super(key: key);

  static setArguments(int orderId) {
    return {"orderId": orderId};
  }

  @override
  State<StatefulWidget> createState() {
    return _ShopOrderDetailPageState();
  }
}

class _ShopOrderDetailPageState extends OrderDetailState<ShopOrderDetailPage>
    implements OrderListViewI {
  // OrderPreviewModel _detail;
  OrderListPresenterImpl _presenter;

  @override
  void initState() {
    super.initState();
    isUserOrder = false;
    int orderId = widget.arguments["orderId"];
    _presenter = OrderListPresenterImpl();
    _presenter.attach(this);
    _presenter.getShopOrderDetail(UserManager.instance.user.info.id, orderId);
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "订单详情",
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: orderDetail == null ? loadingView() : _buildBody(),
      backgroundColor: AppColor.frenchColor,
      // bottomNavigationBar: orderDetail == null ? null : _bottomBar(),
    );
  }

  _buildBody() {
    return ListView(
      children: <Widget>[
        orderStatus(),
        buildAddress(),
        brandList(),
        totalPrice(),
        contactCustomerService(),
        orderInfo()
      ],
    );
  }

  @override
  addressView() {
    String name = orderDetail.addr.receiverName;
    if (name.length > 1) {
      name = name.replaceRange(1, null, "***");
    }
    String mobile = orderDetail.addr.mobile;
    if (mobile != null && mobile.length >= 11) {
      mobile = mobile.replaceRange(3, 7, "****");
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
            text: TextSpan(
                // text: "${_detail.addr.receiverName}",
                text: name + "   ",
                style: AppTextStyle.generate(15 * 2.sp),
                children: [
              TextSpan(
                  // text: "   ${_detail.addr.mobile}",
                  text: mobile,
                  style: AppTextStyle.generate(14 * 2.sp, color: Colors.grey))
            ])),
        Container(
          margin: EdgeInsets.only(top: 8 * 2.sp),
          child: Text(
            // "${_detail.addr.province + _detail.addr.city + _detail.addr.district + _detail.addr.address}",
            "${orderDetail.addr.province + orderDetail.addr.city + orderDetail.addr.district}***",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:
                AppTextStyle.generate(14 * 2.sp, fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }

  @override
  cancelOrderSuccess(OrderModel order) {
    GSDialog.of(context).dismiss(globalContext);
    Toast.showInfo("已取消订单");
    Future.delayed(Duration(milliseconds: 300), () {
      Navigator.pop(globalContext, 2);
    });
  }

  @override
  failure(String msg) {
    GSDialog.of(globalContext).showError(globalContext, msg);
  }

  @override
  getOrderDetailSuccess(OrderDetailModel detail) {
    setState(() {
      orderDetail = detail.data;
    });
  }

  @override
  refundSuccess(msg) {
    GSDialog.of(context).dismiss(globalContext);
    Toast.showInfo(msg);
    _presenter.getShopOrderDetail(
        UserManager.instance.user.info.id, orderDetail.id);
  }

  @override
  void onAttach() {}

  @override
  void onDetach() {}

  @override
  applyInvoiceSuccess() {
    GSDialog.of(globalContext).showSuccess(globalContext, "申请成功");
    _presenter.getShopOrderDetail(
        UserManager.instance.user.info.id, orderDetail.id);
  }

  @override
  deleteOrderSuccess(int orderId) {
    return null;
  }

  @override
  confirmReceiptSuccess(model) {}
}
