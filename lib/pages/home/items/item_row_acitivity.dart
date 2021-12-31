/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-01  15:04 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/models/promotion_goods_list_model.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';

class RowActivityItem extends StatelessWidget {
  final PromotionActivityModel model;
  final VoidCallback click;
  const RowActivityItem({Key key, this.model, this.click,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.frenchColor,
      child: _container(context),
    );
  }
  
  _container(BuildContext context) {
    return Container(
      color: AppColor.frenchColor,
      height: (MediaQuery.of(context).size.width-20)*170.0/350.0+10,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: Container(color: Colors.white.withAlpha(0),),
            onTap: (){
              click();
            },
          ),
          Positioned(
            left: 0, right: 0, top: 0, bottom: 0,
            child: GestureDetector(
              child: CustomCacheImage(
                borderRadius: BorderRadius.circular(10),
                imageUrl: Api.getImgUrl(model.logoUrl),
                fit: BoxFit.fill,
              ),
              onTap: (){
                click();
              },
            ),
            ),
        ],
      ),
    );
  }

}
