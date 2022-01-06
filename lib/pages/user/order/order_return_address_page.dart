/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-15  14:52 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/express_company_model.dart';
import 'package:jingyaoyun/models/order_return_address_model.dart';
import 'package:jingyaoyun/models/order_return_status_model.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/sc_tile.dart';
import 'package:jingyaoyun/widgets/toast.dart';

class OrderReturnAddressPage extends StatefulWidget {
  final Map arguments;

  const OrderReturnAddressPage({Key key, this.arguments}) : super(key: key);

  static setArguments(OrderReturnStatusModel statusModel) {
    return {"statusModel": statusModel};
  }

  @override
  State<StatefulWidget> createState() {
    return _OrderReturnAddressPageState();
  }
}

class _OrderReturnAddressPageState
    extends BaseStoreState<OrderReturnAddressPage> {
  TextStyle textStyle = TextStyle(color: Colors.grey[500], fontSize: 13 * 2.sp);
  OrderReturnAddressModel _addressModel;

  FocusNode _expressFocusNode;
  TextEditingController _expressController;
  FocusNode _expressFeeFocusNode;
  TextEditingController _expressFeeController;

  bool _commitButtonEnable = false;

  String _expressCompany;
  List<String> _expressCompanies;
  OrderReturnStatusModel _statusModel;

  @override
  void initState() {
    super.initState();
    _getAddressDetail();
    _statusModel = widget.arguments['statusModel'];

    _expressController = TextEditingController();
    _expressFocusNode = FocusNode();
    _expressFeeController = TextEditingController();
    _expressFeeFocusNode = FocusNode();
  }

  _getAddressDetail() async {
    ResultData resultData =
        await HttpManager.post(OrderApi.order_return_address, {});
    if (!resultData.result) {
      Toast.showError(resultData.msg);
      return;
    }
    OrderReturnAddressModel model =
        OrderReturnAddressModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      Toast.showError(model.msg);
      return;
    }
    _addressModel = model;
    setState(() {});
  }

  _returnExpressFill() async {
    ResultData resultData =
        await HttpManager.post(OrderApi.after_sales_express_fill, {
      'asId': _statusModel.data.asId,
      'expressCompName': _expressCompany,
      'expressNo': _expressController.text,
      'expressFree': _expressFeeController.text
    });
    if (!resultData.result) {
      Toast.showError(resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      Toast.showError(model.msg);
      return;
    }
    // setState(() {});
    Navigator.maybePop<dynamic>(context, true);
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        // elevation: 0,
        title: "单号提交",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        actions: <Widget>[
          CustomImageButton(
            padding: EdgeInsets.only(
                top: rSize(8), right: rSize(10), left: rSize(8)),
            color: Colors.black,
          )
        ],
      ),
      backgroundColor: AppColor.frenchColor,
      // body: _buildBody(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return ListView(
      children: <Widget>[
        // _returnInfoWidget(),
        _addressModel == null ? Container() : _addressWidget(),
        _addressModel == null ? Container() : _expressInfoView(),
        _addressModel == null ? Container() : _inputExpressWidget(),
        // _addressModel == null || _statusModel.data.reasonType == 1
        //     ? Container()
        //     : _inputExpressFeeWidget(),
        Container(
          height: 60 * 2.h,
        ),
        _addressModel == null ? Container() : _buttonWidget(),
        SafeArea(
          child: SizedBox(
            height: rSize(10),
          ),
          bottom: true,
        )
      ],
    );
  }

  _inputExpressWidget() {
    return Container(
      color: Colors.white,
      height: 35 * 2.h,
      margin: EdgeInsets.symmetric(vertical: 8 * 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: rSize(10)),
            alignment: Alignment.centerLeft,
            width: rSize(60),
            child: Text(
              '单号',
              style: TextStyle(color: Colors.black, fontSize: 16 * 2.sp),
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: (String string) {
                setState(() {
                  if (string.length > 0) {
                    _commitButtonEnable = true;
                  } else {
                    _commitButtonEnable = false;
                  }
                });
              },
              controller: _expressController,
              focusNode: _expressFocusNode,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black, fontSize: 15 * 2.sp),
              // inputFormatters: [LengthLimitingTextInputFormatter(11),],
              cursorColor: Colors.black,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.only(
                //     left: rSize(10), top: rSize(13)),
                border: InputBorder.none,
                hintText: "请输入退货商品的快递单号",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[400],
                    fontSize: 15 * 2.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _inputExpressFeeWidget() {
    return Container(
      color: Colors.white,
      height: 35 * 2.h,
      margin: EdgeInsets.symmetric(vertical: 8 * 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: rSize(10)),
            alignment: Alignment.centerLeft,
            width: rSize(60),
            child: Text(
              '运费补偿',
              style: TextStyle(color: Colors.black, fontSize: 16 * 2.sp),
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: (String string) {
                setState(() {
                  if (string.length > 0) {
                    _commitButtonEnable = true;
                  } else {
                    _commitButtonEnable = false;
                  }
                });
              },
              controller: _expressFeeController,
              focusNode: _expressFeeFocusNode,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black, fontSize: 15 * 2.sp),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "请填写您的发货费用",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[400],
                    fontSize: 15 * 2.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _addressWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rSize(20)),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 50 * 2.h,
            child: Text(
              '官方收货地址',
              style: TextStyle(color: Colors.black, fontSize: 18 * 2.sp),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text('收件人: ${_addressModel.data.name}', style: textStyle),
          ),
          Container(
            margin: EdgeInsets.only(top: 8 * 2.h),
            alignment: Alignment.centerLeft,
            child: Text('电话: ${_addressModel.data.mobile}', style: textStyle),
          ),
          Container(
            margin: EdgeInsets.only(top: 8 * 2.h, bottom: 8 * 2.h),
            alignment: Alignment.centerLeft,
            child: Text('地址: ${_addressModel.data.address}', style: textStyle),
          ),
        ],
      ),
    );
  }

  _buttonWidget() {
    return Container(
      margin: EdgeInsets.only(top: 40 * 2.h),
      padding: EdgeInsets.symmetric(horizontal: rSize(20)),
      height: 40 * 2.h,
      child: FlatButton(
        onPressed: () {
          if (!_commitButtonEnable) {
            return;
          }
          if (TextUtils.isEmpty(_expressCompany)) {
            Toast.showError('请先选择快递公司!');
            return;
          }
          if (TextUtils.isEmpty(_expressController.text)) {
            Toast.showError('请输入正确的快单号!');
            return;
          }

          Alert.show(
              context,
              NormalContentDialog(
                title: "单号",
                content: Text(
                  "请再次确认单号:${_expressController.text}",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                items: ["确认提交", "重新输入"],
                listener: (int index) {
                  // Alert.dismiss(context);
                  if (index == 0) {
                    // 提现
                    _returnExpressFill();
                    Alert.dismiss(context);
                  } else {
                    FocusScope.of(context).requestFocus(_expressFocusNode);
                    Alert.dismiss(context);
                  }
                },
              ));
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _commitButtonEnable
                ? AppColor.themeColor
                : AppColor.themeColor.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          child: Text(
            '提交',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontSize: 18 * 2.sp),
          ),
        ),
      ),
    );
  }

  _expressInfoView() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(
        top: 8 * 2.h,
      ),
      // padding: EdgeInsets.all(rSize(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SCTile.normalTile("快递公司",
              value: _expressCompany ?? "请选择快递公司",
              padding: EdgeInsets.only(top: rSize(3), left: rSize(8)),
              margin: EdgeInsets.symmetric(vertical: rSize(8)), listener: () {
            _getExpressCompany();
          }),
        ],
      ),
    );
  }

  _getExpressCompany() async {
    if (_expressCompanies != null && _expressCompanies.length > 0) {
      _showExpressCompanyList(_expressCompanies);
      return;
    }

    GSDialog.of(globalContext).showLoadingDialog(globalContext, "");
    ResultData resultData =
        await HttpManager.post(OrderApi.express_company_list, {});
    GSDialog.of(context).dismiss(context);

    if (!resultData.result) {
      GSDialog.of(globalContext).showError(context, resultData.msg);
      return;
    }
    ExpressCompanyModel model = ExpressCompanyModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      GSDialog.of(globalContext).showError(context, model.msg);
      return;
    }
    _expressCompanies = model.data;
    _showExpressCompanyList(model.data);
  }

  _showExpressCompanyList(List<String> companies) {
    showCustomModalBottomSheet(
        context: globalContext,
        builder: (context) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              constraints:
                  BoxConstraints(maxHeight: DeviceInfo.screenHeight * 0.6),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(rSize(8)))),
              child: Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                          vertical: rSize(8), horizontal: rSize(10)),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "请选择快递公司:",
                            style: AppTextStyle.generate(14 * 2.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          CustomImageButton(
                            icon: Icon(
                              AppIcons.icon_delete,
                              size: rSize(18),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )),
                  Expanded(
                    child: ListView.builder(
                        itemCount: companies.length,
                        itemBuilder: (_, index) {
                          return CustomImageButton(
                            child: Container(
                              alignment: Alignment.center,
                              padding:
                                  EdgeInsets.symmetric(vertical: rSize(10)),
                              child: Text(
                                companies[index],
                                style: AppTextStyle.generate(rSize(15)),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                _expressCompany = _expressCompanies[index];
                              });
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
