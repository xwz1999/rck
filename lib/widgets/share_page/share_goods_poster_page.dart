import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/share_page/post_all.dart';
import 'package:recook/widgets/share_page/post_select_image.dart';
import 'package:recook/widgets/toast.dart';

class ShareGoodsPosterPage extends StatefulWidget {
  final Map arguments;

  ShareGoodsPosterPage({Key key, this.arguments}) : super(key: key);
  static setArguments({String goodsId = "0"}) {
    return {
      "goodsId": goodsId,
    };
  }

  @override
  _ShareGoodsPosterPageState createState() => _ShareGoodsPosterPageState();
}

class _ShareGoodsPosterPageState extends BaseStoreState<ShareGoodsPosterPage> {
  int _goodsId = 0;
  GoodsDetailModel _goodsDetail;
  GlobalKey _globalKey = GlobalKey();
  // GoodsDetailImagesModel _goodsDetailImagesModel;
  double postHorizontalMargin = 50;
  // double postWidth = 0;
  // // 50 天气 70 头像 45 banner 75 价格二维码
  // double postImageVerticalMargin = 200;
  // double postHeight = 200;
  // double postImageHorizontalMargin = 30;
  //
  String _bigImageUrl = "";
  List<MainPhotos> _selectPhotos = [];
  PostAllWidgetController _postAllWidgetController = PostAllWidgetController();
  @override
  void initState() {
    super.initState();
    try {
      _goodsId = int.parse(widget.arguments["goodsId"]);
    } catch (e) {}
    _getDetail();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "海报分享",
        elevation: 0,
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      bottomNavigationBar: _bottomWidget(),
      // body: _goodsDetail == null && _goodsDetailImagesModel == null?
      body: _goodsDetail == null ? loadingWidget() : _body(),
    );
  }

  _body() {
    return Container(
      color: AppColor.frenchColor,
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            height: 100 * 2.h,
            child: PostSelectImage(
              selectImages: (List<MainPhotos> images) {
                _selectPhotos = images;
                if (images.length > 0) {
                  _bigImageUrl = Api.getImgUrl(images[0].url);
                }
                setState(() {});
                _postAllWidgetController.refreshWidget(images);
              },
              goodsDetailModel: _goodsDetail,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: postHorizontalMargin / 2,
                right: postHorizontalMargin / 2,
                bottom: 10),
            child: RepaintBoundary(
                key: _globalKey,
                child: PostAllWidget(
                  controller: _postAllWidgetController,
                  selectImagePhotos: _selectPhotos,
                  bigImageUrl: _bigImageUrl,
                  goodsDetailModel: _goodsDetail,
                )),
          )
        ],
      ),
    );
  }

  _capturePng() async {
    // '保存中...'
    showLoading("");
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image =
        await boundary.toImage(pixelRatio: ui.window.devicePixelRatio * 1.2);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    if (pngBytes == null || pngBytes.length == 0) {
      dismissLoading();
      showError("图片获取失败...");
      return;
    }
    ImageUtils.saveImage([pngBytes], (index) {}, (success) {
      dismissLoading();
      if (success) {
        showSuccess("图片已经保存到相册!");
      } else {
        showError("图片保存失败...");
      }
    });

    // var filePath = await ImagePickerSaver.saveFile(fileData: pngBytes);

    // var savedFile = File.fromUri(Uri.file(filePath));
    // setState(() {
    //   Future<File>.sync(() => savedFile);
    // });
    // // '保存成功'
    // showSuccess("保存成功!");
  }

  _getDetail() async {
    _goodsDetail = await GoodsDetailModelImpl.getDetailInfo(
        _goodsId, UserManager.instance.user.info.id);
    if (_goodsDetail.code != HttpStatus.SUCCESS) {
      Toast.showError(_goodsDetail.msg);
      return;
    }
    // _bottomBarController.setFavorite(_goodsDetail.data.isFavorite);
    MainPhotos photo = _goodsDetail.data.mainPhotos[0];
    if (_goodsDetail.data.mainPhotos.length >= 1) {
      photo = _goodsDetail.data.mainPhotos[0];
    }
    photo.isSelect = true;
    photo.isSelectNumber = 1;
    _bigImageUrl = Api.getImgUrl(photo.url);
    _selectPhotos.add(photo);
    setState(() {});
  }

  _bottomWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight),
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      height: 60,
      child: CustomImageButton(
        onPressed: () {
          _capturePng();
        },
        boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColor.themeColor),
        title: "保存到相册",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
