import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/pages/user/invoice/invoice_add_title_page.dart';
import 'package:recook/pages/user/invoice/invoice_presenter.dart';
import 'package:recook/pages/user/invoice/models/invoice_title_list_model.dart';
import 'package:recook/widgets/refresh_widget.dart';

pickInvoiceTitle(
    BuildContext context, Function(InvoiceTitleListModel model) onModel) {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: InvoicePicker(
          onModel: onModel,
        ),
      );
    },
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 300),
  );
}

class InvoicePicker extends StatefulWidget {
  final Function(InvoiceTitleListModel model) onModel;
  InvoicePicker({Key key, this.onModel}) : super(key: key);

  @override
  _InvoicePickerState createState() => _InvoicePickerState();
}

class _InvoicePickerState extends State<InvoicePicker> {
  InvoicePresenter _invoicePresenter = InvoicePresenter();
  List<InvoiceTitleListModel> _models = [];
  GSRefreshController _controller = GSRefreshController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        _controller.requestRefresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              rSize(16),
            ),
          ),
        ),
        height: rSize(375),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(rSize(16)),
              child: Text(
                '常用发票抬头',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                  fontSize: 16 * 2.sp,
                ),
              ),
            ),
            _buildDivider(),
            Expanded(
                child: RefreshWidget(
              controller: _controller,
              onRefresh: () async {
                await _invoicePresenter.getInvoiceTitleList().then((value) {
                  setState(() {
                    _models = value;
                    _controller.refreshCompleted();
                  });
                });
              },
              body: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: rSize(0.5),
                      color: Color(0xFF666666),
                    );
                  },
                  itemBuilder: (context, index) {
                    return Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          widget.onModel(_models[index]);
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: rSize(15),
                              height: rSize(48),
                            ),
                            Text(
                              _models[index].name,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: rSP(14),
                              ),
                            ),
                            Spacer(),
                            _models[index].defaultValue == 1
                                ? Text(
                                    '默认抬头',
                                    style: TextStyle(
                                      color: Color(0xFFFA6400),
                                      fontSize: rSP(14),
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              width: rSize(15),
                              height: rSize(48),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: _models.length),
            )),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: rSize(16),
                vertical: rSize(12),
              ),
              child: FlatButton(
                color: AppColor.redColor,
                onPressed: () {
                  Get.off(InvoiceAddTitlePage());
                },
                padding: EdgeInsets.symmetric(
                  vertical: rSize(12),
                ),
                child: Text('添加常用发票抬头'),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).viewPadding.bottom,
            ),
          ],
        ),
      ),
    );
  }

  _buildDivider() {
    return Divider(
      color: Color(0xFFEEEEEE),
      thickness: 0.5,
      height: 0.5,
    );
  }
}
