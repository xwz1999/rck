/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-23  17:44 
 * remark    : 
 * ====================================================
 */

import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/models/shopping_cart_list_model.dart';
import 'package:jingyaoyun/pages/home/widget/plus_minus_view.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/input_view.dart';

import '../similar_goods_page.dart';

typedef GoodsSelectedCallback = Function(ShoppingCartGoodsModel goods);
typedef GoodsClickCallback = Function(ShoppingCartGoodsModel goods);
typedef PlusMinusUpdateCallback = Function(
    ShoppingCartGoodsModel goods, int num);

class ShoppingCartItem extends StatefulWidget {
  final ShoppingCartBrandModel model;
  final GoodsSelectedCallback selectedListener;
  final GoodsClickCallback clickListener;
  final PlusMinusUpdateCallback numUpdateCompleteCallback;
  final TextInputChangeCallBack onBeginInput;
  final bool isEdit;
  const ShoppingCartItem(
      {Key key,
      @required this.model,
      @required this.selectedListener,
      this.clickListener,
      this.numUpdateCompleteCallback,
      this.onBeginInput,
      this.isEdit = false})
      : assert(model != null);

  @override
  _ShoppingCartItemState createState() => _ShoppingCartItemState();
}

class _ShoppingCartItemState extends State<ShoppingCartItem> {
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: rSize(13)),
      margin: EdgeInsets.symmetric(vertical: rSize(5), horizontal: rSize(10)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: <Widget>[_brandName(), _buildGoodsList()],
      ),
    );
  }

  _brandName() {
    return Padding(
      padding:
          EdgeInsets.only(right: rSize(10), left: rSize(10), bottom: rSize(5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // !widget.model.isAllWaitPromotionStart() || widget.isEdit?
          CustomImageButton(
                  icon: Icon(
                    widget.model.selected
                        ? AppIcons.icon_check_circle
                        : AppIcons.icon_circle,
                    color: widget.model.selected
                        ? AppColor.themeColor
                        : Colors.grey,
                    size: rSize(20),
                  ),
                  onPressed: () {
                    widget.model.selected = !widget.model.selected;
                    widget.model.children.forEach((goods) {
                      // 只有 不是 活动未开始 的商品才能选择
                      // isEdit 编辑状态下都可以选择
                      // if (!goods.isWaitPromotionStart() || widget.isEdit) {
                      if (goods.publishStatus == 1 || widget.isEdit) {
                        goods.selected = widget.model.selected;
                        widget.selectedListener(goods);
                      } else {}

                      // }
                    });
                    setState(() {});
                  },
                ),
              // : Container(),
          Container(
            width: rSize(6),
          ),
          CustomImageButton(
            height: rSize(30),
            direction: Direction.horizontal,
            pureDisplay: true,
            // icon: CustomCacheImage(
            //   borderRadius: BorderRadius.all(Radius.circular(rSize(5))),
            //   imageUrl: Api.getResizeImgUrl(widget.model.brandLogo, 200),
            // ),
            contentSpacing: rSize(8),
            style:
                AppTextStyle.generate(17 * 2.sp, fontWeight: FontWeight.w500),
            title: widget.model.brandName,
          ),
        ],
      ),
    );
  }

  _buildGoodsList() {
    return ListView.builder(
        // itemCount: !widget.model.isShowMore &&  widget.model.children.length> 5 ? 5+1 : widget.model.children.length,
        itemCount: widget.model.children.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: ((context, index) {
          return _goodsItem(widget.model.children[index]);
        }));
    // itemBuilder: ((context, index) {
    //   if (!widget.model.isShowMore &&  widget.model.children.length > 5 && index == 5) {
    //     return GestureDetector(
    //       onTap: (){
    //         widget.model.isShowMore = true;
    //         setState(() {});
    //       },
    //       child: Container(
    //         alignment: Alignment.center,
    //         height: 30,
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             Text("点击展开更多 ", style: TextStyle(color: Colors.grey),),
    //             Image.asset('assets/shopping_cart_down_arrow.png', width: 15, height: 15, color: Colors.grey,),
    //           ],
    //         ),
    //         // child:
    //       ),
    //     );
    //   }else{
    //     return _goodsItem(widget.model.children[index]);
    //   }
    // }));
  }

  _goodsItemImage(ShoppingCartGoodsModel goods) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: rSize(4)),
      child: CustomCacheImage(
        width: rSize(90),
        height: rSize(90),
        // imageUrl: Api.getResizeImgUrl(goods.mainPhotoUrl, rSize(80).toInt()),
        imageUrl: Api.getResizeImgUrl(goods.mainPhotoUrl, rSize(200).toInt()),
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
    );
  }

  _goodsItemSelectIcon(ShoppingCartGoodsModel goods) {
    bool selected = goods.selected;
    return Container(
      height: rSize(90),
      alignment: Alignment.center,
      child: CustomImageButton(
        width: rSize(26),
        // padding: EdgeInsets.only(left: rSize(0)),
        height: double.infinity,
        icon: goods.publishStatus == 1 || widget.isEdit
            ? Icon(
                selected ? AppIcons.icon_check_circle : AppIcons.icon_circle,
                color: selected ? AppColor.themeColor : Colors.grey,
                size: rSize(20),
              )
            : Image.asset(
                R.ASSETS_NOT_SELECT_PNG,
                width: 20.rw,
                height: 20.rw,
              ),
        onPressed: goods.publishStatus == 1 || widget.isEdit
            ? () {
                goods.selected = !goods.selected;
                bool checkAll = true;
                widget.model.children.forEach((goodsItem) {
                  if (!goodsItem.selected) {
                    checkAll = false;
                    return;
                  }
                });
                widget.model.selected = checkAll;
                widget.selectedListener(goods);
                setState(() {});
              }
            : () {},
      ),
    );
  }

  _goodsItem(ShoppingCartGoodsModel goods) {
    // DateTime dateTime = DateTime.now();
    // if (goods.isWaitPromotionStart()) {
    //   dateTime = DateTime.parse(goods.promotion.startTime);
    // }

    bool isSeckill = false;

    if(goods.secKill!=null){
      if(goods.secKill.secKill==1){
        isSeckill = true;
        goods.price = goods.secKill.secKillMinPrice;
        goods.commission = goods.secKill.secKillCommission;
        //秒杀中 通过seckill中的库存和销量来判断是否是否售完
      }
    }
    return CustomImageButton(
      padding: EdgeInsets.all(0),
      onPressed: goods.publishStatus == 0
          ? () {}
          : () {
              if (widget.clickListener != null) {
                widget.clickListener(goods);
              }
            },
      child: Container(
        // height: rSize(130),
        padding:
            EdgeInsets.symmetric(vertical: rSize(3), horizontal: rSize(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _goodsItemSelectIcon(goods),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _goodsItemImage(goods),
                4.hb,
                goods.publishStatus == 0
                    ? Text(
                        '该产品已下架',
                        style: TextStyle(
                            fontSize: 12.rsp,
                            color: Color(0xFFC92219),
                            fontWeight: FontWeight.bold),
                      )
                    : SizedBox()
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ExtendedText.rich(
                      TextSpan(
                        children: [
                          goods.isImport == 1
                              ? WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 24,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: goods.countryIcon == null
                                          ? Color(0xFFCC1B4F)
                                          : Colors.transparent,
                                      borderRadius:
                                          BorderRadius.circular(3 * 2.w),
                                    ),
                                    child: goods.countryIcon == null
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
                                            imageUrl: Api.getImgUrl(
                                                goods.countryIcon),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                )
                              : WidgetSpan(child: SizedBox()),
                          goods.isImport == 1
                              ? WidgetSpan(
                                  child: Container(
                                  width: 5 * 2.w,
                                ))
                              : WidgetSpan(child: SizedBox()),
                          TextSpan(
                            text: goods.goodsName,
                            style: AppTextStyle.generate(15 * 2.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: AppColor.frenchColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 6),
                      child: Text(
                        goods.skuName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.generate(10 * 2.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    SizedBox(
                      height: 2 * 2.w,
                    ),
                    goods.isFerme == 1
                        ? Row(
                            children: [
                              Container(
                                width: 32 * 2.w,
                                height: 14 * 2.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFE5ED),
                                  borderRadius:
                                      BorderRadius.circular(7.5 * 2.w),
                                ),
                                child: Text(
                                  '包税',
                                  style: TextStyle(
                                    color: Color(0xFFCC1B4F),
                                    fontSize: 10 * 2.sp,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 2 * 2.w,
                              ),
                              Text(
                                '进口税¥${goods.ferme.toStringAsFixed(2)},由左家右厨承担',
                                style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 10 * 2.sp),
                              ),
                            ],
                          )
                        : SizedBox(),

                    SizedBox(
                      height: 7 * 2.w,
                    ),
                    Row(
                      children: <Widget>[
                        AppConfig.commissionByRoleLevel
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.4,
                                        color: AppColor.themeColor)),
                                margin: EdgeInsets.only(right: 5),
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: Text(
                                  isSeckill?"赚${goods.secKill.secKillCommission.toStringAsFixed(2)}":"赚${goods.commission.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: AppColor.themeColor,
                                      fontSize: 11 * 2.sp),
                                ),
                              )
                            : SizedBox(),
                        // !goods.isWaitPromotionStart()?
                        // Container()
                        // :Container(
                        //   child: Row(
                        //     children: <Widget>[
                        //       CustomImageButton(
                        //         pureDisplay: true,
                        //         padding: EdgeInsets.symmetric(
                        //             horizontal: rSize(2),
                        //             vertical: rSize(2)),
                        //         borderRadius: BorderRadius.all(Radius.circular(
                        //             rSize(3))),
                        //         title:"${dateTime.month}月${dateTime.day}日${dateTime.hour}:${dateTime.minute}开抢",
                        //         fontSize: 12,
                        //         color: AppColor.themeColor,
                        //         // backgroundColor: Colors.pink[50],
                        //       ),
                        //     ],
                        //   )
                        // ),
                      ],
                    ),
                    Container(
                      height: 7,
                    ),
                    Container(
                      height: 30,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: "￥",
                                        style: AppTextStyle.generate(10 * 2.sp,
                                            color: AppColor.themeColor),
                                      ),
                                      TextSpan(
                                        text:
                                        isSeckill?"${goods.secKill.secKillMinPrice.toStringAsFixed(2)}":"${goods.price.toStringAsFixed(2)}",
                                        style: AppTextStyle.generate(14 * 2.sp,
                                            color: AppColor.themeColor),
                                      ),
                                      // TextSpan(
                                      //   text: "￥",
                                      //   style: AppTextStyle.generate(7 * 2.sp,
                                      //       color: AppColor.greyColor),
                                      // ),
                                      // TextSpan(
                                      //   text:
                                      //       "${goods.originalPrice.toStringAsFixed(2)}",
                                      //   style: AppTextStyle.generate(11 * 2.sp,
                                      //       decoration:
                                      //           TextDecoration.lineThrough,
                                      //       color: AppColor.greyColor),
                                      // ),
                                    ])),
                              )),
                          goods.publishStatus == 1
                              ? Positioned(
                                  right: 0,
                                  bottom: 0,
                                  top: 0,
                                  left: 0,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: PlusMinusView(
                                        maxValue: 50,
                                        initialValue: goods.quantity,
                                        onValueChanged: (int num) {},
                                        onBeginInput: widget.onBeginInput,
                                        onInputComplete: (value) {
                                          if (int.parse(value) ==
                                              goods.quantity) return;
                                          if (widget
                                                  .numUpdateCompleteCallback !=
                                              null) {
                                            widget.numUpdateCompleteCallback(
                                                goods, int.parse(value));
                                          }
                                        },
                                      ))
                                    ],
                                  ),
                                )
                              : Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(SimilarGoodsPage(
                                          goodsId: goods.goodsId));
                                    },
                                    child: Container(
                                        width: 48.rw,
                                        height: 20.rw,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.rw)),
                                            border: Border.all(
                                                color: Color(0xFFC92219),
                                                width: 1.rw)),
                                        child: Text(
                                          '找相似',
                                          style: TextStyle(
                                            height: 1.1,
                                            color: Color(0xFFC92219),
                                            fontSize: 12.rsp,
                                          ),
                                        )),
                                  ))
                        ],
                      ),
                    )
                    // Row(
                    //   children: <Widget>[
                    //     RichText(
                    //       overflow: TextOverflow.ellipsis,
                    //       text: TextSpan(
                    //         children: [
                    //           TextSpan(
                    //             text: "￥",
                    //             style: AppTextStyle.generate(10*2.sp,color: AppColor.themeColor),
                    //           ),
                    //           TextSpan(
                    //             text: "${goods.price.toStringAsFixed(2)} ",
                    //             style: AppTextStyle.generate(14*2.sp,color: AppColor.themeColor),
                    //           ),
                    //           TextSpan(
                    //             text: "￥",
                    //             style: AppTextStyle.generate(7*2.sp,decoration: TextDecoration.lineThrough, color: AppColor.greyColor),
                    //           ),
                    //           TextSpan(
                    //             text: "${goods.originalPrice.toStringAsFixed(2) }",
                    //             style: AppTextStyle.generate(11*2.sp,decoration: TextDecoration.lineThrough, color: AppColor.greyColor),
                    //           ),
                    //         ]
                    //     )),
                    //   Expanded(
                    //     child: PlusMinusView(
                    //       maxValue: 50,
                    //       initialValue: goods.quantity,
                    //       onValueChanged: (int num) {

                    //       },
                    //       onBeginInput: widget.onBeginInput,
                    //       onInputComplete: (value) {
                    //         if (int.parse(value) == goods.quantity) return;
                    //         if (widget.numUpdateCompleteCallback != null) {
                    //           widget.numUpdateCompleteCallback(
                    //               goods, int.parse(value));
                    //         }
                    //       },
                    //     ))
                    // ],
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
