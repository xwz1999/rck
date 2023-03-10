import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart' as Fluwx;
import 'package:fluwx/fluwx.dart';
// import 'package:sharesdk_plugin/sharesdk_plugin.dart';

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/app_image_resources.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/home/home_page.dart';
import 'package:jingyaoyun/third_party/wechat/wechat_utils.dart';
import 'package:jingyaoyun/utils/rui_code_util.dart';
import 'package:jingyaoyun/widgets/bottom_sheet/bottom_share_dialog.dart';
import 'package:jingyaoyun/widgets/share_page/share_goods_poster_page.dart';
import 'package:jingyaoyun/widgets/share_page/share_url_poster_page.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:oktoast/oktoast.dart';

class ShareTool {
  static bool qqInstalled = true;
  static bool weiboInstalled = true;
  static init() {
//    SharesdkPlugin.isClientInstalled(ShareSDKPlatforms.qq).then((onValue){
//      if (onValue is bool && onValue) {
//        qqInstalled = true;
//      }
//    });
//    SharesdkPlugin.isClientInstalled(ShareSDKPlatforms.sina).then((onValue){
//      if (onValue is bool && onValue) {
//        weiboInstalled = true;
//      }
//    });
  }

  diamondsInviteShare({String code = ""}) {
    WeChatScene scene = WeChatScene.SESSION;
    String inviteCode = TextUtils.isEmpty(code)
        ? UserManager.instance.user.info.invitationNo
        : code;
    WeChatUtils.shareUrl(
        // url: "http://h5test.reecook.cn/index/index/register?code=9A59AQ",
        url:
            "${AppConfig.debug ? WebApi.testDiamondsInviteRegist : WebApi.diamondsInviteRegist}$inviteCode",
        // assetsThumbnail: "assets://${AppImageName.recook_icon_120}",
        netWorkThumbnail: AppImageName.web_app_icon,
        title: "有福同享，才是‘壕’朋友！",
        description: "左家右厨邀你玩转店铺，快来一起体验吧！",
        scene: scene);
  }

  _shareTitle(String amount) {
    if (TextUtils.isEmpty(amount)) {
      return Container();
    } else {
      return Container(
        // alignment: Alignment.center,
        // child: RichText(
        //   textAlign: TextAlign.center,
        //   text: TextSpan(children: <TextSpan>[
        //     TextSpan(text: '\n'),
        //     TextSpan(
        //         text: '导购赚 ',
        //         style: TextStyle(color: Colors.red, fontSize: 14 * 2.sp)),
        //     TextSpan(
        //         text: amount,
        //         style: TextStyle(
        //           color: Colors.red,
        //           fontSize: 18 * 2.sp,
        //         )),
        //     // TextSpan(text: '\n'),
        //     // TextSpan(
        //     //     text: '分享后好友至少能赚$amount',
        //     //     style: TextStyle(
        //     //         color: Color(0xff999999),
        //     //         fontSize: 10*2.sp)),
        //   ]),
        // ),
      );
    }
  }

  liveShare(
    BuildContext context, {
    @required int liveId,
    @required String title,
    @required String des,
    @required String headUrl,
  }) {
    String baseUrl = "${AppConfig.debug ? WebApi.testLiveUrl : WebApi.liveUrl}";
    WeChatUtils.shareUrl(
      url: '$baseUrl$liveId',
      title: title,
      description: des,
      netWorkThumbnail: Api.getImgUrl(headUrl),
    );
  }


  clipBoard({
    BuildContext context,
    @required int liveId,
  }) {
    String baseUrl = "${AppConfig.debug ? WebApi.testLiveUrl : WebApi.liveUrl}";
    ClipboardData data = new ClipboardData(text: '$baseUrl$liveId');
    Clipboard.setData(data);
    Toast.showCustomSuccess(
      '链接复制成功',
      delayedDuration: Duration(seconds: 0),
    );
  }

  goodsShare(
    BuildContext context, {
    String goodsName = "",
    String goodsDescription = "",
    String goodsPrice = "",
    String amount = "",
    String miniTitle = "",
    String miniPicurl = "",
    String goodsId = "",
    String secondPic = "",
  }) {
    // !!!!
    // String goodsUrl =
    //     "${AppConfig.debug ? WebApi.testGoodsDetail : WebApi.goodsDetail}$goodsId/${UserManager.instance.user.info.invitationNo}";
    // PlatformItem miniItem = PlatformItem(
    //     "小程序",
    //     Image.asset(
    //       ShareToolIcon.wechatmini,
    //       width: 36,
    //       height: 36,
    //     ), itemClick: () {
    //   Navigator.maybePop(context);
    //   WeChatUtils.shareGoodsForMiniProgram(
    //       title: miniTitle,
    //       goodsId: int.parse(goodsId),
    //       thumbnail: Api.getImgUrl(miniPicurl));
    // });
    PlatformItem wechatItem = PlatformItem(
        "小程序",
        Image.asset(
          R.ASSETS_SHARE_BOTTOM_WECHAT_MINI_P_PNG,
          width: 36,
          height: 36,
        ), itemClick: () {
      Navigator.maybePop(context);
      // WeChatScene scene = WeChatScene.SESSION;
      // WeChatUtils.shareUrl(
      //     url: goodsUrl,
      //     netWorkThumbnail: Api.getImgUrl(miniPicurl),
      //     // netWorkThumbnail: AppImageName.web_app_icon,
      //     title: "仅$goodsPrice元 | $goodsName",
      //     description: goodsDescription,
      //     scene: scene);
      WeChatUtils.miniProgramShare(
        id: goodsId,
        netWorkThumbnail: Api.getImgUrl(miniPicurl),
        des: miniTitle,
      );
    });
    // PlatformItem weiboItem = PlatformItem(
    //     "微博",
    //     Image.asset(
    //       ShareToolIcon.weibo,
    //       width: 36,
    //       height: 36,
    //     ), itemClick: () {
    //   Navigator.maybePop(context);
    //   // SSDKMap params = SSDKMap()
    //   //   ..setGeneral(
    //   //       miniTitle + " | 左家右厨全球精选好货，尊享超值福利！" + goodsUrl,
    //   //       miniTitle + " | 左家右厨全球精选好货，尊享超值福利！" + goodsUrl,
    //   //       null,
    //   //       // "https://cdn.reecook.cn/static/default/appicon.png",
    //   //       null,
    //   //       AppImageName.recook_icon_60,
    //   //       goodsUrl,
    //   //       goodsUrl,
    //   //       null,
    //   //       null,
    //   //       AppImageName.recook_icon_60,
    //   //       SSDKContentTypes.webpage);
    //   SSDKMap params = SSDKMap()
    //     ..setGeneral(
    //         miniTitle + " | 左家右厨全球精选好货，尊享超值福利！" + goodsUrl,
    //         miniTitle + " | 左家右厨全球精选好货，尊享超值福利！" + goodsUrl,
    //         null,
    //         null,
    //         null,
    //         goodsUrl,
    //         goodsUrl,
    //         null,
    //         null,
    //         null,
    //         SSDKContentTypes.webpage);
    //   // SSDKMap params = SSDKMap()
    //   // ..setSinaLinkCard(
    //   //   miniTitle + " | 左家右厨全球精选好货，尊享超值福利！",
    //   //   "全球精选好货，尊享超值福利！",
    //   //   goodsUrl,
    //   //   "全球精选好货，尊享超值福利！",
    //   //   "https://cdn.reecook.cn/static/default/appicon.png",
    //   //   "120",
    //   //   "120",
    //   // );
    //   SharesdkPlugin.share(ShareSDKPlatforms.sina, params,
    //       (SSDKResponseState state, Map userdata, Map contentEntity,
    //           SSDKError error) {
    //     // if (error != null) {
    //     //   Toast.showError(jsonEncode(error.rawData));
    //     // }
    //   });
    // });
    // PlatformItem qqItem = PlatformItem(
    //     "QQ",
    //     Image.asset(
    //       R.ASSETS_SHARE_BOTTOM_QQ_PNG,
    //       width: 36,
    //       height: 36,
    //     ), itemClick: () {
    //   Navigator.maybePop(context);
    //   SSDKMap params = SSDKMap()
    //     ..setQQ(
    //         "$miniTitle | 左家右厨全球精选好货，尊享超值福利！",
    //         "全球精选好货，尊享超值福利！",
    //         goodsUrl,
    //         null,
    //         null,
    //         null,
    //         null,
    //         "",
    //         "https://cdn.reecook.cn/static/default/appicon.png",
    //         null,
    //         null,
    //         goodsUrl,
    //         null,
    //         null,
    //         SSDKContentTypes.webpage,
    //         ShareSDKPlatforms.qq);
    //   SharesdkPlugin.share(ShareSDKPlatforms.qq, params,
    //       (SSDKResponseState state, Map userdata, Map contentEntity,
    //           SSDKError error) {
    //     // if (error != null) {
    //     //   Toast.showError(jsonEncode(error.rawData));
    //     // }
    //   });
    // });
    // PlatformItem copyurl = PlatformItem(
    //     "复制链接",
    //     Image.asset(
    //       R.ASSETS_SHARE_BOTTOM_LINK_PNG,
    //       width: 36,
    //       height: 36,
    //     ), itemClick: () {
    //   Navigator.maybePop(context);
    //   ClipboardData data = new ClipboardData(text: goodsUrl);
    //   Clipboard.setData(data);
    //   Toast.showCustomSuccess(
    //     '链接复制成功',
    //     delayedDuration: Duration(seconds: 0),
    //   );
    // });
    PlatformItem qrcode = PlatformItem(
        "二维码海报",
        Image.asset(
          R.ASSETS_SHARE_BOTTOM_BANNER_PNG,
          width: 36,
          height: 36,
        ), itemClick: () {
      Navigator.maybePop(context);
      Future.delayed(Duration(milliseconds: 500), () {
        AppRouter.push(context, RouteName.SHARE_GOODS_POSTER_PAGE,
            arguments: ShareGoodsPosterPage.setArguments(goodsId: goodsId));
      });
    });
    PlatformItem addToLiveGoodsCart = PlatformItem(
      '加到直播车',
      Image.asset(
        R.ASSETS_SHARE_BOTTOM_LIVE_CART_PNG,
        width: 36,
        height: 36,
      ),
      itemClick: () {
        HttpManager.post(LiveAPI.addToCart, {
          'goodsIds': [int.parse(goodsId)],
        }).then((result) {
          showToast(result.data['msg']);
        });
        Navigator.pop(context);
      },
    );

    PlatformItem ruiCode = PlatformItem(
      '云口令',
      Image.asset(
        R.ASSETS_SHARE_BOTTOM_RUI_CODE_PNG,
        width: 36,
        height: 36,
      ),
      itemClick: () async {
        ClipboardListenerValue.canListen = false;
        Navigator.pop(context);
        print(goodsId);
        String code = '【$miniTitle】复制这段描述，打开左家右厨，购全球好物${RUICodeUtil.encrypt(
          int.parse(goodsId),
          UserManager.instance.user.info.id,
        )}左家右厨。\n跟着英子去开店';
        Clipboard.setData(ClipboardData(text: code));
        bool needWechat = await showDialog(
          context: context,
          builder: (context) => Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(rSize(6)),
                  color: Colors.white,
                ),
                margin: EdgeInsets.symmetric(horizontal: rSize(40)),
                padding: EdgeInsets.symmetric(
                    horizontal: rSize(28), vertical: rSize(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '云口令复制成功',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: rSP(16),
                      ),
                    ),
                    rHBox(10),
                    Text(
                      code,
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: rSP(14),
                      ),
                    ),
                    rHBox(20),
                    MaterialButton(
                      color: Color(0xFFF82F33),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      height: rSize(33),
                      minWidth: rSize(119),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      shape: StadiumBorder(),
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        '去微信分享粘贴',
                        style: TextStyle(
                          fontSize: rSP(12),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        if (needWechat == true) {
          await Fluwx.openWeChatApp();
        }
        ClipboardListenerValue.canListen = true;
      },
    );
    List<PlatformItem> itemList = [
      // miniItem,
      qrcode,
      wechatItem,
      // weiboItem,
      // qqItem,
      // copyurl,
    ];
    // if (ShareTool.qqInstalled) {
    //   itemList.add(qqItem);
    // }
    // itemList.add(addToLiveGoodsCart);
    itemList.add(ruiCode);
    // if (ShareTool.weiboInstalled){
    //   itemList.add(weiboItem);
    // }
    ShareDialog.show(context,
        customTitle: _shareTitle(amount), items: itemList, action: (index) {});
  }

  inviteShare(BuildContext context, {Widget customTitle, String code = ""}) {
    if (UserManager.instance.user.info.id == 0) {
      AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
      Toast.showError('请先登录...');
      return;
    }

    //!!!!
    WeChatScene scene = WeChatScene.SESSION;
    String inviteCode = TextUtils.isEmpty(code)
        ? UserManager.instance.user.info.invitationNo
        : code;
    String inviteUrl =
        "${AppConfig.debug ? WebApi.testInviteRegist : WebApi.inviteRegist}$inviteCode";
    String invitePosterUrl = "${Api.host}${WebApi.invitePoster}$inviteCode";
    PlatformItem wechatItem = PlatformItem(
        "微信",
        Image.asset(
          ShareToolIcon.wechat,
          width: 36,
          height: 36,
        ), itemClick: () {
      Navigator.maybePop(context);
      WeChatUtils.shareUrl(
          url: inviteUrl,
          netWorkThumbnail: AppImageName.web_app_icon,
          title: "有福同享，才是‘壕’朋友！",
          description: "左家右厨邀你玩转店铺，快来一起体验吧！",
          scene: scene);
    });

//     PlatformItem weiboItem = PlatformItem(
//         "微博",
//         Image.asset(
//           ShareToolIcon.weibo,
//           width: 36,
//           height: 36,
//         ), itemClick: () {
//       Navigator.maybePop(context);
//       SSDKMap params = SSDKMap()
//         ..setGeneral(
//             "邀请您加入左家右厨  " + inviteUrl,
//             "邀请您加入左家右厨  " + inviteUrl,
//             null,
//             null,
//             null,
//             inviteUrl,
//             inviteUrl,
//             null,
//             null,
//             null,
//             SSDKContentTypes.webpage);
// //          SSDKMap params = SSDKMap()
// //          ..setSinaLinkCard(
// //            "邀请您加入左家右厨",
// //            "邀请您加入左家右厨",
// //            inviteUrl,
// //            "邀请您加入左家右厨",
// //            "https://cdn.reecook.cn/static/default/appicon.png",
// //            "120",
// //            "120",
// //          );
//       try {
//         SharesdkPlugin.share(ShareSDKPlatforms.sina, params,
//             (SSDKResponseState state, Map userdata, Map contentEntity,
//                 SSDKError error) {
//           // if (error != null) {
//           //   Toast.showError(jsonEncode(error.rawData));
//           // }
//         });
//       } catch (e) {
//         Toast.showError(e.toString());
//       }
//     });
    PlatformItem copyurlItem = PlatformItem(
        "复制链接",
        Image.asset(
          ShareToolIcon.copyurl,
          width: 36,
          height: 36,
        ), itemClick: () {
      Navigator.maybePop(context);
      ClipboardData data = new ClipboardData(text: inviteUrl);
      Clipboard.setData(data);
      Toast.showCustomSuccess(
        '链接复制成功',
        delayedDuration: Duration(seconds: 0),
      );
    });
    // PlatformItem qqItem = PlatformItem(
    //     "QQ",
    //     Image.asset(
    //       ShareToolIcon.qq,
    //       width: 36,
    //       height: 36,
    //     ), itemClick: () {
    //   Navigator.maybePop(context);
    //   SSDKMap params = SSDKMap()
    //     ..setQQ(
    //         "左家右厨邀你玩转店铺，快来一起体验吧！",
    //         "有福同享，才是‘壕’朋友！",
    //         inviteUrl,
    //         null,
    //         null,
    //         null,
    //         null,
    //         "",
    //         "https://cdn.reecook.cn/static/default/appicon.png",
    //         null,
    //         null,
    //         inviteUrl,
    //         null,
    //         null,
    //         SSDKContentTypes.webpage,
    //         ShareSDKPlatforms.qq);
    //   SharesdkPlugin.share(ShareSDKPlatforms.qq, params,
    //       (SSDKResponseState state, Map userdata, Map contentEntity,
    //           SSDKError error) {
    //     // if (error != null) {
    //     //   Toast.showError(jsonEncode(error.rawData));
    //     // }
    //   });
    // });
    PlatformItem qrcode = PlatformItem(
        "二维码海报",
        Image.asset(
          ShareToolIcon.poster,
          width: 36,
          height: 36,
        ), itemClick: () {
      Navigator.maybePop(context);
      Future.delayed(Duration(milliseconds: 500), () {
        AppRouter.push(context, RouteName.SHARE_URL_POSTER_PAGE,
            arguments: ShareUrlPosterPage.setArguments(url: invitePosterUrl));
      });
    });
    List<PlatformItem> itemList = [
      wechatItem,
      // weiboItem,
      copyurlItem,
      qrcode,
      // qqItem,
    ];
    // if (ShareTool.qqInstalled) {
    //   itemList.add(qqItem);
    // }
    // if (ShareTool.weiboInstalled){
    //   itemList.add(weiboItem);
    // }
    ShareDialog.show(
      context, customTitle: customTitle, items: itemList,
      // [
      //   PlatformItem(
      //       "小程序",
      //       Image.asset(ShareToolIcon.wechatmini, width: 36, height: 36,),
      //       // Icon(
      //       //   AppIcons.icon_we_chat_circle,
      //       //   size: rSize(35),
      //       //   color: Color(0xFF51B14F),
      //       // )
      //       ),
      //   wechatItem,
      //   weiboItem,
      //   copyurlItem,
      //   qqItem,
      //   PlatformItem(
      //       "微信朋友圈",
      //       Icon(
      //         AppIcons.icon_we_chat_circle,
      //         size: rSize(35),
      //         color: Color(0xFF51B14F),
      //       )),
      // ],
      action: (int index) {},
    );
  }
}
