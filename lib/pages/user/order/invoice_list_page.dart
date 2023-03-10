/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-20  11:38 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/order_detail_model.dart';
import 'package:jingyaoyun/pages/user/mvp/order_list_presenter_impl.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';

class InvoiceListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InvoiceListPageState();
  }
}

class _InvoiceListPageState extends BaseStoreState<InvoiceListPage> {
  OrderListPresenterImpl _presenter;
  List<Invoice> _invoiceList;
  GSRefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _presenter = OrderListPresenterImpl();
    _refreshController = GSRefreshController(initialRefresh: true);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "选择发票",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                AppIcons.icon_add,
                size: 18 * 2.sp,
                color: Colors.black,
              ),
              onPressed: () {
                AppRouter.push(globalContext, RouteName.ORDER_INVOICE_ADD)
                    .then((success) {
                  if (success == null) return;
                  if (success) {
                    _getList();
                  }
                });
              })
        ],
      ),
      backgroundColor: AppColor.tableViewGrayColor,
      body: RefreshWidget(
        controller: _refreshController,
        onRefresh: () {
          _getList();
        },
        body: _invoiceList == null || _invoiceList.length == 0
            ? noDataView("您还没有添加发票")
            : ListView.builder(
                itemCount: _invoiceList.length,
                itemBuilder: (_, index) {
                  return _item(_invoiceList[index]);
                }),
      ),
    );
  }

  _item(Invoice invoice) {
    return CustomImageButton(
      onPressed: () {
        Navigator.pop(globalContext, invoice.id);
      },
      child: Container(
        color: Colors.white,
        padding:
            EdgeInsets.symmetric(vertical: rSize(10), horizontal: rSize(10)),
        margin: EdgeInsets.only(top: rSize(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: rSize(2), horizontal: rSize(4)),
              decoration: BoxDecoration(
                  color: AppColor.rgbColor(239, 239, 239),
                  borderRadius: BorderRadius.all(Radius.circular(rSize(5)))),
              child: Text(
                invoice.type == 0 ? "个人" : "企业",
                style: AppTextStyle.generate(13 * 2.sp),
              ),
            ),
            SizedBox(
              height: rSize(5),
            ),
            Text(
              "发票抬头: ${invoice.title}",
              style: AppTextStyle.generate(14 * 2.sp, color: Colors.grey[600]),
            )
          ],
        ),
      ),
    );
  }

  _getList() async {
    HttpResultModel<List<Invoice>> model =
        await _presenter.getInvoiceList(UserManager.instance.user.info.id);
    _refreshController.refreshCompleted();
    if (!model.result) {
      GSDialog.of(globalContext).showError(globalContext, model.msg);
      return;
    }
    setState(() {
      _invoiceList = model.data;
    });
  }
}
