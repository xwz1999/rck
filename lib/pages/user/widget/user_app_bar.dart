/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/10  10:03 AM 
 * remark    : 
 * ====================================================
 */

import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/meiqia_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/utils/app_router.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/custom_painters/user_app_bar_mask_painter.dart';

class UserAppBar extends StatefulWidget {
  final Function() userListener;
  final Function() withdrawListener;
  const UserAppBar({Key key, this.userListener, this.withdrawListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserAppBarState();
  }
}

class _UserAppBarState extends BaseStoreState<UserAppBar> {
  GlobalKey _myKey = new GlobalKey();
  double _marginRight = 0;
  Color _goldColor = Color(0xffFFDEAA);
  @override
  Widget buildContext(BuildContext context, {store}) {
    Container body = Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              UserLevelTool.currentAppBarBGImagePath(),
              fit: BoxFit.cover,
            ),
          ),
          _buildAppBar(context),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 16),
              painter: UserAppBarMaskPainter(),
            ),
          ),
        ],
      ),
    );
    return ClipRRect(
      // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      child: body,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _buildAppBar(BuildContext context) {
    return Container(
      height: double.infinity,
      child: SafeArea(
        top: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 100,
              width: double.infinity,
              child: _headWidget(),
            ),
            Spacer(),
            Container(
              width: double.infinity,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      "assets/user_page_appbar_bottom_bg.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  _moneyWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _moneyWidget() {
    return Container(
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 51,
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  UserLevelTool.currentAppBarIconImagePath(),
                  width: 16,
                  height: 16,
                ),
                Container(
                  height: 2,
                ),
                Text(
                  UserLevelTool.currentRoleLevel2(),
                  style: TextStyle(color: _goldColor, fontSize: 10),
                )
              ],
            ),
          ),
          Container(
            width: 1,
            margin: EdgeInsets.only(top: 15, bottom: 15, right: 15),
            color: _goldColor,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ExtendedText.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: '余额',
                        style: TextStyle(color: _goldColor, fontSize: 14)),
                    TextSpan(
                        text: '(元)',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: _goldColor,
                            fontSize: 10)),
                    TextSpan(
                        text: ': ',
                        style: TextStyle(color: _goldColor, fontSize: 14)),
                    TextSpan(
                        text: (getStore().state.userBrief.balance ?? 0.0)
                            .toDouble()
                            .toStringAsFixed(2),
                        style:
                            TextStyle(color: _goldColor, fontSize: 22 * 2.sp)),
                  ]),
                  textAlign: TextAlign.start,
                ),
                AppConfig.getShowCommission()
                    ? Container(
                        height: 3,
                      )
                    : SizedBox(),
                AppConfig.getShowCommission()
                    ? Text('每月10日、25日审核提现申请',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: _goldColor,
                            fontSize: 10))
                    : SizedBox(),
              ],
            ),
          ),
          AppConfig.getShowCommission()
              ? GestureDetector(
                  onTap: () {
                    if (!UserManager.instance.user.info.realInfoStatus) {
                      AppRouter.push(context, RouteName.USER_VERIFY,
                          arguments: {'isCashWithdraw': true});
                    } else {
                      if (widget.withdrawListener != null)
                        widget.withdrawListener();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                          colors: [Color(0xfffeccab), Color(0xfffeb273)]),
                    ),
                    margin: EdgeInsets.only(right: 15),
                    alignment: Alignment.center,
                    width: 64,
                    height: 25,
                    child: Text(
                      "提现",
                      style: TextStyle(
                          color: Colors.brown,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  _headWidget() {
    String nickname = UserManager.instance.user.info.nickname;
    if (TextUtils.isEmpty(nickname, whiteSpace: true)) {
      String mobile = UserManager.instance.user.info.mobile;
      nickname = "用户${mobile.substring(mobile.length - 4)}";
    }
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (widget.userListener != null) widget.userListener();
          },
          child: Container(
            width: 70, height: 70,
            margin: EdgeInsets.symmetric(horizontal: rSize(10), vertical: 15),
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.white, width: 2),
            //   borderRadius: BorderRadius.all(Radius.circular(40)),
            // ),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    child: CustomCacheImage(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                      imageUrl: TextUtils.isEmpty(
                              UserManager.instance.user.info.headImgUrl)
                          ? ""
                          : Api.getImgUrl(
                              UserManager.instance.user.info.headImgUrl),
                    )),
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Positioned(
                top: 20,
                child: Container(
                  alignment: Alignment.topLeft,
                  // constraints: BoxConstraints(maxWidth: rSize(120)),
                  child: Text(
                    nickname,
                    // 'wfawfawefwfewefwefwefwfeawf',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    key: _myKey,
                    style: AppTextStyle.generate(18 * 2.sp,
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Positioned(
                bottom: 23,
                left: _marginRight,
                child: UserLevelTool.roleLevelWidget(),
                // child: UserIconWidget.levelWidget(UserManager.instance.user.info.role),
              )
            ],
          ),
        ),
        CustomImageButton(
          // icon: Icon(AppIcons.icon_message),
          // icon: Icon(Icons.favorite_border, size: 25, color: Colors.white,),
          icon: ImageIcon(
            AssetImage(
              "assets/navigation_like.png",
            ),
            size: 18,
          ),
          title: "收藏",
          fontSize: 10,
          color: getCurrentAppItemColor(),
          onPressed: () {
            push(RouteName.MY_FAVORITE_PAGE);
          },
        ),
        Container(
          width: 5,
        ),
        CustomImageButton(
          // icon: Icon(AppIcons.icon_message),
          icon: ImageIcon(
            AssetImage("assets/navigation_msg.png"),
            size: 18,
          ),
          title: "客服",
          fontSize: 10,
          color: getCurrentAppItemColor(),
          onPressed: () {
            MQManager.goToChat(
                userId: UserManager.instance.user.info.id.toString(),
                userInfo: <String, String>{
                  "name": UserManager.instance.user.info.nickname ?? "",
                  "gender":
                      UserManager.instance.user.info.gender == 1 ? "男" : "女",
                  "mobile": UserManager.instance.user.info.mobile ?? ""
                });
          },
        ),
        Container(
          width: 20,
        ),
      ],
    );
  }
}

class UserAppBarController {
  ValueNotifier<double> offset = ValueNotifier(0);

  double get offsetValue => offset.value;

  void dispose() {
    offset.dispose();
  }
}
