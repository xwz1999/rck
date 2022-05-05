/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-19  15:05
 * remark    :
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/logistic_list_model.dart';
import 'package:recook/widgets/custom_cache_image.dart';

class LogisticItem extends StatelessWidget {
  final LogisticDetailModel model;

  const LogisticItem({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            EdgeInsets.symmetric(horizontal: rSize(10), vertical: rSize(8)),
        margin: EdgeInsets.only(bottom: rSize(8)),
//      margin: EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(8)),
        decoration: BoxDecoration(
          color: Colors.white,
//        borderRadius: BorderRadius.all(Radius.circular(rSize(5)))
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _contentContainer(),
            ),
            Container(
              width: 30,
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 20,
                color: Colors.grey[600],
              ),
            ),
          ],
        ));
  }

  _contentContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "${model.name}: ${model.no}",
          style: AppTextStyle.generate(13 * 2.sp, color: Colors.grey[600]),
        ),
        SizedBox(
          height: rSize(5),
        ),
        model.data != null && model.data.length > 0
            ? Text(
                model.data.first.context,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.generate(11 * 2.sp,
                    color: Colors.grey[600], fontWeight: FontWeight.w300),
              )
            : Container(),
        SizedBox(
          height: rSize(10),
        ),
        GridView.builder(
            shrinkWrap: true,
            itemCount: model.picUrls.length,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: rSize(5),
                mainAxisSpacing: rSize(8),
                crossAxisCount: 4),
            itemBuilder: (_, index) {
              return CustomCacheImage(
                imageUrl: Api.getImgUrl(model.picUrls[index]),
                fit: BoxFit.cover,
              );
            })
      ],
    );
  }
}
