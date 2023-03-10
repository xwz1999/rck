import 'package:common_utils/common_utils.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/goods_detail_model.dart';
import 'package:jingyaoyun/models/goods_simple_list_model.dart';
import 'package:jingyaoyun/pages/goods/small_coupon_widget.dart';
import 'package:jingyaoyun/pages/home/classify/commodity_detail_page.dart';
import 'package:jingyaoyun/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:jingyaoyun/pages/home/items/item_tag_widget.dart';
import 'package:jingyaoyun/pages/home/promotion_time_tool.dart';
import 'package:jingyaoyun/utils/share_tool.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

class WholesaleGoodsWidget extends StatelessWidget {
  // final Goods goods;
  final VoidCallback buyClick;

  const WholesaleGoodsWidget(
      {Key key, this.buyClick, })
      : super(key: key);
  static final Color colorGrey = Color(0xff999999);

  @override
  Widget build(BuildContext context) {
    bool sellout = false;
    // if(this.goods.inventory>0){
    //   sellout = false;
    // }else{
    //   sellout = true;
    // }
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        color: Colors.white,
        // padding: EdgeInsets.fromLTRB(5 * 2.w, 0, 5 * 2.w, 8 * 2.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // rHBox(5),
            Container(
              width: 140.rw,
              height: 140.rw,
              child: Stack(
                children: <Widget>[
                  AspectRatio(
                      aspectRatio: 1,
                      child: Material(
                        color: AppColor.frenchColor,
                        child: CustomCacheImage(
                            fit: BoxFit.cover,
                            placeholder: AppImageName.placeholder_1x1,
                            imageUrl:
                            AppImageName.placeholder_1x1),
                      )),
                  Positioned(
                    child: sellout
                        ? ItemTagWidget.imageMaskWidget(
                        padding: 40, width: 140.rw, height:140.rw)
                        : Container(),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4 * 2.w),
              padding: EdgeInsets.only(left: 6.rw,right: 6.rw),
              child: ExtendedText.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '?????????????????????24cm??????',
                      style: AppTextStyle.generate(15 * 2.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 6.rw,right: 6.rw),
              child: Text(
                '???????????249.00',
                style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Color(0xff898989),
                    fontSize: 12 * 2.sp,
                    color: Color(0xff898989),
                    fontWeight: FontWeight.w400),
              ),
            ),


            Container(
              padding: EdgeInsets.only(left: 6.rw,right: 6.rw),
              child: ExtendedText.rich(
                TextSpan(children: [
                  TextSpan(
                    text: "???????????",
                    style: AppTextStyle.generate(12 * 2.sp,
                        color: Color(0xffc70404),
                        fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: '219.00',
                    // text: "${model.discountPrice>=100?model.discountPrice.toStringAsFixed(0):model.discountPrice.toStringAsFixed(1)}",
                    style: TextStyle(
                        letterSpacing: -1,
                        wordSpacing: -1,
                        fontSize: 19 * 2.sp,
                        color: Color(0xFFC92219),
                        fontWeight: FontWeight.w500),
                  ),
                  WidgetSpan(
                      child: SizedBox(
                        width: 5,
                      )),
                ]),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 6.rw,right: 6.rw),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "??????5000???",
                    style: TextStyle(
                      color: Color(0xff595757),
                      fontSize: 12 * 2.sp,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 10,
                  ),
                  GestureDetector(
                    child: CustomImageButton(
                      direction: Direction.horizontal,
                      height: 21,
                      title: sellout ? "?????????" : "??????",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13 * 2.sp,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenAdapterUtils.setWidth(
                             8),
                          vertical: rSize(0)),
                      borderRadius: BorderRadius.circular(40),
                      // borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(
                      //         UserLevelTool.currentRoleLevelEnum() ==
                      //                 UserRoleLevel.Vip
                      //             ? 40
                      //             : 0),
                      //     bottomLeft: Radius.circular(
                      //         UserLevelTool.currentRoleLevelEnum() ==
                      //                 UserRoleLevel.Vip
                      //             ? 40
                      //             : 0),
                      //     topRight: Radius.circular(40),
                      //     bottomRight: Radius.circular(40)),
                      backgroundColor: sellout
                          ? AppColor.greyColor
                          : Color(0xFFC92219),
                      pureDisplay: true,
                    ),
                    onTap: () {
                      _buyEvent(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buyEvent(BuildContext context) {
    if (buyClick != null) {
      buyClick();
    } else {
      // AppRouter.push(context, RouteName.COMMODITY_PAGE,
      //     arguments: CommodityDetailPage.setArguments(this.goods.id));
    }
  }
  //
  // _brandWidget() {
  //   return Container(
  //         width: double.infinity,
  //         color: Colors.white,
  //         child: Row(
  //           children: <Widget>[
  //             Expanded(
  //               child: Text(
  //                 TextUtils.isEmpty(this.goods.brandName)
  //                     ? ""
  //                     : this.goods.brandName,
  //                 maxLines: 2,
  //                 style: TextStyle(
  //                   color: Color(0xffc70404),
  //                   fontSize: 12 * 2.sp,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  // }

}
