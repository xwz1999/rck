import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class UserHistoryBenefitPage extends StatefulWidget {
  UserHistoryBenefitPage({Key key}) : super(key: key);

  @override
  _UserHistoryBenefitPageState createState() => _UserHistoryBenefitPageState();
}

class _UserHistoryBenefitPageState extends State<UserHistoryBenefitPage> {
  GSRefreshController _refreshController = GSRefreshController();
  _renderColumn(String title, String subTitle) {
    return Column(
      children: [
        title.text.size(14.sp).black.make(),
        2.hb,
        subTitle.text.size(14.sp).black.make(),
      ],
    ).expand();
  }

  _renderDivider() {
    return Container(
      height: 22.w,
      width: 1.w,
      color: Color(0xFF979797),
    );
  }

  _buildCard() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFA6A6AD).withOpacity(0.41),
            offset: Offset(0, 2.w),
            blurRadius: 6.w,
          ),
        ],
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(UserLevelTool.currentCardImagePath()),
              ),
            ),
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    '累计总收益(瑞币)'.text.black.make(),
                    8.hb,
                    '10000.00'.text.black.size(34.sp).make(),
                  ],
                ).expand(),
                Image.asset(
                  UserLevelTool.currentMedalImagePath(),
                  width: 48.w,
                  height: 48.w,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.w),
            child: Row(
              children: [
                _renderColumn('自购收益', '1000.00'),
                _renderDivider(),
                _renderColumn('导购收益', '1000.00'),
                _renderDivider(),
                _renderColumn('店铺补贴', '1000.00'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RecookBackButton(white: true),
        backgroundColor: Color(0xFF16182B),
        centerTitle: true,
        elevation: 0,
        title: Text(
          '累计总收益',
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshWidget(
        controller: _refreshController,
        onRefresh: () async {
          _refreshController.refreshCompleted();
        },
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.w),
          children: [
            _buildCard(),
          ],
        ),
      ),
    );
  }
}
