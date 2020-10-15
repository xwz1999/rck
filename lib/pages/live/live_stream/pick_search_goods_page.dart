import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/recook_back_button.dart';

class PickSearchGoodsPage extends StatefulWidget {
  PickSearchGoodsPage({Key key}) : super(key: key);

  @override
  _PickSearchGoodsPageState createState() => _PickSearchGoodsPageState();
}

class _PickSearchGoodsPageState extends State<PickSearchGoodsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: RecookBackButton(),
        title: TextField(
          decoration: InputDecoration(
            fillColor: Colors.black.withOpacity(0.2),
            filled: true,
            isDense: true,
            contentPadding: EdgeInsets.all(rSize(15)),
            border: OutlineInputBorder(),
          ),
        ),
        centerTitle: true,
        titleSpacing: 0,
      ),
    );
  }
}
