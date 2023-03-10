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
import 'package:jingyaoyun/models/goods_detail_model.dart';
import 'package:jingyaoyun/widgets/text_button.dart' as TButton;

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
                  child: Text(
                "产品参数",
                style: AppTextStyle.generate(16 * 2.sp,
                    fontWeight: FontWeight.w400),
              )),
              rHBox(30),
              Row(
                children: <Widget>[
                  rWBox(20),
                  Container(
                    width: rSize(60),
                    child: Text(
                      '品牌',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13 * 2.sp,
                      ),
                    ),
                  ),
                  rWBox(20),
                  Expanded(
                      child: Container(
                    child: Text(
                      model.data.brand.name,
                      style: TextStyle(color: Colors.grey, fontSize: 13 * 2.sp),
                    ),
                  )),
                ],
              ),
              rHBox(10),
              Row(
                children: <Widget>[
                  rWBox(20),
                  Container(
                    width: rSize(60),
                    child: Text(
                      '条形码',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13 * 2.sp,
                      ),
                    ),
                  ),
                  rWBox(20),
                  Container(
                    child: Text(
                      '${model.data.sku[0].name}  ${model.data.sku[0].code}',
                      style: TextStyle(color: Colors.grey, fontSize: 13 * 2.sp),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  rWBox(100),
                  Column(
                    children: model.data.sku
                        .sublist(1)
                        .map(
                          (e) => Container(
                            child: Text(
                              '${e.name}  ${e.code}',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 13 * 2.sp),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              Spacer(),
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
