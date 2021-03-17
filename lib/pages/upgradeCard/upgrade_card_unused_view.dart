import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/pages/upgradeCard/upgrade_card_use_result_page.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/progress/re_toast.dart';
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
              _renderButton(
                  title: '使用',
                  onTap: () async {
                    DateTime now = DateTime.now();
                    DateTime nextMonth = DateTime(now.year, now.month + 1);

                    bool result = await _openUseCardDialog(
                      confirmTitle: '使用黄金卡',
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          '黄金卡使用后将于${nextMonth.month}月1日考核时生效'
                              .text
                              .black
                              .size(15.sp)
                              .make(),
                          '您使用了黄金卡，将于下月1日生效，若店铺考核未达到黄金店铺考核标准，则消耗一张黄金卡成为黄金店铺，享受黄金店铺权益；若店铺考核达到黄金店铺标准，则黄金卡将返还至您的卡包。'
                              .text
                              .color(Color(0xFFDE180C))
                              .size(15.sp)
                              .make(),
                        ],
                      ),
                    );
                    if (result) {
                      final cancel = ReToast.loading(text: '使用中');
                      //TODO 请求使用权益卡接口
                      await Future.delayed(Duration(seconds: 2));
                      cancel();
                      await Get.to(() => UpgradeUseResultPage(
                            result: true,
                            content: '恭喜',
                          ));
                      _refreshController.requestRefresh();
                    }
                  }),
              16.hb,
              _renderButton(title: '赠送', onTap: () async {}),
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
              _renderButton(
                  title: '使用',
                  onTap: () async {
                    DateTime now = DateTime.now();
                    DateTime nextMonth = DateTime(now.year, now.month + 1);

                    bool result = await _openUseCardDialog(
                      confirmTitle: '使用白银卡',
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          '白银卡使用后将于${nextMonth.month}月1日考核时生效'
                              .text
                              .black
                              .size(15.sp)
                              .make(),
                          '您使用了白银卡，将于下月1日生效，若店铺考核未达到白银店铺考核标准，则消耗一张白银卡成为白银店铺，享受白银店铺权益；若店铺考核达到白银店铺标准，则白银卡将返还至您的卡包。'
                              .text
                              .color(Color(0xFFDE180C))
                              .size(15.sp)
                              .make(),
                        ],
                      ),
                    );
                  }),
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

  Future<bool> _openUseCardDialog({String confirmTitle, Widget child}) async {
    return (await Get.dialog(NormalContentDialog(
          title: '提示',
          content: child,
          type: NormalTextDialogType.delete,
          items: ['取消'],
          deleteItem: confirmTitle,
          listener: (_) => Get.back(),
          deleteListener: () => Get.back(result: true),
        ))) ==
        true;
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
