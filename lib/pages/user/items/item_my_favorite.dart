/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-26  15:37 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/my_favorites_list_model.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_cache_image.dart';

class MyFavoriteItem extends StatelessWidget {
  final FavoriteModel model;
  final Function? shareFunc;
  final Function? deleteFunc;

  const MyFavoriteItem(
      {Key? key, required this.model, this.shareFunc, this.deleteFunc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Container(
      padding: EdgeInsets.all(rSize(10)),
      // height: rSize(90),
      height: 110,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(width: 0.5 * 2.w, color: Colors.grey[300]!))),
      child: Row(
        children: <Widget>[
          CustomCacheImage(
            imageUrl: Api.getResizeImgUrl(model.goods!.mainPhotoUrl!, 150),
            width: 90,
            height: 90,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          SizedBox(
            width: rSize(10),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  model.goods!.goodsName!,
                  style: AppTextStyle.generate(15 * 2.sp,
                      fontWeight: FontWeight.w300, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(model.goods!.description!,
                      style: AppTextStyle.generate(12 * 2.sp,
                          fontWeight: FontWeight.w300, color: Colors.black54)),
                ),

                Row(
                  children: <Widget>[
                    RichText(
                        text: TextSpan(
                            text: "￥",
                            style: AppTextStyle.generate(14 * 2.sp,
                                color: Color(0xffEE5252)),
                            children: [
                          TextSpan(
                              text:
                                  model.goods!.discountPrice!.toStringAsFixed(2),
                              style: AppTextStyle.generate(17 * 2.sp,
                                  color: Color(0xffEE5252),
                                  fontWeight: FontWeight.w400))
                        ])),
                    Spacer(),
                    _itemTextButton('取消收藏', deleteFunc),
                    Container(
                      width: 10,
                    ),
                    UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip
                        ? Container()
                        : _itemTextButton('导购', shareFunc),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _itemTextButton(title, click) {
    return GestureDetector(
      onTap: () {
        if (click != null) {
          click();
        }
      },
      child: Container(
        child: Text(
          title,
          style: TextStyle(
              fontSize: 14 * 2.sp,
              color: Color(0xffEE5252),
              fontWeight: FontWeight.w300),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(ScreenAdapterUtils.setWidth(12.5))),
          border: Border.all(color: Color(0xffEE5252), width: 0.5),
        ),
        width: 70,
        height: 25,
        alignment: Alignment.center,
      ),
    );
  }
}
