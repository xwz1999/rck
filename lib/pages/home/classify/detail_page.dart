/*
 * ====================================================
 * package   : pages.home.classify
 * author    : Created by nansi.
 * time      : 2019/5/22  9:42 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/goods_detail_images_model.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/toast.dart';

class DetailPage extends StatefulWidget {
  final int? goodsID;

  const DetailPage({Key? key, this.goodsID}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DetailPageState();
  }
}

class _DetailPageState extends State<DetailPage>
    with AutomaticKeepAliveClientMixin {
  GoodsDetailImagesModel? _model;

  @override
  void initState() {
    super.initState();
    GoodsDetailModelImpl.getDetailImages(widget.goodsID)
        .then((GoodsDetailImagesModel model) {
      if (model.code != HttpStatus.SUCCESS) {
        Toast.showError(model.msg);
        return;
      }
      _model = model;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context, {store}) {
    super.build(context);
    print("build ---------- detail");
    double topPadding = (DeviceInfo.statusBarHeight! + DeviceInfo.appBarHeight);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        padding: EdgeInsets.only(top: topPadding),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: _goodDetailImages(),
        ),
      ),
    );
  }

  List<Widget> _goodDetailImages() {
    if (_model == null) return [];

    List<Widget> children = _model!.data!.list!.map((Images image) {
      double width = DeviceInfo.screenWidth!;
      double height = image.height! * (width / image.width!);

      // String placeHolder;
      // if (width > height) {
      //   placeHolder = AppImageName.placeholder_2x1;
      // } else if (width == height) {
      //   placeHolder = AppImageName.placeholder_1x1;
      // } else {
      //   placeHolder = AppImageName.placeholder_1x2;
      // }

      return Container(
        child: CustomCacheImage(
          imageUrl: Api.getImgUrl(image.url),
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
      );
    }).toList();

    children.insert(
        0,
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Text(
            "产品详情",
            style: AppTextStyle.generate(15),
          ),
        ));

    return children;
  }

  @override
  // implement wantKeepAlive
  bool get wantKeepAlive => true;
}
