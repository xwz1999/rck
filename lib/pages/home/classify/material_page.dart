/*
 * ====================================================
 * package   : pages.home.classify
 * author    : Created by nansi.
 * time      : 2019/5/22  9:43 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/material_list_model.dart';
import 'package:jingyaoyun/pages/business/publish_business_district_page.dart';
import 'package:jingyaoyun/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:jingyaoyun/pages/home/items/item_publish_material.dart';
import 'package:jingyaoyun/third_party/wechat/wechat_utils.dart';
import 'package:jingyaoyun/utils/image_utils.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/pic_swiper.dart';
import 'package:jingyaoyun/widgets/toast.dart';

class MaterialPage extends StatefulWidget {
  final int goodsID;
  const MaterialPage({Key key, this.goodsID}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MaterialPageState();
  }
}

class _MaterialPageState extends State<MaterialPage>
    with AutomaticKeepAliveClientMixin {
  MaterialListModel _model;

  @override
  void initState() {
    print("initState ---------- Good");
    super.initState();
    int userID = 0;
    if (UserManager.instance.haveLogin) {
      userID = UserManager.instance.user.info.id;
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
    double topPadding = (DeviceInfo.statusBarHeight + DeviceInfo.appBarHeight);
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
                  itemCount: _model == null || _model.data == null
                      ? 0
                      : _model.data.length + 1,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == _model.data.length) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        color: Colors.green.withAlpha(0),
                      );
                    }
                    return _itemWidget(
                      _model.data[index],
                    );
                  }),
              !UserManager.instance.haveLogin
                  ? Container()
                  : Positioned(
                      bottom: 10,
                      child: CustomImageButton(
                        title: "????????????",
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
        downloadListener: () {
          GSDialog.of(context).showLoadingDialog(context, "???????????????...");
          List<String> urls = model.photos.map((f) {
            // return Api.getResizeImgUrl(f.url, 300);
            return Api.getResizeImgUrl(f.url, 800);
          }).toList();
          ImageUtils.saveNetworkImagesToPhoto(urls, (index) {
            DPrint.printf("????????????---$index");
          }, (success) {
            GSDialog.of(context).dismiss(context);
            success
                ? GSDialog.of(context).showSuccess(context, "????????????!")
                : GSDialog.of(context).showError(context, "????????????...");
            // if (!TextUtils.isEmpty(model.text)) {
            //   ClipboardData data = new ClipboardData(text: model.text);
            //   Clipboard.setData(data);
            //   Toast.showCustomSuccess('????????????????????????????????????');
            //   // Toast.showSuccess('????????????????????????????????????');
            // }
          });
        },
        copyListener: () {
          if (!TextUtils.isEmpty(model.text)) {
            ClipboardData data = new ClipboardData(text: model.text);
            Clipboard.setData(data);
            Toast.showCustomSuccess('????????????????????????????????????');
            // showSuccess('????????????????????????????????????');
          }
        },
        focusListener: () {
          DPrint.printf("????????????????????????!");
          _attention(model);
        },
        picListener: (index) {
          List<PicSwiperItem> picSwiperItem = [];
          for (Photos photo in model.photos) {
            picSwiperItem.add(PicSwiperItem(Api.getImgUrl(photo.url)));
          }
          AppRouter.fade(
            context,
            RouteName.PIC_SWIPER,
            arguments: PicSwiper.setArguments(
              index: index,
              pics: picSwiperItem,
            ),
          );
        },
        model: model,
      ),
    );
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
  //           GSDialog.of(context).showLoadingDialog(context, "???????????????...");
  //           List<String> urls = model.photos.map((f) {
  //             return Api.getResizeImgUrl(f.url, 300);
  //           }).toList();
  //           ImageUtils.saveNetworkImagesToPhoto(urls, (index) {
  //             DPrint.printf("????????????---$index");
  //           }, (success) {
  //             GSDialog.of(context).dismiss(context);
  //             success
  //                 ? GSDialog.of(context).showSuccess(context, "????????????")
  //                 : GSDialog.of(context).showError(context, "????????????");
  //             if (!TextUtils.isEmpty(model.text)) {
  //               ClipboardData data = new ClipboardData(text: model.text);
  //               Clipboard.setData(data);
  //               Toast.showCustomSuccess('????????????????????????????????????');
  //               // Toast.showSuccess('????????????????????????????????????');
  //             }
  //           });
  //         },
  //         copyListener: () {
  //           if (!TextUtils.isEmpty(model.text)) {
  //             ClipboardData data = new ClipboardData(text: model.text);
  //             Clipboard.setData(data);
  //             Toast.showCustomSuccess('????????????????????????????????????');
  //             // showSuccess('????????????????????????????????????');
  //           }
  //         },
  //         focusListener: () {
  //           DPrint.printf("????????????????????????!");
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
  //           title: "????????????",
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

  ///??????
  _attention(MaterialModel model) async {
    if (model.isAttention) {
      //????????????
      HttpResultModel<BaseModel> resultModel =
          await GoodsDetailModelImpl.goodsAttentionCancel(
              UserManager.instance.user.info.id, model.userId);
      if (!resultModel.result) {
        Toast.showInfo(resultModel.msg);
        return;
      }
      setState(() {
        model.isAttention = false;
      });
    } else {
      //??????
      HttpResultModel<BaseModel> resultModel =
          await GoodsDetailModelImpl.goodsAttentionCreate(
              UserManager.instance.user.info.id, model.userId);
      if (!resultModel.result) {
        Toast.showInfo(resultModel.msg);
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
