

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/wholesale/vip_shop_card_page.dart';
import 'package:recook/utils/storage/hive_store.dart';

class SevenCardDialog extends StatefulWidget {

  SevenCardDialog({Key? key,})
      : super(key: key);

  @override
  _SevenCardDialogState createState() => _SevenCardDialogState();
}

class _SevenCardDialogState extends State<SevenCardDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            Image.asset(Assets.sevenVipCard.path,width: 340.rw,height: 307.rw,),
          72.hb,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  HiveStore.appBox!.put('showSeven${UserManager.instance!.user.info!.id}', true);
                  Get.back();
                },
                child: Container(
                  width: 128.rw,
                  height: 42.rw,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.white,width: 2.rw),
                    borderRadius: BorderRadius.circular(25.rw)

                  ),
                  child: Text('下次领取',style: TextStyle(
                    color: Colors.white,fontSize: 18.rsp
                  ),),
                ),
              ),
              50.wb,
              GestureDetector(
                onTap: (){
                  HiveStore.appBox!.put('showSeven${UserManager.instance!.user.info!.id}', true);
                  Get.back();
                  Get.to(()=>VipShopCardPage());
                },
                child: Container(
                  width: 128.rw,
                  height: 42.rw,
                  alignment: Alignment.center,
                  //padding: EdgeInsets.symmetric(vertical: 12.rw,horizontal: 28.rw),
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(Assets.vipCardBtn.path),fit: BoxFit.fitWidth)
                  ),
                  child: Text('领取使用',style: TextStyle(
                      color: Colors.white,fontSize: 18.rsp
                  ),),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}