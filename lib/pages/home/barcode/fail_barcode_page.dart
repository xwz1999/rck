import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/utils/app_router.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';

class FailBarcodePage extends StatefulWidget {
  final Map arguments;
  const FailBarcodePage({Key key, this.arguments}) : super(key: key);

  static setArguments(String code, String message) {
    return {"message": message, "code": code};
  }

  @override
  State<StatefulWidget> createState() {
    return _FailBarcodePageState();
  }
}

class _FailBarcodePageState extends BaseStoreState<FailBarcodePage> {
  String code;
  String message;
  @override
  void initState() {
    super.initState();
    if (widget.arguments != null) {
      code = widget.arguments["code"];
      message = widget.arguments["message"];
    }
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "识别失败",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        appBackground: Colors.white,
        elevation: 0,
      ),
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    double width = MediaQuery.of(context).size.width;
    Color buttonColor = Color(0xffE98787);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: width,
            padding: EdgeInsets.only(left: 30, top: 20),
            child: Text(
              message == null ? "商品未录入" : message,
              style: TextStyle(color: Colors.black, fontSize: 22 * 2.sp),
            ),
          ),
          _codeWidget(),
          Container(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
              top: 100,
            ),
            child: CustomImageButton(
              height: 36 * 2.h,
              backgroundColor: AppColor.themeColor,
              title: "重新扫描",
              color: Colors.white,
              fontSize: 16,
              onPressed: () {
                AppRouter.pushAndReplaced(context, RouteName.BARCODE_SCAN);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
              top: 20,
            ),
            child: CustomImageButton(
              height: 36 * 2.h,
              title: "返回首页",
              color: buttonColor,
              border: Border.all(
                color: buttonColor,
              ),
              fontSize: 16,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  _codeWidget() {
    return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  // height: 60,
                  alignment: Alignment.center,
                  child: Text(
                    "扫码结果",
                    style: TextStyle(color: Colors.black, fontSize: 16 * 2.sp),
                  ),
                ),
                Container(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    height: 60,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      code,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 15 * 2.sp),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 1,
              color: AppColor.frenchColor,
            )
          ],
        ));
  }
}
