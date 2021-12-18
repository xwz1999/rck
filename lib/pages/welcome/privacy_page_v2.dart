import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/pages/agreements/agreements_markdown.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';

class PrivacyPageV2 extends StatefulWidget {
  PrivacyPageV2({Key key}) : super(key: key);

  @override
  _PrivacyPageV2State createState() => _PrivacyPageV2State();
}

class _PrivacyPageV2State extends State<PrivacyPageV2> {
  TextStyle get black => TextStyle(
        color: Color(0xFF333333),
      );
  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '左家右厨App用户使用协议及隐私政策',
      body: Markdown(
        styleSheet: MarkdownStyleSheet(
          h1: black,
          h2: black.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: rSP(18),
          ),
          h3: black,
          h4: black,
          p: black,
          codeblockDecoration: BoxDecoration(
            color: Colors.white,
          ),
          code: TextStyle(
            backgroundColor: Colors.white,
            color: Color(0xFF333333),
          ),
        ),
        data: AgreementsMD.privacy,
      ),
    );
  }
}
