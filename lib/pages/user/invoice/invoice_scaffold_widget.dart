import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/app_image_resources.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';

class InvoiceScaffoldWidget extends StatefulWidget {
  final Widget body;
  final String title;
  final Color backgroundColor;
  final Widget bottomNavigationBar;
  final String extraMessage;
  final String address;
  final String tel;
  final String bankNum;
  InvoiceScaffoldWidget(
      {Key key,
      this.body,
      this.title,
      this.backgroundColor,
      this.bottomNavigationBar,
      this.extraMessage,
      this.address,
      this.tel,
      this.bankNum})
      : super(key: key);

  @override
  _InvoiceScaffoldWidgetState createState() => _InvoiceScaffoldWidgetState();
}

class _InvoiceScaffoldWidgetState extends State<InvoiceScaffoldWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? AppColor.frenchColor,
      appBar: CustomAppBar(
        elevation: 0,
        leading: _backButton(context),
        appBackground: Colors.white,
        themeData: AppBarTheme(
          brightness: Brightness.light,
        ),
        title: Text(
          widget.title ?? '开具发票',
          style: TextStyle(color: AppColor.blackColor),
        ),
      ),
      body: widget.body,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  _backButton(context) {
    if (Navigator.canPop(context)) {
      return IconButton(
          icon: Icon(
            AppIcons.icon_back,
            size: 17,
            color: AppColor.blackColor,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          });
    } else
      return SizedBox();
  }
}
