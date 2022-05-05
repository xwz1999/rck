import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/gen/assets.gen.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/user/invite/my_group_page_v2.dart';
import 'package:jingyaoyun/pages/wholesale/func/wholesale_func.dart';
import 'package:jingyaoyun/pages/wholesale/models/wholesale_customer_model.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_customer_page.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:velocity_x/velocity_x.dart';

class OtherItemViewV2 extends StatelessWidget {
  OtherItemViewV2({Key key}) : super(key: key);

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
                () => AppRouter.push(context, RouteName.RECEIVING_ADDRESS_PAGE),
              ),
              _buildItem(
                Image.asset(
                  R.ASSETS_USER_FUNC_FANS_PNG,
                  width: 30.rw,
                  height: 30.rw,
                ),
                // '商务合作',
                // () => AppRouter.push(context, RouteName.BUSSINESS_COOPERATION_PAGE),
                '我的客户', () => Get.to(() => MyGroupPageV2()),
              ),
               !UserManager.instance.isWholesale?   _buildItem(
                Image.asset(
                  R.ASSETS_USER_FUNC_FAVOR_PNG,
                  width: 30.rw,
                  height: 30.rw,
                ),
                '我的收藏',
                () => AppRouter.push(context, RouteName.MY_FAVORITE_PAGE),
              ):SizedBox(),

              _buildItem(
                Image.asset(
                  Assets.icLxkf.path,
                  width: 30.rw,
                  height: 30.rw,
                ),
                '联系客服',
                () async {
                  if (UserManager.instance.haveLogin) {
                    //跳转到客服页面
                    WholesaleCustomerModel model =
                        await WholesaleFunc.getCustomerInfo();

                    Get.to(() => WholesaleCustomerPage(
                          model: model,
                        ));
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

              !UserManager.instance.isWholesale?SizedBox(): _buildItem(
                Image.asset(
                  R.ASSETS_USER_FUNC_SETTING_PNG,
                  width: 30.rw,
                  height: 30.rw,
                ),
                '我的设置',
                () => AppRouter.push(context, RouteName.SETTING_PAGE),
              ),
            ],
          ).pSymmetric(v: 18.w),
         UserManager.instance.isWholesale?SizedBox():
         Row(
           mainAxisAlignment: MainAxisAlignment.start,
            children: [
              46.wb,
              CustomImageButton(
                padding: EdgeInsets.zero,
                onPressed:  () => AppRouter.push(context, RouteName.SETTING_PAGE),
                child: <Widget>[
                  Image.asset(
                    R.ASSETS_USER_FUNC_SETTING_PNG,
                    width: 30.rw,
                    height: 30.rw,
                  ),
             '我的设置'.text.color(Color(0xFF666666)).size(12.rsp).make(),
                ].column(),
              )
            ],
          ).pSymmetric(v: 18.w),
        ],
      ),
    ).color(Color(0xFFFFFFFF)).make();
  }
}
