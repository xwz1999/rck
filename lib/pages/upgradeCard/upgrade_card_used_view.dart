import 'package:flutter/material.dart';

import 'package:common_utils/common_utils.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/pages/upgradeCard/function/user_card_function.dart';
import 'package:recook/pages/upgradeCard/model/user_card_%20model.dart';
import 'package:recook/widgets/refresh_widget.dart';

class UpgradeUsedView extends StatefulWidget {
  UpgradeUsedView({Key key}) : super(key: key);

  @override
  _UpgradeUsedViewState createState() => _UpgradeUsedViewState();
}

class _UpgradeUsedViewState extends State<UpgradeUsedView> {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);

  List<UserCardModel> _cards = [];

  int _page = 1;

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
        _cards = [];
        _page = 1;
        _cards = await UserCardFunction.fetchList(_page, 1);
        _refreshController.refreshCompleted();
        setState(() {});
      },
      onLoadMore: () async {
        _page++;
        _cards.addAll(await UserCardFunction.fetchList(_page, 1));
        _refreshController.loadComplete();
        setState(() {});
      },
      body: ListView.separated(
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final item = _cards[index];
          return _userCard(
            type: item.type,
            status: item.status,
            code: item.code,
            giveDate: DateTime.fromMillisecondsSinceEpoch(item.useAt * 1000),
            givePerson: item.giveUserNickname,
            sendDate:
                DateTime.fromMillisecondsSinceEpoch(item.createdAt * 1000),
            giveTel: '',
          );
        },
        separatorBuilder: (_, __) => 10.hb,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
      ),
    );
  }
}

class _userCard extends StatelessWidget {
  final int type;
  final int status;
  final String code;
  final DateTime giveDate;
  final String givePerson;
  final String giveTel;
  final DateTime sendDate;
  const _userCard({
    Key key,
    @required this.type,
    @required this.status,
    @required this.code,
    @required this.giveDate,
    @required this.givePerson,
    @required this.giveTel,
    @required this.sendDate,
  }) : super(key: key);

  _renderItem(String title, String subTitle) {
    return Row(
      children: [
        title.text.size(14.sp).black.make().w(72.w),
        subTitle.text.size(14.sp).black.make(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String typeValue = '';
    if (type == 1) typeValue = '黄金卡';
    if (type == 2) typeValue = '白银卡';
    bool used = status != 2;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5.w),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          _renderItem('卡类型:', typeValue),
          _renderItem('编号:', code ?? ''),
          _renderItem(
            used ? '使用时间' : '赠送时间:',
            DateUtil.formatDate(giveDate, format: 'yyyy-MM-dd HH:mm'),
          ),
          if (used) _renderItem('赠送对象:', '$givePerson $giveTel'),
          _renderItem(
            '发放时间:',
            DateUtil.formatDate(sendDate, format: 'yyyy-MM-dd HH:mm'),
          ),
        ].sepWidget(separate: 4.hb),
      ).p(10.w),
    );
  }
}
