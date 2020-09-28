import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/pages/user/review/already_review_page.dart';
import 'package:recook/pages/user/review/need_review_page.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/recook_indicator.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage({Key key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int waitReviewAmount = 0;
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
      backgroundColor: AppColor.frenchColor,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: RecookBackButton(),
        centerTitle: true,
        title: Text(
          '我的评价',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              rSize(90),
              0,
              rSize(90),
              rSize(4),
            ),
            child: TabBar(
              controller: _tabController,
              labelPadding: EdgeInsets.zero,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.red,
              labelColor: Color(0xFF333333),
              unselectedLabelColor: Color(0xFF666666),
              indicator: RecookIndicator(
                borderSide: BorderSide(
                  width: rSize(3),
                  color: Color(0xFFDB2D2D),
                ),
              ),
              tabs: [
                Tab(
                    text:
                        '待评价${waitReviewAmount == 0 ? '' : '(' + waitReviewAmount.toString() + ')'}'),
                Tab(text: '已评价'),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(rSize(44)),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NeedReviewPage(
            updateTabBar: updateTabBar,
          ),
          AlreadyReviewPage(),
        ],
      ),
    );
  }

  updateTabBar(count) {
    waitReviewAmount = count;
    setState(() {});
  }
}
