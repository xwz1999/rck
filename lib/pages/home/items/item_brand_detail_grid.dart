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
import 'package:jingyaoyun/widgets/toast.dart';

class BrandDetailGridItem extends StatelessWidget {
  // final Goods goods;
  final GoodsSimple goods;
  final VoidCallback buyClick;
  final Function onBrandClick;
  final VoidCallback shareClick;

  const BrandDetailGridItem(
      {Key key, this.goods, this.buyClick, this.onBrandClick, this.shareClick})
      : super(key: key);
  static final Color colorGrey = Color(0xff999999);

  @override
  Widget build(BuildContext context) {


    bool sellout = false;
    bool isSeckill = false;

      if(this.goods.inventory>0){
        sellout = false;
      }else{
        sellout = true;
      }
      if(this.goods.secKill!=null){
        if(this.goods.secKill.secKill==1){
          isSeckill = true;
          if(this.goods.secKill.realStock>0){
            sellout = false;
          }else{
            sellout = true;
          }
          //秒杀中 通过seckill中的库存和销量来判断是否是否售完
        }
      }

    double width = (MediaQuery.of(context).size.width - 10) / 2;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(5 * 2.w, 0, 5 * 2.w, 8 * 2.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            rHBox(5),
            Container(
              width: width,
              height: width,
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
                                Api.getResizeImgUrl(goods.mainPhotoUrl, 300)),
                      )),
                  Positioned(
                    child: sellout
                        ? ItemTagWidget.imageMaskWidget(
                            padding: 40, width: width - 80, height: width - 80)
                        : Container(),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4 * 2.w),
              child: ExtendedText.rich(
                TextSpan(
                  children: [
                    this.goods.isImport == 1
                        ? WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Container(
                              alignment: Alignment.center,
                              width: 24,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: this.goods.countryIcon == null
                                      ? Color(0xFFCC1B4F)
                                      : Colors.transparent,
                                borderRadius: BorderRadius.circular(3 * 2.w),
                              ),
                              child: 
                              this.goods.countryIcon==null?
                              Text(
                                '进口',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10 * 2.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ): CustomCacheImage(
                                  width: rSize(100),
                                  height: rSize(100),
                                  imageUrl: Api.getImgUrl( this.goods.countryIcon),
                                  fit: BoxFit.cover,
                                ),
                            ),
                          )
                        : WidgetSpan(child: SizedBox()),
                    this.goods.isImport == 1
                        ? WidgetSpan(
                            child: Container(
                            width: 5 * 2.w,
                          ))
                        : WidgetSpan(child: SizedBox()),
                    this.goods.gysId==1800||this.goods.gysId==2000?//jd的商品供应商 自营为1800 pop 为2000?
                    WidgetSpan(
                        child:  Container(
                            padding: EdgeInsets.only(right: 5.rw),
                            child:
                            Container(
                                child: Container(
                                  width: 40.rw,
                                  height: 15.rw,
                                  margin: EdgeInsets.only(top: 5.rw),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFC92219),
                                    borderRadius: BorderRadius.all(Radius.circular(2.rw)),
                                  ),
                                  child: Row(
                                    //crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      2.hb,
                                      Text(
                                        this.goods.gysId == 1800
                                            ? '京东自营'
                                            :  this.goods.gysId == 2000
                                            ? '京东优选'
                                            : '',
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 9.rsp, height: 1.05),
                                      ),

                                    ],
                                  ),
                                ))
                        )
                    ): WidgetSpan(child: SizedBox()),
                    TextSpan(
                      text: this.goods.goodsName,
                      style: AppTextStyle.generate(15 * 2.sp,
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
            // Spacer(),
            AppConfig.getShowCommission() ? _brandWidget() : SizedBox(),
            // Spacer(),
            _saleNumberWidget(this.goods),
            SizedBox(
              height: 4.w,
            ),
            Row(
              children: [
                isSeckill?Container(
                  alignment: Alignment.center,
                  child: Text(
                    "赚" +  (this.goods.secKill.secKillCommission??0).toStringAsFixed(2),
                    style: TextStyle(
                      color: Color(0xFFC92219),
                      fontSize: 12 * 2.sp,
                    ),
                  ),
                ):
                Text(
                  '¥${this.goods.originalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Color(0xff898989),
                      fontSize: 12 * 2.sp,
                      color: Color(0xff898989),
                      fontWeight: FontWeight.w400),
                ),
                Spacer(),
                Text(
                  isSeckill?"已售${this.goods.secKill.saleNum}件":"已售${this.goods.salesVolume}件",
                  style: TextStyle(
                    color: Color(0xff595757),
                    fontSize: 12 * 2.sp,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2 * 2.w,
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
                          text: "折后价¥",
                          style: AppTextStyle.generate(isSeckill?18.rsp:11 * 2.sp,
                              color: Color(0xffc70404),
                              fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text:"${(this.goods.discountPrice-this.goods.commission).toStringAsFixed(2)}",
                          // text: "${model.discountPrice>=100?model.discountPrice.toStringAsFixed(0):model.discountPrice.toStringAsFixed(1)}",
                          style: TextStyle(
                              letterSpacing: -1,
                              wordSpacing: -1,
                              fontSize: 17 * 2.sp,
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
                  // UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip
                  //     ? Container()
                  //     :
                  GestureDetector(
                    onTap: () {
                      if (UserManager.instance.user.info.id == 0) {
                        AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                        Toast.showError('请先登录...');
                        return;
                      }
                      if (shareClick != null) {
                        shareClick();
                      } else {
                        _shareEvent(context);
                      }
                    },
                    child: Container(
                      color: Colors.white.withAlpha(1),

                      child: Image.asset(
                        "assets/share.png",
                        width: 19,
                        height: 19,
                      ),
                    ),
                  ),

                  // GestureDetector(
                  //     child: CustomImageButton(
                  //       height: 21,
                  //       title: "导购",
                  //       style: TextStyle(
                  //           fontSize: 13*2.sp,
                  //           color: sellout ? Colors.grey : _shareTextColor),
                  //       padding: EdgeInsets.symmetric(
                  //           horizontal: rSize(8),
                  //           vertical: rSize(0)),
                  //       borderRadius: BorderRadius.only(
                  //           topLeft: Radius.circular(40),
                  //           bottomLeft: Radius.circular(40)),
                  //       border: Border.all(
                  //           color: sellout ? Colors.grey : _shareTextColor,
                  //           width: 0.5),
                  //       pureDisplay: true,
                  //     ),
                  //     onTap: () {
                  //       // if (shareClick != null) shareClick();
                  //       if (shareClick != null) {
                  //         shareClick();
                  //       } else {
                  //         _shareEvent();
                  //       }
                  //     },
                  //   ),
                  Container(
                    width: 10,
                  ),
                  GestureDetector(
                    child: CustomImageButton(
                      direction: Direction.horizontal,
                      height: 21,
                      title: sellout ? "已售完" : "自购",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13 * 2.sp,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenAdapterUtils.setWidth(
                              UserLevelTool.currentRoleLevelEnum() ==
                                          UserRoleLevel.Vip &&
                                      this.goods.getPromotionStatus() ==
                                          PromotionStatus.start
                                  ? 16
                                  : 8),
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

  _saleNumberWidget(GoodsSimple goods) {
    bool sellout = false;
    bool isSeckill = false;

    if(this.goods.inventory>0){
      sellout = false;
    }else{
      sellout = true;
    }
    if(this.goods.secKill!=null){
      if(this.goods.secKill.secKill==1){
        isSeckill = true;
        sellout = true;
        //秒杀中 通过seckill中的库存和销量来判断是否是否售完
      }
    }
    return Container(
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              isSeckill?SizedBox():
              (goods.coupon != null && goods.coupon != 0)
                  ? Container(
                      margin: EdgeInsets.only(right: 5),
                      child: SmallCouponWidget(
                        height: 18,
                        number: goods.coupon,
                      ),
                    )
                  : SizedBox(),
              isSeckill? Container(
                padding: EdgeInsets.only(top:5.rw),
                child: Image.asset(R.ASSETS_SECKILL_ICON_PNG,width: 69.rw,height: 20.rw,),
              ):
              AppConfig.commissionByRoleLevel
                  ? Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[

                          Container(
                            margin: EdgeInsets.symmetric(vertical: 2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  color: Color(0xffec294d),
                                  width: 0.5,
                                )),
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            child: Text(
                              "赚" + goods.commission.toStringAsFixed(2),
                              style: TextStyle(
                                color: Colors.white.withAlpha(0),
                                fontSize: 12 * 2.sp,
                              ),
                            ),
                          ),

                          AppConfig.getShowCommission()
                              ? Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "赚" + goods.commission.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Color(0xffeb0045),
                                      fontSize: 12 * 2.sp,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    )
                  : SizedBox(),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  _buyEvent(BuildContext context) {
    if (buyClick != null) {
      buyClick();
    } else {
      AppRouter.push(context, RouteName.COMMODITY_PAGE,
          arguments: CommodityDetailPage.setArguments(this.goods.id));
    }
  }

  _brandWidget() {
    return GestureDetector(
        onTap: () {
          if (onBrandClick != null) onBrandClick();
        },
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              // Container(
              //   width: 13 * 1.5,
              //   height: 13 * 1.5,
              //   child: TextUtils.isEmpty(this.goods.brandImg)
              //       ? SizedBox()
              //       : ExtendedImage.network(
              //           Api.getImgUrl(this.goods.brandImg),
              //           fit: BoxFit.fill,
              //         ),
              // ),
              // SizedBox(
              //   width: 4,
              // ),
              Expanded(
                child: Text(
                  TextUtils.isEmpty(this.goods.brandName)
                      ? ""
                      : this.goods.brandName,
                  maxLines: 2,
                  style: TextStyle(
                    color: Color(0xffc70404),
                    fontSize: 12 * 2.sp,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future _shareEvent(BuildContext context) async {

    bool isSeckill = false;

    if(this.goods.secKill!=null){
      if(this.goods.secKill.secKill==1){
        isSeckill = true;

        //秒杀中 通过seckill中的库存和销量来判断是否是否售完
      }
    }
    String imgUrl;
    GoodsDetailModel imagesModel = await GoodsDetailModelImpl.getDetailInfo(
        this.goods.id, UserManager.instance.user.info.id);
    if (imagesModel.data.mainPhotos.length >= 1) {
      imgUrl = imagesModel.data.mainPhotos[0].url;
    } else {
      imgUrl = imagesModel.data?.mainPhotos?.first?.url ?? '';
    }
    String goodsTitle =
        isSeckill?"￥${this.goods.secKill.secKillMinPrice} | ${this.goods.goodsName} | ${this.goods.description}":
        "￥${this.goods.discountPrice} | ${this.goods.goodsName} | ${this.goods.description}";
    ShareTool().goodsShare(context,
        goodsPrice: isSeckill?this.goods.secKill.secKillMinPrice.toStringAsFixed(2):this.goods.discountPrice.toStringAsFixed(2),
        goodsName: this.goods.goodsName,
        goodsDescription: this.goods.description,
        miniTitle: goodsTitle,
        miniPicurl: imgUrl,
        amount: isSeckill?this.goods.secKill.secKillCommission.toString():this.goods.commission.toString(),
        goodsId: this.goods.id.toString());
  }
}
