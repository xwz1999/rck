import 'package:flutter/material.dart';
import 'package:recook/pages/user/invoice/invoice_presenter.dart';
import 'package:recook/pages/user/invoice/models/invoice_detail_model.dart';

import '../../../constants/constants.dart';
import '../../../widgets/custom_image_button.dart';
import 'invoice_scaffold_widget.dart';

class InvoiceDetailInfomationPage extends StatefulWidget {
  final dynamic arguments;
  InvoiceDetailInfomationPage({
    Key? key,
    this.arguments,
  }) : super(key: key);

  @override
  _InvoiceDetailInfomationPageState createState() =>
      _InvoiceDetailInfomationPageState();
}

class _InvoiceDetailInfomationPageState
    extends State<InvoiceDetailInfomationPage> {
  InvoiceDetailModel? model;
  InvoicePresenter _invoicePresenter = InvoicePresenter();
  bool _showMore = false;
  @override
  void initState() {
    super.initState();
    _invoicePresenter.getDetailModel(widget.arguments['id']).then((value) {
      setState(() {
        model = value;
      });
    });
  }


  String  statusString(int invoiceStatus) {
    switch (invoiceStatus) {
      case 1:
        return '开票中';
      case 2:
        return '开票异常';
      case 3:
        return '开票中';
      case 4:
        return '开票失败';
      case 5:
        return '开票成功';
      default:
        return '未知';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InvoiceScaffoldWidget(
      title: '发票详情',
      body: model == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                SizedBox(height: rSize(8)),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: rSize(12),
                    horizontal: rSize(16),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '电子发票',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: rSize(16),
                        ),
                      ),

                      Spacer(),
                      Text(
                        statusString(model!.invoiceStatus??1),
                        style: TextStyle(
                          color: model!.invoiceStatus == 5
                              ? Color(0xFFFF8F44)
                              : Color(0xFF333333),
                          fontSize: rSize(16),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: rSize(8)),
                _buildBox('公司名称', model!.buyerName),
                _buildBox('公司税号', model!.taxNum),
                _buildBox('公司地址', model!.address, show: _showMore),
                _buildBox('公司电话', model!.telephone, show: _showMore),
                _buildBox('开户银行账号', model!.account, show: _showMore),
                _buildBox('发票内容', '平台消费', show: _showMore),//发票内容暂时写死
                _buildBox('备注', model!.message, show: _showMore),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: rSize(12),
                    horizontal: rSize(16),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '发票金额',
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: rSize(16),
                        ),
                      ),
                      Spacer(),
                      Text(
                        model!.totalAmount!.toStringAsFixed(2),
                        style: TextStyle(
                          color: Color(0xFFFF4D4F),
                          fontSize: rSize(14),
                        ),
                      ),
                      Text(
                        '元',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: rSize(14),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBox('申请时间', model!.ctime),
                CustomImageButton(
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: rSize(12)),
                    child: Text(
                      _showMore ? '收起' : '展开更多信息',
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: rSP(12),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _showMore = !_showMore;
                    });
                  },
                ),
              ],
            ),
    );
  }

  _buildBox(String title, String? subtitle, {bool show = true}) {
    if (!show) return SizedBox();
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: rSize(12),
        horizontal: rSize(16),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: rSize(16),
            ),
          ),
          Spacer(),
          Text(
            subtitle!,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSize(14),
            ),
          ),
        ],
      ),
    );
  }
}
