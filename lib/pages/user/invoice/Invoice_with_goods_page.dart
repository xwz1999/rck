import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/pages/user/invoice/models/invoice_get_bill_model.dart';
import 'package:recook/pages/user/invoice/invoice_presenter.dart';
import 'package:recook/pages/user/invoice/invoice_scaffold_widget.dart';
import 'package:recook/pages/user/widget/recook_check_box.dart';
import 'package:recook/widgets/refresh_widget.dart';

class InvoiceWithGoodsPage extends StatefulWidget {
  InvoiceWithGoodsPage({Key key}) : super(key: key);

  @override
  _InvoiceWithGoodsPageState createState() => _InvoiceWithGoodsPageState();
}

class _InvoiceWithGoodsPageState extends State<InvoiceWithGoodsPage> {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);
  InvoicePresenter _invoicePresenter = InvoicePresenter();
  List<InvoiceGetBillModel> _models = [];
  List<int> _selectedIds = [];
  double _price = 0.0;
  int _page = 0;

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InvoiceScaffoldWidget(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: rSize(16),
              vertical: rSize(8),
            ),
            child: Row(
              children: [
                Text(
                  '可开票订单',
                  style: TextStyle(
                    color: Color(0xFF333333),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Divider(
            color: Color(0xFFEEEEEE),
            height: 0.5,
          ),
          Expanded(
            child: RefreshWidget(
              onRefresh: () async {
                await _invoicePresenter.getInvoice().then((value) {
                  _page = 0;
                  if (mounted) {
                    setState(() {
                      _models = value;
                    });
                    _refreshController.refreshCompleted();
                  }
                });
              },
              onLoadMore: () async {
                _page++;
                await _invoicePresenter.getInvoice(page: _page).then((value) {
                  _models.addAll(value);
                  if (mounted)
                    setState(() {
                      _refreshController.loadComplete();
                    });
                });
              },
              controller: _refreshController,
              body: ListView.builder(
                itemBuilder: (context, index) {
                  return _buildCard(_models[index]);
                },
                itemCount: _models.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: rSize(4),
              spreadRadius: rSize(2),
              color: Color(0xFF3C0A07).withOpacity(0.07),
            ),
          ],
        ),
        child: SafeArea(
          bottom: true,
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: rSize(16),
                  vertical: rSize(6),
                ),
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: ScreenAdapterUtils.setSp(12),
                    ),
                    children: [
                      TextSpan(
                        text: _selectedIds.length.toString(),
                        style: TextStyle(color: AppColor.priceColor),
                      ),
                      TextSpan(
                        text: '笔订单，共',
                      ),
                      TextSpan(
                        text: _price.toStringAsFixed(2),
                        style: TextStyle(color: AppColor.priceColor),
                      ),
                      TextSpan(
                        text: '元',
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: ScreenAdapterUtils.setWidth(0.5),
                color: Color(0xFFEEEEEE),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: rSize(16),
                  vertical: rSize(10),
                ),
                child: Row(
                  children: [
                    CupertinoButton(
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RecookCheckBox(
                              state: _selectedIds.length == _models.length),
                          SizedBox(width: rSize(8)),
                          Text(
                            '全选',
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: ScreenAdapterUtils.setSp(14),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        if (_selectedIds.length == _models.length) {
                          _selectedIds = [];
                          _price = 0;
                        } else {
                          _selectedIds = [];
                          _price = 0;
                          _models.forEach((element) {
                            _price += element.goodsAmount;
                            _selectedIds.add(element.goodsDetailId);
                          });
                        }
                        setState(() {});
                      },
                    ),
                    Spacer(),
                    FlatButton(
                      onPressed: () {
                        AppRouter.push(context, RouteName.USER_INVOICE_DETAIL,
                            arguments: {'ids': _selectedIds, 'price': _price});
                      },
                      child: Text('下一步'),
                      color: AppColor.redColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCard(InvoiceGetBillModel model) {
    return InkWell(
      onTap: () {
        if (_selectedIds.contains(model.goodsDetailId)) {
          _selectedIds.remove(model.goodsDetailId);
          _price -= model.goodsAmount;
        } else {
          _selectedIds.add(model.goodsDetailId);
          _price += model.goodsAmount;
        }
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.all(rSize(16)),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: rSize(1),
              color: Color(0xFFEEEEEE),
            ),
          ),
        ),
        height: ScreenAdapterUtils.setHeight(100),
        child: Row(
          children: [
            RecookCheckBox(state: _selectedIds.contains(model.goodsDetailId)),
            SizedBox(width: rSize(16)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.orderTime,
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: ScreenAdapterUtils.setSp(14),
                    ),
                  ),
                  Text(
                    model.goodsName,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: ScreenAdapterUtils.setSp(14),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  model.goodsAmount.toString(),
                  style: TextStyle(
                    color: Color(0xFFDB2D2D),
                    fontSize: ScreenAdapterUtils.setSp(24),
                  ),
                ),
                Text(
                  '元',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: ScreenAdapterUtils.setSp(14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
