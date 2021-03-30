import 'package:flutter/material.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:recook/constants/header.dart';
import 'package:velocity_x/velocity_x.dart';

class UpgradeUseResultPage extends StatelessWidget {
  final bool result;
  final String content;

  const UpgradeUseResultPage(
      {Key key, @required this.result, @required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '权益卡',
      whiteBg: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          70.hb,
          Image.asset(
            result ? R.ASSETS_RESULT_SUCCESS_PNG : R.ASSETS_RESULT_FAIL_PNG,
            width: 68.w,
            height: 68.w,
          ),
          10.hb,
          content.text.size(18.sp).black.make().centered(),
        ],
      ),
    );
  }
}
