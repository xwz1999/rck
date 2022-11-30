import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/models/material_list_model.dart';
import 'package:recook/pages/business/focus/mvp/focus_mvp_contact.dart';
import 'package:recook/pages/business/focus/mvp/focus_presenter_implementation.dart';
import 'package:recook/pages/business/items/item_business_focus.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/pages/home/promotion_time_tool.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/pic_swiper.dart';
import 'package:recook/widgets/share_page/post_all.dart';
import 'package:recook/widgets/toast.dart';
import 'package:permission_handler/permission_handler.dart';




class FocusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FocusPageState();
  }
}

class _FocusPageState extends BaseStoreState<FocusPage>
    with MvpListViewDelegate<MaterialModel>
    implements FocusViewI {
  FocusPresenterImpl? _presenter;
  MvpListViewController<MaterialModel>? _listViewController;
  List<MainPhotos> _selectPhotos = [];
  GoodsDetailModel? _goodsDetail;
  int _goodsId = 0;
  String _bigImageUrl = "";


  // _getDetail(int goodsId) async {
  //   _goodsDetail = await GoodsDetailModelImpl.getDetailInfo(
  //       goodsId, UserManager.instance.user.info.id);
  //   if (_goodsDetail.code != HttpStatus.SUCCESS) {
  //     Toast.showError(_goodsDetail.msg);
  //     return;
  //   }
  //   // _bottomBarController.setFavorite(_goodsDetail.data.isFavorite);
  //   MainPhotos photo = _goodsDetail.data.mainPhotos[0];
  //   if (_goodsDetail.data.mainPhotos.length >= 1) {
  //     photo = _goodsDetail.data.mainPhotos[0];
  //   }
  //   photo.isSelect = true;
  //   photo.isSelectNumber = 1;
  //   _bigImageUrl = Api.getImgUrl(photo.url);
  //   _selectPhotos.add(photo);
  //   setState(() {});
  //
  //   _capturePng();
  // }

  @override
  void initState() {
    super.initState();
    _presenter = FocusPresenterImpl();
    _presenter!.attach(this);
    _listViewController = MvpListViewController();
    int? userId = UserManager.instance!.user.info!.id;
    _presenter!.fetchList(userId, 0);
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    int? userId = 0;
    if (UserManager.instance!.haveLogin)
      userId = UserManager.instance!.user.info!.id;
    return Container(
      color: AppColor.frenchColor,
      child: MvpListView<MaterialModel>(
        autoRefresh: false,
        delegate: this,
        controller: _listViewController,
        refreshCallback: () {
          _presenter!.fetchList(userId, 0);
        },
        loadMoreCallback: (int page) {
          _presenter!.fetchList(userId, page);
        },
        itemBuilder: (_, index) {
          MaterialModel indexModel = _listViewController!.getData()[index];
          return Column(
            children: [
              BusinessFocusItem(
                model: indexModel,
                publishMaterialListener: () {
                  Get.to(()=>CommodityDetailPage(arguments:
                  CommodityDetailPage.setArguments(indexModel.goods!.id)));
                },
                downloadListener: (ByteData byteData) async{
                  await _capturePng(byteData);

                  List<String> urls = indexModel.photos!.map((f) {
                    return Api.getResizeImgUrl(f.url!, 800);
                  }).toList();
                  print(urls);

                 await ImageUtils.saveNetworkImagesToPhoto(urls, (index) {
                   BotToast.closeAllLoading();
                   if(index==99){

                     BotToast.showText(text: '图片保存失败');
                   }else{

                     DPrint.printf("保存好了---$index");
                   }

                  }, (success) {
                    BotToast.closeAllLoading();
                    //dismissLoading();
                    success
                        ? showSuccess("保存完成!")
                        : Alert.show(
                            context,
                            NormalContentDialog(
                              title: '提示',
                              content: Text(
                                '图片保存失败，请前往应用权限页，设置存储权限为始终允许',
                                style: TextStyle(
                                    color: Color(0xFF333333), fontSize: 14.rsp),
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

                  //   if (!TextUtils.isEmpty(indexModel.text)) {
                  //     ClipboardData data = new ClipboardData(text: indexModel.text);
                  //     Clipboard.setData(data);
                  //     Toast.showCustomSuccess('文字内容已经保存到剪贴板');
                  //     showSuccess('文字内容已经保存到剪贴板');
                  // }
                 });
                },
                copyListener: () {
                  if (!TextUtils.isEmpty(indexModel.text)) {
                    ClipboardData data = new ClipboardData(text: indexModel.text);
                    Clipboard.setData(data);
                    Toast.showCustomSuccess('文字内容已经保存到剪贴板');
                    // showSuccess('文字内容已经保存到剪贴板');
                  }
                },
                picListener: (index) {
                  List<PicSwiperItem> picSwiperItem = [];
                  for (Photos photo in indexModel.photos!) {
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
                focusListener: () {
                  _attention(_listViewController!.getData()[index]);
                },
              ),
              // _getPoster()
            ],
          );
        },
        noDataView: NoDataView(
          title: "暂时没有动态~",
          height: 500,
        ),
      ),
    );
  }

  //
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

  @override
  MvpListViewPresenterI<MaterialModel, MvpView, MvpModel>? getPresenter() {
    return _presenter;
  }

  @override
  void onDetach() {}

  @override
  void onAttach() {}
///
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
        showError("图片获取失败...");
        return;
      }

      await ImageUtils.saveImage( [pngBytes], (index) {

      }, (success,path) {

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

  _getPoster(){
    double postImageHorizontalMargin = 30;
    double postHorizontalMargin = 50;
    double postWidth = 300 - postHorizontalMargin;
    double truePhotoWidth = postWidth - postImageHorizontalMargin;
    double truePhotoHeight = truePhotoWidth;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width,
      height: 480.rw,
      child: Column(
        children: <Widget>[
          UserManager.instance!.homeWeatherModel != null
              ? Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              top: postImageHorizontalMargin / 2,
            ),
            height: 43.rw,
            child: PostWeatherWidget(
              homeWeatherModel: UserManager.instance!.homeWeatherModel,
            ),
          )
              : Container(),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: PostUserInfo(
              name: UserManager.instance!.user.info!.nickname! + "的店铺",
              gysId: _goodsDetail!.data!.vendorId,
            ),
          ),
          Container(
            color: AppColor.frenchColor,
            width: truePhotoWidth,
            height: truePhotoHeight,
            child: CachedNetworkImage(
              imageUrl: _bigImageUrl,
            ),
          ),
          PostBannerInfo(
            timeInfo: _getTimeInfo(),
          ),
          PostBottomWidget(
            goodsDetailModel: _goodsDetail,
          ),
          Container(
            height: postImageHorizontalMargin / 2,
          ),
        ],
      ),
    );
  }

  String _getTimeInfo() {
    if (_goodsDetail!.data!.promotion != null &&
        _goodsDetail!.data!.promotion!.id! > 0) {
      if (PromotionTimeTool.getPromotionStatusWithGoodDetailModel(
          _goodsDetail!) ==
          PromotionStatus.start) {
        //活动中
        DateTime endTime = DateTime.parse(_goodsDetail!.data!.promotion!.endTime!);
        return "结束时间\n${DateUtil.formatDate(endTime, format: 'M月d日 HH:mm')}";
      }
      if (PromotionTimeTool.getPromotionStatusWithGoodDetailModel(
          _goodsDetail!) ==
          PromotionStatus.ready) {
        DateTime startTime =
        DateTime.parse(_goodsDetail!.data!.promotion!.startTime!);
        return "开始时间\n${DateUtil.formatDate(startTime, format: 'M月d日 HH:mm')}";
      }
    }
    return "";
  }

}
