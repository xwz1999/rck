import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:recook/constants/header.dart';

class UpgradeUsedView extends StatefulWidget {
  UpgradeUsedView({Key key}) : super(key: key);

  @override
  _UpgradeUsedViewState createState() => _UpgradeUsedViewState();
}

class _UpgradeUsedViewState extends State<UpgradeUsedView> {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);

  _renderItem(String title, String subTitle) {
    return Row(
      children: [
        title.text.size(14.sp).black.make().w(72.w),
        subTitle.text.size(14.sp).black.make(),
      ],
    );
  }

  _renderGoldCard({
    String code,
    DateTime useDate,
    DateTime sendDate,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5.w),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          _renderItem('卡类型:', '黄金卡'),
          _renderItem('编号:', code ?? ''),
          _renderItem(
            '使用时间:',
            DateUtil.formatDate(useDate, format: 'yyyy-MM-dd HH:mm'),
          ),
          _renderItem(
            '发放时间:',
            DateUtil.formatDate(sendDate, format: 'yyyy-MM-dd HH:mm'),
          ),
        ].sepWidget(separate: 4.hb),
      ).p(10.w),
    );
  }

  _renderSilverCard({
    String code,
    DateTime giveDate,
    String givePerson,
    String giveTel,
    DateTime sendDate,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5.w),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          _renderItem('卡类型:', '白银卡'),
          _renderItem('编号:', code ?? ''),
          _renderItem(
            '赠送时间:',
            DateUtil.formatDate(giveDate, format: 'yyyy-MM-dd HH:mm'),
          ),
          _renderItem('赠送对象:', '$givePerson $giveTel'),
          _renderItem(
            '发放时间:',
            DateUtil.formatDate(sendDate, format: 'yyyy-MM-dd HH:mm'),
          ),
        ].sepWidget(separate: 4.hb),
      ).p(10.w),
    );
  }

  ///// 0=未使用 1=已使用
  Future<List> _fetchList(int index, int type) async {
    ResultData resultData = await HttpManager.post(APIV2.userAPI.userCard, {
      'page': index,
      'type': type,
    });
    if (resultData == null ||
        resultData.data == null ||
        resultData.data['data'] == null ||
        resultData.data['data']['list'] == null) return [];
    //TODO
    return [];
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshWidget(
      controller: _refreshController,
      onRefresh: () async {
        print((await _fetchList(1, 0)));
        _refreshController.refreshCompleted();
      },
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
        children: [
          _renderGoldCard(
            code: 'ADWADW',
            useDate: DateTime.now(),
            sendDate: DateTime.now(),
          ),
          10.hb,
          _renderSilverCard(
            code: 'ADWADW',
            giveDate: DateTime.now(),
            givePerson: 'TESTMAN',
            giveTel: '11889123',
            sendDate: DateTime.now(),
          ),
        ],
      ),
    );
  }
}
