/*
 * ====================================================
 * package   : pages.home
 * author    : Created by nansi.
 * time      : 2019/5/8  9:57 AM 
 * remark    : 
 * ====================================================
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recook/widgets/refresh_widget.dart';

class SaleListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SaleListWidgetState();
  }
}

class _SaleListWidgetState extends State<SaleListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: RefreshWidget(
        onRefresh: () {

        },
        isInNest: true,
        body: ListView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  height: 50,
                  color: Colors.teal[(index + 1) * 100],
                  child: Text("${index}"),
                ),
              );
            }),
      ),
    );
  }
}
