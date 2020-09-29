import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';

class CropVideoPage extends StatefulWidget {
  final File file;
  CropVideoPage({Key key, @required this.file}) : super(key: key);

  @override
  _CropVideoPageState createState() => _CropVideoPageState();
}

class _CropVideoPageState extends State<CropVideoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF232323),
      appBar: CustomAppBar(
        appBackground: Color(0xFF232323),
        leading: RecookBackButton(white: true),
        actions: [
          Center(
            child: SizedBox(
              width: rSize(72),
              height: rSize(28),
              child: MaterialButton(
                child: Text('确定'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(rSize(14)),
                ),
                onPressed: () {},
                color: Color(0xFFFA3B3E),
              ),
            ),
          ),
          SizedBox(width: rSize(15)),
        ],
      ),
    );
  }
}
