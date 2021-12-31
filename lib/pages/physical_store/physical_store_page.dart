/*
 * ====================================================
 * package   : pages.physical_store
 * author    : Created by nansi.
 * time      : 2019/5/13  2:21 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/pages/physical_store/items/physical_store_item.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';

class PhysicalStorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PhysicalStorePageState();
  }
}

class _PhysicalStorePageState extends State<PhysicalStorePage> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("--------- PhysicalStorePage");

    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(title: "实体店", themeData: AppThemes.themeDataGrey.appBarTheme,),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (_, index) {
            return PhysicalStoreItem();
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
