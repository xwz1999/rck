import 'dart:convert';
import 'dart:io';

import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/order_list_model.dart';
import 'package:recook/pages/user/address/receiving_address_page.dart';
import 'package:recook/pages/user/functions/user_func.dart';
import 'package:recook/pages/user/setting_page.dart';
import 'package:recook/pages/wholesale/func/wholesale_func.dart';
import 'package:recook/pages/wholesale/models/wholesale_customer_model.dart';
import 'package:recook/pages/wholesale/wholesale_customer_page.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/widgets/toast.dart';
import 'package:velocity_x/velocity_x.dart';

import '../my_favorites_page.dart';

class OtherItemViewV2 extends StatelessWidget {

  GSRefreshController? _refreshController = GSRefreshController(initialRefresh: true);

  int _page = 0;

  ///订单列表
  List<OrderModel> _orderList = [];
  bool isNodata = false;

  OtherItemViewV2({Key? key}) : super(key: key);

  Widget _buildItem(Widget icon, String title, VoidCallback onTap) {
    return CustomImageButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: <Widget>[
        icon,
        title.text.color(Color(0xFF666666)).size(12.rsp).make(),
      ].column(),
    ).expand();
  }

  @override
  Widget build(BuildContext context) {
    return VxBox(
      child: Column(
        children: [
          14.hb,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              20.wb,
              Text(
                '我的服务',
                style: AppTextStyle.generate(16, fontWeight: FontWeight.w700),
              )
            ],
          ),
          Row(
            children: [
              _buildItem(
                Image.asset(
                  R.ASSETS_USER_FUNC_LOCATION_PNG,
                  width: 30.rw,
                  height: 30.rw,
                ),
                '我的地址',
                () =>   Get.to(() => ReceivingAddressPage(

                ))  //AppRouter.push(context, RouteName.RECEIVING_ADDRESS_PAGE),
              ),
              // _buildItem(
              //   Image.asset(
              //     R.ASSETS_USER_FUNC_FANS_PNG,
              //     width: 30.rw,
              //     height: 30.rw,
              //   ),
              //   // '商务合作',
              //   // () => AppRouter.push(context, RouteName.BUSSINESS_COOPERATION_PAGE),
              //   '我的客户', () => Get.to(() => MyGroupPageV2()),
              // ),
               !UserManager.instance!.isWholesale?   _buildItem(
                Image.asset(
                  R.ASSETS_USER_FUNC_FAVOR_PNG,
                  width: 30.rw,
                  height: 30.rw,
                ),
                '我的收藏',
                () =>   Get.to(() => MyFavoritesPage(

                ))    //AppRouter.push(context, RouteName.MY_FAVORITE_PAGE),
              ):SizedBox(),

              _buildItem(
                Image.asset(
                  Assets.icLxkf.path,
                  width: 30.rw,
                  height: 30.rw,
                ),
                '联系客服',
                () async {
                  if (UserManager.instance!.haveLogin) {
                    if (UserManager.instance!.user.info!.id == 0) {
                      AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                      Toast.showError('请先登录...');
                      return;
                    }

                    // var custom = json.encode({
                    //   "type": BytedeskConstants.MESSAGE_TYPE_COMMODITY, // 不能修改
                    //   "title": "", // 可自定义, 类型为字符串
                    //   "content": "", // 可自定义, 类型为字符串
                    //   "price": "" , // 可自定义, 类型为字符串
                    //   "imageUrl":"", //必须为图片网址, 类型为字符串
                    //   "id":"", // 可自定义
                    //   "categoryCode":"", // 可自定义, 类型为字符串
                    //   "client": "flutter" // 可自定义, 类型为字符串
                    // });


                    BytedeskKefu.startWorkGroupChatOrderCallback(context, AppConfig.WORK_GROUP_WID, "客服", (value) {}, () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 700.rw,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.vertical(top: Radius.circular(rSize(15))),
                            ),
                            child: RefreshWidget(

                            ),
                          );
                        },
                      );
                    });
                    //BytedeskKefu.startWorkGroupChat(context, AppConfig.WORK_GROUP_WID, "客服");
                  } else {
                    AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                    // showError("请先登录!");
                    Toast.showError("请先登录");
                  }

                },
              ),

              // (UserLevelTool.currentRoleLevelEnum() ==
              //     UserRoleLevel.Shop|| UserLevelTool.currentRoleLevelEnum() ==UserRoleLevel.physical||
              //     UserLevelTool.currentRoleLevelEnum() ==UserRoleLevel.subsidiary)?
              // _buildItem(
              //   Image.asset(R.ASSETS_USER_FUNC_RECOMMEND_PNG, width: 30.rw,
              //     height: 30.rw,),
              //   '店铺推荐',
              //       () => Get.to(() => RecommendShopPage()),
              // ):SizedBox(),
              //
              // _buildItem(
              //   Image.asset(R.ASSETS_USER_FUNC_RECOMMEND_PNG, width: 30.rw,
              //     height: 30.rw,),
              //   '批发',
              //       () => Get.to(() => WholesaleHomePage()),
              // ),

              _buildItem(
                Image.asset(
                  R.ASSETS_USER_FUNC_SETTING_PNG,
                  width: 30.rw,
                  height: 30.rw,
                ),
                '我的设置',
                () =>   Get.to(() => SettingPage(

                ))  // AppRouter.push(context, RouteName.SETTING_PAGE),
              ),
            ],
          ).pSymmetric(v: 18.w),
         // UserManager.instance.isWholesale?SizedBox():
         // Row(
         //   mainAxisAlignment: MainAxisAlignment.start,
         //    children: [
         //      46.wb,
         //      CustomImageButton(
         //        padding: EdgeInsets.zero,
         //        onPressed:  () => AppRouter.push(context, RouteName.SETTING_PAGE),
         //        child: <Widget>[
         //          Image.asset(
         //            R.ASSETS_USER_FUNC_SETTING_PNG,
         //            width: 30.rw,
         //            height: 30.rw,
         //          ),
         //     '我的设置'.text.color(Color(0xFF666666)).size(12.rsp).make(),
         //        ].column(),
         //      )
         //    ],
         //  ).pSymmetric(v: 18.w),
        ],
      ),
    ).color(Color(0xFFFFFFFF)).make();
  }


  getJson(String title,String content,String price,String imageUrl,String id,String categoryCode){
    var custom = json.encode({
      "type": BytedeskConstants.MESSAGE_TYPE_COMMODITY, // 不能修改
      "title": "", // 可自定义, 类型为字符串
      "content": "", // 可自定义, 类型为字符串
      "price": "" , // 可自定义, 类型为字符串
      "imageUrl":"", //必须为图片网址, 类型为字符串
      "id":"", // 可自定义
      "categoryCode":"", // 可自定义, 类型为字符串
      "client": "flutter" // 可自定义, 类型为字符串
    });
    return custom;
  }


  orderList(){
   return RefreshWidget(
      controller: _refreshController,
      onRefresh: () async {
        _page = 0;
        _orderList = [];
        _orderList = (await UserFunc.getOrderList(_page))??[];

        if(_orderList.isEmpty){
          isNodata = true;
        }else{
          isNodata = false;
        }

  /*      WholesaleFunc.getGoodsList(_page,_sortType,categoryID: _category.id,keyword: _searchText).then((value) {
          _goodsList = value;
          if(_goodsList.isEmpty){
            isNodata = true;
          }else{
            isNodata = false;
          }

            setState(() {});

          // if (value.isEmpty)
          //   _refreshController.isNoData;
          // else
          _refreshController!.refreshCompleted();
          // _refreshController.resetNoData();
        });*/
      },
      onLoadMore: () async{
        _page++;
        // WholesaleFunc.getGoodsList(_page,_sortType,categoryID: _category.id,keyword: _searchText).then((value) {
        //   _goodsList.addAll(value);
        //   setState(() {
        //   });
        //   if (value.isEmpty)
        //     _refreshController!.loadNoData();
        //   else{
        //     _refreshController!.loadComplete();
        //   }
        // });
      },
      body: isNodata? NoDataView(title:'没有找到可用数据哦～',):

      ListView.builder(
        itemCount: _orderList.length,
        padding: EdgeInsets.only(
          left: 12.rw,
          right: 12.rw,
          top: 0.rw,
        ),
        itemBuilder: (BuildContext context, int index) =>
            _itemWidget(_orderList[index]),
      ),

    );
  }

  _itemWidget(OrderModel model){
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text('订单号：${model.id}',style: TextStyle(color: Color(0xFF666666),fontSize: 14.rsp),),
              Spacer(),
              Text(model.createdAt??"",style: TextStyle(color: Color(0xFF666666),fontSize: 14.rsp),),
            ],
          ),
          Container(
            child: ListView.builder(
                itemCount: model.goodsList!.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  return _goodsItem(model.goodsList![index]);
                })),
          )
        ],
      ),
    );
  }

  _goodsItem(OrderGoodsModel goods) {
    return Container(
      height: rSize(110),
      padding: EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(3)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: AppColor.frenchColor),
            margin: EdgeInsets.symmetric(horizontal: rSize(4)),
            child: CustomCacheImage(
              width: rSize(90),
              height: rSize(90),
              imageUrl: Api.getImgUrl(goods.mainPhotoUrl),
              fit: BoxFit.cover,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: ExtendedText.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: goods.goodsName),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.generate(
                        14 * 2.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Color(0xffeff1f6),
                          ),
                          constraints: BoxConstraints(maxWidth: 150.rw),//增加最大宽度
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 6),
                          child: Text(
                            "${goods.skuName}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.generate(11 * 2.sp,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Spacer(),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "x${goods.quantity}",
                            style: AppTextStyle.generate(13,
                                color: Colors.grey,
                                fontWeight: FontWeight.w300),
                          ),
                        )
                      ],
                    ),
                  ),
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
                              text: "${((goods.goodsAmount!-goods.coinAmount!)/(goods.quantity??1)).toStringAsFixed(2)}",
                              style: AppTextStyle.generate(14 * 2.sp,
                                  color: AppColor.priceColor),
                            ),
                            TextSpan(
                              text:  " (折后价)",
                              style: AppTextStyle.generate(12 * 2.sp,
                                  color: Color(0xFF999999)),
                            )
                          ])),
                      Spacer(),
                      Text(
                        goods.rStatus!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.generate(14 * 2.sp,
                            color: AppColor.priceColor),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
