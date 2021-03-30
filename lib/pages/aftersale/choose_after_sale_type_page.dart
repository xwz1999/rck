import 'package:flutter/material.dart';

import 'package:extended_text/extended_text.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/models/order_detail_model.dart';
import 'package:recook/pages/user/order/return_goods_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_cache_image.dart';

class ChooseAfterSaleTypePage extends StatefulWidget {
  final Map arguments;
  ChooseAfterSaleTypePage({Key key, this.arguments}) : super(key: key);
  static setArguments(Goods goods) {
    return {"goods": goods};
  }

  @override
  _ChooseAfterSaleTypePageState createState() =>
      _ChooseAfterSaleTypePageState();
}

class _ChooseAfterSaleTypePageState
    extends BaseStoreState<ChooseAfterSaleTypePage> {
  Goods _goods;
  @override
  void initState() {
    _goods = widget.arguments['goods'];
    super.initState();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        appBackground: Colors.white,
        title: "选择售后类型",
        elevation: 0,
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColor.frenchColor,
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(rSize(10)),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.symmetric(
                horizontal: rSize(15),
                vertical: ScreenAdapterUtils.setHeight(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _goodsItemWidget(),
                _itemWidget(
                    onPressed: () {
                      AppRouter.push(context, RouteName.ORDER_REFUND,
                              arguments: GoodsReturnPage.setArguments(
                                  [_goods.goodsDetailId], [_goods]))
                          .then((returnSuccess) {
                        if (returnSuccess == null &&
                            returnSuccess is bool &&
                            returnSuccess) {
                          // Navigator.pop(context, true);
                          // DPrint.printf("退货成功了");
                          // _presenter.getOrderDetail(UserManager.instance.user.info.id, orderDetail.id);
                        }
                      });
                    },
                    image: R.ASSETS_AFTER_SALE_QIAN_PNG,
                    title: "我要退款(无需退货)",
                    info: "没收到货，或与平台协商同意不用退货只退款"),
                Container(
                  height: 0.8,
                  color: AppColor.frenchColor,
                ),
                _itemWidget(
                    onPressed: () {
                      AppRouter.push(context, RouteName.ORDER_RETURN,
                              arguments: GoodsReturnPage.setArguments(
                                  [_goods.goodsDetailId], [_goods]))
                          .then((returnSuccess) {
                        if (returnSuccess == null &&
                            returnSuccess is bool &&
                            returnSuccess) {
                          // Navigator.pop(context, true);
                          // DPrint.printf("退货成功了");
                          // _presenter.getOrderDetail(UserManager.instance.user.info.id, orderDetail.id);
                        }
                      });
                    },
                    image: R.ASSETS_AFTER_SALE_TUI_PNG,
                    title: "我要退货退款",
                    info: "已收到货，需要退还收到的货物"),
                // _itemWidget(
                //   image: R.ASSETS_AFTER_SALE_HUAN_PNG,
                //   title: "我要换货",
                //   info: "已收到货，需要更换已收到的货物"
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _goodsItemWidget() {
    TextStyle subGreyStyle = TextStyle(
        color: Color(0xff666666), fontSize: ScreenAdapterUtils.setSp(14));
    TextStyle subBlackStyle =
        TextStyle(color: Colors.black, fontSize: ScreenAdapterUtils.setSp(14));
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(bottom: ScreenAdapterUtils.setHeight(5)),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(width: 1, color: AppColor.frenchColor)),
      ),
      height: rSize(90),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: AppColor.frenchColor,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            margin: EdgeInsets.symmetric(horizontal: rSize(4)),
            child: CustomCacheImage(
              width: rSize(90),
              height: rSize(90),
              imageUrl: Api.getImgUrl(_goods.mainPhotoUrl),
              borderRadius: BorderRadius.all(Radius.circular(6)),
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _goods.goodsName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColor.blackColor,
                  fontSize: ScreenAdapterUtils.setSp(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "型号规格 ${_goods.skuName}",
                style: TextStyle(
                    color: Color(0xff666666),
                    fontSize: ScreenAdapterUtils.setSp(13)),
              ),
              ExtendedText.rich(TextSpan(children: [
                TextSpan(text: "订单金额 ", style: subGreyStyle),
                TextSpan(text: "￥${_goods.goodsAmount}", style: subBlackStyle),
                TextSpan(text: "  购买数量 ", style: subGreyStyle),
                TextSpan(text: "${_goods.quantity}", style: subBlackStyle),
              ])),
            ],
          ))
        ],
      ),
    );
  }

  _itemWidget(
      {String image, String title = "", String info = "", Function onPressed}) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) onPressed();
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: rSize(10)),
        height: rSize(60),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: rSize(10)),
              width: rSize(20),
              height: rSize(20),
              child:
                  TextUtils.isEmpty(image) ? Container() : Image.asset(image),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      color: AppColor.blackColor,
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenAdapterUtils.setSp(14)),
                ),
                Text(
                  info,
                  style: TextStyle(
                      color: AppColor.blackColor,
                      fontSize: ScreenAdapterUtils.setSp(12)),
                ),
              ],
            )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(SimpleLineIcons.arrow_right,
                    color: Color(0xffb3b3b3), size: rSize(15)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
