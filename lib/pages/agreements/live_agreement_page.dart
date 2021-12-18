import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/pages/agreements/agreements_markdown.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';

class LiveAgreementPage extends StatefulWidget {
  LiveAgreementPage({Key key}) : super(key: key);

  @override
  _LiveAgreementPageState createState() => _LiveAgreementPageState();
}

class _LiveAgreementPageState extends State<LiveAgreementPage> {
  TextStyle get black => TextStyle(
        color: Color(0xFF333333),
      );
  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '左家右厨直播服务申明',
      body: SingleChildScrollView(
        padding: EdgeInsets.all(rSize(15)),
        child: MarkdownBody(
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
          data: AgreementsMD.liveAgreement,
        ),
      ),
    );
  }
}
