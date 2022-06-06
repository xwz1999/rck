/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-26  17:26 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/coupon_list_model.dart';
import 'package:recook/pages/home/classify/mvp/coupon_list_model_impl.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/toast.dart';

class MyCouponListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyCouponListPageState();
  }
}

class _MyCouponListPageState extends BaseStoreState<MyCouponListPage> {
  List<Coupon>? _couponList;

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        elevation: 0,
        title: "优惠券",
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      backgroundColor: AppColor.frenchColor,
      body: _couponList == null || _couponList!.length == 0
          ? noDataView("您当前没有可用的优惠券")
          : _buildBody(),
    );
  }

  _buildBody() {
    return ListView.builder(
        itemCount: _couponList!.length,
        itemBuilder: (_, index) {
          return _item(_couponList![index]);
        });
  }

  _item(Coupon coupon) {
    return Container(
      height: rSize(120),
      margin: EdgeInsets.symmetric(horizontal: rSize(10), vertical: rSize(8)),
      decoration: BoxDecoration(
          color: Colors.red,
          gradient: LinearGradient(colors: [
            AppColor.rgbColor(230, 90, 94),
            AppColor.rgbColor(237, 122, 116),
          ]),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            padding: EdgeInsets.only(
              bottom: rSize(25),
              left: rSize(10),
              right: rSize(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RichText(
                    text: TextSpan(
                        text: coupon.cash.toString(),
                        style: AppTextStyle.generate(33 * 2.sp,
                            color: Colors.white, fontWeight: FontWeight.w600),
                        children: [
                      TextSpan(
                          text: " 元",
                          style: AppTextStyle.generate(14 * 2.sp,
                              color: Colors.white, fontWeight: FontWeight.w400))
                    ])),
                SizedBox(
                  width: rSize(30),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      coupon.name!,
                      style: AppTextStyle.generate(17 * 2.sp,
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      coupon.startTime!.substring(0, 10) +
                          "-" +
                          coupon.endTime!.substring(0, 10),
                      style: AppTextStyle.generate(13 * 2.sp,
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              height: rSize(25),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: rSize(8)),
                width: double.infinity,
                color: AppColor.rgbColor(0, 0, 0, a: 30),
                alignment: Alignment.centerLeft,
                child: Text(
                  coupon.explanation!,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.generate(13 * 2.sp,
                      fontWeight: FontWeight.w300, color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }

  _getList() async {
    HttpResultModel<CouponListModel?> resultModel =
        await CouponListImpl.getReceiveCouponList(
            UserManager.instance!.user.info!.id);
    if (!resultModel.result) {
      Toast.showInfo(resultModel.msg);
      return;
    }
    setState(() {
      _couponList = resultModel.data!.data;
    });
  }
}
