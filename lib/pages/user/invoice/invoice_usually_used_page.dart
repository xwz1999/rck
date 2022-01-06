import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/pages/user/invoice/invoice_presenter.dart';
import 'package:jingyaoyun/pages/user/invoice/invoice_scaffold_widget.dart';
import 'package:jingyaoyun/pages/user/invoice/models/invoice_title_list_model.dart';
import 'package:jingyaoyun/utils/app_router.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';

class InvoiceUsuallyUsedPage extends StatefulWidget {
  InvoiceUsuallyUsedPage({Key key}) : super(key: key);

  @override
  _InvoiceUsuallyUsedPageState createState() => _InvoiceUsuallyUsedPageState();
}

class _InvoiceUsuallyUsedPageState extends State<InvoiceUsuallyUsedPage> {
  GSRefreshController _controller = GSRefreshController();
  List<InvoiceTitleListModel> _models = [];
  InvoicePresenter _invoicePresenter = InvoicePresenter();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) _controller.requestRefresh();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InvoiceScaffoldWidget(
      title: '常用开票抬头',
      body: RefreshWidget(
        controller: _controller,
        onRefresh: () async {
          await _invoicePresenter.getInvoiceTitleList().then((value) {
            setState(() {
              _models = value;
            });
            _controller.refreshCompleted();
          });
        },
        body: ListView.separated(
          padding: EdgeInsets.only(
            top: rSize(8),
          ),
          separatorBuilder: (context, index) {
            return SizedBox(height: rSize(8));
          },
          itemBuilder: (context, index) {
            return _buildCard(_models[index]);
          },
          itemCount: _models.length,
        ),
      ),
      bottomNavigationBar: Container(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: rSize(16),
            vertical: rSize(12),
          ),
          child: SafeArea(
            bottom: true,
            top: false,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(rSize(4)),
              ),
              padding: EdgeInsets.symmetric(vertical: rSize(13)),
              onPressed: () {
                AppRouter.push(context, RouteName.USER_INVOICE_ADD_TITLE)
                    .then((value) {
                  _controller.requestRefresh();
                });
              },
              child: Text('添加发票抬头'),
              color: AppColor.redColor,
            ),
          ),
        ),
      ),
    );
  }

  _buildCard(InvoiceTitleListModel model) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          AppRouter.push(
            context,
            RouteName.USER_INVOICE_ADD_TITLE,
            arguments: {
              'model': model,
            },
          ).then((value) {
            _controller.requestRefresh();
          });
        },
        child: Container(
          constraints: BoxConstraints(minHeight: rSize(52)),
          child: Row(
            children: [
              SizedBox(width: rSize(15)),
              Text(
                model.name,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: rSize(16),
                ),
              ),
              SizedBox(width: rSize(8)),
              model.defaultValue == 1
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: rSize(6),
                        vertical: rSize(1),
                      ),
                      child: Text(
                        '默认',
                        style: TextStyle(
                          color: Color(0xFFFA6400),
                          fontSize: rSP(12),
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFFA6400),
                        ),
                        borderRadius: BorderRadius.circular(rSize(4)),
                      ),
                    )
                  : SizedBox(),
              Spacer(),
              Icon(
                AppIcons.icon_next,
                color: Color(0xFF666666),
                size: rSize(12),
              ),
              SizedBox(width: rSize(12)),
            ],
          ),
        ),
      ),
    );
  }
}
