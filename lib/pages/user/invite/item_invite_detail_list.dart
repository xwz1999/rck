import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/app_image_resources.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/models/invite_list_model.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';

class InviteDetailListItem extends StatelessWidget {
  final InviteModel model;
  final bool isUpgrade;
  const InviteDetailListItem({Key key, this.model, this.isUpgrade = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: rSize(100),
        height: 70,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: rSize(5)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(rSize(10)))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _imageView(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _nameView(),
                  Container(
                    height: rSize(4),
                  ),
                  !isUpgrade ? _subInfoView() : _roleLevelIconWidget(),
                  // _infoView(),
                  // Spacer(),
                  // _timeView(),
                  // Container(height: 3,),
                ],
              ),
            ),
            // _nextIcon(),
          ],
        ));
  }

  _imageView() {
    return Container(
      //头像
      margin: EdgeInsets.only(left: 12, right: 12, top: 7.5, bottom: 7.5),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(22.5)),
          child: CustomCacheImage(
            fit: BoxFit.cover,
            imageUrl: Api.getResizeImgUrl(model.headImgUrl, 300),
            placeholder: AppImageName.placeholder_1x1,
          ),
        ),
      ),
    );
  }

  _nameView() {
    String name = model.nickname;
    if (!TextUtils.isEmpty(model.remarkName)) {
      name = name + "(" + model.remarkName + ")";
    }
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: AppTextStyle.generate(14,
                color: Colors.black, fontWeight: FontWeight.w400),
          ),
          Container(
            width: 8,
          ),
          !isUpgrade
              ? Image.asset(
                  "assets/invite_detail_edit.png",
                  width: 13,
                  height: 13,
                )
              : Container(),
        ],
      ),
      margin: EdgeInsets.only(top: 10),
    );
  }

  _subInfoView() {
    return Container(
      child: Row(
        children: <Widget>[
          Image.asset(
            "assets/invite_detail_phone.png",
            width: 13,
            height: 13,
          ),
          Container(
            width: 4,
          ),
          Text(
            TextUtils.isEmpty(model.phoneNum) ? "未设置" : model.phoneNum,
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          Container(
            width: 24,
          ),
          Image.asset(
            "assets/invite_detail_time.png",
            width: 13,
            height: 13,
          ),
          Container(
            width: 4,
          ),
          !TextUtils.isEmpty(model.createdAt)
              ? Text(
                  model.createdAt,
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                )
              : Container(),
        ],
      ),
    );
  }

  _roleLevelIconWidget() {
    return Container(
      child: Row(
        children: <Widget>[
          Image.asset(
            "assets/invite_detail_phone.png",
            width: 13,
            height: 13,
          ),
          Container(
            width: 4,
          ),
          Text(
            TextUtils.isEmpty(model.phoneNum) ? "未设置" : model.phoneNum,
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          Container(
            width: 24,
          ),
          // Image.asset("assets/invite_detail_time.png", width: 13, height: 13,),
          Image.asset(
            UserLevelTool.upgradeRoleLevelIcon(
                UserLevelTool.roleLevelEnum(model.roleLevel)),
            width: 13,
            height: 13,
          ),
          Container(
            width: 4,
          ),
          Text(
            UserLevelTool.roleLevel(model.roleLevel),
            style: TextStyle(fontSize: 11, color: Colors.grey),
          )
          // !TextUtils.isEmpty(model.createdAt)?
          //   Text(model.createdAt, style: TextStyle(fontSize: 11, color: Colors.grey),)
          //   :Container(),
        ],
      ),
    );
  }
}
