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
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:package_info/package_info.dart';
// import 'package:recook/base/base_store_state.dart';
// import 'package:recook/constants/api.dart';
// import 'package:recook/constants/header.dart';
// import 'package:recook/manager/http_manager.dart';
// import 'package:recook/manager/user_manager.dart';
// import 'package:recook/models/base_model.dart';
// import 'package:recook/models/user_brief_info_model.dart';
// import 'package:recook/models/user_model.dart';
// import 'package:recook/pages/user/order/order_after_sale_page.dart';
// import 'package:recook/pages/user/order/order_center_page.dart';
// import 'package:recook/pages/user/widget/capital_view.dart';
// import 'package:recook/pages/user/widget/money_view.dart';
// import 'package:recook/pages/user/widget/order_central_view.dart';
// import 'package:recook/pages/user/widget/other_item_view.dart';
// import 'package:recook/pages/user/widget/user_app_bar.dart';
// import 'package:recook/redux/recook_state.dart';
// import 'package:recook/third_party/wechat/wechat_utils.dart';
// import 'package:recook/widgets/alert.dart';
// import 'package:recook/widgets/custom_image_button.dart';
// import 'package:recook/widgets/refresh_widget.dart';
// import 'package:recook/widgets/toast.dart';
// import 'package:redux/redux.dart';
// import 'package:url_launcher/url_launcher.dart';

// class UserPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _UserPageState();
//   }
// }

// class _UserPageState extends BaseStoreState<UserPage> {
//   bool _weChatLoginLoading = false;

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
//       backgroundColor: Color.fromARGB(255, 243, 245, 247),
//       body: _bodyWidget(context, store),);
//   }

//   Widget _buildNestedScrollView(BuildContext context, Store<RecookState> store) {
//     return Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             color: Colors.yellow, height: 100+ScreenUtil.statusBarHeight,
//             child: UserAppBar(
//               userListener: (){
//                 push(RouteName.USER_INFO_PAGE);
//               },
//             ),),
//           Expanded(
//             child: _buildRefreshScrollView(context, store),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRefreshScrollView(BuildContext context, Store<RecookState> store) {
//     return Stack(
//       children: <Widget>[
//         Container(color: AppColor.themeColor,height: ScreenAdapterUtils.setHeight(60)),
//         RefreshWidget(
//           headerTriggerDistance: rSize(80),
//           color: Colors.white,
//           controller: _refreshController,
//           releaseText: "松开更新个人数据",
//           idleText: "下拉更新个人数据",
//           refreshingText: "正在更新个人数据...",
//           onRefresh: () {
//             UserManager.instance.updateUserBriefInfo(getStore()).then((success) {
//               if (success) {
//                 if ( UserManager.instance.user.info.role != getStore().state.userBrief.role){
//                   UserManager.instance.user.info.role = getStore().state.userBrief.role;
//                   UserManager.instance.refreshUserRole.value = !UserManager.instance.refreshUserRole.value;
//                   UserManager.updateUserInfo(getStore());
//                 }
//                 _refreshController.refreshCompleted();
//               }
//             });
//           },
//           body: ListView(
//             physics: AlwaysScrollableScrollPhysics(),
//               // physics: BouncingScrollPhysics(),
//             children: <Widget>[
//               // _favoriteView(),
//               // UserManager.instance.user.info.role == 0?
//               //   MemberInviteView(listener: (){
//               //     ShareTool().inviteShare(context);
//               //   }):
//               MoneyView(
//                 listener: _moneyViewListener,
//                 wechatListener: _wechatBindinghandle,
//               ),
//               // _inviteView(),
//               CapitalView(),
//               OrderCentralView(
//                 clickListener: (int index) {
//                   if (index == 4) {
//                     AppRouter.push(context, RouteName.ORDER_AFTER_SALE_GOODS_LIST, arguments: OrderAfterSalePage.setArguments(OrderAfterSaleType.userPage, null, null));
//                     return;
//                   }
//                   push(RouteName.ORDER_LIST_PAGE, arguments: OrderCenterPage.setArguments(index));
//                 },
//               ),
//               OtherItemView(),
//               // _bottomTestContainer(),
//             ],
//           ),
//         ),
//       ],
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
//             margin: EdgeInsets.only(top: rSize(120)),
//             width: rSize(70),
//             height: rSize(70),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: AspectRatio(
//                 aspectRatio: 1.0/1.0,
//                 child: Image.asset(AppImageName.recook_icon_300, fit: BoxFit.fill),),
//               ),
//           ),
//           Container(height: 150,),
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
//               AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
//             },
//           ),),
//         ],
//       );
//     }
//   }

//   _moneyViewListener(int index) {
//     switch (index) {
//       case 0: //我的余额
//         push(RouteName.BALANCE_PAGE);
//         break;
//       case 1: //提现
//         _withdrawMoney();
//         break;
//       case 2: //查看订单明细
//         push(RouteName.USER_BILLING_DETAILS);
//         break;
//       case 3: //未到账
//         // push(RouteName.RUI_COIN_PAGE);
//         break;
//       case 4: //累计收入
//         // push(RouteName.RUI_COIN_PAGE);
//         break;
//     }
//   }

//  _withdrawMoney(){
//     //getStore().state.userBrief.monthSaleAmount.toStringAsFixed(2)
//     double amount = getStore().state.userBrief.amount;
//     // double amount = 0.0;
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
//         // showSuccess(model.msg);
//         GSDialog.of(globalContext).showSuccess(globalContext, model.msg, duration: Duration(milliseconds: 3000));
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
//           WhitelistingTextInputFormatter.digitsOnly,
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
//   _wechatBindinghandle(){
//     DPrint.printf("微信登录");
//     if (!WeChatUtils.isInstall) {
//       showError("没有检测到微信！请先安装！");
//       return;
//     }
//     GSDialog.of(context).showLoadingDialog(context, "正在请求数据...");
//     WeChatUtils.wxLogin((WXLoginResult result) {
//       if (result.errCode != 0) {
//         GSDialog.of(context).dismiss(context);
//         Toast.showInfo(result.errStr);
//       } else {
//         if (!_weChatLoginLoading) {
//           _weChatLoginLoading = true;
//           _weChatLogin(result.code);
//         }
//       }
//     });
//   }
//   _weChatLogin(String code) async {
//     GSDialog.of(context).showLoadingDialog(context, "登录中...");
//     ResultData resultData = await HttpManager.post(UserApi.wx_binding, {
//       'userId':UserManager.instance.user.info.id,
//       'code':code
//     });
//     GSDialog.of(context).dismiss(context);

//     _weChatLoginLoading = false;
//     if (!resultData.result) {
//       showError(resultData.msg);
//       return;
//     }
//     UserModel model = UserModel.fromJson(resultData.data);
//     if (model.code != HttpStatus.SUCCESS) {
//       showError(model.msg);
//       return;
//     }
//     UserManager.updateUser(model.data, getStore());
//     setState(() {});
//     showSuccess('绑定成功!');
//   }
// }
