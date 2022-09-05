import 'dart:convert';

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
import 'package:recook/pages/user/my_favorites_page.dart';
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

class OtherItemViewV extends StatefulWidget {
  const OtherItemViewV({Key? key}) : super(key: key);

  @override
  _OtherItemViewVState createState() => _OtherItemViewVState();
}

class _OtherItemViewVState extends State<OtherItemViewV> {
  GSRefreshController? _refreshController =
      GSRefreshController(initialRefresh: true);

  int _page = 0;
  late StateSetter _stateSetter;
  late String _status;
  Color? _color;

  ///订单列表
  List<OrderModel> _orderList = [];
  bool isNodata = false;

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
                  () => Get.to(() =>
                      ReceivingAddressPage()) //AppRouter.push(context, RouteName.RECEIVING_ADDRESS_PAGE),
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
              !UserManager.instance!.isWholesale
                  ? _buildItem(
                      Image.asset(
                        R.ASSETS_USER_FUNC_FAVOR_PNG,
                        width: 30.rw,
                        height: 30.rw,
                      ),
                      '我的收藏',
                      () => Get.to(() =>
                          MyFavoritesPage()) //AppRouter.push(context, RouteName.MY_FAVORITE_PAGE),
                      )
                  : SizedBox(),

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

                    var custom = json.encode({
                      "type": BytedeskConstants.MESSAGE_TYPE_COMMODITY, // 不能修改
                      "title": "", // 可自定义, 类型为字符串
                      "content": "", // 可自定义, 类型为字符串
                      "price": "", // 可自定义, 类型为字符串
                      "imageUrl": "", //必须为图片网址, 类型为字符串
                      "id": "", // 可自定义
                      "categoryCode": "", // 可自定义, 类型为字符串
                      "client": "flutter" // 可自定义, 类型为字符串
                    });

                    BytedeskKefu.startWorkGroupChatOrderCallback(
                        context, AppConfig.WORK_GROUP_WID, "客服", (value) {},
                        () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 800.rw,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(rSize(15))),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(rSize(15))),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.rw, top: 10.rw, bottom: 10.rw),
                                    child: Row(
                                      children: [
                                        Text(
                                          '请选择想要查询的订单',
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 15.rsp),
                                        ),
                                        Spacer(),
                                        IconButton(icon: Icon(Icons.close,size: 20.rw,color: Colors.black54,), onPressed: () {
                                          Get.back();
                                        },

                                        )
                                      ],
                                    ),
                                  ),
                                  width: double.infinity,
                                ),
                                Divider(
                                  color: Color(0xFFEEEEEE),
                                  height: 0.5.rw,
                                  thickness: 1.rw,
                                ),
                                StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setSta) {
                                    _stateSetter = setSta;
                                    return orderList();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    });
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
                  () => Get.to(() =>
                      SettingPage()) // AppRouter.push(context, RouteName.SETTING_PAGE),
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

  getJson(String title, String content, String price, String imageUrl,
      String id, String categoryCode) {
    var custom = json.encode({
      "type": BytedeskConstants.MESSAGE_TYPE_COMMODITY, // 不能修改
      "title": title, // 可自定义, 类型为字符串
      "content": content, // 可自定义, 类型为字符串
      "price": price, // 可自定义, 类型为字符串
      "imageUrl": imageUrl, //必须为图片网址, 类型为字符串
      "id": id, // 可自定义
      "categoryCode": categoryCode, // 可自定义, 类型为字符串
      "client": "flutter" // 可自定义, 类型为字符串
    });
    return custom;
  }

  orderList() {
    return Expanded(
      child: RefreshWidget(
          controller: _refreshController,
          onRefresh: () async {
            _page = 0;
            _orderList = [];
            _orderList = (await UserFunc.getOrderList(_page)) ?? [];

            if (_orderList.isEmpty) {
              isNodata = true;
            } else {
              isNodata = false;
            }
            _stateSetter(() {});
            _refreshController!.refreshCompleted();
          },
          onLoadMore: () async {
            _page++;
            UserFunc.getOrderList(_page).then((value) {
              _orderList.addAll(value!);
              setState(() {});
              if (value.isEmpty)
                _refreshController!.loadNoData();
              else {
                _refreshController!.loadComplete();
              }
            });
          },
          body: isNodata
              ? NoDataView(
                  title: '没有找到可用数据哦～',
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) =>
                      _itemWidget(_orderList[index]),
                  separatorBuilder: (context, index) => Divider(
                    color: Color(0xFFEEEEEE),
                    height: 0.5.rw,
                    thickness: 1.rw,
                  ),
                  itemCount: _orderList.length,
                  padding: EdgeInsets.only(
                    left: 12.rw,
                    right: 12.rw,
                    top: 5.rw,
                  ),
                )),
    );
  }

  _itemWidget(OrderModel model) {
    _orderStatus(model);
    return GestureDetector(
      onTap: () {
        BytedeskKefu.updateGoods(getJson(
            model.title ?? '',
          '订单时间：'+ ( model.createdAt ?? ""),
            model.actualTotalAmount!.toStringAsFixed(2),
            Api.getImgUrl(model.goodsList?.first.mainPhotoUrl) ?? "",
            '订单号：${model.id}',
          '',));
        Get.back();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15.rw, top: 10.rw),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '订单号：${model.id}',
                  style: TextStyle(color: Color(0xFF666666), fontSize: 14.rsp),
                ),
                Spacer(),
                Text(
                  model.createdAt ?? "",
                  style: TextStyle(color: Color(0xFF666666), fontSize: 14.rsp),
                ),
              ],
            ),
            10.hb,
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.all(Radius.circular(8.rw)),
              ),
              child: Container(
                height: rSize(110),
                padding: EdgeInsets.symmetric(
                    vertical: rSize(8), horizontal: rSize(3)),
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
                        imageUrl:
                            Api.getImgUrl(model.goodsList?.first.mainPhotoUrl),
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              child: ExtendedText.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: model.title),
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
                            Text(
                              "共${model.totalGoodsCount}件商品",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.generate(13 * 2.sp),
                            ),
                            Row(
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        text: "实付￥",
                                        style: AppTextStyle.generate(13 * 2.sp),
                                        children: [
                                      TextSpan(
                                          text:
                                              "${model.actualTotalAmount!.toStringAsFixed(2)}",
                                          style:
                                              AppTextStyle.generate(16 * 2.sp))
                                    ])),
                                Spacer(),
                                Text(
                                  _status,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.generate(14 * 2.sp,
                                      color: _color),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _orderStatus(OrderModel model) {
    switch (model.status) {
      case 0:
        _status = "未付款";
        _color = Color.fromARGB(255, 249, 61, 6);
        break;
      case 1:
        _status = "支付成功";
        _color = Colors.red;
//        _expressStatus(status, color);
        break;
      case 2:
        _status = "订单已取消";
        _color = Colors.grey;
        break;
      case 3:
        _status = "订单已过期";
        _color = Colors.grey;
        break;
      case 4:
        _status = "交易已完成";
        _color = AppColor.priceColor;
        break;
      case 5:
        _status = "交易已关闭";
        _color = Colors.red[300];
        break;
    }
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
                          constraints: BoxConstraints(maxWidth: 150.rw),
                          //增加最大宽度
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
                          text:
                              "${((goods.goodsAmount! - goods.coinAmount!) / (goods.quantity ?? 1)).toStringAsFixed(2)}",
                          style: AppTextStyle.generate(14 * 2.sp,
                              color: AppColor.priceColor),
                        ),
                        TextSpan(
                          text: " (折后价)",
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
