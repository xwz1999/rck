import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/pages/user/invoice/invoice_scaffold_widget.dart';
import 'package:jingyaoyun/widgets/sc_tile.dart';

class InvoicePage extends StatefulWidget {
  InvoicePage({Key key}) : super(key: key);

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  @override
  Widget build(BuildContext context) {
    return InvoiceScaffoldWidget(
      body: ListView(
        padding: EdgeInsets.only(
          top: rSize(8),
        ),
        children: [
          SCTile.normalTile('平台消费开票',
              listener: () =>
                  AppRouter.push(context, RouteName.USER_INVOICE_GOODS)),
          _buildDivider(),
          SCTile.normalTile('常用发票抬头',
              listener: () =>
                  AppRouter.push(context, RouteName.USER_INVOICE_USUALLY_USED)),
          _buildDivider(),
          SCTile.normalTile('开票历史',
              listener: () =>
                  AppRouter.push(context, RouteName.USER_INVOICE_HISTORY)),
        ],
      ),
    );
  }

  _buildDivider() {
    return Container(
      color: Colors.white,
      child: Divider(
        color: Color(0xFFEEEEEE),
        height: 0.5,
        indent: rSize(16),
      ),
    );
  }
}
