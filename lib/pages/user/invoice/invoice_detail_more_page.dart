import 'package:flutter/material.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/pages/user/invoice/invoice_scaffold_widget.dart';


class InvoiceDetailMorePage extends StatefulWidget {
  final TextEditingController addr;
  final TextEditingController telephone;
  final TextEditingController bankNum;
  final TextEditingController message;
  InvoiceDetailMorePage({
    Key key,
    @required this.addr,
    @required this.telephone,
    @required this.bankNum,
    @required this.message,
  }) : super(key: key);

  @override
  _InvoiceDetailMorePageState createState() => _InvoiceDetailMorePageState();
}

class _InvoiceDetailMorePageState extends State<InvoiceDetailMorePage> {
  int _addrMax = 0;
  int _messageMax = 0;
  @override
  Widget build(BuildContext context) {
    return InvoiceScaffoldWidget(
      body: ListView(
        padding: EdgeInsets.only(
          top: rSize(8),
        ),
        children: [
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: rSize(12)),
                Row(
                  children: [
                    SizedBox(width: rSize(16)),
                    Text(
                      '公司地址',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(16),
                      ),
                    ),
                    Spacer(),
                    Text(
                      '$_addrMax/50',
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: rSize(14),
                      ),
                    ),
                    SizedBox(width: rSize(16)),
                  ],
                ),
                TextField(
                  controller: widget.addr,
                  onChanged: (text) {
                    setState(() {
                      _addrMax = text.length;
                    });
                  },
                  style: TextStyle(
                    color: Color(0xFF333333),
                  ),
                  minLines: 3,
                  maxLines: 3,
                  maxLength: 50,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: rSize(16),
                      vertical: rSize(12),
                    ),
                    hintText: '填写公司地址',
                    hintStyle: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: rSize(14),
                    ),
                    border: InputBorder.none,
                  ),
                ),
                Divider(color: Color(0xFF666666)),
                Row(
                  children: [
                    SizedBox(
                      width: rSize(16),
                    ),
                    Text(
                      '公司电话',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(16),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: Color(0xFF333333),
                        ),
                        controller: widget.telephone,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: rSize(12),
                            horizontal: rSize(16),
                          ),
                          border: InputBorder.none,
                          hintText: '填写公司电话',
                          hintStyle: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: rSize(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: rSize(8)),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: rSize(12)),
                Row(
                  children: [
                    SizedBox(
                      width: rSize(16),
                    ),
                    Text(
                      '开户行帐号',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(16),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: Color(0xFF333333),
                        ),
                        controller: widget.bankNum,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: rSize(12),
                            horizontal: rSize(16),
                          ),
                          border: InputBorder.none,
                          hintText: '填写开户行帐号',
                          hintStyle: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: rSize(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: rSize(8)),
          Container(
            color: Colors.white,
            child: Row(
              children: [
                SizedBox(
                  width: rSize(16),
                  height: rSize(32),
                ),
                Text(
                  '备注',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: rSP(16),
                  ),
                ),
                Text(
                  '该内容将会打印在发票上',
                  style: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: rSize(14),
                  ),
                ),
                Spacer(),
                Text(
                  '$_messageMax/80',
                  style: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: rSize(14),
                  ),
                ),
                SizedBox(width: rSize(16)),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: TextField(
              controller: widget.message,
              onChanged: (text) {
                setState(() {
                  _messageMax = text.length;
                });
              },
              style: TextStyle(
                color: Color(0xFF333333),
              ),
              minLines: 3,
              maxLines: 3,
              maxLength: 80,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: rSize(16),
                  vertical: rSize(12),
                ),
                hintText: '按企业报销要求填写，如下单时间，下单原因',
                hintStyle: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: rSize(14),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
