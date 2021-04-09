/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/6  9:12 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_cache_image.dart';

class PhysicalStoreItem extends StatelessWidget {
  final double _qrCodeSize = 35;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _companyName(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 5, right: 15),
                      child: Icon(
                        Icons.phone,
                        size: 20,
                      ),
                    ),
                    Text("158123456789",
                        style:
                            AppTextStyle.generate(14, color: Colors.grey[600])),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 5, right: 15),
                      child: Icon(
                        Icons.location_on,
                        size: 20,
                      ),
                    ),
                    Expanded(
                        child: Text("浙江省宁波市江北路翠柏路00",
                            style: AppTextStyle.generate(14,
                                color: Colors.grey[600]))),
                  ],
                ),
              ],
            ),
          )),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Image.asset(
                AppImageName.store_bg,
                width: 80,
                height: 120,
                fit: BoxFit.fill,
              ),
              CustomCacheImage(
                fit: BoxFit.cover,
                imageUrl:
                    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559711939336&di=b0d64520f7da02b6667dffdd75d8a613&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201506%2F16%2F20150616143732_PJ8Xf.jpeg",
                height: _qrCodeSize,
                width: _qrCodeSize,
              )
            ],
          ),
        ],
      ),
    );
  }

  Container _companyName() {
    return Container(
                margin: EdgeInsets.only(right: 8, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.local_cafe,
                      size: 30,
                    ),
                    Container(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("宁波大华科技有限公司",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.generate(14)),
                        Text("NingBoDaHuaKeJiYouXianGongSi",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.generate(12,
                                color: Colors.grey[400]))
                      ],
                    )
                  ],
                ),
              );
  }
}
