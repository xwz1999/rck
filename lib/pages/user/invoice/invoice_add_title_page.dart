import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/pages/user/invoice/invoice_presenter.dart';
import 'package:jingyaoyun/pages/user/invoice/invoice_scaffold_widget.dart';
import 'package:jingyaoyun/pages/user/invoice/models/invoice_title_list_model.dart';
import 'package:jingyaoyun/pages/user/widget/recook_check_box.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/sc_tile.dart';

class InvoiceAddTitlePage extends StatefulWidget {
  final dynamic arguments;
  InvoiceAddTitlePage({Key key, this.arguments}) : super(key: key);

  @override
  _InvoiceAddTitlePageState createState() => _InvoiceAddTitlePageState();
}

class _InvoiceAddTitlePageState extends State<InvoiceAddTitlePage> {
  bool _isCompany = true;
  bool defaultValue = false;

  TextEditingController _cName = TextEditingController();
  TextEditingController _pName = TextEditingController();
  TextEditingController _taxNum = TextEditingController();
  TextEditingController _addr = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _bankNum = TextEditingController();
  InvoiceTitleListModel model;
  InvoicePresenter _invoicePresenter = InvoicePresenter();
  @override
  void initState() {
    super.initState();
    if (widget.arguments != null) {
      model = widget.arguments['model'] as InvoiceTitleListModel;

      _isCompany = (model.type == 1);
      _cName.text = _isCompany ? model.name : "";
      _pName.text = _isCompany ? "" : model.name;
      _taxNum.text = model.taxnum;
      _addr.text = model.address;
      _phone.text = model.phone;
      _bankNum.text = model.bank;
      defaultValue = model.defaultValue == 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InvoiceScaffoldWidget(
      title: '常用发票抬头',
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: rSize(8)),
        children: [
          SCTile.listTile(
              '抬头类型',
              Row(
                children: [
                  CustomImageButton(
                    onPressed: () {
                      setState(() {
                        _isCompany = true;
                      });
                    },
                    child: Row(
                      children: [
                        RecookCheckBox(state: _isCompany),
                        SizedBox(width: rSize(8)),
                        Text(
                          '企业单位',
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
                      });
                    },
                    child: Row(
                      children: [
                        RecookCheckBox(state: !_isCompany),
                        SizedBox(width: rSize(8)),
                        Text(
                          '个人/非企业单位',
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
          _isCompany ? _buildCompany() : _buildPersonal(),
          SizedBox(height: rSize(10)),
          Material(
            color: Colors.white,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: rSize(16)),
              title: Text(
                '设备默认抬头',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: rSP(16),
                ),
              ),
              subtitle: Text(
                '每次开票会默认填写该抬头信息',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: rSP(12),
                ),
              ),
              trailing: CupertinoSwitch(
                value: defaultValue,
                activeColor: AppColor.redColor,
                onChanged: (value) {
                  setState(() {
                    defaultValue = value;
                  });
                },
              ),
            ),
          ),
        ],
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
              disabledColor: Color(0xFFCCCCCC),
              disabledTextColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: rSize(13)),
              onPressed: _parseCheck()
                  ? () {
                      if (widget.arguments != null) {
                        _invoicePresenter
                            .updateLetterHead(
                          _isCompany ? 1 : 2,
                          _isCompany ? _cName.text : _pName.text,
                          model.id,
                          taxNum: _taxNum.text,
                          addr: _addr.text,
                          phone: _phone.text,
                          bankNum: _bankNum.text,
                          defaultValue: defaultValue ? 1 : 0,
                        )
                            .then((value) {
                          Navigator.pop(context);
                        });
                      } else
                        _invoicePresenter
                            .addLetterHead(
                          _isCompany ? 1 : 2,
                          _isCompany ? _cName.text : _pName.text,
                          taxNum: _taxNum.text,
                          addr: _addr.text,
                          phone: _phone.text,
                          bankNum: _bankNum.text,
                          defaultValue: defaultValue ? 1 : 0,
                        )
                            .then((value) {
                          Navigator.pop(context);
                        });
                    }
                  : null,
              child: Text('保存'),
              color: AppColor.redColor,
            ),
          ),
        ),
      ),
    );
  }

  _buildCompany() {
    return Column(
      children: [
        SCTile.listTile(
          '公司名称',
          TextField(
            style: TextStyle(color: Color(0xFF333333)),
            controller: _cName,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              hintText: '请输入公司名称',
              hintStyle: TextStyle(
                fontSize: rSP(14),
                color: Color(0xFF999999),
              ),
            ),
          ),
          inNeed: true,
        ),
        _BuildDivider(),
        SCTile.listTile(
          '公司税号',
          TextField(
            style: TextStyle(color: Color(0xFF333333)),
            controller: _taxNum,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: '请填写纳税人识别号',
              hintStyle: TextStyle(
                color: Color(0xFF999999),
                fontSize: rSP(14),
              ),
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          ),
          inNeed: true,
        ),
        _BuildDivider(),
        SCTile.listTile(
          '注册地址',
          TextField(
            style: TextStyle(color: Color(0xFF333333)),
            onChanged: (_) => setState(() {}),
            controller: _addr,
            decoration: InputDecoration(
              hintText: '请填写公司注册地址',
              hintStyle: TextStyle(
                color: Color(0xFF999999),
                fontSize: rSP(14),
              ),
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          ),
        ),
        _BuildDivider(),
        SCTile.listTile(
          '注册电话',
          TextField(
            style: TextStyle(color: Color(0xFF333333)),
            controller: _phone,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: '请填写公司注册电话',
              hintStyle: TextStyle(
                color: Color(0xFF999999),
                fontSize: rSP(14),
              ),
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          ),
        ),
        _BuildDivider(),
        SCTile.listTile(
          '银行账号',
          TextField(
            style: TextStyle(color: Color(0xFF333333)),
            controller: _bankNum,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: '请填写银行帐号',
              hintStyle: TextStyle(
                color: Color(0xFF999999),
                fontSize: rSP(14),
              ),
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  //前端验证
  bool _parseCheck() {
    return _isCompany
        ? (TextUtils.isNotEmpty(_cName.text) &&
            TextUtils.isNotEmpty(_taxNum.text))
        : (TextUtils.isNotEmpty(_pName.text));
  }

  _buildPersonal() {
    return SCTile.listTile(
      '名称',
      TextField(
        style: TextStyle(color: Color(0xFF333333)),
        controller: _pName,
        onChanged: (text) => setState(() {}),
        decoration: InputDecoration(
          hintText: '填写发票抬头',
          hintStyle: TextStyle(
            color: Color(0xFF999999),
            fontSize: rSP(14),
          ),
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
      ),
      inNeed: true,
    );
  }

  _BuildDivider() {
    return Divider(
      height: rSize(0.5),
      thickness: rSize(0.5),
      color: Color(0xFFEEEEEE),
    );
  }
}
