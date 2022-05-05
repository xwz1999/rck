/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-05  16:48 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/coupon_list_model.dart';
import 'package:jingyaoyun/pages/home/classify/mvp/coupon_list_model_impl.dart';
import 'package:jingyaoyun/pages/home/items/item_coupon.dart';
import 'package:jingyaoyun/widgets/text_button.dart' as TButton;
import 'package:jingyaoyun/widgets/toast.dart';

class CouponListPage extends StatefulWidget {
  final int brandId;

  const CouponListPage({Key key, this.brandId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CouponListPageState();
  }
}

class _CouponListPageState extends BaseStoreState<CouponListPage> {
  List<Coupon> _coupons;

  @override
  void initState() {
    super.initState();
    _coupons = [];
    CouponListImpl.getCouponList(
            UserManager.instance.user.info.id, widget.brandId)
        .then((CouponListModel model) {
      if (model.code != HttpStatus.SUCCESS) {
        Toast.showError(model.msg);
        return;
      }
      setState(() {
        _coupons = model.data;
      });
    });
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        height: DeviceInfo.screenHeight * 0.6,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
        child: SafeArea(
          bottom: true,
          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "优惠",
                    style: AppTextStyle.generate(16 * 2.sp,
                        fontWeight: FontWeight.w400),
                  )),
              Expanded(
                child: ListView.builder(
                    itemCount: _coupons.length,
                    itemBuilder: (_, index) {
                      return CouponItem(
                        coupon: _coupons[index],
                      );
                    }),
              ),
              TButton.TextButton(
                margin: EdgeInsets.only(top: 8, left: 20, right: 20),
                radius: BorderRadius.all(Radius.circular(30)),
                height: rSize(35),
                title: "完成",
                font: 16 * 2.sp,
                textColor: Colors.white,
                backgroundColor: Color(0xFFFF2812),
                onTap: () {
                  Navigator.maybePop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
