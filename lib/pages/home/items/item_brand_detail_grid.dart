/*
 * ====================================================
 * package   : pages.home.items
 * author    : Created by nansi.
 * time      : 2019/5/21  9:52 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/goods_list_model.dart';
import 'package:recook/models/goods_simple_list_model.dart';
import 'package:recook/pages/home/items/item_tag_widget.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';

class BrandDetailGridItem extends StatelessWidget {
  // final Goods goods;
  final GoodsSimple goods;

  const BrandDetailGridItem({Key key, this.goods}) : super(key: key);
  static final Color colorGrey = Color(0xff999999);
  @override
  Widget build(BuildContext context) {
    bool isSoldOut = goods.inventory <= 0 ? true : false;
    double width = (MediaQuery.of(context).size.width - 10) / 2;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(bottom: 8),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: width,
                height: width,
                child: Stack(
                  children: <Widget>[
                    AspectRatio(
                        aspectRatio: 1,
                        child: CustomCacheImage(
                            fit: BoxFit.cover,
                            placeholder: AppImageName.placeholder_1x1,
                            imageUrl:
                                Api.getResizeImgUrl(goods.mainPhotoUrl, 300))),
                    Positioned(
                      child: isSoldOut
                          ? ItemTagWidget.imageMaskWidget(
                              padding: 40,
                              width: width - 80,
                              height: width - 80)
                          : Container(),
                    )
                  ],
                ),
              ),
              Container(
                // height: 60,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 0, top: 8, bottom: 0),
                  child: Text(
                    goods.goodsName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: false,
                    style: AppTextStyle.generate(15,
                        color: isSoldOut ? colorGrey : Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(left: 8, right: 8, bottom: 2),
                height: 15,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: goods.tags != null && goods.tags.length > 0
                      ? goods.tags.length
                      : 0,
                  itemBuilder: (BuildContext context, int index) {
                    return ItemTagWidget.getWidgetWithTag(goods.tags[index],
                        color: goods.inventory <= 0
                            ? colorGrey
                            : AppColor.themeColor);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Row(
                  children: <Widget>[
                    RichText(
                        text: TextSpan(
                            text: "￥",
                            style: AppTextStyle.generate(
                                ScreenAdapterUtils.setSp(
                                  13,
                                ),
                                color: isSoldOut
                                    ? colorGrey
                                    : AppColor.priceColor),
                            children: [
                          TextSpan(
                            text: goods.discountPrice.toStringAsFixed(2),
                            style: AppTextStyle.generate(
                                ScreenAdapterUtils.setSp(16),
                                color: isSoldOut
                                    ? colorGrey
                                    : AppColor.priceColor),
                          ),
                          TextSpan(
                            text: AppConfig.getShowCommission() ? "/" : "",
                            style: AppTextStyle.generate(
                                ScreenAdapterUtils.setSp(17),
                                color:
                                    isSoldOut ? colorGrey : AppColor.priceColor,
                                fontWeight: FontWeight.w300),
                          ),
                          TextSpan(
                            text: AppConfig.getShowCommission()
                                ? "赚${goods.commission.toStringAsFixed(2)}"
                                : "",
                            style: AppTextStyle.generate(
                                ScreenAdapterUtils.setSp(13),
                                color: isSoldOut
                                    ? colorGrey
                                    : AppColor.themeColor),
                          ),
                        ])),
                    Spacer(),
                  ],
                ),
              ),
              Container(
                height: 3,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: rSize(5)),
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Text(
                        "${goods.salesVolume}人付款",
                        style: AppTextStyle.generate(12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 2,
              )
            ],
          )),
    );
  }
}
