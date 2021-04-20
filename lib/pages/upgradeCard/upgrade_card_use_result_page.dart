import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';

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
            width: 68.rw,
            height: 68.rw,
          ),
          10.hb,
          content.text.size(18.rsp).black.make().centered(),
        ],
      ),
    );
  }
}
