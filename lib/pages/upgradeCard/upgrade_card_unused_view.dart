import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:recook/constants/api_v2.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/upgradeCard/function/user_card_function.dart';
import 'package:recook/pages/upgradeCard/model/user_card_%20model.dart';
import 'package:recook/pages/upgradeCard/upgrade_card_send_page_v2.dart';
import 'package:recook/pages/upgradeCard/upgrade_card_use_result_page.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/refresh_widget.dart';

class UpgradeUnusedView extends StatefulWidget {
  UpgradeUnusedView({Key key}) : super(key: key);

  @override
  _UpgradeUnusedViewState createState() => _UpgradeUnusedViewState();
}

class _UpgradeUnusedViewState extends State<UpgradeUnusedView> {
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
        _cards = await UserCardFunction.fetchList(_page, 0);
        _refreshController.refreshCompleted();
        setState(() {});
      },
      onLoadMore: () async {
        _page++;
        _cards.addAll(await UserCardFunction.fetchList(_page, 0));
        _refreshController.loadComplete();
        setState(() {});
      },
      body: ListView.separated(
        separatorBuilder: (_, __) => 10.hb,
        itemBuilder: (context, index) {
          final item = _cards[index];
          return _UserCard(
            model: item,
            refreshController: _refreshController,
          );
        },
        itemCount: _cards.length,
        padding: EdgeInsets.symmetric(
          horizontal: 16.rw,
          vertical: 10.rw,
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserCardModel model;
  final GSRefreshController refreshController;
  const _UserCard({Key key, this.model, this.refreshController})
      : super(key: key);

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
      minWidth: 80.rw,
      height: 33.rw,
      onPressed: onTap,
      child: title.text.size(14.rsp).white.make(),
    );
  }

  String get type {
    if (model.type == 1) return '黄金卡';
    if (model.type == 2)
      return '白银卡';
    else
      return '';
  }

  String get typeValue {
    if (model.type == 1) return '黄金';
    if (model.type == 2)
      return '白银';
    else
      return '';
  }

  String get typeEng {
    if (model.type == 1) return 'Gold Card';
    if (model.type == 2)
      return 'Silver Card';
    else
      return '';
  }

  String get _cardFace {
    if (model.type == 1) return R.ASSETS_USER_UPGRADE_GOLD_CARD_WEBP;
    if (model.type == 2) return R.ASSETS_USER_UPGRADE_SILVER_CARD_WEBP;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 193.rw,
      padding: EdgeInsets.only(
        left: 16.rw,
        top: 16.rw,
        bottom: 6.rw,
        right: 10.rw,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              type.text.color(Color(0xFFDD2C4E)).size(18.rsp).bold.make(),
              typeEng.text.color(Color(0xFFDD2C4E)).size(10.rsp).make(),
              Spacer(),
              '编号：${model.code}'
                  .text
                  .color(Color(0xFFDD2C4E))
                  .size(16.rsp)
                  .bold
                  .make(),
              (model?.sourceName ?? '')
                  .text
                  .color(Color(0xFFDD2C4E))
                  .size(12.rsp)
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
                      confirmTitle: '使用$type',
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          '$type使用后将于${nextMonth.month}月1日考核时生效'
                              .text
                              .black
                              .size(15.rsp)
                              .make(),
                          '您使用了$type，将于下月1日生效，若店铺考核未达到$typeValue店铺考核标准，则消耗一张$type成为$typeValue店铺，享受$typeValue店铺权益；若店铺考核达到$typeValue店铺标准，则$type将返还至您的卡包。'
                              .text
                              .color(Color(0xFFDE180C))
                              .size(15.rsp)
                              .make(),
                        ],
                      ),
                    );
                    if (result) {
                      ResultData resultData = await HttpManager.post(
                        APIV2.userAPI.useCard,
                        {'cardId': model.id},
                      );
                      if (resultData.data['code'] == 'FAIL') {
                        showToast(resultData.data['msg']);
                        await Get.to(() => UpgradeUseResultPage(
                              result: false,
                              content: '使用失败，您已经使用了一张权益卡',
                            ));
                      } else
                        await Get.to(() => UpgradeUseResultPage(
                              result: true,
                              content: '恭喜您，使用成功！',
                            ));
                      refreshController.requestRefresh();
                    }
                  }),
              16.hb,
              _renderButton(
                title: '赠送',
                onTap: () async {
                  int id = await Get.to(() => UpgradeeCardSendPageV2());
                  if (id != null) {
                    ResultData resultData = await HttpManager.post(
                      APIV2.userAPI.giveCard,
                      {
                        'cardId': model.id,
                        'giveUserId': id,
                      },
                    );
                    if (resultData.data['code'] == 'FAIL') {
                      showToast(resultData.data['msg']);
                      await Get.to(() => UpgradeUseResultPage(
                            result: false,
                            content: '使用失败，您已经使用了一张权益卡',
                          ));
                    } else
                      await Get.to(() => UpgradeUseResultPage(
                            result: true,
                            content: '恭喜您，使用成功！',
                          ));
                    refreshController.requestRefresh();
                  }
                },
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_cardFace),
        ),
      ),
    );
  }
}
