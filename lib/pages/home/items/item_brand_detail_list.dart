/*
 * ====================================================
 * package   : pages.home.items
 * author    : Created by nansi.
 * time      : 2019/5/20  5:01 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/goods_simple_list_model.dart';
import 'package:recook/pages/home/items/item_tag_widget.dart';
import 'package:recook/widgets/custom_cache_image.dart';

class BrandDetailListItem extends StatelessWidget {
  // final Goods goods;
  final GoodsSimple goods;
  const BrandDetailListItem({Key key, this.goods}) : super(key: key);

  static final Color colorGrey = Color(0xff999999);
  
  @override
  Widget build(BuildContext context) {
    bool isSoldOut = goods.inventory<=0?true:false;
    return Container(
      height: 120,
      // margin: EdgeInsets.only(top: 3, bottom: 3),
      // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      color: Colors.white,
      child: Stack(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 120, width: 120,
              margin: EdgeInsets.only(right: 10),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0, top: 0, bottom: 0, width: 120,
                    child: CustomCacheImage(
                      fit: BoxFit.cover,
                      imageUrl: Api.getResizeImgUrl(goods.mainPhotoUrl, 300),
                      placeholder: AppImageName.placeholder_1x1,
                    )
                    // child: AspectRatio(
                    //   aspectRatio: 1,
                    //   child: ClipRRect(
                    //     // borderRadius: BorderRadius.all(Radius.circular(8)),
                    //     child: CustomCacheImage(
                    //       fit: BoxFit.cover,
                    //       imageUrl: Api.getResizeImgUrl(goods.mainPhotoUrl, 300),
                    //       placeholder: AppImageName.placeholder_1x1,
                    //     ),
                    //   )),
                  ),
                  Positioned(
                    left: 0, right: 0, top: 0, bottom: 0,
                    child: isSoldOut?ItemTagWidget.imageMaskWidget():Container(),
                  )
                ],
              )
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(height: 2,),
                  Container(
                    child: Text(
                      goods.goodsName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: AppTextStyle.generate(16,
                          fontWeight: FontWeight.w400, color: isSoldOut?colorGrey:Colors.black),
                    ),
                    margin: EdgeInsets.only(top: 3),
                  ),
                  // Spacer(),
                  
                  Container(height: 5,),
//                    Container(
//                        height: 20,
//                        margin: EdgeInsets.only(top: 2, bottom: 6),
//                        child: Text(
//                          goods.description,
//                          overflow: TextOverflow.ellipsis,
//                          maxLines: 1,
//                          style: AppTextStyle.generate(13,
//                              color: Colors.grey, fontWeight: FontWeight.w300),
//                        )),
                  Container(
                    height: 15,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: goods.tags!=null&&goods.tags.length>0?goods.tags.length:0,
                      itemBuilder: (BuildContext context, int index) {
                      return ItemTagWidget.getWidgetWithTag(goods.tags[index], color: goods.inventory <= 0? colorGrey: AppColor.themeColor);
                     },
                    ),
                  ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: _tagsWidget(),
                  // ),
                  Spacer(),
                  Container(height: 5,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "￥",
                        style: AppTextStyle.generate(13,
                            fontWeight: FontWeight.w400, color: isSoldOut?colorGrey: AppColor.priceColor),
                      ),
                      Text(
                        "${goods.discountPrice.toStringAsFixed(2)}",
                        style: AppTextStyle.generate(16, color: isSoldOut?colorGrey: AppColor.priceColor),
                      ),
                      Container(
                        width: 10,
                      ),
                      Offstage(
                        offstage: !AppConfig.showCommission,
                        child: Text(
                          AppConfig.getShowCommission()? "赚${goods.commission.toStringAsFixed(2)}":"",
                          style: AppTextStyle.generate(13,
                              color: isSoldOut?colorGrey: Colors.red, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Text(
                          "${goods.salesVolume}人付款",
                          style: AppTextStyle.generate(11, color: isSoldOut?colorGrey: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  Container(height: 5,),
                  // Column(
                  //   mainAxisSize: MainAxisSize.min,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: <Widget>[
                      
                      
                      
                  //   ],
                  // )
                ],
              ),
            )
          ],
        ),
//        Icon(
//          AppIcons.icon_hot,
//          size: 30,
//        )
      ]),
    );
  }

  _soldOutWidget(){
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.black.withOpacity(0.2).withAlpha(110),
      child: Image.asset("assets/goods_sold_out.png", width: 82, height: 82,),
    );
  }
  _tagsWidget(){
    List<Widget> list = <Widget>[];
    if (goods.tags!=null && goods.tags.length>0) {
      for (dynamic tag in goods.tags) {
        list.add(
          ItemTagWidget.getWidgetWithTag(tag, color: goods.inventory <= 0? colorGrey: AppColor.themeColor)
        );
      }
    }
    
    return list;
  }
}
