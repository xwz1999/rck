import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/address_list_model.dart';
import 'package:recook/models/province_city_model.dart';
import 'package:recook/pages/user/address/mvp/address_model_impl.dart';
import 'package:recook/utils/file_utils.dart';
import 'package:recook/widgets/bottom_sheet/address_selector.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/toast.dart';

class UserInfoAddressPage extends StatefulWidget {
  final Map arguments;
  final Function(String result) callback;

  const UserInfoAddressPage({Key key, this.arguments, this.callback})
      : assert(arguments != null, "参数不能为空");

  static Map setArguments(String title, String origin, {int maxLength: 0}) {
    return {"title": title, "origin": origin, "maxLength": maxLength};
  }

  @override
  _UserInfoAddressPageState createState() => _UserInfoAddressPageState();
}

class _UserInfoAddressPageState extends BaseStoreState<UserInfoAddressPage> {
  TextEditingController _controller;
  ProvinceCityModel _addressModel;
  AddressModelImpl _modelImpl;
  StateSetter _addressStateSetter;
  Address _address;

  @override
  void initState() {
    super.initState();
    _modelImpl = AddressModelImpl();
    _controller = TextEditingController(text: widget.arguments["origin"]);
    if (_address == null) {
      _address = Address.empty();
    }
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        title: "${widget.arguments["title"]}",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        actions: <Widget>[
          CustomImageButton(
            padding: EdgeInsets.symmetric(horizontal: 10),
            fontSize: 15 * 2.sp,
            title: "确定",
            onPressed: () {
              String areaString =
                  "${_address.province}${_address.city}${!TextUtils.isEmpty(_address.district) ? "${_address.district}" : ""}";
              if (TextUtils.isEmpty(_controller.text) &&
                  TextUtils.isEmpty(areaString)) {
                showError("请填写详细地址信息");
                return;
              }
              Navigator.pop(context, areaString + _controller.text);
            },
          )
        ],
      ),
      body: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 150,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _addressView(),
              TextField(
                maxLength: widget.arguments["maxLength"],
                textAlign: TextAlign.start,
                style: AppTextStyle.generate(15 * 2.sp),
                controller: _controller,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.grey),
                    labelText: "请输入详细地址",
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        AppIcons.icon_clear,
                        color: Colors.grey[400],
                        size: 18 * 2.sp,
                      ),
                      onPressed: () {
                        _controller.text = "";
                      },
                    )),
              )
            ],
          )),
    );
  }

  // ==================
  _addressView() {
    return GestureDetector(
      onTap: () {
        if (_addressModel == null) {
          GSDialog.of(context).showLoadingDialog(context, "");
          _getAddress().then((success) {
            GSDialog.of(context).dismiss(context);
            if (success) {
              _selectAddress(context);
            }
          });
          return;
        }
        _selectAddress(context);
      },
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setSta) {
          _addressStateSetter = setSta;
          return Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(color: Colors.grey[200], width: 0.5))),
            child: Row(
              children: <Widget>[
                Container(
                  width: rSize(80),
                  child: Text(
                    "所在地区",
                    style:
                        AppTextStyle.generate(15, fontWeight: FontWeight.w300),
                  ),
                ),
                Expanded(
                    child: Text(
                  TextUtils.isEmpty(_address.province)
                      ? "选择地址"
                      : "${_address.province}-${_address.city}${!TextUtils.isEmpty(_address.district) ? "-${_address.district}" : ""}",
                  textAlign: TextAlign.end,
                  style: AppTextStyle.generate(14, fontWeight: FontWeight.w500),
                )),
                Icon(
                  AppIcons.icon_next,
                  size: 16,
                  color: Colors.black,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  /// 弹出地址选择
  _selectAddress(BuildContext context) {
    AddressSelectorHelper.show(context,
        model: _addressModel,
        province: _address.province,
        city: _address.city,
        district: _address.district,
        callback: (String province, String city, String district) {
      _address.province = province;
      _address.city = city;
      _address.district = district;
      _addressStateSetter(() {});
      DPrint.printf("$province - $city -$district");
    });
  }

  Future<bool> _getAddress() async {
    FileOperationResult result =
        await FileUtils.readJSON(AppPaths.path_province_city_json);
    if (result.success &&
        result.data != null &&
        result.data.toString().length > 0) {
      _addressModel = ProvinceCityModel.fromJson(json.decode(result.data));
      return true;
    }
    ResultData res = await _modelImpl.fetchWholeProvince();
    if (!res.result) {
      Toast.showError(res.msg);
      return false;
    }
    _addressModel = ProvinceCityModel.fromJson(res.data);
    FileUtils.writeJSON(
        AppPaths.path_province_city_json, json.encode(res.data));
    return true;
  }
}
