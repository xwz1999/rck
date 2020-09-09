import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:oktoast/oktoast.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/user_brief_info_model.dart';
import 'package:recook/models/user_model.dart';
import 'package:recook/pages/welcome/launch_widget.dart';
import 'package:recook/redux/openinstall_state.dart';
import 'package:recook/redux/recook_state.dart';
import 'package:recook/third_party/bugly_helper.dart';
import 'package:recook/utils/test.dart';
import 'package:redux/redux.dart';

import 'constants/header.dart';
import 'utils/app_router.dart';

// import 'package:sharesdk_plugin/sharesdk_plugin.dart';

import 'package:openinstall_flutter_plugin/openinstall_flutter_plugin.dart';

void main() async {
  AppConfig.initial(
    useEncrypt: false
    /// 网络请求加密功能
    // useEncrypt: true
  );
  // 设置当前是否为测试环境
  bool isDebug = true;
  AppConfig.setDebug(isDebug);

  bool inTest = Test.test();
  if (inTest) {
    return;
  }
  // WeChatUtils.initial();
  // MQManager.initial();
  // 奔溃界面修改!!!!
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
    print(flutterErrorDetails.toString());
    return Center(
      child: Container(
        color: Colors.white,
        child: Text(
          "app不小心奔溃了!请重新打开app!",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  };

  final store = Store<RecookState>(appReducer,
      initialState: RecookState(
          user: User.empty(),
          themeData: AppThemes.themeDataMain,
          userBrief: UserBrief.empty(),
          openinstall: Openinstall.empty()));

  const bool inProduction = const bool.fromEnvironment("dart.vm.product");

  if (inProduction) {
    AppConfig.setDebug(isDebug);
    DPrint.printf("当前为release 模式");
    return FlutterBugly.postCatchedException(() {
      runApp(MyApp(store));
    });
  }
  DPrint.printf("当前为 debug 模式");
  return FlutterBugly.postCatchedException(() {
    runApp(MyApp(store));
  });
  runApp(MyApp(store));
}

class MyApp extends StatefulWidget {
  final Store<RecookState> store;
  MyApp(this.store);

  @override
  State<StatefulWidget> createState() {
    return MyAppState(store);
  }
}

class MyAppState extends State<MyApp> {
  //openinstall_flutter_plugin
  OpeninstallFlutterPlugin _openinstallFlutterPlugin;
  final Store<RecookState> store;
  MyAppState(this.store);

  @override
  void initState() {
    super.initState();
    initPlatformState();
    BuglyHelper.initialSDK();
    // BuglyHelper.setUserInfo();
    // ShareSDKRegister register = ShareSDKRegister();
    // register.setupQQ("1109724223", "UGWklum7WWI03ll9");
    // SharesdkPlugin.regist(register);
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    _openinstallFlutterPlugin = new OpeninstallFlutterPlugin();
    _openinstallFlutterPlugin.init(wakeupHandler);
    _openinstallFlutterPlugin.install(installHandler);
  }

  Future installHandler(Map<String, dynamic> data) async {
    setState(() {
      // if (AppConfig.debug) {
      // store.state.openinstall.bindData = "insdata";
      // store.state.openinstall.channelCode = "inscod";
      // }else{

      store.state.openinstall.bindData = data['bindData'];
      if (store.state.openinstall.bindData.length > 0) {
        var decode = json.decode(data['bindData']);
        store.state.openinstall.code = decode['code'];
      }
      store.state.openinstall.channelCode = data['channelCode'];
      // }
    });
  }

  Future wakeupHandler(Map<String, dynamic> data) async {
    setState(() {
      // if (AppConfig.debug) {
      //   store.state.openinstall.bindData = "insdata";
      //   store.state.openinstall.channelCode = "inscod";
      // }else{
      store.state.openinstall.date = data.toString();
      store.state.openinstall.bindData = data['bindData'];
      if (store.state.openinstall.bindData.length > 0) {
        try {
          Map decode = json.decode(data['bindData']);
          if (decode.containsKey("code")) {
            store.state.openinstall.code = decode['code'];
          }
          if (decode.containsKey("goodsid")) {
            store.state.openinstall.goodsid = decode['goodsid'];
            UserManager.instance.openInstallGoodsId.value =
                !UserManager.instance.openInstallGoodsId.value;
          }
        } catch (e) {}
      }
      store.state.openinstall.channelCode = data['channelCode'];
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<RecookState>(
        store: store,
        child: StoreBuilder<RecookState>(builder: (context, store) {
          return OKToast(
            child: MaterialApp(
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                // CommonLocalizationsDelegate(),
              ],
              supportedLocales: [
                const Locale('zh', 'CN'),
                const Locale('en', 'US'),
              ],
              title: 'Recook',
              debugShowCheckedModeBanner: false,
              // 设置这一属性即可
              checkerboardOffscreenLayers: false,
              // 使用了saveLayer的图形会显示为棋盘格式并随着页面刷新而闪烁
              checkerboardRasterCacheImages: false,
              // 做了缓存的静态图片在刷新页面时不会改变棋盘格的颜色；如果棋盘格颜色变了说明被重新缓存了，这是我们要避免的
              theme: store.state.themeData,
              home: LaunchWidget(),
              // home: WillPopScope(
              //   onWillPop: () async {
              //     AndroidBackTop.backDeskTop();  //设置为返回不退出app
              //     return false;  //一定要return false
              //   },
              //   child: LaunchWidget(),
              // ),
              // home: WelcomeWidget(),
              onGenerateRoute: onGenerateRoute,
            ),
          );
        }));
  }
}
