import 'package:flutter/material.dart';
import 'package:recook/constants/app_image_resources.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/utils/app_router.dart';

class InviteView extends StatefulWidget {
  final bool isDiamond; // 只显示单行
  final Function() shareListener;
  const InviteView({Key key, this.shareListener, this.isDiamond = true})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _InviteViewState();
  }
}

class _InviteViewState extends State<InviteView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(10),
        ),
        // margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _titleWidget(),
            widget.isDiamond ? _buildDiamondCards() : _rowInviteView()
          ],
        ));
  }

  _titleWidget() {
    return Container(
      height: 40,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 15),
      child: Text(
        "邀请升级",
        style: AppTextStyle.generate(16, fontWeight: FontWeight.w700),
      ),
    );
  }

  _buildDiamondCards() {
    return Container(
      height: rSize(150),
      padding: EdgeInsets.symmetric(horizontal: rSize(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: rSize(130),
            child: _buildUpgrade(),
          ),
          SizedBox(width: rSize(5)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _buildMyRecommend()),
                      SizedBox(width: rSize(5)),
                      Expanded(child: _buildMyInvite(small: true)),
                    ],
                  ),
                ),
                SizedBox(height: rSize(5)),
                Expanded(child: _buildInvite(small: true)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _rowInviteView() {
    return Container(
      height: 90,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: <Widget>[
          Expanded(child: _buildInvite()),
          Container(width: rSize(5)),
          Expanded(child: _buildMyInvite()),
        ],
      ),
    );
  }

  _buildUpgrade() {
    return _buildCard(
      background: Image.asset(
        R.ASSETS_SHOP_UPGRADE_PNG,
        fit: BoxFit.cover,
      ),
      title: '升级财富圈',
      subTitle: '邀请好友·福利双赢',
      onTap: () =>
          AppRouter.push(context, RouteName.SHOP_RECOMMEND_UPGRADE_PAGE),
    );
  }

  _buildInvite({bool small = false}) {
    return _buildCard(
      background: Image.asset(
        small
            ? R.ASSETS_SHOP_INVITE_OPEN_STORE_SMALL_PNG
            : R.ASSETS_SHOP_INVITE_OPEN_STORE_PNG,
        fit: BoxFit.cover,
      ),
      title: '邀请开店',
      subTitle: '0元创业·轻松赚',
      onTap: () {
        if (widget.shareListener != null) widget.shareListener();
      },
    );
  }

  _buildMyInvite({bool small = false}) {
    return _buildCard(
      background: Image.asset(
        small ? R.ASSETS_SHOP_MY_INVITE_SMALL_PNG : R.ASSETS_SHOP_MY_INVITE_PNG,
        fit: BoxFit.cover,
      ),
      title: '我的邀请',
      subTitle: '有福同享·真壕友',
      onTap: () => AppRouter.push(
        context,
        RouteName.USER_INVITE,
      ),
    );
  }

  _buildMyRecommend() {
    return _buildCard(
        background: Image.asset(
          R.ASSETS_SHOP_MY_RECOMMAND_PNG,
          fit: BoxFit.cover,
        ),
        title: '我的推荐',
        subTitle: '呼朋唤友·享收益',
        onTap: () {});
  }

  Widget _buildCard({
    @required Widget background,
    @required String title,
    @required String subTitle,
    @required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(rSize(4)),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: background,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: rSize(10),
              vertical: rSize(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: rSP(14),
                    height: 20 / 14,
                  ),
                ),
                SizedBox(height: rSize(4)),
                Text(
                  subTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: rSP(10),
                    height: 14 / 10,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
