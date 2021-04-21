import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/widget/modify_detail_app_bar.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';

class WebViewPage extends StatefulWidget {
  final Map arguments;
  const WebViewPage({Key key, this.arguments});
  static setArguments({
    String url,
    String title,
    bool hideBar: false,
    AppBarTheme appBarTheme = const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        color: AppColor.themeColor,
        textTheme: TextTheme(
            title: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500))),
  }) {
    return {
      "url": url,
      "title": title,
      'hideBar': hideBar,
      "appBarTheme": appBarTheme
    };
  }

  @override
  State<WebViewPage> createState() {
    return _WebViewState();
  }
}

class _WebViewState extends BaseStoreState<WebViewPage> {
  bool _isLoading = true;
  AppBarController _appBarController;
  @override
  void initState() {
    super.initState();
    _appBarController = AppBarController();
    _appBarController.scale.value = 1;
  }

  @override
  void dispose() {
    super.dispose();
    _appBarController?.dispose();
  }

  JavascriptChannel _alertJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'recook',
        onMessageReceived: (JavascriptMessage message) {
          if (!TextUtils.isEmpty(message.message)) {
            Map map = jsonDecode(message.message);
            //{"method":"method_name","data":{"goods_id":10}}
            if (map.containsKey("method") && map["method"] == "detail") {
              if (map.containsKey("data")) {
                Map subMap = map["data"];
                if (subMap.containsKey("goods_id") &&
                    subMap["goods_id"] != null) {
                  //跳转详情页面
                  AppRouter.push(context, RouteName.COMMODITY_PAGE,
                      arguments:
                          CommodityDetailPage.setArguments(subMap["goods_id"]));
                }
              }
            }
          }
        });
  }

  @override
  // Widget build(BuildContext context) {
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: widget.arguments['hideBar']
          ? null
          : CustomAppBar(
              title: Text(widget.arguments['title']),
              themeData: widget.arguments['appBarTheme']),
      // :AppBar(
      //   title: Text(widget.arguments['title']),
      // ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: <Widget>[
            WebView(
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: <JavascriptChannel>[
                _alertJavascriptChannel(context),
              ].toSet(),
              initialUrl: widget.arguments["url"],
              onWebViewCreated: (WebViewController web) {
                web.canGoBack().then((res) {
                  print(res); // 是否能返回上一级
                });
                web.currentUrl().then((url) {
                  print(url); // 返回当前url
                });
                web.canGoForward().then((res) {
                  print(res); //是否能前进
                });
              },
              onPageFinished: (String value) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
            _loading(),
            !widget.arguments['hideBar']
                ? Container()
                : Positioned(
                    top: ScreenUtil().statusBarHeight,
                    left: rSize(10),
                    width: rSize(30),
                    height: rSize(30),
                    child: CustomImageButton(
                      icon: Icon(
                        AppIcons.icon_back,
                        size: 16 * 2.sp,
                        color: Colors.white,
                      ),
                      buttonSize: rSize(30),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      backgroundColor: Color.fromARGB(100, 0, 0, 0),
                      onPressed: () {
                        Navigator.maybePop(context);
                      },
                    ),
                    // child: Container(),
                  ),
          ],
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(widget.arguments["title"]),
    //   ),
    //   body: Stack(
    //     children: <Widget>[
    //       new WebView(
    //         javascriptMode: JavascriptMode.unrestricted,
    //         javascriptChannels: <JavascriptChannel>[
    //           _alertJavascriptChannel(context),
    //           ].toSet(),
    //         initialUrl: widget.arguments["url"],
    //         onWebViewCreated: (WebViewController web) {
    //          web.canGoBack().then((res){
    //            print(res); // 是否能返回上一级
    //          });
    //          web.currentUrl().then((url){
    //            print(url);// 返回当前url
    //          });
    //          web.canGoForward().then((res){
    //            print(res); //是否能前进
    //          });
    //         },
    //         onPageFinished: (String value){
    //           setState(() {
    //             _isLoading = false;
    //           });
    //         },
    //       ),
    //       _loading()
    //     ],
    //   ),
    // );
  }

  _loading() {
    return _isLoading == true
        ? Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(getCurrentThemeColor()),
                strokeWidth: 1.0,
              ),
            ),
          )
        : Text('');
  }
}
