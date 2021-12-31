import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/models/goods_simple_list_model.dart';
import 'package:jingyaoyun/pages/goods/small_coupon_widget.dart';
import 'package:jingyaoyun/pages/home/classify/commodity_detail_page.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';

class NormalGoodsItem extends StatelessWidget {
  final BuildContext buildCtx;
  final GoodsSimple model;
  final VoidCallback shareClick;
  final VoidCallback buyClick;
  const NormalGoodsItem(
      {Key key, this.model, this.shareClick, this.buyClick, this.buildCtx})
      : super(key: key);

  // static Color _shareTextColor = Color(0xffc70404);
  static double _height = 0;

  @override
  Widget build(BuildContext context) {
    _height = (MediaQuery.of(context).size.width - 20) * 140.0 / 350.0;
    return Container(
      height: _height,
      padding: EdgeInsets.only(bottom: 3.33, left: 10, right: 10),
      color: AppColor.frenchColor,
      child: _container(),
    );
  }

  _container() {
    return Container(
      height: _height,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: Container(
              color: Colors.white.withAlpha(0),
            ),
            onTap: () {
              _buyEvent();
            },
          ),
          GestureDetector(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _buyEvent();
                  },
                  child: _image(),
                ),
                _rowInfoWidget(),
              ],
            ),
            onTap: () {
              _buyEvent();
            },
          ),
        ],
      ),
    );
  }

  _rowInfoWidget() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 2,
                  ),
                  Text(
                    model.goodsName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.generate(15 * 2.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 2),
                      child: model.description == null
                          ? Container()
                          : Text(
                              model.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.generate(12 * 2.sp,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w300),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            // Offstage(
            //   offstage: !(model.getPromotionStatus() == PromotionStatus.start),
            //   // offstage: !(model.getPromotionStatus() == PromotionStatus.start || model.getPromotionStatus() == PromotionStatus.ready),
            //   child: _priceView(),
            // ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _saleNumberWidget(),
                ],
                // children: <Widget>[
                //   Expanded(child: _saleNumberWidget(),),
                //   _inventoryView(),
                // ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // _addGestureDetectorForWidget(Widget widget, VoidCallback click) {
  //   return GestureDetector(
  //     child: widget,
  //     onTap: () {
  //       if (click != null) click();
  //     },
  //   );
  // }

  _image() {
    double cir = 5;
    return Container(
      width: _height - 8,
      height: _height - 8,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(cir)),
        child: Stack(children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(color: AppColor.frenchColor),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: CustomCacheImage(
              borderRadius: BorderRadius.circular(5),
              width: _height - 8,
              height: _height - 8,
              imageUrl: Api.getImgUrl(model.mainPhotoUrl),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Offstage(
              offstage: model.inventory > 0,
              child: Container(
                color: Colors.black38,
                child: Center(
                  child: Image.asset(
                    'assets/sellout_bg.png',
                    width: rSize(70),
                    height: rSize(70),
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  // _inventoryView() {
  //   bool sellout = model.inventory <= 0;
  //   Color priceColor = Color(0xffc70404);
  //   return Container(
  //     alignment: Alignment.center,
  //     child: Stack(
  //       children: <Widget>[
  //         Positioned(
  //           left: 0,
  //           right: 0,
  //           top: 0,
  //           bottom: 0,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   Text("券",
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.w800,
  //                           color: priceColor,
  //                           fontSize: 5*2.sp)),
  //                   Text("后",
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.w800,
  //                           color: priceColor,
  //                           fontSize: 5*2.sp)),
  //                 ],
  //               ),
  //               Container(
  //                 width: 1,
  //               ),
  //               RichText(
  //                   text: TextSpan(children: [
  //                 TextSpan(
  //                   text: "¥",
  //                   style: AppTextStyle.generate(11*2.sp,
  //                       color: priceColor, fontWeight: FontWeight.w500),
  //                 ),
  //                 TextSpan(
  //                   text:
  //                       "${(model.discountPrice - model.discountPrice.toInt()) > 0 ? model.discountPrice.toStringAsFixed(1) : model.discountPrice.toStringAsFixed(0)}",
  //                   // text: "${model.discountPrice>=100?model.discountPrice.toStringAsFixed(0):model.discountPrice.toStringAsFixed(1)}",
  //                   style: TextStyle(
  //                       fontSize: 15*2.sp,
  //                       color: priceColor,
  //                       fontWeight: FontWeight.w500),
  //                 ),
  //               ])),
  //               Container(
  //                 width: 3,
  //               ),
  //               RichText(
  //                   text: TextSpan(children: [
  //                 TextSpan(
  //                   text: "¥",
  //                   style: AppTextStyle.generate(9*2.sp,
  //                       color: Color(0xff898989), fontWeight: FontWeight.w500),
  //                 ),
  //                 TextSpan(
  //                   text: "${model.originalPrice.toStringAsFixed(0)}",
  //                   style: TextStyle(
  //                       decoration: TextDecoration.lineThrough,
  //                       decorationColor: Color(0xff898989),
  //                       fontSize: 13*2.sp,
  //                       color: Color(0xff898989),
  //                       fontWeight: FontWeight.w500),
  //                 ),
  //               ])),
  //               Expanded(child: Container()),
  //             ],
  //           ),
  //         ),
  //         Row(
  //           children: <Widget>[
  //             Spacer(),
  //             UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip
  //                 ? Container()
  //                 :
  //                 // model.getPromotionStatus() == PromotionStatus.ready ?
  //                 //   GestureDetector(
  //                 //     onTap: (){
  //                 //       if (shareClick != null){
  //                 //         shareClick();
  //                 //       }else{
  //                 //         _shareEvent();
  //                 //       }
  //                 //     },
  //                 //     child: Container(
  //                 //       margin: EdgeInsets.only(right: 5),
  //                 //       child: Image.asset("assets/home_page_row_share_icon.png", width: 18, height: 18,),
  //                 //     ),
  //                 //   ):
  //                 GestureDetector(
  //                     child: CustomImageButton(
  //                       height: 21,
  //                       title: "导购",
  //                       style: TextStyle(
  //                           fontSize: 14*2.sp,
  //                           color: sellout ? Colors.grey : _shareTextColor),
  //                       padding: EdgeInsets.symmetric(
  //                           horizontal: rSize(8), vertical: rSize(0)),
  //                       borderRadius: BorderRadius.only(
  //                           topLeft: Radius.circular(40),
  //                           bottomLeft: Radius.circular(40)),
  //                       border: Border.all(
  //                           color: sellout ? Colors.grey : _shareTextColor,
  //                           width: 0.5),
  //                       pureDisplay: true,
  //                     ),
  //                     onTap: () {
  //                       // if (shareClick != null) shareClick();
  //                       if (shareClick != null) {
  //                         shareClick();
  //                       } else {
  //                         _shareEvent();
  //                       }
  //                     },
  //                   ),
  //             Container(
  //               width: 5,
  //             ),
  //             GestureDetector(
  //               child: CustomImageButton(
  //                 direction: Direction.horizontal,
  //                 height: 21,
  //                 title: sellout ? "已售完" : "自购",
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 14*2.sp,
  //                 ),
  //                 padding: EdgeInsets.symmetric(
  //                     horizontal: ScreenAdapterUtils.setWidth(
  //                         UserLevelTool.currentRoleLevelEnum() ==
  //                                     UserRoleLevel.Vip &&
  //                                 model.getPromotionStatus() ==
  //                                     PromotionStatus.start
  //                             ? 16
  //                             : 8),
  //                     vertical: rSize(0)),
  //                 borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(
  //                         UserLevelTool.currentRoleLevelEnum() ==
  //                                 UserRoleLevel.Vip
  //                             ? 40
  //                             : 0),
  //                     bottomLeft: Radius.circular(
  //                         UserLevelTool.currentRoleLevelEnum() ==
  //                                 UserRoleLevel.Vip
  //                             ? 40
  //                             : 0),
  //                     topRight: Radius.circular(40),
  //                     bottomRight: Radius.circular(40)),
  //                 backgroundColor:
  //                     sellout ? AppColor.greyColor : _shareTextColor,
  //                 pureDisplay: true,
  //               ),
  //               onTap: () {
  //                 _buyEvent();
  //               },
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  // _priceView() {
  //   if (model.getPromotionStatus() == PromotionStatus.ready) {
  //     return Container();
  //   }
  //   return Row(
  //     children: <Widget>[
  //       _stockWidget(),
  //       Container(
  //         width: 10,
  //       ),
  //       Expanded(
  //         child: Text.rich(
  //           TextSpan(children: [
  //             TextSpan(
  //                 text: "已售",
  //                 style: TextStyle(color: Colors.black, fontSize: 11)),
  //             TextSpan(
  //                 text: "${(model.percent / 100.0).toStringAsFixed(0)}%",
  //                 style: TextStyle(color: Color(0xffec294d), fontSize: 11)),
  //           ]),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  _saleNumberWidget() {
    return Container(
        // height: 18,
        color: Colors.yellow,
        height: 30,
        child: Row(
          children: <Widget>[
            (model.coupon != null && model.coupon != 0)
                ? Container(
                    margin: EdgeInsets.only(right: 10),
                    child: SmallCouponWidget(
                      height: 30,
                      number: model.coupon,
                    ),
                  )
                : SizedBox(),
            !AppConfig.getShowCommission()
                ? Container()
                : Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                          color: Color(0xffec294d),
                          width: 0.5,
                        )),
                    height: 18,
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      "赚" + model.commission.toStringAsFixed(2),
                      style: TextStyle(
                        color: Color(0xffeb0045),
                        fontSize: 11,
                      ),
                    ),
                  ),
            Spacer(),
            Text(
              "累计已售${model.salesVolume}件",
              style: TextStyle(
                color: Color(0xff595757),
                fontSize: 10,
              ),
            ),
          ],
        ));
  }

  // _stockWidget() {
  //   double height = 4;
  //   double allWidth = 120;
  //   double proportion = model.percent / 100.0;
  //   double width = allWidth * proportion < 4 && allWidth * proportion > 0
  //       ? 4
  //       : allWidth * proportion;
  //   return Container(
  //     width: allWidth,
  //     height: height,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(height)),
  //         // color: AppColor.pinkColor,
  //         color: Color(0xffdcdddd)),
  //     child: Stack(
  //       alignment: AlignmentDirectional.centerStart,
  //       children: <Widget>[
  //         Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.all(Radius.circular(height)),
  //             color: AppColor.themeColor,
  //           ),
  //           width: width,
  //           height: height,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // _shareEvent() {
  //   GoodsSimple goods = model;
  //   String goodsTitle =
  //       "￥${goods.discountPrice} | ${goods.goodsName} | ${goods.description}";
  //   ShareTool().goodsShare(buildCtx,
  //       goodsPrice: goods.discountPrice.toStringAsFixed(2),
  //       goodsName: goods.goodsName,
  //       goodsDescription: goods.description,
  //       miniTitle: goodsTitle,
  //       miniPicurl: goods.mainPhotoUrl,
  //       amount: goods.commission.toString(),
  //       goodsId: goods.id.toString());
  // }

  _buyEvent() {
    if (buyClick != null) {
      buyClick();
    } else {
      AppRouter.push(buildCtx, RouteName.COMMODITY_PAGE,
          arguments: CommodityDetailPage.setArguments(model.id));
    }
  }
}
