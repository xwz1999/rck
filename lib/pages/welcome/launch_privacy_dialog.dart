import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/webView.dart';

Future<bool?> launchPrivacyDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => _PrivacyDialog(),
    barrierDismissible: false,
  );
}

Future launchPrivacySecondDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => _PrivacySecondDialog(),
    barrierDismissible: false,
  );
}

class _PrivacyDialog extends StatefulWidget {
  _PrivacyDialog({Key? key}) : super(key: key);

  @override
  __PrivacyDialogState createState() => __PrivacyDialogState();
}

class __PrivacyDialogState extends State<_PrivacyDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: rSize(400),
        margin: EdgeInsets.symmetric(horizontal: rSize(36)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(rSize(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(rSize(18)),
                ),
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: rSize(16)),
                  children: [
                    rHBox(26),
                    Center(
                      child: Text(
                        '感谢您下载瑞库客',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: rSP(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    rHBox(14),
                    Text(
                      '''请您了解，您需要注册成为瑞库客用户后方可使用本软件的网上购物功能，在您注册前您仍可以浏览本软件中的商品和服务内容。请您充分了解在使用本软件过程中我们可能收集、使用、或共享您个人信息的情形，希望您着重关注：
为了完成您订单的支付、配送或售后，我们可能会收集使用您订单中的信息，相关必要信息可能需要共享给商家、支付、物流等三方合作方。
                        ''',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(12),
                      ),
                    ),
                    rHBox(20),
                    GestureDetector(
                      onTap: () {
                        AppRouter.push(
                          context,
                          RouteName.WEB_VIEW_PAGE,
                          arguments: WebViewPage.setArguments(
                              url: WebApi.privacy,
                              title: "用户使用协议",
                              hideBar: true),
                        );
                        //CRoute.push(context, PrivacyPageV2());
                      },
                      child: Text.rich(TextSpan(
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: rSP(10),
                        ),
                        children: [
                          TextSpan(
                            text: '相关您个人信息的相关问题，详见',
                          ),
                          TextSpan(text: "您已阅读并同意", children: [
                            new TextSpan(
                                text: '《用户服务协议》',
                                style: new TextStyle(color: Colors.red),
                                recognizer: _recognizer(context, 2)),
                            TextSpan(
                              text: "和",
                            ),
                            new TextSpan(
                                text: '《用户隐私政策》',
                                style: new TextStyle(color: Colors.red),
                                recognizer: _recognizer(context, 1)),
                          ]),
                          TextSpan(
                            text:
                                '全文，请您认真阅读并充分理解，如您同意我们的政策内容，请点击同意并继续使用本软件。我们会不断完善技术和安全管理，保护您的个人信息。',
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: rSize(20)),
              height: rSize(36),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFA2F19),
                    Color(0xFFF95F19),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(rSize(18)),
              ),
              child: MaterialButton(
                shape: StadiumBorder(),
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  '同 意',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: rSP(14),
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                '不同意',
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: rSP(14),
                ),
              ),
            ),
            SizedBox(height: rSize(10)),
          ],
        ),
      ),
    );
  }
}

_recognizer(context, int type) {
  final TapGestureRecognizer recognizer = new TapGestureRecognizer();
  recognizer.onTap = () {
    print("点击协议了");
    AppRouter.push(
      context,
      RouteName.WEB_VIEW_PAGE,
      arguments: WebViewPage.setArguments(
          url: type == 1 ? WebApi.privacy : WebApi.agreement,
          title: type == 1 ? "用户隐私政策" : "用户服务协议",
          hideBar: true),
    );
    //CRoute.push(context, PrivacyPageV2());
  };
  return recognizer;
}

class _PrivacySecondDialog extends StatelessWidget {
  const _PrivacySecondDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rSize(16)),
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(horizontal: rSize(36)),
        child: Material(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: rSize(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                rHBox(26),
                Center(
                  child: Text(
                    '我们将充分尊重并保护您的隐私，\n请您放心',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: rSP(16),
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                rHBox(20),
                GestureDetector(
                  onTap: () {
                    AppRouter.push(
                      context,
                      RouteName.WEB_VIEW_PAGE,
                      arguments: WebViewPage.setArguments(
                          url: WebApi.privacy, title: "用户使用协议", hideBar: true),
                    );
                    //CRoute.push(context, PrivacyPageV2());
                  },
                  child: Text.rich(TextSpan(
                    children: [
                      TextSpan(text: '您可再次查看'),
                      new TextSpan(
                          text: '《用户服务协议》',
                          style: TextStyle(
                            color: Color(0xFFFD3212),
                            fontSize: rSP(14),
                          ),
                          recognizer: _recognizer(context, 2)),
                      TextSpan(
                        text: "和",
                      ),
                      new TextSpan(
                          text: '《用户隐私政策》',
                          style: TextStyle(
                            color: Color(0xFFFD3212),
                            fontSize: rSP(14),
                          ),
                          recognizer: _recognizer(context, 1)),
                      TextSpan(text: '全文。如您同意我们的政策内容后，您可继续使用瑞库客'),
                    ],
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: rSP(14),
                    ),
                  )),
                ),
                rHBox(26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      child: Text(
                        '不同意',
                        style: TextStyle(
                          color: Color(0xFFFD3212),
                          fontSize: rSP(14),
                        ),
                      ),
                      height: rSize(30),
                      shape: StadiumBorder(
                          side: BorderSide(color: Color(0xFFFD3212))),
                      minWidth: rSize(105),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    MaterialButton(
                      child: Text(
                        '同意',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: rSP(14),
                        ),
                      ),
                      minWidth: rSize(105),
                      height: rSize(30),
                      color: Color(0xFFFD3212),
                      shape: StadiumBorder(),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              ],
            ),
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }
}
