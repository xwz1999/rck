
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jingyaoyun/models/user_brief_info_model.dart';
import 'package:jingyaoyun/models/user_model.dart';
import 'package:jingyaoyun/pages/welcome/launch_widget.dart';
import 'package:jingyaoyun/redux/openinstall_state.dart';
import 'package:jingyaoyun/redux/recook_state.dart';
import 'package:jingyaoyun/utils/CommonLocalizationsDelegate.dart';
import 'package:jingyaoyun/utils/storage/hive_store.dart';
import 'package:jingyaoyun/utils/test.dart';
import 'package:oktoast/oktoast.dart';
import 'package:redux/redux.dart';

import 'constants/header.dart';
import 'utils/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  const bool.fromEnvironment('ISDEBUG', defaultValue:  true);

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
  }else{
    DPrint.printf("当前为 debug 模式");
    runApp(MyApp(store));
  }
  //return FlutterBugly.postCatchedException(() {

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

  final Store<RecookState> store;
  MyAppState(this.store);

  @override
  void initState() {
    super.initState();

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
                  title: '左家右厨',
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
