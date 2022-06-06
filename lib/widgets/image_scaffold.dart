
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageScaffold extends StatelessWidget {
  ///沉浸式带背景的APPBar
  ///path未背景图的path
  final Widget? body;
  final Widget? appbar;
  final Color bodyColor;
  final Widget? bottomNavi;
  final FloatingActionButton? fab;
  final bool extendBody;
  final String path;

  final SystemUiOverlayStyle? systemStyle;

  const ImageScaffold({
    Key? key,
    this.body,
    this.appbar,
    this.bodyColor = const Color(0xFFF9F9F9),
    this.bottomNavi,
    this.fab,
    this.systemStyle ,
    this.extendBody = false,
    required this.path,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemStyle!,
      child: Scaffold(
        backgroundColor: bodyColor,
        extendBodyBehindAppBar: extendBody,
        extendBody: extendBody,
        body: Stack(
          children: [
            Positioned(
                child: Image.asset(
              path ,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            )),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                appbar ?? const SizedBox(),
                body ?? const SizedBox(),
              ],
            )
          ],
        ),
        bottomNavigationBar: bottomNavi,
        floatingActionButton: fab,
      ),
    );
  }
}
