/*
 * ====================================================
 * package   : pages.home.items
 * author    : Created by nansi.
 * time      : 2019/5/28  11:08 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/widgets/custom_cache_image.dart';

class UserCommentItem extends StatelessWidget {
  final Evaluation? evaluation;

  const UserCommentItem({Key? key, this.evaluation}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 200,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      decoration: BoxDecoration(
          color: Color(0xFFF4F4F4),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: CustomCacheImage(
                  fit: BoxFit.cover,
                  imageUrl: Api.getImgUrl(evaluation!.headImgUrl),
                  width: 30,
                  height: 30,
                ),
              ),
              Container(
                width: 5,
              ),
              Text(
                evaluation!.nickname!,
                style: AppTextStyle.generate(14, fontWeight: FontWeight.w300),
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(rSize(4)),
              child: Text(
                evaluation!.content!,
                style: AppTextStyle.generate(14, fontWeight: FontWeight.w300),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }
}
