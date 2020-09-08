import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/utils/app_router.dart';
import 'package:recook/widgets/custom_app_bar.dart';

class VerifyResultPage extends StatefulWidget {
  final Map arguments;
  VerifyResultPage({Key key, this.arguments}) : super(key: key);
  static setArgument(bool isSuccess) {
    return {
      'isSuccess': isSuccess,
    };
  }

  @override
  _VerifyResultPageState createState() => _VerifyResultPageState();
}

class _VerifyResultPageState extends BaseStoreState<VerifyResultPage> {
  bool _isSuccess = false;
  bool _isCashWithdraw = false;
  @override
  void initState() {
    super.initState();
    _isSuccess = widget.arguments["isSuccess"];
    _isCashWithdraw = widget.arguments['isCashWithdraw']??false;
    if (_isCashWithdraw && _isSuccess) {
      Future.delayed(Duration(milliseconds: 2000), () {
        AppRouter.pushAndReplaced(
          context,
          RouteName.USER_CASH_WITHDRAW_PAGE,
          arguments: {'amount': getStore().state.userBrief.balance.toDouble()},
        );
      });
    }
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        background: AppColor.frenchColor,
        themeData: AppThemes.themeDataGrey.appBarTheme,
        title: "认证结果",
        elevation: 0,
      ),
      body: _isSuccess ? _successBodyWidget() : _faildBodyWidget(),
    );
  }

  _successBodyWidget() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 120),
            width: double.infinity, height: 68,
            child: Image.asset(
              "assets/result_success.png",
              width: 68,
              height: 68,
            ),
            // child: Icon(Icons.check, color: Color(0xff12b631), size: 68,),
          ),
          Container(
            margin: EdgeInsets.only(top: 60),
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              '恭喜你,认证成功!',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  _faildBodyWidget() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 120),
            width: double.infinity, height: 68,
            child: Image.asset(
              "assets/result_fail.png",
              width: 68,
              height: 68,
            ),
            // child: Icon(Icons.close, color: Color(0xffE30606), size: 68,),
          ),
          Container(
              margin: EdgeInsets.only(top: 60),
              width: double.infinity,
              alignment: Alignment.center,
              child: ExtendedText.rich(
                TextSpan(style: TextStyle(fontSize: 18), children: [
                  WidgetSpan(
                      child: Text("认证失败! 请",
                          style: TextStyle(color: Colors.black, fontSize: 18))),
                  WidgetSpan(
                    child: GestureDetector(
                      child: Text("重新认证",
                          style: TextStyle(
                              color: Color(0xffE30606), fontSize: 18)),
                      onTap: () {
                        AppRouter.pushAndReplaced(
                            context, RouteName.USER_VERIFY,
                            arguments: {'isCashWithdraw': _isCashWithdraw});
                      },
                    ),
                  ),
                ]),
              )),
        ],
      ),
    );
  }
}
