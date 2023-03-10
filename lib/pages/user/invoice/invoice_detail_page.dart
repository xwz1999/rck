import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/pages/user/invoice/invoice_presenter.dart';
import 'package:jingyaoyun/pages/user/invoice/invoice_scaffold_widget.dart';
import 'package:jingyaoyun/pages/user/invoice/pick_invoice_title_picker.dart';
import 'package:jingyaoyun/pages/user/widget/recook_check_box.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/sc_tile.dart';

import 'invoice_detail_more_page.dart';

class InvoiceDetailPage extends StatefulWidget {
  final Map<String, dynamic> arguments;
  InvoiceDetailPage({Key key, this.arguments}) : super(key: key);

  @override
  _InvoiceDetailPageState createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  bool _isCompany = true;
  InvoicePresenter _invoicePresenter = InvoicePresenter();

  TextEditingController _cName = TextEditingController();
  TextEditingController _pName = TextEditingController();
  TextEditingController _taxNum = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();

  TextEditingController _addr = TextEditingController();
  TextEditingController _telePhone = TextEditingController();
  TextEditingController _bankNum = TextEditingController();
  TextEditingController _message = TextEditingController();

  GlobalKey<FormState> _formState = GlobalKey<FormState>();

  controllerClear() {
    _cName.clear();
    _pName.clear();
    _taxNum.clear();
    _phone.clear();
    _email.clear();
    _addr.clear();
    _telePhone.clear();
    _bankNum.clear();
    _message.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formState,
      child: InvoiceScaffoldWidget(
        body: ListView(
          padding: EdgeInsets.only(
            top: rSize(8),
          ),
          children: [
            SCTile.listTile(
                '????????????',
                Row(
                  children: [
                    CustomImageButton(
                      onPressed: () {
                        setState(() {
                          _isCompany = true;
                          controllerClear();
                        });
                      },
                      child: Row(
                        children: [
                          RecookCheckBox(state: _isCompany),
                          SizedBox(width: rSize(8)),
                          Text(
                            '????????????',
                            style: TextStyle(
                              fontSize: 14 * 2.sp,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: rSize(24)),
                    CustomImageButton(
                      onPressed: () {
                        setState(() {
                          _isCompany = false;
                          controllerClear();
                        });
                      },
                      child: Row(
                        children: [
                          RecookCheckBox(state: !_isCompany),
                          SizedBox(width: rSize(8)),
                          Text(
                            '??????/?????????',
                            style: TextStyle(
                              fontSize: 14 * 2.sp,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            _buildDivider(),
            _isCompany ? _buildInc() : _buildPerson(),
            SizedBox(height: rSize(8)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: rSize(16),
                vertical: rSize(12),
              ),
              color: Colors.white,
              child: Row(
                children: [
                  Text(
                    '?????????',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16 * 2.sp,
                    ),
                  ),
                  Spacer(),
                  Text(
                    widget.arguments['price'].toString(),
                    style: TextStyle(
                      color: Color(0xFFDB2D2D),
                      fontSize: rSize(14),
                    ),
                  ),
                  Text(
                    ' ???',
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: rSize(14),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: rSize(16),
                vertical: rSize(10),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                '????????????',
                style: TextStyle(
                  fontSize: 14 * 2.sp,
                  color: Color(0xFF666666),
                ),
              ),
            ),
            SCTile.listTile(
              '????????????',
              TextFormField(
                validator: (value) {
                  if (TextUtils.isEmpty(value)) {
                    return "?????????????????????????????????";
                  } else
                    return null;
                },
                style: TextStyle(
                  color: Color(0xFF333333),
                ),
                onChanged: (_) => setState(() {}),
                controller: _phone,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  border: InputBorder.none,
                  hintText: '????????????????????????????????????',
                  hintStyle: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 14 * 2.sp,
                  ),
                ),
              ),
              inNeed: true,
            ),
            SCTile.listTile(
              '????????????',
              TextFormField(
                style: TextStyle(
                  color: Color(0xFF333333),
                ),
                validator: (value) {
                  if (TextUtils.isEmpty(value)) {
                    return "?????????????????????????????????";
                  } else
                    return null;
                },
                onChanged: (_) => setState(() {}),
                controller: _email,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  border: InputBorder.none,
                  hintText: '??????????????????????????????',
                  hintStyle: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 14 * 2.sp,
                  ),
                ),
              ),
              inNeed: true,
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(
            horizontal: rSize(16),
            vertical: rSize(12),
          ),
          child: SafeArea(
            bottom: true,
            top: false,
            child: FlatButton(
              padding: EdgeInsets.symmetric(
                vertical: rSize(12),
              ),
              color: AppColor.redColor,
              disabledColor: Color(0xFFCCCCCC),
              disabledTextColor: Colors.white,
              onPressed: _parseCheck()
                  ? () {
                      if (_formState.currentState.validate()) {
                        showGeneralDialog(
                          barrierDismissible: true,
                          barrierLabel: '',
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionDuration: Duration(milliseconds: 300),
                          context: context,
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: Material(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(
                                        rSize(10),
                                      ),
                                    ),
                                  ),
                                  height: rSize(375),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: rSize(15)),
                                          child: Text(
                                            '??????????????????',
                                            style: TextStyle(
                                              fontSize: 18 * 2.sp,
                                              color: Color(0xFF333333),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: ListView(
                                        children: [
                                          Divider(
                                            height: 0.5,
                                            color: Color(0xFF666666),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: rSize(12),
                                              horizontal: rSize(16),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '????????????',
                                                  style: TextStyle(
                                                    fontSize: rSize(16),
                                                    color: Color(0xFF999999),
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  '????????????',
                                                  style: TextStyle(
                                                    fontSize: rSize(14),
                                                    color: Color(0xFF333333),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 0.5,
                                            color: Color(0xFF666666),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: rSize(12),
                                              horizontal: rSize(16),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '????????????',
                                                  style: TextStyle(
                                                    fontSize: rSize(16),
                                                    color: Color(0xFF999999),
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  _isCompany
                                                      ? _cName.text
                                                      : _pName.text,
                                                  style: TextStyle(
                                                    fontSize: rSize(14),
                                                    color: Color(0xFF333333),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 0.5,
                                            color: Color(0xFF666666),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: rSize(12),
                                              horizontal: rSize(16),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '????????????',
                                                  style: TextStyle(
                                                    fontSize: rSize(16),
                                                    color: Color(0xFF999999),
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  widget.arguments['price']
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: rSize(14),
                                                    color: AppColor.redColor,
                                                  ),
                                                ),
                                                Text(
                                                  '???',
                                                  style: TextStyle(
                                                    fontSize: rSize(14),
                                                    color: Color(0xFF333333),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 0.5,
                                            color: Color(0xFF666666),
                                          ),
                                        ],
                                      )),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: rSize(16),
                                          vertical: rSize(12),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: rSize(16),
                                            vertical: rSize(12),
                                          ),
                                          child: TextButton(
                                            onPressed: _parseCheck()
                                                ? () async {
                                                    await _invoicePresenter
                                                        .createBill(
                                                      ids: widget
                                                          .arguments['ids'],
                                                      buyername: _isCompany
                                                          ? _cName.text
                                                          : _pName.text,
                                                      taxnum: _taxNum.text,
                                                      addr: _addr.text,
                                                      telephone:
                                                          _telePhone.text,
                                                      phone: _phone.text,
                                                      email: _email.text,
                                                      account: _bankNum.text,
                                                      totalAmount: widget
                                                          .arguments['price'],
                                                      invoiceStatus: 1,
                                                      message: _message.text,
                                                    )
                                                        .then((value) {
                                                      if (value) {
                                                        AppRouter.pushAndReplaced(
                                                            context,
                                                            RouteName
                                                                .USER_INVOICE_UPLOAD_DONE);
                                                      } else {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      }
                                                    });
                                                  }
                                                : null,
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        AppColor.redColor)),
                                            child: Text(
                                              '????????????',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16 * 2.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context)
                                            .viewPadding
                                            .bottom,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }
                  : null,
              child: Text(
                '??????',
                style: TextStyle(
                  fontSize: 16 * 2.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _parseCheck() {
    return _isCompany
        ? (TextUtils.isNotEmpty(_cName.text) &&
            TextUtils.isNotEmpty(_taxNum.text))
        : (TextUtils.isNotEmpty(_pName.text));
  }

  _buildInc() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SCTile.listTile(
          '????????????',
          TextField(
            style: TextStyle(
              color: Color(0xFF333333),
            ),
            onChanged: (_) => setState(() {}),
            controller: _cName,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              border: InputBorder.none,
              hintText: '??????????????????',
              hintStyle: TextStyle(
                color: Color(0xFF999999),
                fontSize: 14 * 2.sp,
              ),
            ),
          ),
          inNeed: true,
          suffix: GestureDetector(
            child: Icon(
              Icons.menu,
              color: Color(0xFF707070),
            ),
            onTap: () {
              pickInvoiceTitle(context, (model) {
                if (model.type == 1) {
                  _addr.text = model.address;
                  _cName.text = model.name;
                  _taxNum.text = model.taxnum;
                  _telePhone.text = model.phone;
                  _bankNum.text = model.bank;
                } else {
                  _pName.text = model.name;
                }
              });
            },
          ),
        ),
        _buildDivider(),
        SCTile.listTile(
          '????????????',
          TextField(
            style: TextStyle(
              color: Color(0xFF333333),
            ),
            onChanged: (_) => setState(() {}),
            controller: _taxNum,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              border: InputBorder.none,
              hintText: '????????????????????????',
              hintStyle: TextStyle(
                color: Color(0xFF999999),
                fontSize: 14 * 2.sp,
              ),
            ),
          ),
          inNeed: true,
        ),
        _buildDivider(),
        SCTile.listTile(
          '????????????',
          Text(
            '???????????????????????????????????????',
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 14 * 2.sp,
            ),
          ),
          suffix: Icon(
            AppIcons.icon_next,
            color: Color(0xFFCCCCCC),
            size: rSize(12),
          ),
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => InvoiceDetailMorePage(
                    addr: _addr,
                    bankNum: _bankNum,
                    message: _message,
                    telephone: _telePhone,
                  ),
                ));
          },
        ),
      ],
    );
  }

  _buildPerson() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SCTile.listTile(
          '????????????',
          TextField(
            style: TextStyle(
              color: Color(0xFF333333),
            ),
            onChanged: (_) => setState(() {}),
            controller: _pName,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              border: InputBorder.none,
              hintText: '??????????????????',
              hintStyle: TextStyle(
                color: Color(0xFF999999),
                fontSize: 14 * 2.sp,
              ),
            ),
          ),
          inNeed: true,
          suffix: GestureDetector(
            child: Icon(
              Icons.menu,
              color: Color(0xFF707070),
            ),
            onTap: () {
              pickInvoiceTitle(context, (model) {
                if (model.type == 1) {
                  _addr.text = model.address;
                  _cName.text = model.name;
                  _taxNum.text = model.taxnum;
                  _telePhone.text = model.phone;
                  _bankNum.text = model.bank;
                } else {
                  _pName.text = model.name;
                }
              });
            },
          ),
        ),
      ],
    );
  }

  _buildDivider() {
    return Container(
      child: Divider(
        height: 0.5 * 2.w,
        thickness: 1,
        color: Color(0xFFEEEEEE),
      ),
      color: Colors.white,
    );
  }
}
