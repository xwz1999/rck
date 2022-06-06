/*
 * ====================================================
 * package   : pages.store
 * author    : Created by nansi.
 * time      : 2019/5/13  2:20 PM
 * remark    :
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/widgets/transparent_app_bar.dart';

class StorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StorePageState();
  }
}

class _StorePageState extends State<StorePage> with AutomaticKeepAliveClientMixin{
  SliverAppBarController? _appBarController;

  @override
  void initState() {
    super.initState();
    _appBarController = SliverAppBarController();
  }

  @override
  Widget build(BuildContext context, {store}) {
    super.build(context);
    print("--------- StorePage");

    return TransparentAppBar(
      title: "小卷毛杂货店",
      topTotalHeight: 280,
      header: _header(),
      controller: _appBarController,
      appBarBackgroundColor: AppColor.frenchColor,
      itemColor: Colors.black,
      body: Container(
        color: AppColor.frenchColor,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: RefreshWidget(
            isInNest: true,
            enableOverScroll: false,
            body: ListView.builder(itemBuilder: (_, index) {
              return Container(
                // child: ColumnGoodsItem(model: ColumnGoodsModel(isProcessing: 1, salesVolume: 0 ,imgUrl: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559711896703&di=f581d59f81066775195d8b6bb0d91713&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201704%2F02%2F20170402184902_E3iW8.jpeg", title: "22222222", des: "11111", price: 20.0, commission: 1.0, inventory: 1),),
              );
            }),
          ),
        ),
      ),
    );
  }

  Stack _header() {
    return Stack(children: [
      /// 背景图
      Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: CustomCacheImage(
              fit: BoxFit.cover,
              imageUrl:
                  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559711896703&di=f581d59f81066775195d8b6bb0d91713&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201704%2F02%2F20170402184902_E3iW8.jpeg")),

//      /// 蒙版
//      Positioned(
//          top: 0,
//          bottom: 0,
//          left: 0,
//          right: 0,
//          child: Opacity(
//            opacity: 0.3,
//            child: Container(
//              color: Colors.black,
//            ),
//          )),

      /// 品牌信息
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 85,
          padding: EdgeInsets.only(left: 110, bottom: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "小卷毛杂货店",
                  style: AppTextStyle.generate(18, fontWeight: FontWeight.w400),
                ),
                Text(
                  "And a thousand times I've seen this road",
                  maxLines: 1,
                  style: AppTextStyle.generate(14,
                      color: Colors.grey[700], fontWeight: FontWeight.w300),
                )
              ],
            ),
            onTap: () {
              AppRouter.push(context, RouteName.STORE_DETAIL_PAGE);
            },
          ),
        ),
      ),

      /// 品牌icon
      Positioned(
          left: 15,
          bottom: 20,
          child: CustomCacheImage(
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              imageUrl:
                  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559711939336&di=b0d64520f7da02b6667dffdd75d8a613&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201506%2F16%2F20150616143732_PJ8Xf.jpeg")),
    ]);
  }

  @override
  void dispose() {
    _appBarController?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
