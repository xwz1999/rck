/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-20  13:32 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/user/mvp/order_list_presenter_impl.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/input_view.dart';
import 'package:jingyaoyun/widgets/toast.dart';

class InvoiceAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InvoiceAddPageState();
  }
}

class _InvoiceAddPageState extends BaseStoreState<InvoiceAddPage> {
  int _type = 0;
  TextEditingController _titleController;
  TextEditingController _TFNController;

  OrderListPresenterImpl _presenter;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _TFNController = TextEditingController();
    _presenter = OrderListPresenterImpl();
  }

  @override
  void dispose() {
    super.dispose();
    _TFNController.dispose();
    _titleController.dispose();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "发票信息",
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: _buildBody(),
      backgroundColor: AppColor.tableViewGrayColor,
    );
  }

  _buildBody() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        _electronicPersonInvoice(),
        SizedBox(
          height: 100,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: rSize(50)),
          child: CustomImageButton(
            title: "确认保存",
            padding: EdgeInsets.symmetric(vertical: rSize(8)),
            backgroundColor: AppColor.themeColor,
            borderRadius: BorderRadius.all(Radius.circular(rSize(5))),
            color: Colors.white,
            fontSize: 14 * 2.sp,
            onPressed: () {
              _saveInvoice();
            },
          ),
        )
      ],
    );
  }

  Container _line() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: rSize(15)),
      color: Colors.grey[300],
      height: 0.5 * 2.w,
    );
  }

  _electronicPersonInvoice() {
    bool personal = _type == 0;
    Color selectedColor = Color(0xFFF0827D);
    Color unselectedColor = Colors.grey;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10 * 2.sp,
        vertical: 15 * 2.sp,
      ),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  width: rSize(80),
                  child: Text(
                    "发票类型",
                    style: AppTextStyle.generate(15 * 2.sp,
                        color: Colors.grey[500], fontWeight: FontWeight.w300),
                  )),
              CustomImageButton(
                title: "个人",
                padding: EdgeInsets.symmetric(
                    vertical: rSize(3), horizontal: rSize(10)),
                borderRadius: BorderRadius.all(Radius.circular(rSize(5))),
                border: personal
                    ? null
                    : Border.all(
                        color: unselectedColor,
                        width: ScreenAdapterUtils.setSp(0.5)),
                fontSize: 13 * 2.sp,
                backgroundColor: personal ? selectedColor : null,
                color: personal ? Colors.white : unselectedColor,
                onPressed: () {
                  if (_type == 0) return;
                  setState(() {
                    _type = 0;
                  });
                },
              ),
              SizedBox(
                width: rSize(10),
              ),
              CustomImageButton(
                title: "企业",
                padding: EdgeInsets.symmetric(
                    vertical: rSize(3), horizontal: rSize(10)),
                borderRadius: BorderRadius.all(Radius.circular(rSize(5))),
                border: !personal
                    ? null
                    : Border.all(
                        color: unselectedColor,
                        width: ScreenAdapterUtils.setSp(0.5)),
                fontSize: 13 * 2.sp,
                backgroundColor: !personal ? selectedColor : null,
                color: !personal ? Colors.white : unselectedColor,
                onPressed: () {
                  if (_type == 1) return;
                  setState(() {
                    _type = 1;
                  });
                },
              ),
            ],
          ),
          _line(),
          Row(
            children: <Widget>[
              Container(
                  width: rSize(80),
                  child: Text(
                    "发票抬头",
                    style: AppTextStyle.generate(15 * 2.sp,
                        color: Colors.grey[500], fontWeight: FontWeight.w300),
                  )),
              Expanded(
                child: InputView(
                  padding: EdgeInsets.zero,
                  controller: _titleController,
                  textStyle: AppTextStyle.generate(
                    15 * 2.sp,
                  ),
                  hint: "请输入发票抬头",
                  hintStyle:
                      AppTextStyle.generate(15 * 2.sp, color: Colors.grey[300]),
                ),
              ),
            ],
          ),
          Offstage(offstage: personal, child: _line()),
          Offstage(
            offstage: personal,
            child: Row(
              children: <Widget>[
                Container(
                    width: rSize(80),
                    child: Text(
                      "发票税号",
                      style: AppTextStyle.generate(15 * 2.sp,
                          color: Colors.grey[500], fontWeight: FontWeight.w300),
                    )),
                Expanded(
                  child: InputView(
                    padding: EdgeInsets.zero,
                    controller: _TFNController,
                    textStyle: AppTextStyle.generate(
                      15 * 2.sp,
                    ),
                    hint: "请输入税号",
                    hintStyle: AppTextStyle.generate(15 * 2.sp,
                        color: Colors.grey[300]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _saveInvoice() async {
    GSDialog.of(globalContext).showLoadingDialog(globalContext, "");
    HttpResultModel result = await _presenter.addInvoice(
        UserManager.instance.user.info.id,
        _type,
        _titleController.text,
        _TFNController.text);

    if (!result.result) {
      GSDialog.of(globalContext).showError(globalContext, result.msg);
      return;
    }
    Toast.showInfo("添加成功");
    Navigator.pop(globalContext, true);
  }
}
