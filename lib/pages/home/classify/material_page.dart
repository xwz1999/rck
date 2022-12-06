/*
 * ====================================================
 * package   : pages.home.classify
 * author    : Created by nansi.
 * time      : 2019/5/22  9:43 AM 
 * remark    : 
 * ====================================================
 */

import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/material_list_model.dart';
import 'package:recook/pages/business/publish_business_district_page.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/pages/home/items/item_publish_material.dart';
import 'package:recook/third_party/wechat/wechat_utils.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/pic_swiper.dart';
import 'package:recook/widgets/toast.dart';

class MaterialPage extends StatefulWidget {
  final int? goodsID;
  const MaterialPage({Key? key, this.goodsID}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MaterialPageState();
  }
}

class _MaterialPageState extends State<MaterialPage>
    with AutomaticKeepAliveClientMixin {
  MaterialListModel? _model;

  @override
  void initState() {
    print("initState ---------- Good");
    super.initState();
    int? userID = 0;
    if (UserManager.instance!.haveLogin) {
      userID = UserManager.instance!.user.info!.id;
    }
    GoodsDetailModelImpl.getDetailMoments(userID, widget.goodsID)
        .then((MaterialListModel model) {
      if (model.code != HttpStatus.SUCCESS) {
        Toast.showError(model.msg);
        return;
      }
      _model = model;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build ---------- Good");
    print('$_model');
    super.build(context);
    double topPadding = (DeviceInfo.statusBarHeight! + DeviceInfo.appBarHeight);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        color: AppColor.frenchColor,
        padding: EdgeInsets.only(top: topPadding),
        child: Stack(alignment: Alignment.center,
            // children: _materialDetail(),
            children: [
              ListView.builder(
                  itemCount: _model == null || _model!.data == null
                      ? 0
                      : _model!.data!.length + 1,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == _model!.data!.length) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        color: Colors.green.withAlpha(0),
                      );
                    }
                    return _itemWidget(
                      _model!.data![index],
                    );
                  }),
              !UserManager.instance!.haveLogin
                  ? Container()
                  : Positioned(
                      bottom: 10,
                      child: CustomImageButton(
                        title: "我要发布",
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                        color: Colors.white,
                        fontSize: 15 * 2.sp,
                        backgroundColor: AppColor.themeColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        onPressed: () {
                          AppRouter.model(
                              context, RouteName.BUSINESS_DISTRICT_PUBLISH_PAGE,
                              arguments:
                                  PublishBusinessDistrictPage.setArguments(
                                      goodsId: widget.goodsID));
                        },
                      ),
                    )
            ]),
      ),
    );
  }

  _itemWidget(MaterialModel model) {
    return Container(
      child: PublishMaterialItem(
        publishMaterialListener: (Goods goods) {
          WeChatUtils.shareGoodsForMiniProgram(
              goodsId: goods.id,
              thumbnail: Api.getImgUrl(goods.mainPhotoURL),
              title: goods.name);
        },
        downloadListener: (ByteData byteData) {
          _capturePng(byteData);

          List<String> urls = model.photos!.map((f) {
            // return Api.getResizeImgUrl(f.url, 300);
            return Api.getResizeImgUrl(f.url!, 800);
          }).toList();
          ImageUtils.saveNetworkImagesToPhoto(urls, (index) {
            DPrint.printf("保存好了---$index");
          }, (success) {
            BotToast.closeAllLoading();
            success
                ? GSDialog.of(context).showSuccess(context, "保存完成!")
                : Alert.show(
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
            // if (!TextUtils.isEmpty(model.text)) {
            //   ClipboardData data = new ClipboardData(text: model.text);
            //   Clipboard.setData(data);
            //   Toast.showCustomSuccess('文字内容已经保存到剪贴板');
            //   // Toast.showSuccess('文字内容已经保存到剪贴板');
            // }
          });
        },
        copyListener: () {
          if (!TextUtils.isEmpty(model.text)) {
            ClipboardData data = new ClipboardData(text: model.text);
            Clipboard.setData(data);
            Toast.showCustomSuccess('文字内容已经保存到剪贴板');
            // showSuccess('文字内容已经保存到剪贴板');
          }
        },
        focusListener: () {
          DPrint.printf("关注或者取消关注!");
          _attention(model);
        },
        picListener: (index) {
          List<PicSwiperItem> picSwiperItem = [];
          for (Photos photo in model.photos!) {
            picSwiperItem.add(PicSwiperItem(Api.getImgUrl(photo.url)));
          }
          Get.to(()=>PicSwiper(arguments: PicSwiper.setArguments(
            index: index,
            pics: picSwiperItem,
          )));
          // AppRouter.fade(
          //   context,
          //   RouteName.PIC_SWIPER,
          //   arguments: PicSwiper.setArguments(
          //     index: index,
          //     pics: picSwiperItem,
          //   ),
          // );
        },
        model: model,
      ),
    );
  }

  _capturePng(ByteData byteData) async {
    // '保存中...
    // ui.Image image =
    // await boundary.toImage(pixelRatio: ui.window.devicePixelRatio * 1.2);
    // ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png,);


    // ByteData byteData = await WidgetToImage.widgetToImage( Directionality(
    //   textDirection: TextDirection.ltr,
    //   child: Material(
    //       child:_getPoster()
    //   ),
    // ),pixelRatio: window.devicePixelRatio,size: Size(370.rw,465.rw));
    //
    // await Future.delayed(Duration(milliseconds: 3000));


    Uint8List pngBytes = byteData.buffer.asUint8List();

    if (pngBytes.length == 0) {
      BotToast.showText(text: '保存失败');
      return;
    }

    await ImageUtils.saveImage( [pngBytes], (index) {}, (success,path) {

      if (success) {
        //showSuccess("图片已经保存到相册!");
      } else {
        Alert.show(
          context,
          NormalContentDialog(
            title: '提示',
            content: Text(
              '图片保存失败，请前往应用权限页，设置存储权限为始终允许',
              style: TextStyle(color: Color(0xFF333333), fontSize: 14.rsp),
            ),
            items: ["取消"],
            listener: (index) {
              Alert.dismiss(context);
            },
            deleteItem: "确认",
            deleteListener: () async {
              Alert.dismiss(context);
              bool isOpened = await openAppSettings();
            },
            type: NormalTextDialogType.delete,
          ),
        );
      }
    },quality: 100);


  }

  // List<Widget> _materialDetail() {
  //   if (_model == null) return [];
  //
  //   List<Widget> children = _model.data.map((MaterialModel model) {
  //     return Container(
  //       child: PublishMaterialItem(
  //         publishMaterialListener: (Goods goods) {
  //           WeChatUtils.shareGoodsForMiniProgram(
  //               goodsId: goods.id,
  //               thumbnail: Api.getImgUrl(goods.mainPhotoURL),
  //               title: goods.name);
  //         },
  //         downloadListener: () {
  //           GSDialog.of(context).showLoadingDialog(context, "保存图片中...");
  //           List<String> urls = model.photos.map((f) {
  //             return Api.getResizeImgUrl(f.url, 300);
  //           }).toList();
  //           ImageUtils.saveNetworkImagesToPhoto(urls, (index) {
  //             DPrint.printf("保存好了---$index");
  //           }, (success) {
  //             GSDialog.of(context).dismiss(context);
  //             success
  //                 ? GSDialog.of(context).showSuccess(context, "保存完成")
  //                 : GSDialog.of(context).showError(context, "保存失败");
  //             if (!TextUtils.isEmpty(model.text)) {
  //               ClipboardData data = new ClipboardData(text: model.text);
  //               Clipboard.setData(data);
  //               Toast.showCustomSuccess('文字内容已经保存到剪贴板');
  //               // Toast.showSuccess('文字内容已经保存到剪贴板');
  //             }
  //           });
  //         },
  //         copyListener: () {
  //           if (!TextUtils.isEmpty(model.text)) {
  //             ClipboardData data = new ClipboardData(text: model.text);
  //             Clipboard.setData(data);
  //             Toast.showCustomSuccess('文字内容已经保存到剪贴板');
  //             // showSuccess('文字内容已经保存到剪贴板');
  //           }
  //         },
  //         focusListener: () {
  //           DPrint.printf("关注或者取消关注!");
  //           _attention(model);
  //         },
  //         picListener: (index) {
  //           List<PicSwiperItem> picSwiperItem = [];
  //           for (Photos photo in model.photos) {
  //             picSwiperItem.add(PicSwiperItem(Api.getImgUrl(photo.url)));
  //           }
  //           AppRouter.fade(
  //             context,
  //             RouteName.PIC_SWIPER,
  //             arguments: PicSwiper.setArguments(
  //               index: index,
  //               pics: picSwiperItem,
  //             ),
  //           );
  //         },
  //         model: model,
  //       ),
  //     );
  //   }).toList();
  //
  //   if (UserManager.instance.haveLogin) {
  //     children.add(Container(
  //       child: Positioned(
  //         bottom: 40,
  //         child: CustomImageButton(
  //           title: "我要发布",
  //           padding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
  //           color: Colors.white,
  //           fontSize: 15 * 2.sp,
  //           backgroundColor: Color(0xFFFF2810),
  //           borderRadius: BorderRadius.all(Radius.circular(20)),
  //           onPressed: () {
  //             AppRouter.model(context, RouteName.BUSINESS_DISTRICT_PUBLISH_PAGE,
  //                 arguments: PublishBusinessDistrictPage.setArguments(
  //                     goodsId: widget.goodsID));
  //           },
  //         ),
  //       ),
  //     ));
  //   }
  //   return children;
  // }

  ///关注
  _attention(MaterialModel model) async {
    if (model.isAttention!) {
      //取消关注
      HttpResultModel<BaseModel?> resultModel =
          await GoodsDetailModelImpl.goodsAttentionCancel(
              UserManager.instance!.user.info!.id, model.userId);
      if (!resultModel.result) {
        Toast.showInfo(resultModel.msg??'');
        return;
      }
      setState(() {
        model.isAttention = false;
      });
    } else {
      //关注
      HttpResultModel<BaseModel?> resultModel =
          await GoodsDetailModelImpl.goodsAttentionCreate(
              UserManager.instance!.user.info!.id, model.userId);
      if (!resultModel.result) {
        Toast.showInfo(resultModel.msg??'');
        return;
      }
      setState(() {
        model.isAttention = true;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
