import 'package:common_utils/common_utils.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/pages/wholesale/models/wholesale_good_model.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

import '../wholeasale_detail_page.dart';

class WholesaleGoodsGrid extends StatelessWidget {

  final WholesaleGood goods;


  const WholesaleGoodsGrid(
      {Key key, this.goods})
      : super(key: key);
  static final Color colorGrey = Color(0xff999999);

  @override
  Widget build(BuildContext context) {

    double width = (MediaQuery.of(context).size.width - 10) / 2;
    return

      Container(

        padding: EdgeInsets.fromLTRB(5 * 2.w, 0, 5 * 2.w, 8 * 2.w),
        margin: EdgeInsets.only(top: 8.rw),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            rHBox(5),
            Container(
              width: width,
              //height: width,
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: Material(
                          color: AppColor.frenchColor,
                          child: CustomCacheImage(
                              fit: BoxFit.cover,
                              placeholder: AppImageName.placeholder_1x1,
                              imageUrl:
                              Api.getResizeImgUrl(goods.mainPhotoUrl, 300)),
                        )),
                  ),
                  Positioned(
                    child: Container(),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4 * 2.w),
              child: ExtendedText.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: this.goods.goodsName,
                      style: AppTextStyle.generate(16 * 2.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            TextUtil.isEmpty(this.goods.description)
                ? SizedBox()
                : Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(
                  left: 0, right: 0, top: 5, bottom: 5),
              child:
              this.goods.description == null
                  ? Container()
                  : Text(
                this.goods.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.generate(12.rsp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(
              height: 12.rw,
            ),
            Row(
              children: [
                Text(
                  '零售价¥${this.goods.discountPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                      // decoration: TextDecoration.lineThrough,
                      decorationColor: Color(0xff898989),
                      fontSize: 12 * 2.sp,
                      color: Color(0xFF999999),
                      fontWeight: FontWeight.w400),
                ),
                Spacer(),
                Text(
                  "已订${this.goods.salesVolume}单",
                  style: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 12 * 2.sp,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12.rw,
            ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 1,
                  ),
                  Container(
                    // height: double.infinity,
                    alignment: Alignment.center,
                    child: ExtendedText.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: "批发价 ¥ ",
                          style: AppTextStyle.generate(12 * 2.sp,
                              color: Color(0xffc70404),
                              fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: this.goods.salePrice.toStringAsFixed(2),
                          // text: "${model.discountPrice>=100?model.discountPrice.toStringAsFixed(0):model.discountPrice.toStringAsFixed(1)}",
                          style: TextStyle(
                              letterSpacing: -1,
                              wordSpacing: -1,
                              fontSize: 16 * 2.sp,
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
                  Spacer(),

                  Container(
                    width: 10,
                  ),
                  CustomImageButton(
                    direction: Direction.horizontal,
                    height: 21,
                    title:  "批发",
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
                    backgroundColor: Color(0xFFC92219),
                    pureDisplay: true,
                  ),

                ],
              ),
            ),
            SizedBox(
              height: 4.rw,
            ),
          ],
        ),
    );
  }

  _buyEvent(BuildContext context) {
    Get.to(()=>WholesaleDetailPage(goodsId: this.goods.id,));
      //
      // AppRouter.push(context, RouteName.COMMODITY_PAGE,
      //     arguments: CommodityDetailPage.setArguments(this.goods.id));

  }

}
