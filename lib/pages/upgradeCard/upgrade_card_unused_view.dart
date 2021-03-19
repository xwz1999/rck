import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/pages/upgradeCard/function/user_card_function.dart';
import 'package:recook/pages/upgradeCard/model/user_card_%20model.dart';
import 'package:recook/widgets/alert.dart';
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
      },
      onLoadMore: () async {
        _page++;
        _cards.addAll(await UserCardFunction.fetchList(_page, 0));
        _refreshController.refreshCompleted();
        setState(() {});
      },
      body: ListView.separated(
        separatorBuilder: (_, __) => 10.hb,
        itemBuilder: (context, index) {
          final item = _cards[index];
          return _UserCard(model: item);
        },
        itemCount: _cards.length,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 10.w,
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserCardModel model;
  const _UserCard({Key key, this.model}) : super(key: key);

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
      minWidth: 80.w,
      height: 33.w,
      onPressed: onTap,
      child: title.text.size(14.sp).white.make(),
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

  @override
  Widget build(BuildContext context) {
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
              type.text.color(Color(0xFFDD2C4E)).size(18.sp).bold.make(),
              typeEng.text.color(Color(0xFFDD2C4E)).size(10.sp).make(),
              Spacer(),
              '编号：${model.code}'
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
                      confirmTitle: '使用$type',
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          '$type使用后将于${nextMonth.month}月1日考核时生效'
                              .text
                              .black
                              .size(15.sp)
                              .make(),
                          '您使用了$type，将于下月1日生效，若店铺考核未达到$typeValue店铺考核标准，则消耗一张$type成为$typeValue店铺，享受$typeValue店铺权益；若店铺考核达到$typeValue店铺标准，则$type将返还至您的卡包。'
                              .text
                              .color(Color(0xFFDE180C))
                              .size(15.sp)
                              .make(),
                        ],
                      ),
                    );
                    if (result) {

                    }
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
}
