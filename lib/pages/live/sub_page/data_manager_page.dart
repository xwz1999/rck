import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/live/sub_page/data_manager/data_manager_all_view.dart';
import 'package:recook/pages/live/sub_page/data_manager/data_manager_live_view.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/recook_indicator.dart';

class DataManagerPage extends StatefulWidget {
  DataManagerPage({Key key}) : super(key: key);

  @override
  _DataManagerPageState createState() => _DataManagerPageState();
}

class _DataManagerPageState extends State<DataManagerPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF9F9FB),
        appBar: AppBar(
          backgroundColor: Color(0xFFF9F9FB),
          elevation: 0,
          leading: SizedBox(
            width: rSize(50),
            child: RecookBackButton(),
          ),
          brightness: Brightness.light,
          actions: [SizedBox(width: rSize(50))],
          title: TabBar(
            controller: _tabController,
            indicator: RecookIndicator(
              borderSide: BorderSide(
                color: Color(0xFFDB2D2D),
                width: rSize(3),
              ),
            ),
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Color(0xFF333333),
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal,
            ),
            unselectedLabelColor: Color(0xFF333333).withOpacity(0.5),
            tabs: [
              Tab(text: '数据总览'),
              Tab(text: '场次数据'),
            ],
          ),
          centerTitle: true,
          titleSpacing: 0,
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            DataManagerAllView(),
            DatamanagerLiveView(),
          ],
        ));
  }
}
