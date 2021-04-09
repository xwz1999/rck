import 'dart:async';

import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';

class LiveBuyingWidget extends StatefulWidget {
  LiveBuyingWidget({Key key}) : super(key: key);

  @override
  LiveBuyingWidgetState createState() => LiveBuyingWidgetState();
}

class LiveBuyingWidgetState extends State<LiveBuyingWidget> {
  bool showEmpty = true;
  String key = '';
  Timer _timer;
  updateChild(String value) {
    showEmpty = false;
    key = value;
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: 5000), () {
      setState(() {
        showEmpty = true;
      });
    });
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: showEmpty
          ? SizedBox(width: 40, key: ValueKey('default'))
          : Align(
              key: ValueKey(key),
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: rSize(10)),
                child: Text(key),
                decoration: BoxDecoration(
                  color: Color(0xFFF4BC22),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
    );
  }
}
