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
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/shopping_cart_list_model.dart';
import 'package:recook/pages/home/widget/plus_minus_view.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/input_view.dart';

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
          !widget.model.isAllWaitPromotionStart() || widget.isEdit
              ? CustomImageButton(
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
                      goods.selected = widget.model.selected;
                      widget.selectedListener(goods);
                      // }
                    });
                    setState(() {});
                  },
                )
              : Container(),
          Container(
            width: rSize(6),
          ),
          CustomImageButton(
            height: rSize(30),
            direction: Direction.horizontal,
            pureDisplay: true,
            icon: CustomCacheImage(
              borderRadius: BorderRadius.all(Radius.circular(rSize(5))),
              imageUrl: Api.getResizeImgUrl(widget.model.brandLogo, 200),
            ),
            contentSpacing: rSize(8),
            style: AppTextStyle.generate(ScreenAdapterUtils.setSp(17),
                fontWeight: FontWeight.w500),
            title: widget.model.brandName,
          )
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
        icon: Icon(
          selected ? AppIcons.icon_check_circle : AppIcons.icon_circle,
          color: selected ? AppColor.themeColor : Colors.grey,
          size: rSize(20),
        ),
        onPressed: () {
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
        },
      ),
    );
  }

  _goodsItem(ShoppingCartGoodsModel goods) {
    // DateTime dateTime = DateTime.now();
    // if (goods.isWaitPromotionStart()) {
    //   dateTime = DateTime.parse(goods.promotion.startTime);
    // }
    return CustomImageButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
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
            _goodsItemImage(goods),
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
                                      color: Color(0xFFCC1B4F),
                                      borderRadius: BorderRadius.circular(
                                          ScreenAdapterUtils.setWidth(3)),
                                    ),
                                    child: Text(
                                      '进口',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenAdapterUtils.setSp(10),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                              : WidgetSpan(child: SizedBox()),
                          goods.isImport == 1
                              ? WidgetSpan(
                                  child: Container(
                                  width: ScreenAdapterUtils.setWidth(5),
                                ))
                              : WidgetSpan(child: SizedBox()),
                          TextSpan(
                            text: goods.goodsName,
                            style: AppTextStyle.generate(
                                ScreenAdapterUtils.setSp(15),
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
                        style: AppTextStyle.generate(
                            ScreenAdapterUtils.setSp(10),
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    SizedBox(
                      height: ScreenAdapterUtils.setWidth(2),
                    ),
                    goods.isFerme==1
                        ? Row(
                            children: [
                              Container(
                                width: ScreenAdapterUtils.setWidth(32),
                                height: ScreenAdapterUtils.setWidth(14),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFE5ED),
                                  borderRadius: BorderRadius.circular(
                                      ScreenAdapterUtils.setWidth(7.5)),
                                ),
                                child: Text(
                                  '包税',
                                  style: TextStyle(
                                    color: Color(0xFFCC1B4F),
                                    fontSize: ScreenAdapterUtils.setSp(10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: ScreenAdapterUtils.setWidth(2),
                              ),
                              Text(
                                '进口税¥${(goods.price * 1.2 * 9.1 / 100.0).toStringAsFixed(2)},由瑞库客承担',
                                style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: ScreenAdapterUtils.setSp(10)),
                              ),
                            ],
                          )
                        : SizedBox(),

                    SizedBox(
                      height: ScreenAdapterUtils.setWidth(7),
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
                                  "赚${goods.commission.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: AppColor.themeColor,
                                      fontSize: ScreenAdapterUtils.setSp(11)),
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
                                        style: AppTextStyle.generate(
                                            ScreenAdapterUtils.setSp(10),
                                            color: AppColor.themeColor),
                                      ),
                                      TextSpan(
                                        text:
                                            "${goods.price.toStringAsFixed(2)} ",
                                        style: AppTextStyle.generate(
                                            ScreenAdapterUtils.setSp(14),
                                            color: AppColor.themeColor),
                                      ),
                                      TextSpan(
                                        text: "￥",
                                        style: AppTextStyle.generate(
                                            ScreenAdapterUtils.setSp(7),
                                            color: AppColor.greyColor),
                                      ),
                                      TextSpan(
                                        text:
                                            "${goods.originalPrice.toStringAsFixed(2)}",
                                        style: AppTextStyle.generate(
                                            ScreenAdapterUtils.setSp(11),
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: AppColor.greyColor),
                                      ),
                                    ])),
                              )),
                          Positioned(
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
                                    if (int.parse(value) == goods.quantity)
                                      return;
                                    if (widget.numUpdateCompleteCallback !=
                                        null) {
                                      widget.numUpdateCompleteCallback(
                                          goods, int.parse(value));
                                    }
                                  },
                                ))
                              ],
                            ),
                          )
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
                    //             style: AppTextStyle.generate(ScreenAdapterUtils.setSp(10),color: AppColor.themeColor),
                    //           ),
                    //           TextSpan(
                    //             text: "${goods.price.toStringAsFixed(2)} ",
                    //             style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),color: AppColor.themeColor),
                    //           ),
                    //           TextSpan(
                    //             text: "￥",
                    //             style: AppTextStyle.generate(ScreenAdapterUtils.setSp(7),decoration: TextDecoration.lineThrough, color: AppColor.greyColor),
                    //           ),
                    //           TextSpan(
                    //             text: "${goods.originalPrice.toStringAsFixed(2) }",
                    //             style: AppTextStyle.generate(ScreenAdapterUtils.setSp(11),decoration: TextDecoration.lineThrough, color: AppColor.greyColor),
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
