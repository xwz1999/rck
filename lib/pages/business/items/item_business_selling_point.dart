/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/12  3:01 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';

class BusinessSellingPointItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BusinessSellingPointItemState();
  }
}

class _BusinessSellingPointItemState extends State<BusinessSellingPointItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 2.3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: CustomCacheImage(fit: BoxFit.cover,imageUrl: "https://img14.360buyimg.com/n0/jfs/t1/76597/19/1120/277789/5cf604a2Ee35129bd/bdac98c72ffbe01c.jpg"),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 5, left: 5, right: 5),
            child: Text("左家右厨韩式煎锅班戟不粘鸡蛋饼可丽饼皮烙饼牛排...", maxLines: 1, overflow: TextOverflow.ellipsis,style: AppTextStyle.generate(15, fontWeight: FontWeight.w300),),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Row(
              children: <Widget>[
                Expanded(child: Text("麦饭石涂层 不放油可以煎蛋", maxLines: 1, overflow: TextOverflow.ellipsis,style: AppTextStyle.generate(13, color: Colors.grey[500], fontWeight: FontWeight.w300),)),
                Text("库存 200", style: AppTextStyle.generate(13,color: Colors.grey[500], fontWeight: FontWeight.w300),)
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
            ),
            child: Row(
              children: <Widget>[
                Text("￥150.00", style: AppTextStyle.generate(16, fontWeight: FontWeight.w300),),
                Container(width: 5,),
                Text(AppConfig.getShowCommission() ? "赚50.00" : "", style: AppTextStyle.generate(16, color: Colors.red, fontWeight: FontWeight.w300),),
                Expanded(child: Container()),
                Container(width: 10,),
                CustomImageButton(
                  title: "马上抢",
                  color: Colors.white,
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  onPressed: (){
                      
                  },),
              ],
            ),
          )

        ],
      ),
    );
  }
}

