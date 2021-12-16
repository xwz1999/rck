import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:camera/camera.dart';
// import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openinstall_flutter_plugin/openinstall_flutter_plugin.dart';
import 'package:package_info/package_info.dart';
import 'package:package_signature/package_signature.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:redux/redux.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tencent_live_fluttify/tencent_live_fluttify.dart';

import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/user_brief_info_model.dart';
import 'package:recook/models/user_model.dart';
import 'package:recook/pages/welcome/launch_widget.dart';
import 'package:recook/redux/openinstall_state.dart';
import 'package:recook/redux/recook_state.dart';
import 'package:recook/third_party/bugly_helper.dart';
import 'package:recook/utils/CommonLocalizationsDelegate.dart';
import 'package:recook/utils/storage/hive_store.dart';
import 'package:recook/utils/test.dart';
import 'constants/header.dart';
import 'utils/app_router.dart';

// import 'package:sharesdk_plugin/sharesdk_plugin.dart';

// List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //配合隐私政策整改，将一部分初始化转移到同意隐私政策以后

  //cameras = await availableCameras();

  // PackageInfo _packageInfo = await PackageInfo.fromPlatform();
  // AppConfig.versionNumber = _packageInfo.buildNumber;
  //初始化AMap
  // AmapLocation.instance.init(iosKey: 'e8a8057cfedcdcadcf4e8f2c7f8de982');

  //初始化腾讯im

  // TencentImPlugin.init(appid: '1400435566');

  AppConfig.initial(
    useEncrypt: false,
    // 网络请求加密功能
    // useEncrypt: true
  );



  bool inTest = Test.test();
  if (inTest) {
    return;
  }

  //持久化存储
  await Hive.initFlutter();
  await HiveStore.initBox();

  // 设置当前是否为测试环境
  const bool isDebug =
  const bool.fromEnvironment('ISDEBUG', defaultValue:  false);

  AppConfig.setDebug(isDebug);
  // WeChatUtils.initial();
  // MQManager.initial();
  // 奔溃界面修改!!!!
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
    print(flutterErrorDetails.toString());
    if (isDebug) return ErrorWidget(flutterErrorDetails.exception);
    return Material(
      color: Colors.white,
      child: Center(
        child: Text(
          "服务器繁忙，请稍后再试！",
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

  // const bool inProduction = const bool.fromEnvironment("dart.vm.product");

  if (!isDebug) {
    AppConfig.setDebug(isDebug);
    DPrint.printf("当前为release 模式");
    //return FlutterBugly.postCatchedException(() {
      runApp(MyApp(store));
    //});
  }
  DPrint.printf("当前为 debug 模式");
  //return FlutterBugly.postCatchedException(() {
    runApp(MyApp(store));
  //});
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
    //BuglyHelper.initialSDK();
    // checkSignature();

    // BuglyHelper.setUserInfo();
    // ShareSDKRegister register = ShareSDKRegister();
    // register.setupQQ("1109724223", "UGWklum7WWI03ll9");
    // SharesdkPlugin.regist(register);

    // HttpManager.post(LiveAPI.liveLicense, {}).then((resultData) {
    //   String key = resultData.data['data']['key'];
    //   String licenseURL = resultData.data['data']['licenseUrl'];
    //   //初始化腾讯直播
    //   TencentLive.instance.init(
    //     licenseUrl: licenseURL,
    //     licenseKey: key,
    //   );
    // });
  }

  //签名验证
  //----------
  //使用SHA256计算签名
  //仅验证Android 端的签名
  Future checkSignature() async {
    if (Platform.isAndroid) {
      Signature signature = await PackageSignature.signature;
      bool signPass =
          'kzOk4i5opDSCXXjbA9SSrws9a5fytdFFUsumV5DHz2o=' == signature.sha256;
      if (!signPass) {

        ReToast.raw(Text('请从官方渠道下载本应用,即将退出'));
        Future.delayed(Duration(milliseconds: 300), () {
          SystemNavigator.pop();
        });
      }
    }
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
          if (decode.containsKey("type")) {
            store.state.openinstall.type = decode['type'];
            store.state.openinstall.itemId = decode['itemId'];
            UserManager.instance.openInstallLive.value =
                !UserManager.instance.openInstallLive.value;
          }
        } catch (e) {}
      }
      store.state.openinstall.channelCode = data['channelCode'];
      // }
    });
  }

  final botToastBuilder = BotToastInit();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, //只能纵向
      DeviceOrientation.portraitDown,//只能纵向
    ]);
    return StoreProvider<RecookState>(
        store: store,
        child: StoreBuilder<RecookState>(builder: (context, store) {
          return OKToast(
            child: ScreenUtilInit(
              designSize: Size(750, 1334),
              builder: () => GestureDetector(
                onTap: (){
                  //只能响应点击非手势识别的组件
                  var currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
                child: GetMaterialApp(
                  builder: (context, child) {
                    return MediaQuery(
                      //设置文字大小不随系统设置改变
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: BotToastInit().call(context,child),
                    );
                  },
                  //builder:  BotToastInit(),
                  navigatorObservers: [BotToastNavigatorObserver()],
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    CommonLocalizationsDelegate(),
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
                  onGenerateRoute: onGenerateRoute,
                ),
              ),
            ),
          );
        }));
  }
}
