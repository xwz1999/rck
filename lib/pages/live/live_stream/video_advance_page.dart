import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recook/widgets/recook_back_button.dart';

class VideoAdvancePage extends StatefulWidget {
  final File file;
  VideoAdvancePage({Key key, @required this.file}) : super(key: key);

  @override
  _VideoAdvancePageState createState() => _VideoAdvancePageState();
}

class _VideoAdvancePageState extends State<VideoAdvancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF232323),
      appBar: AppBar(
        leading: RecookBackButton(white: true),
        backgroundColor: Color(0xFF232323),
        actions: [
          MaterialButton(
            // color: ,
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Placeholder(),
          ),
        ],
      ),
    );
  }
}
