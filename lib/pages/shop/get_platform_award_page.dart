import 'package:flutter/material.dart';
import 'package:jingyaoyun/const/resource.dart';
import 'package:jingyaoyun/widgets/recook/recook_scaffold.dart';

class GetPlatformAwardPage extends StatelessWidget {
  const GetPlatformAwardPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '获取平台奖励',
      body: SingleChildScrollView(
        child: Image.asset(R.ASSETS_USER_PLATFORM_AWARD_WEBP),
      ),
    );
  }
}
