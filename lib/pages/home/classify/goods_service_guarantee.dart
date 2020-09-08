/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-05  16:48 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/text_button.dart';

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
                    style: AppTextStyle.generate(ScreenAdapterUtils.setSp(16),
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
                      '由平台认证供应商或者品牌商直接发货,也可直接在瑞库客门店提货;由认证供应商或者品牌商提供售后服务'),
                  _contentView('售后无忧', '瑞库客购无忧,售后更无忧,您的售后,由瑞库客平台客服全力护航'),
                  _contentView('支持七天无理由退换货', '该商品支持七天无理由退货(未使用)'),
                ],
              )),
              TextButton(
                margin: EdgeInsets.only(top: 8, left: 20, right: 20),
                radius: BorderRadius.all(Radius.circular(30)),
                height: rSize(35),
                title: "完成",
                font: ScreenAdapterUtils.setSp(16),
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
          fontSize: ScreenAdapterUtils.setSp(14)),
      color: Colors.black,
      direction: Direction.horizontal,
      fontSize: ScreenAdapterUtils.setSp(14),
      icon: Image.asset(
        'assets/goods_service_guarantee_close.png',
        width: 17,
        height: 17,
      ),
      // icon: Icon(
      //   AppIcons.icon_check,
      //   // color: Color(0xFFFC8381),
      //   color: Colors.red,
      //   size: ScreenAdapterUtils.setSp(20),
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
