// /*
//  * ====================================================
//  * package   : pages.user
//  * author    : Created by nansi.
//  * time      : 2019/5/13  2:17 PM
//  * remark    :
//  * ====================================================
//  */

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluwx/fluwx.dart';
// import 'package:package_info/package_info.dart';
// import 'package:recook/base/base_store_state.dart';
// import 'package:recook/constants/api.dart';
// import 'package:recook/constants/header.dart';
// import 'package:recook/manager/http_manager.dart';
// import 'package:recook/manager/user_manager.dart';
// import 'package:recook/models/base_model.dart';
// import 'package:recook/models/user_brief_info_model.dart';
// import 'package:recook/pages/user/order/order_center_page.dart';
// import 'package:recook/pages/user/widget/capital_view.dart';
// import 'package:recook/pages/user/widget/money_view.dart';
// import 'package:recook/pages/user/widget/order_central_view.dart';
// import 'package:recook/pages/user/widget/other_item_view.dart';
// import 'package:recook/pages/user/widget/user_app_bar.dart';
// import 'package:recook/redux/recook_state.dart';
// import 'package:recook/third_party/wechat/wechat_utils.dart';
// import 'package:recook/widgets/alert.dart';
// import 'package:recook/widgets/arc_painter.dart';
// import 'package:recook/widgets/bottom_sheet/bottom_share_dialog.dart';
// import 'package:recook/widgets/custom_image_button.dart';
// import 'package:recook/widgets/refresh_widget.dart';
// import 'package:recook/widgets/toast.dart';
// import 'package:redux/redux.dart';
// import 'package:recook/pages/user/invite/user_invite.dart';
// import 'package:url_launcher/url_launcher.dart';

// class UserPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _UserPageState();
//   }
// }

// class _UserPageState extends BaseStoreState<UserPage> {
//   bool animating = false;
//   GSRefreshController _refreshController;
//   String capital; //提现金额
//   bool _isFirstLoad = true;

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   bool needStore() {
//     return true;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _refreshController = GSRefreshController();

//     WidgetsBinding.instance.addPostFrameCallback((callback){
//       if (_isFirstLoad) {
//         _isFirstLoad = false;
//       }else{
//         return;
//       }
//       _showUpDateAlert();
//     });
//   }

//   @override
//   Widget buildContext(BuildContext context, {store}) {
//     return Scaffold(
//       backgroundColor: AppColor.frenchColor,
//       body: NotificationListener(
//         onNotification: (ScrollEndNotification notification) {

//         },
//         child: _bodyWidget(context, store),
//         ));
//   }

//   Widget _buildNestedScrollView(BuildContext context, Store<RecookState> store) {
//     return NestedScrollView(
//       physics: NeverScrollableScrollPhysics(),
//       headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//         return [
//           SliverAppBar(
//             pinned: true,
//             floating: true,
//             elevation: 0,
//             backgroundColor: Colors.blueGrey,
//             expandedHeight: rSize(100),
//             flexibleSpace: UserAppBar(),
//           )
//         ];
//       },
//       body: Stack(
//         children: <Widget>[
//           CustomPaint(
//             painter: ArcPainter(color: AppColor.themeColor),
//             child: Container(
//               height: 120,
//             ),
//           ),
//           RefreshWidget(
//             headerTriggerDistance: rSize(80),
//             color: Colors.white,
//             controller: _refreshController,
//             releaseText: "松开更新个人数据",
//             idleText: "下拉更新个人数据",
//             refreshingText: "正在更新个人数据...",
//             onRefresh: () {
//               UserManager.instance.updateUserBriefInfo(getStore()).then((success) {
//                 if (success) {
//                   _refreshController.refreshCompleted();
//                 }
//               });
//             },
//             body: MediaQuery.removePadding(
//               context: context,
//               removeTop: true,
//               child: ListView(
//                 physics: NeverScrollableScrollPhysics(),
//                 // physics: AlwaysScrollableScrollPhysics(),
//                 children: <Widget>[
//                   _favoriteView(),
//                   MoneyView(listener: _moneyViewListener,),
//                   CapitalView(listener: _capitalViewListener,),
//                   _inviteView(),
//                   OrderCentralView(
//                     clickListener: (int index) {
//                       push(RouteName.ORDER_LIST_PAGE,
//                           arguments: OrderCenterPage.setArguments(index));
//                     },
//                   ),
//                   OtherItemView(),
//                   // _bottomTestContainer(),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   _bottomTestContainer(){
//     return Container(
//       height: 800,
//       color: Colors.red,
//     );
//   }

//   Widget _bodyWidget(BuildContext context, Store<RecookState> store){
//     if (UserManager.instance.haveLogin) {// 登录了就渲染用户界面
//       return _buildNestedScrollView(context, store);
//     }else{//没登录就渲染一个登录按钮
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Container(
//                 width: double.infinity,
//                 height: rSize(70),
//                 margin: EdgeInsets.only(top: rSize(120)),
//                 child: Image.asset(AppImageName.login_logo)),
//           Container(height: 200,),
//           Container(
//           margin: EdgeInsets.symmetric(horizontal: 100),
//           child:CustomImageButton(
//             padding: EdgeInsets.symmetric(vertical: 8),
//             title: " 登录 ",
//             backgroundColor: AppColor.themeColor,
//             color: Colors.white,
//             fontSize: ScreenAdapterUtils.setSp(16),
//             borderRadius: BorderRadius.all(Radius.circular(8)),
//             onPressed: (){
//               // AppRouter.push(context, RouteName.LOGIN);
//               AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
//             },
//           ),),
//         ],
//       );
//     }
//   }

//   _moneyViewListener(int index) {
//     switch (index) {
//       case 0:
//         break;
//       case 1:
//         break;
//       case 2:
//         push(RouteName.BALANCE_PAGE);
//         break;
//       case 3:
//         push(RouteName.RUI_COIN_PAGE);
//         break;
//     }
//   }

//   _capitalViewListener(){

//     //getStore().state.userBrief.monthSaleAmount.toStringAsFixed(2)
//     // double amount = getStore().state.userBrief.asset.fund;
//     double amount = 0.0;
//     if (amount < 10) {//少于十元
//       Alert.show(
//         context,
//         NormalTextDialog(
//           title: "提现",
//           content: "可用余额少于10元无法提现",
//           items: ["取消"],
//           listener: (int index) {
//             Alert.dismiss(context);
//           },
//         ));
//     } else {
//       if (!UserManager.instance.user.info.isVerified) { //如果用户没有实名认证让用户跳转实名认证
//         Toast.showError("未实名认证用户无法提现,请先进行实名认证!");
//         AppRouter.push(context, RouteName.USER_VERIFY).then((success){
//             if (success is bool) {
//               if (success) { //实名认证成功
//                 GSDialog.of(context).showSuccess(context, "实名认证成功");
//                 setState(() {UserManager.instance.user.info.isVerified = true;});
//                 UserManager.updateUserInfo(getStore());
//               }
//             }
//           });
//         return;
//       }
//       Alert.show(
//         context,
//         NormalContentDialog(
//           title: "提现",
//           content: _capitalText(),
//           items: ["确认提现", "取消"],
//           listener: (int index){// Alert.dismiss(context);
//             if (index == 0) {// 提现
//               if (TextUtils.isEmpty(capital) || double.parse(capital) < 10) {//提现金额不能小于10元
//                 Toast.showError("提现金额不能小于10元");
//               }else if(double.parse(capital) > amount){//提现 -> double.parse(capital) 大于余额
//                 Toast.showError("提现金额大于余额,当前余额:${amount.toStringAsFixed(2)}");
//               }else{//正常提现
//                 _withdrawAmount(double.parse(capital));
//                 capital = null;
//                 Alert.dismiss(context);
//               }
//             }else{
//               Alert.dismiss(context);
//             }
//           },
//         )
//       );
//     }
//   }

//   _withdrawAmount(double amount) async {//取款
//     ResultData resultData = await HttpManager.post(
//       UserApi.withdraw, {"amount": amount, "userId": UserManager.instance.user.info.id});
//     if (!resultData.result) {
//       showError(resultData.msg);
//       return;
//     }
//     BaseModel model = BaseModel.fromJson(resultData.data);
//       if (model.code == HttpStatus.SUCCESS) { //提款成功
//         // getStore().state.userBrief.asset.fund -= amount;
//         showSuccess(model.msg);
//       } else {
//         showError(model.msg);
//       }
//   }

//   Container _capitalText() {
//     return Container(
//       margin: EdgeInsets.only(top: rSize(10), right: rSize(20), left: rSize(20)),
//       decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey[500], width: 0.5),
//           borderRadius: BorderRadius.all(Radius.circular(3))),
//       child: TextField(
//         keyboardType: TextInputType.number,
//         style: TextStyle(color: Colors.black, fontSize: ScreenAdapterUtils.setSp(16)),
//         inputFormatters: [
//           LengthLimitingTextInputFormatter(10),
//         ],
//         cursorColor: Colors.black,
//         onChanged: (String number) {
//           capital = number.toString();
//         },
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.only(
//                 left: rSize(10), top: rSize(13), bottom: rSize(14)),
//             border: InputBorder.none,
//             hintText: "请输入提现金额",
//             hintStyle: TextStyle(color: Colors.grey[400], fontSize: ScreenAdapterUtils.setSp(15)),
//         ),
//       ),
//     );
//   }

//   _favoriteView() {
//     return Container(
//       padding: EdgeInsets.symmetric(
//           vertical: rSize(8), horizontal: rSize(10)),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: GestureDetector(
//               behavior: HitTestBehavior.translucent,
//               onTap: () {
//                 push(RouteName.MY_FAVORITE_PAGE);
//               },
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     getStore().state.userBrief.asset.favoritesCount.toString(),
//                     style: AppTextStyle.generate(ScreenAdapterUtils.setSp(18), color: Colors.white),
//                   ),
//                   SizedBox(
//                     height: rSize(1),
//                   ),
//                   Text(
//                     "收藏夹",
//                     style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13), color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: GestureDetector(
//               behavior: HitTestBehavior.translucent,
//               onTap: () {
//                 push(RouteName.MY_COUPON_PAGE);
//               },
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     getStore().state.userBrief.asset.couponCount.toString(),
//                     style: AppTextStyle.generate(ScreenAdapterUtils.setSp(18), color: Colors.white),
//                   ),
//                   SizedBox(
//                     height: rSize(1),
//                   ),
//                   Text(
//                     "红包卡券",
//                     style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13), color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _inviteView() {
//     return Container(
//       height: 80,
//       color: Colors.white,
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//               flex: 1,
//               child: ClipRRect(
//                   borderRadius: BorderRadius.all(Radius.circular(8)),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: <Widget>[
//                       Image.asset(
//                         AppImageName.invite_bg,
//                         fit: BoxFit.cover,
//                       ),
//                       MaterialButton(
//                         onPressed: () {
//                           _showShare(context);
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             Expanded(
//                               child: Text(
//                                 "邀请注册\n邀请码: ${UserManager.instance.user.info.invitationNo}",
//                                 style: TextStyle(fontSize: ScreenAdapterUtils.setSp(13), color: Colors.white, ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                             Image.asset(
//                               AppImageName.invite_icon,
//                               height: rSize(40),
//                               width: rSize(40),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ))),
//           Container(
//             width: 10,
//           ),
//           Expanded(
//               flex: 1,
//               child: ClipRRect(
//                   borderRadius: BorderRadius.all(Radius.circular(8)),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: <Widget>[
//                       Image.asset(
//                         AppImageName.my_invite_bg,
//                         fit: BoxFit.cover,
//                       ),
//                       MaterialButton(
//                         onPressed: () {
//                           AppRouter.push(context, RouteName.USER_INVITE, arguments: InvitePage.setArguments(true, UserManager.instance.user.info.id));
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: <Widget>[
//                             Text(
//                               "我的邀请",
//                               style: AppTextStyle.generate(ScreenAdapterUtils.setSp(17),
//                                   color: Colors.white),
//                             ),
//                             Image.asset(
//                               AppImageName.my_invite_icon,
//                               height: rSize(40),
//                               width: rSize(40),
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ))),
//         ],
//       ),
//     );
//   }

//   _showUpDateAlert() async {
//     VersionInfo versionInfo = getStore().state.userBrief.versionInfo;
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     //当前版本小于服务器版本
//     if (int.parse(packageInfo.buildNumber) < versionInfo.build) {
//       Alert.show(
//         context,
//         NormalTextDialog(
//           title: "发现新版本",
//           content: "${versionInfo.desc}",
//           items: ["确认","取消"],
//           listener: (int index) async {
//             Alert.dismiss(context);
//               if (index == 0) {
//                 String _url = WebApi.androidUrl;
//                 if (Platform.isIOS) _url = WebApi.iOSUrl;
//                 if (await canLaunch(_url)){
//                   launch(_url);
//                   if (Theme.of(context).platform == TargetPlatform.iOS) {
//                     Future.delayed(const Duration(seconds: 3), () => closeWebView());
//                   }
//                 }
//               }
//             },
//           )
//       );
//     }

//   }

//   _showShare(BuildContext context, {Widget customTitle}) {
//     ShareDialog.show(context, customTitle: customTitle, items: [
//       PlatformItem(
//           "微信好友",
//           Icon(
//             AppIcons.icon_we_chat,
//             size: rSize(35),
//             color: Color(0xFF51B14F),
//           )),
//       PlatformItem(
//           "微信朋友圈",
//           Icon(
//             AppIcons.icon_we_chat_circle,
//             size: rSize(35),
//             color: Color(0xFF51B14F),
//           )),
//     ], action: (index) {
//       Navigator.maybePop(context);
//       print("选择了第 $index");
//       WeChatScene scene = WeChatScene.SESSION;
//       if (index == 0) { /// 微信好友

//       }
//       if (index == 1) { /// 微信朋友圈
//         scene = WeChatScene.TIMELINE;
//       }
//       WeChatUtils.shareUrl(
//           url: "${WebApi.inviteRegist}${UserManager.instance.user.info.invitationNo}",
//           assetsThumbnail: "assets://${AppImageName.app_icon}",
//           title: "${UserManager.instance.user.info.nickname}邀请您使用瑞库客",
//           description: "打开瑞库客",
//           scene: scene);
//     });
//   }

// }
