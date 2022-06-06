import 'package:flutter/material.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class UserOldHistoryBenefitPage extends StatefulWidget {
  UserOldHistoryBenefitPage({Key? key}) : super(key: key);

  @override
  _UserOldHistoryBenefitPageState createState() =>
      _UserOldHistoryBenefitPageState();
}

class _UserOldHistoryBenefitPageState extends State<UserOldHistoryBenefitPage> {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);

  double? _total = 0.0;
  double? _purchase = 0.0;
  double? _guide = 0.0;
  double? _team = 0.0;

  _renderColumn(String title, String subTitle) {
    return Column(
      children: [
        title.text.size(14.rsp).black.make(),
        2.hb,
        subTitle.text.size(14.rsp).black.make(),
      ],
    ).expand();
  }

  _renderDivider() {
    return Container(
      height: 22.rw,
      width: 1.rw,
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
            offset: Offset(0, 2.rw),
            blurRadius: 6.rw,
          ),
        ],
        borderRadius: BorderRadius.circular(4.rw),
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
            padding: EdgeInsets.all(10.rw),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    '历史累计总收益(瑞币)'.text.black.make(),
                    8.hb,
                    (_total!.toStringAsFixed(2))
                        .text
                        .black
                        .size(34.rsp)
                        .make(),
                  ],
                ).expand(),
                Image.asset(
                  UserLevelTool.currentMedalImagePath(),
                  width: 48.rw,
                  height: 48.rw,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.rw),
            child: Row(
              children: [
                _renderColumn('自购收益', _purchase!.toStringAsFixed(2)),
                _renderDivider(),
                _renderColumn('导购收益', _guide!.toStringAsFixed(2) ),
                _renderDivider(),
                _renderColumn('品牌补贴', _team!.toStringAsFixed(2)),
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
          '历史累计总收益',
          style: TextStyle(
            fontSize: 18.rsp,
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshWidget(
        controller: _refreshController,
        onRefresh: () async {
          ResultData result =
              await HttpManager.post(APIV2.userAPI.oldIncome, {});
          if (result.data != null &&
              result.data['data'] != null) {
            _total = result.data['data']['total'] + .0;
            _purchase = result.data['data']['purchase'] + .0;
            _guide = result.data['data']['guide'] + .0;
            _team = result.data['data']['team'] + .0;
            setState(() {});
          }
          _refreshController.refreshCompleted();
        },
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 36.rw, vertical: 20.rw),
          children: [
            _buildCard(),
          ],
        ),
      ),
    );
  }
}
