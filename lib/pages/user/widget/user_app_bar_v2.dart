import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:velocity_x/velocity_x.dart';

class UserAppBarV2 extends StatefulWidget {
  UserAppBarV2({Key key}) : super(key: key);

  @override
  _UserAppBarV2State createState() => _UserAppBarV2State();
}

class _UserAppBarV2State extends BaseStoreState<UserAppBarV2> {

  _buildInnerInfo() {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          10.wb,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomImageButton(
                onPressed: () => push(RouteName.USER_INFO_PAGE),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.rw),
                    border: Border.all(
                      width: 1.rw,
                      color: Color(0x8F979797),
                    ),
                  ),
                  position: DecorationPosition.foreground,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.rw),
                    child: FadeInImage.assetNetwork(
                      height: 60.rw,
                      width: 60.rw,
                      placeholder: Assets.icon.icLauncherPlaystore.path,
                      image: TextUtils.isEmpty(
                              UserManager.instance.user.info.headImgUrl)
                          ? ""
                          : Api.getImgUrl(
                              UserManager.instance.user.info.headImgUrl),
                    ),
                  ),
                ),
              ),
              10.hb,
              '${UserManager.instance.user.info.nickname}'
                  .text
                  .color(Color(0xFF333333))
                  .size(20.rsp)

                  .make(),
              10.hb,
            ],
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              12.hb,
              Image.asset(
                  UserLevelTool.cardBadge(UserLevelTool.currentRoleLevelEnum()),
                  width: 55.rw,
                  height: 55.rw,
                ),
              4.hb,
            ],
          ),
        ],
      ),
      Row(
        children: [
          10.wb,
          'NO.${UserManager.instance.indentifier}'
              .text
              .color(Color(0xFF333333))
              .size(10.rsp)
              .bold
              .make(),
          Spacer(),
          Builder(
            builder: (context) {
              DateTime createTime;
              if (!TextUtils.isEmpty(
                  UserManager.instance.user.info.createdAt)) {
                createTime =
                    DateTime.parse(UserManager.instance.user.info.createdAt);
              }
              return (createTime != null
                      ? '注册时间 ${createTime.year}-${createTime.month}-${createTime.day}'
                      : "")
                  .text
                  .color(Color(0xFF333333))
                  .size(10)
                  .make();
            },
          ),
          Spacer(),
          UserLevelTool.currentRoleLevelEnum() ==
              UserRoleLevel.Vip?''.text
        .color(Color(0xFF333333))
        .size(12.rsp)
        .make():'(${UserLevelTool.currentRoleLevel()})'
              .text
              .color(Color(0xFF333333))
              .size(12.rsp)
              .make(),
          15.wb,
        ],
      ),
    ].column();
  }


  _info3() {
    return Container(
      width: double.infinity,

      child: Column(
        children: [

          Container(
            padding: EdgeInsets.only(top: 24.rw,left:  24.rw,right: 33.rw),
            color: Colors.transparent,
            child: Row(
              children: [
                CustomImageButton(
                  onPressed: () => push(RouteName.USER_INFO_PAGE),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.rw),
                      border: Border.all(
                        width: 1.rw,
                        color: Colors.white,
                      ),
                    ),
                    position: DecorationPosition.foreground,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.rw),
                      child: FadeInImage.assetNetwork(
                        height: 48.rw,
                        width: 48.rw,
                        placeholder: Assets.icon.icLauncherPlaystore.path,
                        image: TextUtils.isEmpty(
                            UserManager.instance.user.info.headImgUrl)
                            ? ""
                            : Api.getImgUrl(
                            UserManager.instance.user.info.headImgUrl),
                      ),
                    ),
                  ),
                ),
                20.wb,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '${UserManager.instance.user.info.nickname}'
                          .text
                          .color(Colors.white)
                          .size(16.rsp)
                          .make(),
                      5.hb,
                      Padding(padding: EdgeInsets.only(left: 0.rw),child:           getStore().state.userBrief.end == '0001-01-01T00:00:00Z'
                          ? Container(
                        padding: EdgeInsets.symmetric(horizontal:6.rw ),
                        decoration: BoxDecoration(
                            color: Color(0xFFFEC17C),
                            borderRadius: BorderRadius.circular(2.rw)),
                        child: Text(

                          'VIP店铺',
                          style: TextStyle(
                              fontSize: 10.rsp, color: Color(0xFF512309)),
                        ),
                      )
                          : Container(
                        padding: EdgeInsets.symmetric(horizontal:6.rw ),
                        decoration: BoxDecoration(
                            color: Color(0xFFFEC17C),
                            borderRadius: BorderRadius.circular(2.rw)),
                        child: Text(
                          'VIP店铺有效期至 '+DateUtil.formatDate(
                              DateTime.parse(getStore().state.userBrief.end),
                              format: 'yyyy-MM-dd'),
                          style: TextStyle(
                              fontSize: 10.rsp, color: Color(0xFF512309)),
                        ),
                      ),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 8.rw,bottom:8.rw),
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                52.wb,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '注册时间'
                          .text
                          .color(Colors.white.withOpacity(0.6))
                          .size(10.rsp)
                          .make(),
                      16.hb,
                      (!TextUtils.isEmpty(
                          UserManager.instance.user.info.createdAt)
                          ? '${DateTime.parse(UserManager.instance.user.info.createdAt).year}-${DateTime.parse(UserManager.instance.user.info.createdAt).month}-${DateTime.parse(UserManager.instance.user.info.createdAt).day}'
                          : "")
                          .text
                          .color(Colors.white.withOpacity(0.8))
                          .bold
                          .size(10.rsp)
                          .make(),
                    ],
                  ),
                ),

                Container(
                  height: 28.rw,
                  width: 1.rw,

                  decoration: BoxDecoration(
                    gradient:LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[ Color(0xFFB41C32),Color(0xFFC95767), Color(0xFFB41C32),],
                    ),
                  ),
                ),

                48.wb,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '我的编号'
                          .text
                          .color(Colors.white.withOpacity(0.6))
                          .size(10.rsp)
                          .make(),
                      16.hb,
                      'NO.${UserManager.instance.indentifier}'
                          .text
                          .color(Colors.white.withOpacity(0.8))
                          .bold
                          .size(10.rsp)
                          .make(),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),

    );
  }

  _info2() {
    return Container(
      width: double.infinity,

      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 24.rw,bottom:21.rw,left:  24.rw,right: 33.rw),
            decoration: BoxDecoration(
                color: Color(0xFF3A3943), borderRadius: BorderRadius.vertical(top: Radius.circular(8.rw))),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          '${UserManager.instance.user.info.nickname}'
                              .text
                              .color(Colors.white)
                              .size(20.rsp)
                              .make(),
                        ],
                      ),
                      20.hb,
                      Container(
                        padding: EdgeInsets.only(top: 2.rw , bottom:2.rw,left: 8.rw,right: 4.rw),
                        decoration: BoxDecoration(
                            color: Color(0xFF3A3943), borderRadius: BorderRadius.all(Radius.circular(2.rw)),
                            gradient:LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: <Color>[Color(0xFFFFECC7), Color(0xFFFFD38D)],
                            ),

                        ),
                        child: Text(
                            UserManager.instance.userBrief.isEnterPrise?'合伙人（公司）':'合伙人（个人）',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 10.rsp
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                CustomImageButton(
                  onPressed: () => push(RouteName.USER_INFO_PAGE),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.rw),
                      border: Border.all(
                        width: 1.rw,
                        color: Colors.white,
                      ),
                    ),
                    position: DecorationPosition.foreground,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.rw),
                      child: FadeInImage.assetNetwork(
                        height: 48.rw,
                        width: 48.rw,
                        placeholder: Assets.icon.icLauncherPlaystore.path,
                        image: TextUtils.isEmpty(
                            UserManager.instance.user.info.headImgUrl)
                            ? ""
                            : Api.getImgUrl(
                            UserManager.instance.user.info.headImgUrl),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 8.rw,bottom:8.rw),
            decoration: BoxDecoration(
                color: Color(0xFF56555D), borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.rw))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                52.wb,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '注册时间'
                          .text
                          .color(Colors.white.withOpacity(0.6))
                          .size(10.rsp)
                          .make(),
                      16.hb,
                      (!TextUtils.isEmpty(
                          UserManager.instance.user.info.createdAt)
                          ? '${DateTime.parse(UserManager.instance.user.info.createdAt).year}-${DateTime.parse(UserManager.instance.user.info.createdAt).month}-${DateTime.parse(UserManager.instance.user.info.createdAt).day}'
                          : "")
                          .text
                          .color(Colors.white.withOpacity(0.8))
                          .size(10.rsp)
                          .make(),
                    ],
                  ),
                ),

                Container(
                  height: 28.rw,
                  width: 1.rw,

                  decoration: BoxDecoration(
                    gradient:LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[ Color(0xFF56555D),Color(0xFF72717C), Color(0xFF56555D),],
                    ),
                  ),
                ),

                48.wb,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '我的编号'
                          .text
                          .color(Colors.white.withOpacity(0.6))
                          .size(10.rsp)
                          .make(),
                      16.hb,
                      'NO.${UserManager.instance.indentifier}'
                          .text
                          .color(Colors.white.withOpacity(0.8))
                          .size(10.rsp)
                          .make(),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),

    );
  }


  @override
  Widget buildContext(BuildContext context, {store}) {
    return UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary?

      Container(
      height:  240.rw,
      child: Stack(
        children: [
          (UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.subsidiary &&
              UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.physical)
              ? SizedBox(
            height: 180.rw + MediaQuery.of(context).padding.top,
            child: Image.asset(
              R.ASSETS_USER_USER_APP_BAR_BG_WEBP,
              fit: BoxFit.cover,
            ),
          )
              : SizedBox(),
          (UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.subsidiary &&
              UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.physical)
              ? Positioned(
            left: 6.rw,
            right: 6.rw,
            bottom: 5.rw,
            child: Image.asset(
              UserLevelTool.userCardBackground,
              fit: BoxFit.cover,
            ),
          )
              : SizedBox(),
          (UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.subsidiary &&
              UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.physical)
              ? Positioned(
            left: 30.rw,
            right: 30.rw,
            bottom: 30.rw,
            child: _buildInnerInfo(),
          )
              : SizedBox(),
          (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.physical)
              ? Container(
            padding:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            // height: 250.rw + MediaQuery.of(context).padding.top,
            width: double.infinity,
            child: Image.asset(
              Assets.userVipBg.path,
              fit: BoxFit.fitWidth,
            ),
          )
              : SizedBox(),
          (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary)
              ? Container(
            //padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
            height: 140.rw + MediaQuery.of(context).padding.top,

            child: Column(
              children: [
                Image.asset(
                  Assets.userPartnerBg.path,
                  fit: BoxFit.fill,
                ),
                16.hb,
              ],
            ),
          )
              : SizedBox(),
          (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.physical)
              ? Positioned(
            left: 30.rw,
            right: 30.rw,
            bottom: 25.rw,
            child: _info3(),
          )
              : SizedBox(),
          (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary)
              ? Positioned(
            left: 20.rw,
            right: 20.rw,
            bottom: 0.rw,
            child: _info2(),
          )
              : SizedBox(),
        ],
      ),
    ):Stack(
      children: [
        (UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.subsidiary &&
            UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.physical)
            ? SizedBox(
          height: 180.rw + MediaQuery.of(context).padding.top,
          child: Image.asset(
            R.ASSETS_USER_USER_APP_BAR_BG_WEBP,
            fit: BoxFit.cover,
          ),
        )
            : SizedBox(),
        (UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.subsidiary &&
            UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.physical)
            ? Positioned(
          left: 6.rw,
          right: 6.rw,
          bottom: 5.rw,
          child: Image.asset(
            UserLevelTool.userCardBackground,
            fit: BoxFit.cover,
          ),
        )
            : SizedBox(),
        (UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.subsidiary &&
            UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.physical)
            ? Positioned(
          left: 30.rw,
          right: 30.rw,
          bottom: 30.rw,
          child: _buildInnerInfo(),
        )
            : SizedBox(),
        (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.physical)
            ? Container(
          // padding:
          // EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          // // height: 250.rw + MediaQuery.of(context).padding.top,
          width: double.infinity,
          child: Image.asset(
            Assets.userVipBg.path,
            fit: BoxFit.fitWidth,
          ),
        )
            : SizedBox(),
        (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary)
            ? Container(
          //padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
          height: 140.rw + MediaQuery.of(context).padding.top,

          child: Column(
            children: [
              Image.asset(
                Assets.userPartnerBg.path,
                fit: BoxFit.fill,
              ),
              16.hb,
            ],
          ),
        )
            : SizedBox(),
        (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.physical)
            ? Positioned(
          left: 30.rw,
          right: 30.rw,
          bottom: 25.rw,
          child: _info3(),
        )
            : SizedBox(),
        (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary)
            ? Positioned(
          left: 20.rw,
          right: 20.rw,
          bottom: 0.rw,
          child: _info2(),
        )
            : SizedBox(),
      ],
    );
  }
}
