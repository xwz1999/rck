/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/24  4:05 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/address_list_model.dart';
import 'package:recook/widgets/custom_image_button.dart';

// ignore: must_be_immutable
class MyAddressItem extends StatelessWidget {
  final Address addressModel;
  final VoidCallback setDefaultListener;
  final VoidCallback deleteListener;
  final VoidCallback editListener;

  Color _titleColor = Colors.black;
  Color _defaultColor = AppColor.themeColor;

  MyAddressItem(
      {@required this.addressModel,
      this.deleteListener,
      this.editListener,
      this.setDefaultListener})
      : assert(addressModel != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: rSize(5)),
      padding: EdgeInsets.only(top: rSize(8)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: rSize(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  addressModel.name,
                  style: AppTextStyle.generate(ScreenAdapterUtils.setSp(16),
                      fontWeight: FontWeight.w400),
                ),
                Container(
                  height: rSize(10),
                  width: rSize(10),
                ),
                Text(
                  addressModel.mobile,
                  style: AppTextStyle.generate(ScreenAdapterUtils.setSp(15),
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: rSize(20), vertical: rSize(6)),
            child: Text(
              "${addressModel.province}${addressModel.city}${addressModel.district}${addressModel.address}",
              style: AppTextStyle.generate(ScreenAdapterUtils.setSp(15),
                  fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          Row(
            children: <Widget>[
              CustomImageButton(
                padding: EdgeInsets.symmetric(
                    vertical: rSize(7), horizontal: rSize(10)),
                direction: Direction.horizontal,
                fontSize: ScreenAdapterUtils.setSp(15),
                icon: Icon(
                  addressModel.isDefault == 0
                      ? AppIcons.icon_check
                      : Icons.check_circle,
                  size: ScreenAdapterUtils.setSp(18),
                ),
                title: addressModel.isDefault == 0 ? "设为默认地址" : "默认地址",
                contentSpacing: 5,
                color:
                    addressModel.isDefault == 0 ? _titleColor : _defaultColor,
                onPressed: this.setDefaultListener,
              ),
              Spacer(),
              CustomImageButton(
                  padding: EdgeInsets.symmetric(horizontal: rSize(10)),
                  fontSize: ScreenAdapterUtils.setSp(15),
                  title: "编辑",
                  color: _titleColor,
                  onPressed: this.editListener),
              CustomImageButton(
                padding: EdgeInsets.symmetric(horizontal: rSize(10)),
                fontSize: ScreenAdapterUtils.setSp(15),
                title: "删除",
                color: _titleColor,
                onPressed: this.deleteListener,
              ),
            ],
          )
        ],
      ),
    );
  }
}
