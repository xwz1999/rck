import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:qr_flutter/qr_flutter.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_cache_image.dart';

class UserInfoQrCodePage extends StatefulWidget {
  UserInfoQrCodePage({Key key}) : super(key: key);

  @override
  _UserInfoQrCodePageState createState() => _UserInfoQrCodePageState();
}

class _UserInfoQrCodePageState extends BaseStoreState<UserInfoQrCodePage> {
  double scale = 610.0 / 466.0;
  double width;
  double height;

  @override
  Widget buildContext(BuildContext context, {store}) {
    width = MediaQuery.of(context).size.width * (466 / 562);
    height = scale * width;
    return Scaffold(
        appBar: CustomAppBar(
          background: AppColor.frenchColor,
          appBackground: AppColor.frenchColor,
          elevation: 0,
          title: "我的邀请码",
          themeData: AppThemes.themeDataGrey.appBarTheme,
        ),
        backgroundColor: AppColor.frenchColor,
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: (MediaQuery.of(context).size.height - height) / 2 -
                      (MediaQuery.of(context).padding.top + kToolbarHeight)),
              alignment: Alignment.center,
              child: _body(),
            )
          ],
        ));
  }

  _body() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 60,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 60,
                  height: 60,
                  child: CustomCacheImage(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                    imageUrl: Api.getImgUrl(
                        UserManager.instance.user.info.headImgUrl),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            UserManager.instance.user.info.nickname,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          Container(
                            width: 5,
                          ),
                          Image.asset(
                            UserManager.instance.user.info.gender == 2
                                ? "assets/user_info_qrcode_woman.png"
                                : "assets/user_info_qrcode_man.png",
                            width: 12,
                            height: 12,
                          ),
                        ],
                      ),
                      Container(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          UserLevelTool.roleLevelWidget()
                          // UserIconWidget.levelWidget(UserManager.instance.user.info.level.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Center(
            child: _qrcodeWidget(346 / 466 * width > (height * 0.9 - 100)
                ? (height * 0.9 - 100)
                : 346 / 466 * width),
          )),
          Container(
            margin: EdgeInsets.only(bottom: 15),
            alignment: Alignment.center,
            // child: Text("我的邀请码: ${UserManager.instance.user.info.invitationNo}", style: TextStyle(color: Colors.black),),
          ),
          Container(
            height: height * 0.1,
            child: Stack(
              children: <Widget>[
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Image.asset(
                      "assets/user_info_qrcode_pattern.png",
                      fit: BoxFit.cover,
                    )),
                Center(
                  child: Text(
                    "扫一扫上面的二维码图案，和我一起加入瑞库客",
                    style: TextStyle(
                        color: Color(0xff999999), fontSize: 11 * 2.sp),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _qrcodeWidget(double size) {
    return Container(
      width: size,
      height: size,
      child: QrImage(
        data:
            "${AppConfig.debug ? WebApi.testInviteRegist : WebApi.inviteRegist}${UserManager.instance.user.info.invitationNo}",
        version: QrVersions.auto,
        size: size,
        gapless: false,
        errorStateBuilder: (cxt, err) {
          return Container(
            child: Center(
              child: Text(
                "Uh oh! Something went wrong...",
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
