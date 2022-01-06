/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/25  2:43 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/address_list_model.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/province_city_model.dart';
import 'package:jingyaoyun/pages/user/address/mvp/address_model_impl.dart';
import 'package:jingyaoyun/utils/file_utils.dart';
import 'package:jingyaoyun/widgets/bottom_sheet/address_selector.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/edit_tile.dart';
import 'package:jingyaoyun/widgets/toast.dart';

class NewAddressPage extends StatefulWidget {
  final bool isFirstAdd;
  final Map arguments;

  const NewAddressPage({Key key, this.arguments, this.isFirstAdd})
      : super(key: key);

  static setArguments(Address address) {
    return {"address": address};
  }

  @override
  State<StatefulWidget> createState() {
    return _NewAddressPageState();
  }
}

class _NewAddressPageState extends BaseStoreState<NewAddressPage> {
  AddressModelImpl _modelImpl;
  ProvinceCityModel _addressModel;
  StateSetter _addressStateSetter;
  Address _address;

  @override
  void initState() {
    super.initState();
    _modelImpl = AddressModelImpl();
    if (widget.arguments != null) {
      _address = widget.arguments["address"];
    }

    if (_address == null) {
      _address = Address.empty();
    }
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "添加收货地址",
        elevation: 1,
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      backgroundColor: AppColor.frenchColor,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: ListView(
            children: <Widget>[
              Container(
                height: 10,
              ),
              EditTile(
                constraints: BoxConstraints.tight(Size(double.infinity, 45)),
                title: "收货人",
                value: _address.name,
                hint: "请填写收货人姓名",
                textChanged: (value) {
                  _address.name = value;
                },
              ),
              Container(
                height: 3,
              ),
              EditTile(
                constraints: BoxConstraints.tight(Size(double.infinity, 45)),
                title: "手机号码",
                value: _address.mobile,
                hint: "请填写收货人手机号码",
                maxLength: 11,
                textChanged: (value) {
                  _address.mobile = value;
                },
              ),
              Container(
                height: 3,
              ),
              _addressView(),
              Container(
                height: 3,
              ),
              EditTile(
                title: "详细地址",
                hint: "街道门牌号等",
                value: _address.address,
                maxLength: 100,
                maxLines: 3,
                direction: Axis.vertical,
                constraints: BoxConstraints(maxHeight: 100),
                textChanged: (value) {
                  _address.address = value;
                },
              ),
              Container(
                height: 30,
              ),
              _defaultAddressTile(),
              Container(
                height: 100,
              ),
              _saveButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Container _saveButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: CustomImageButton(
        height: 45,
        padding: EdgeInsets.symmetric(vertical: 8),
        title: "保存地址",
        backgroundColor: AppColor.themeColor,
        color: Colors.white,
        fontSize: 17 * 2.sp,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        onPressed: () {
          _saveAddress(context);
        },
      ),
    );
  }

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
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
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

  _defaultAddressTile() {
    if (widget.isFirstAdd != null)
      widget.isFirstAdd ? _address.isDefault = 1 : _address.isDefault = 0;
    return StatefulBuilder(
      builder: (context, setSta) {
        return GestureDetector(
          onTap: () {
            setSta(() {
              if (_address.isDefault == 0) {
                _address.isDefault = 1;
              } else {
                _address.isDefault = 0;
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(color: Colors.grey[200], width: 0.5))),
            child: Row(
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    "设为默认地址",
                    style:
                        AppTextStyle.generate(15, fontWeight: FontWeight.w300),
                  ),
                ),
                Spacer(),
                _address.isDefault == 0
                    ? Icon(
                        AppIcons.icon_check,
                        color: Colors.grey,
                        size: 20,
                      )
                    : Icon(
                        Icons.check_circle,
                        color: AppColor.themeColor,
                        size: 20,
                      )
              ],
            ),
          ),
        );
      },
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

  /// 保存地址
  _saveAddress(BuildContext context) async {
    if (TextUtils.isEmpty(_address.name)) {
      Toast.showError("收货人不能为空");
      return;
    }

    if (TextUtils.isEmpty(_address.mobile) ||
        !TextUtils.verifyPhone(_address.mobile)) {
      Toast.showError("手机号格式不正确");
      return;
    }

    if (TextUtils.isEmpty(_address.province)) {
      Toast.showError("所在地区不能为空");
      return;
    }

    if (TextUtils.isEmpty(_address.address)) {
      Toast.showError("详细地址不能为空");
      return;
    }

    ResultData resultData;
    if (_address.id != null) {
      resultData = await _modelImpl.updateAddress(
          _address.id,
          UserManager.instance.user.info.id,
          _address.name,
          _address.province,
          _address.city,
          _address.district,
          _address.address,
          _address.mobile,
          _address.isDefault);
    } else {
      resultData = await _modelImpl.addNewAddress(
          UserManager.instance.user.info.id,
          _address.name,
          _address.province,
          _address.city,
          _address.district,
          _address.address,
          _address.mobile,
          _address.isDefault);
    }

    if (!resultData.result) {
      Toast.showError(resultData.msg);
      return;
    }

    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      Toast.showError(model.msg);
      return;
    }
    Navigator.maybePop<dynamic>(context, _address);
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
