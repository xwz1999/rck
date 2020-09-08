/*
 * ====================================================
 * package   : pages.home.items
 * author    : Created by nansi.
 * time      : 2019/5/28  11:12 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_cache_image.dart';

class UsersLikeItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(5), right: Radius.circular(5)),
              child: CustomCacheImage(
                  fit: BoxFit.cover,
                  imageUrl: "http://d.5857.com/bnmn_170609/001.jpg"),
            ),
          ),
          Text(
            "几何构型小三糖果色灯",
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: AppTextStyle.generate(14, fontWeight: FontWeight.w300),
          ),
          Text(
            "￥ 109.00",
            style: AppTextStyle.generate(12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
