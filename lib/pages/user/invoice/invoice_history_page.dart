import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/pages/user/invoice/invoice_presenter.dart';
import 'package:recook/pages/user/invoice/invoice_scaffold_widget.dart';
import 'package:recook/pages/user/invoice/models/invoice_bill_list_model.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_dotted_line.dart';
import 'package:recook/widgets/refresh_widget.dart';

class InvoiceHistoryPage extends StatefulWidget {
  InvoiceHistoryPage({Key key}) : super(key: key);

  @override
  _InvoiceHistoryPageState createState() => _InvoiceHistoryPageState();
}

class _InvoiceHistoryPageState extends State<InvoiceHistoryPage> {
  List<InvoiceBillListModel> _models = [];
  GSRefreshController _gsRefreshController = GSRefreshController();
  InvoicePresenter _presenter = InvoicePresenter();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      _gsRefreshController.requestRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InvoiceScaffoldWidget(
      title: '开票历史',
      body: RefreshWidget(
        onRefresh: () async {
          _presenter.getBillList().then((value) {
            setState(() {
              _models = value;
              _gsRefreshController.refreshCompleted();
            });
          });
        },
        controller: _gsRefreshController,
        body: ListView.builder(
          itemBuilder: (context, index) {
            return invoiceHistoryCard(
              context,
              _models[index],
            );
          },
          itemCount: _models.length,
        ),
      ),
    );
  }
}

Widget invoiceHistoryCard(BuildContext context, InvoiceBillListModel model) {
  return CustomImageButton(
    onPressed: () {
      AppRouter.push(context, RouteName.USER_INVOICE_DETAIL_INFOMATION,
          arguments: {'id': model.id});
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(rSize(8)),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: rSize(16),
        vertical: rSize(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: rSize(14)),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: rSize(10), right: rSize(8)),
                height: rSize(12),
                width: rSize(12),
                decoration: BoxDecoration(
                  color: Color(0xFFFD8637),
                  borderRadius: BorderRadius.circular(rSize(6)),
                ),
              ),
              Text(
                model.ctime,
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: rSP(14),
                ),
              ),
              Spacer(),
              Icon(
                AppIcons.icon_next,
                size: rSize(12),
                color: Color(0xFFCCCCCC),
              ),
              SizedBox(width: rSize(10)),
            ],
          ),
          SizedBox(height: rSize(24)),
          Row(
            children: [
              SizedBox(width: rSize(30)),
              Text(
                '平台消费',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: rSP(14),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: rSize(3)),
                decoration: BoxDecoration(
                  color: Color(0xFFE2F3FF),
                  borderRadius: BorderRadius.circular(rSize(3)),
                  border: Border.all(
                    width: rSize(1),
                    color: Color(0xFF63BCFF),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: rSize(5),
                  vertical: rSize(2),
                ),
                child: Text(
                  '电子发票',
                  style: TextStyle(
                    color: Color(0xFF10B1F1),
                    fontSize: rSP(11),
                  ),
                ),
              ),
              Spacer(),
              Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Text(
                    model.totalAmount.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: rSP(24),
                      color: Color(0xFF333333),
                    ),
                  ),
                  Text(
                    '元',
                    style: TextStyle(
                      fontSize: rSP(14),
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
              SizedBox(width: rSize(16)),
            ],
          ),
          SizedBox(height: rSize(20)),
          RecookDottedLine(),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              left: rSize(10),
              bottom: rSize(10),
              top: rSize(8),
            ),
            child: Text(
              model.statusString,
              style: TextStyle(
                color: model.statusColor,
                fontSize: rSP(13),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
