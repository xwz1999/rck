import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/models/missing_children_model.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/utils/permission_tool.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/share_page/post_all.dart';
import 'package:recook/widgets/share_page/post_select_image.dart';
import 'package:recook/widgets/toast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../alert.dart';

class ShareGoodsPosterPage extends StatefulWidget {
  final Map? arguments;

  ShareGoodsPosterPage({Key? key, this.arguments}) : super(key: key);
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
  GoodsDetailModel? _goodsDetail;
  GlobalKey _globalKey = GlobalKey();
  // GoodsDetailImagesModel _goodsDetailImagesModel;
  double postHorizontalMargin = 50;
  MissingChildrenModel? _missingChildrenModel;
  // double postWidth = 0;
  // // 50 天气 70 头像 45 banner 75 价格二维码
  // double postImageVerticalMargin = 200;
  // double postHeight = 200;
  // double postImageHorizontalMargin = 30;
  //
  String? _bigImageUrl = "";
  List<MainPhotos> _selectPhotos = [];
  PostAllWidgetController _postAllWidgetController = PostAllWidgetController();
  @override
  void initState() {
    super.initState();
    try {
      _goodsId = int.parse(widget.arguments!["goodsId"]);
    } catch (e) {}
    _getDetail();
    // _getMissingChildren();
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
            padding: EdgeInsets.only(bottom: 10, left: 10.rw, right: 10.rw),
            child: RepaintBoundary(
                key: _globalKey,
                child: PostAllWidget(
                  controller: _postAllWidgetController,
                  selectImagePhotos: _selectPhotos,
                  bigImageUrl: _bigImageUrl,
                  goodsDetailModel: _goodsDetail,
                  missingChildrenModel: _missingChildrenModel,
                )),
          ),
        ],
      ),
    );
  }

  _capturePng() async {
    // '保存中...'
    showLoading("");
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image =
        await boundary.toImage(pixelRatio: ui.window.devicePixelRatio * 1.2);
    ByteData byteData = (await (image.toByteData(format: ui.ImageByteFormat.png) ))!;

    Uint8List pngBytes = byteData.buffer.asUint8List();

    if (pngBytes.length == 0) {
      dismissLoading();
      showError("图片获取失败...");
      return;
    }


    bool permission = await Permission.storage.isGranted;
    if(!permission){
      dismissLoading();
      Alert.show(
        context,
        NormalContentDialog(
          title: '存储权限',
          content:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Image.asset(R.ASSETS_LOCATION_PER_PNG,width: 44.rw,height: 44.rw,),
              Text('允许应用获取存储权限来保存图片', style: TextStyle(
                  color: Color(0xFF666666), fontSize: 14.rsp),),
            ],
          ),
          items: ["残忍拒绝"],
          listener: (index) {
            Alert.dismiss(context);

          },
          deleteItem: "立即授权",
          deleteListener: () async {
            Alert.dismiss(context);

            bool  canUseCamera = await PermissionTool.haveStoragePermission();
            if (!canUseCamera) {
              PermissionTool.showOpenPermissionDialog(
                  context, "没有存储权限,授予后才能保存图片");
              return;
            } else {

              ImageUtils.saveImage([pngBytes], (index) {}, (success) {

                if (success) {
                  showSuccess("图片已经保存到相册!");
                } else {
                  Alert.show(
                    context,
                    NormalContentDialog(
                      title: '提示',
                      content: Text('图片保存失败，请前往应用权限页，设置存储权限为始终允许',style: TextStyle(color: Color(0xFF333333),fontSize: 14.rsp),),
                      items: ["取消"],
                      listener: (index) {
                        Alert.dismiss(context);
                      },
                      deleteItem: "确认",
                      deleteListener: () async{

                        Alert.dismiss(context);
                        bool isOpened = await openAppSettings();
                      },
                      type: NormalTextDialogType.delete,
                    ),
                  );
                }
              });
            }
          },
          type: NormalTextDialogType.delete,
        ),
      );

    }else{
      dismissLoading();
      ImageUtils.saveImage([pngBytes], (index) {}, (success) {

        if (success) {
          showSuccess("图片已经保存到相册!");
        } else {
          Alert.show(
            context,
            NormalContentDialog(
              title: '提示',
              content: Text('图片保存失败，请前往应用权限页，设置存储权限为始终允许',style: TextStyle(color: Color(0xFF333333),fontSize: 14.rsp),),
              items: ["取消"],
              listener: (index) {
                Alert.dismiss(context);
              },
              deleteItem: "确认",
              deleteListener: () async{

                Alert.dismiss(context);
                bool isOpened = await openAppSettings();
              },
              type: NormalTextDialogType.delete,
            ),
          );
        }
      });
    }




    // dismissLoading();

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
        _goodsId, UserManager.instance!.user.info!.id);
    if (_goodsDetail!.code != HttpStatus.SUCCESS) {
      Toast.showError(_goodsDetail!.msg);
      return;
    }
    // _bottomBarController.setFavorite(_goodsDetail.data.isFavorite);
    MainPhotos photo = _goodsDetail!.data!.mainPhotos![0];
    if (_goodsDetail!.data!.mainPhotos!.length >= 1) {
      photo = _goodsDetail!.data!.mainPhotos![0];
    }
    photo.isSelect = true;
    photo.isSelectNumber = 1;
    _bigImageUrl = Api.getImgUrl(photo.url);
    _selectPhotos.add(photo);
    setState(() {});
  }

  _getMissingChildren() async {
    _missingChildrenModel = await GoodsDetailModelImpl.getMissingChildrenInfo();
    print(Api.getImgUrl(_missingChildrenModel!.pic));
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
