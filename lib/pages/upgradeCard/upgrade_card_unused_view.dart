import 'package:flutter/material.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:recook/constants/header.dart';

class UpgradeUnusedView extends StatefulWidget {
  UpgradeUnusedView({Key key}) : super(key: key);

  @override
  _UpgradeUnusedViewState createState() => _UpgradeUnusedViewState();
}

class _UpgradeUnusedViewState extends State<UpgradeUnusedView> {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);
  _renderButton({
    String title,
    VoidCallback onTap,
  }) {
    return MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      shape: StadiumBorder(
        side: BorderSide(
          color: Colors.white,
        ),
      ),
      minWidth: 80.w,
      height: 33.w,
      onPressed: onTap,
      child: title.text.size(14.sp).white.make(),
    );
  }

  _renderGoldCard() {
    return Container(
      height: 193.w,
      padding: EdgeInsets.only(
        left: 16.w,
        top: 16.w,
        bottom: 6.w,
        right: 10.w,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              '黄金卡'.text.color(Color(0xFFDD2C4E)).size(18.sp).bold.make(),
              'Gold Card'.text.color(Color(0xFFDD2C4E)).size(10.sp).make(),
              Spacer(),
              '编号：IDJW23423'
                  .text
                  .color(Color(0xFFDD2C4E))
                  .size(16.sp)
                  .bold
                  .make(),
              '2020年4余额团队销售额达标赠送'
                  .text
                  .color(Color(0xFFDD2C4E))
                  .size(12.sp)
                  .make(),
            ],
          ).expand(),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _renderButton(title: '使用', onTap: () {}),
              16.hb,
              _renderButton(title: '赠送', onTap: () {}),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(R.ASSETS_USER_UPGRADE_GOLD_CARD_WEBP),
        ),
      ),
    );
  }

  _renderSilverCard() {
    return Container(
      height: 193.w,
      padding: EdgeInsets.only(
        left: 16.w,
        top: 16.w,
        bottom: 6.w,
        right: 10.w,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              '白银卡'.text.color(Color(0xFFDD2C4E)).size(18.sp).bold.make(),
              'Silver Card'.text.color(Color(0xFFDD2C4E)).size(10.sp).make(),
              Spacer(),
              '编号：IDJW23423'
                  .text
                  .color(Color(0xFFDD2C4E))
                  .size(16.sp)
                  .bold
                  .make(),
              '系统赠送'.text.color(Color(0xFFDD2C4E)).size(12.sp).make(),
            ],
          ).expand(),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _renderButton(title: '使用', onTap: () {}),
              16.hb,
              _renderButton(title: '赠送', onTap: () {}),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(R.ASSETS_USER_UPGRADE_SILVER_CARD_WEBP),
        ),
      ),
    );
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
        _refreshController.refreshCompleted();
      },
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 10.w,
        ),
        children: [
          _renderGoldCard(),
          10.hb,
          _renderSilverCard(),
        ],
      ),
    );
  }
}
