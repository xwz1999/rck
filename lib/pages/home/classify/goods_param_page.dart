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
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/text_button.dart';

class GoodsParamPage extends StatefulWidget {
  // final List<Sku> skus;
  final GoodsDetailModel model;
  const GoodsParamPage({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GoodsParamPageState();
  }
}

class _GoodsParamPageState extends BaseStoreState<GoodsParamPage> {
  // List<Sku> _skus;
  GoodsDetailModel model;
  @override
  void initState() {
    super.initState();
    // _skus = widget.skus;
    model = widget.model;
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
                    "产品参数",
                    style: AppTextStyle.generate(ScreenAdapterUtils.setSp(16),
                        fontWeight: FontWeight.w400),
                  )),
              Container(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 23,
                        alignment: Alignment.topLeft,
                        child: Text(
                          '品牌',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenAdapterUtils.setSp(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 20,
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(bottom: 0),
                    height: 23,
                    child: Text(
                      model.data.brand.name,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenAdapterUtils.setSp(13)),
                    ),
                  )),
                ],
              ),
              Container(
                height: 10,
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 23,
                          alignment: Alignment.topLeft,
                          child: Text(
                            '条形码',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenAdapterUtils.setSp(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: model.data.sku.length,
                          itemBuilder: (_, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 0),
                              height: 23,
                              child: Text(
                                model.data.sku[index].name +
                                    "  " +
                                    model.data.sku[index].code,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: ScreenAdapterUtils.setSp(13)),
                              ),
                            );
                            // return CouponItem(coupon: _coupons[index],);
                          }),
                    ),
                  ],
                ),
              ),
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
}
