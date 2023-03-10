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
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/text_button.dart' as TButton;

class GoodsServiceGuarantee extends StatefulWidget {
  // final List<Sku> skus;

  // const GoodsServiceGuarantee({Key key, this.skus}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GoodsServiceGuaranteeState();
  }
}

class _GoodsServiceGuaranteeState
    extends BaseStoreState<GoodsServiceGuarantee> {
  // List<Sku> _skus;
  @override
  void initState() {
    super.initState();
    // _skus = widget.skus;
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
                    "服务保障",
                    style: AppTextStyle.generate(16 * 2.sp,
                        fontWeight: FontWeight.w400),
                  )),
              Container(
                height: 20,
              ),
              Expanded(
                  child: ListView(
                children: <Widget>[
                  _contentView('正品保证', '本商品由海内外认证的供应商或品牌商直供货源,保证100%正品'),
                  _contentView('发货&售后',
                      '由平台认证供应商或者品牌商直接发货,也可直接在左家右厨门店提货;由认证供应商或者品牌商提供售后服务'),
                  _contentView('售后无忧', '左家右厨购无忧,售后更无忧,您的售后,由左家右厨平台客服全力护航'),
                  _contentView('支持七天无理由退换货', '该商品支持七天无理由退货(未使用)'),
                ],
              )),
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

  _serviceLabel(title) {
    return CustomImageButton(
      onPressed: () {},
      title: title,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: 14 * 2.sp),
      color: Colors.black,
      direction: Direction.horizontal,
      fontSize: 14 * 2.sp,
      icon: Image.asset(
        'assets/goods_service_guarantee_close.png',
        width: 17,
        height: 17,
      ),
      // icon: Icon(
      //   AppIcons.icon_check,
      //   // color: Color(0xFFFC8381),
      //   color: Colors.red,
      //   size: 20*2.sp,
      // )
    );
  }

  _contentView(title, info) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: _serviceLabel('    ' + title),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 33, right: 10, top: 6, bottom: 10),
            child: Text(
              info,
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
