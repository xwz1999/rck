import 'package:common_utils/common_utils.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/guide_order_item_model.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:velocity_x/velocity_x.dart';

class GuideOrderCard extends StatelessWidget {
  final GuideOrderItemModel model;
  const GuideOrderCard({Key key, @required this.model}) : super(key: key);
  Widget _buildGoodsItem(Goods item) {
    return SizedBox(
      height: 100.rw,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(5.rw),
            child: FadeInImage.assetNetwork(
              placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
              image: Api.getImgUrl(item.mainPhotoUrl),
              height: 100.rw,
              width: 100.rw,
            ),
          ),
          10.wb,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExtendedText.rich(
                TextSpan(
                  children: [
                    ExtendedWidgetSpan(
                      child: model.shippingMethod == 1
                          ? Container(
                              margin: EdgeInsets.only(right: 2.rw),
                              height: 14.rw,
                              width: 24.rw,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFFCC1B4F),
                                borderRadius: BorderRadius.circular(3.rw),
                              ),
                              child: Text(
                                '自提',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.rsp,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ),
                    ExtendedWidgetSpan(
                      child: item.importValue
                          ? Container(
                              margin: EdgeInsets.only(right: 2.rw),
                              height: 14.rw,
                              width: 24.rw,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                                                      color: item.countryIcon == null
                                          ? Color(0xFFCC1B4F)
                                          : Colors.transparent,
                                borderRadius: BorderRadius.circular(3.rw),
                              ),
                              child: item.countryIcon == null
                                  ? Text(
                                      '进口',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10 * 2.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : CustomCacheImage(
                                      width: rSize(100),
                                      height: rSize(100),
                                      imageUrl:
                                          Api.getImgUrl(item.countryIcon),
                                      fit: BoxFit.cover,
                                    ),
                            )
                          : SizedBox(),
                    ),
                    TextSpan(text: item.goodsName),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.generate(
                  14 * 2.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              5.hb,
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Color(0xffeff1f6),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                    child: Text(
                      "${item.skuName}",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.generate(11 * 2.sp,
                          color: Colors.grey[600], fontWeight: FontWeight.w300),
                    ),
                  ),
                  Spacer(),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "x${item.quantity}",
                      style: AppTextStyle.generate(13,
                          color: Colors.grey, fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: <Widget>[
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: "￥",
                      style: AppTextStyle.generate(10 * 2.sp,
                          color: AppColor.priceColor),
                    ),
                    TextSpan(
                      text: "${item.unitPrice.toStringAsFixed(2)}",
                      style: AppTextStyle.generate(14 * 2.sp,
                          color: AppColor.priceColor),
                    )
                  ])),
                  Spacer(),
                  Text(
                    item.refundStatusValue,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.generate(14 * 2.sp,
                        color: AppColor.priceColor),
                  )
                ],
              )
            ],
          ).expand(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5.rw),
      child: Padding(
        padding: EdgeInsets.all(15.rw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  height: 20.rw,
                  width: 20.rw,
                  decoration: BoxDecoration(
                    color: Color(0xFFFE3E27),
                    borderRadius: BorderRadius.circular(2.rw),
                  ),
                  child: Text(
                    '卖',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.rsp,
                    ),
                  ),
                  alignment: Alignment.center,
                ),
                8.wb,
                DateUtil.formatDate(
                  DateTime.fromMillisecondsSinceEpoch(model.createdAt * 1000),
                  format: 'yyyy-MM-dd HH:mm:ss',
                ).text.black.size(16.rsp).make(),
                Spacer(),
                model.statusValue.text
                    .color(Color(0xFFC92219))
                    .size(14.rsp)
                    .make(),
              ],
            ),
            10.hb,
            ...model.goods
                .map((e) => _buildGoodsItem(e))
                .toList()
                .sepWidget(separate: 10.hb),
            Divider(color: Color(0xFFE6E6E6)),
            Row(
              children: [
                Spacer(),
                '共${model.goods.length}件商品 总计¥${model.goodsTotalAmount.toStringAsFixed(2)}'
                    .text
                    .black
                    .size(14.rsp)
                    .make(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
