import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/pages/user/invoice/invoice_scaffold_widget.dart';

class InvoiceUploadDonePage extends StatefulWidget {
  InvoiceUploadDonePage({Key key}) : super(key: key);

  @override
  _InvoiceUploadDonePageState createState() => _InvoiceUploadDonePageState();
}

class _InvoiceUploadDonePageState extends State<InvoiceUploadDonePage> {
  @override
  Widget build(BuildContext context) {
    return InvoiceScaffoldWidget(
      backgroundColor: AppColor.frenchColor,
      body: Column(
        children: [
          SizedBox(height: rSize(8)),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: rSize(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: rSize(38),
                    width: double.infinity,
                  ),
                  Center(
                    child: Icon(
                      AppIcons.icon_check_circle,
                      color: Color(0xFFFA873A),
                      size: rSize(54),
                    ),
                  ),
                  SizedBox(
                    height: rSize(24),
                  ),
                  Center(
                    child: Text(
                      '提交成功',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: ScreenAdapterUtils.setSp(18),
                      ),
                    ),
                  ),
                  SizedBox(height: rSize(8)),
                  Center(
                    child: Text(
                      '您的发票预计将在24小时内开出，请注意查收',
                      style: TextStyle(
                        fontSize: ScreenAdapterUtils.setSp(13),
                        color: Color(0xFF999999),
                      ),
                    ),
                  ),
                  SizedBox(height: rSize(48)),
                  FlatButton(
                    color: AppColor.redColor,
                    splashColor: Colors.black.withOpacity(0.3),
                    padding: EdgeInsets.symmetric(
                      vertical: rSize(12),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(rSize(4)),
                    ),
                    child: Text(
                      '发票首页',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenAdapterUtils.setSp(16),
                      ),
                    ),
                  ),
                  SizedBox(height: rSize(16)),
                  OutlineButton(
                    color: Color(0xFF666666),
                    borderSide: BorderSide(
                      color: Color(0xFF666666),
                    ),
                    splashColor: AppColor.redColor.withOpacity(0.1),
                    highlightedBorderColor: Color(0xFF666666),
                    padding: EdgeInsets.symmetric(
                      vertical: rSize(12),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      AppRouter.push(context, RouteName.USER_INVOICE_HISTORY);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(rSize(4)),
                    ),
                    child: Text(
                      '开票历史',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: ScreenAdapterUtils.setSp(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
