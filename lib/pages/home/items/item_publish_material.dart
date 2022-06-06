/*
 * ====================================================
 * package   : pages.home.items
 * author    : Created by nansi.
 * time      : 2019/5/28  3:38 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:typed_data';
import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/models/material_list_model.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/utils/permission_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/nine_grid_view.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/share_page/post_all.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widget_to_image/widget_to_image.dart';

import '../promotion_time_tool.dart';

class PublishMaterialItem extends StatefulWidget {
  final VoidCallback? focusListener;
  // final VoidCallback publishMaterialListener;
  final void Function(Goods)? publishMaterialListener;
  final Function(ByteData) downloadListener;
  final VoidCallback? copyListener;
  final VoidCallback? moreListener;
  final void Function(int index)? picListener;
  final MaterialModel? model;

  const PublishMaterialItem(
      {Key? key,
      this.focusListener,
      this.publishMaterialListener,
      required this.downloadListener,
      this.moreListener,
      this.picListener,
      this.model,
      this.copyListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PublishMaterialItemState();
  }
}

class _PublishMaterialItemState extends State<PublishMaterialItem> {
  // bool _focused;
  ByteData? byteData;
  List<MainPhotos> _selectPhotos = [];
  GoodsDetailModel? _goodsDetail;
  String? _bigImageUrl = "";
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _goodsDetail = await GoodsDetailModelImpl.getDetailInfo(
          widget.model!.goodsId, UserManager.instance!.user.info!.id);
      if (_goodsDetail!.code != HttpStatus.SUCCESS) {
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

    });
    // _focused = false;
  }

  @override
  Widget build(BuildContext context) {
    // List<String> list = [
    //   "http://pic1.rwin4000.com/mobile/2019-05-16/5cdd0991ec539.jpg",
    //   "http://img.tukexw.com/img/2c95d3d0d00cde29.jpg"
    // ];
    // int index11 = Random().nextInt(2);
    // int itemCount = Random().nextInt(5) + 1;
    int itemCount = widget.model!.photos!.length;
    Color? focusedColor =
        !widget.model!.isAttention! ? Color(0xFFFF1E31) : Colors.grey[600];

    return Container(
      margin: EdgeInsets.only(bottom: 5, top: 5),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: FadeInImage.assetNetwork(
                  height: 40.rw,
                  width: 40.rw,
                  placeholder: Assets.icon.icLauncherPlaystore.path,
                  image: Api.getResizeImgUrl(widget.model!.headImgUrl!, 300),
                ),
              ),
              Container(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.model!.nickname!,
                      style: AppTextStyle.generate(15),
                    ),
                    Text(
                      widget.model!.createdAt!,
                      style: AppTextStyle.generate(12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // widget.model.isOfficial
              //     ? Container()
              //     : CustomImageButton(
              //         title: widget.model.isAttention ? "已关注" : "关注",
              //         color: focusedColor,
              //         padding: EdgeInsets.symmetric(horizontal: 8),
              //         borderRadius: BorderRadius.all(Radius.circular(5)),
              //         border: Border.all(color: focusedColor, width: 0.8),
              //         onPressed: () {
              //           setState(() {
              //             // _focused = !_focused;
              //             widget.focusListener();
              //           });
              //         },
              //       )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                NineGridView(
                  builder: (context, index) {
                    return CustomCacheImage(
                        imageClick: () {
                          // DPrint.printf("点击了图片——————${widget.model.photos[index].url}");
                          widget.picListener!(index);
                        },
                        // imageUrl: list[index11],
                        imageUrl: Api.getResizeImgUrl(
                            widget.model!.photos![index].url!, 300),
                        placeholder: AppImageName.placeholder_1x1,
                        fit: itemCount != 1 ? BoxFit.cover : BoxFit.scaleDown);
                  },
                  type: GridType.weChat,
                  itemCount: itemCount,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    widget.model!.text!,
                    style: AppTextStyle.generate(15,
                        color: Colors.grey[700], fontWeight: FontWeight.w300),
                    maxLines: 100,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _bottomItems()
              ],
            ),
          )
        ],
      ),
    );
  }

  Row _bottomItems() {
    if (!UserManager.instance!.haveLogin) {
      return Row(
        children: <Widget>[
          Container(
            height: 1,
          )
        ],
      );
    }
    return Row(
      children: <Widget>[
        // CustomImageButton(
        //   icon: Icon(
        //     AppIcons.icon_wx_circle,
        //     size: 20,
        //   ),
        //   height: 30,
        //   title: "一键发圈",
        //   direction: Direction.horizontal,
        //   color: Colors.white,
        //   fontSize: 12*2.sp,
        //   backgroundColor: AppColor.themeColor,
        //   contentSpacing: 8,
        //   borderRadius: BorderRadius.all(Radius.circular(20)),
        //   padding: EdgeInsets.symmetric(horizontal: 10),
        //   onPressed: () {
        //     if (widget.publishMaterialListener != null && widget.model.goods != null) widget.publishMaterialListener(widget.model.goods);
        //   },
        // ),
        // Container(
        //   width: 10,
        // ),
        CustomImageButton(
          icon: Icon(
            AppIcons.icon_download,
            size: 16,
          ),
          height: 30,
          title: "下载发圈",
          direction: Direction.horizontal,
          color: Colors.black,
          fontSize: 12 * 2.sp,
          backgroundColor: Color(0xFFF3F3F3),
          contentSpacing: 8,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          padding: EdgeInsets.symmetric(horizontal: 12),
          onPressed: () async {
            bool permission = await Permission.storage.isGranted;
            if(!permission){
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

                      var cancel =  ReToast.loading(text:'保存图片中...' );
                      byteData = await WidgetToImage.widgetToImage( Directionality(
                        textDirection: TextDirection.ltr,
                        child: Material(
                            child:_getPoster()
                        ),
                      ),pixelRatio: window.devicePixelRatio,size: Size(370.rw,500.rw));

                      await Future.delayed(Duration(seconds: 1));

                      byteData = await WidgetToImage.widgetToImage( Directionality(
                        textDirection: TextDirection.ltr,
                        child: Material(
                            child:_getPoster()
                        ),
                      ),pixelRatio: window.devicePixelRatio,size: Size(370.rw,500.rw));

                      widget.downloadListener(byteData! );
                    }
                  },
                  type: NormalTextDialogType.delete,
                ),
              );

            }else{

              var cancel =  ReToast.loading(text:'保存图片中...' );
              byteData = await WidgetToImage.widgetToImage( Directionality(
                textDirection: TextDirection.ltr,
                child: Material(
                    child:_getPoster()
                ),
              ),pixelRatio: window.devicePixelRatio,size: Size(370.rw,500.rw));

              await Future.delayed(Duration(seconds: 1));

              byteData = await WidgetToImage.widgetToImage( Directionality(
                textDirection: TextDirection.ltr,
                child: Material(
                    child:_getPoster()
                ),
              ),pixelRatio: window.devicePixelRatio,size: Size(370.rw,500.rw));

              widget.downloadListener(byteData! );
            }
            //widget.downloadListener();
          },
        ),
        SizedBox(
          width: 20,
        ),
        CustomImageButton(
          icon: Icon(
            Icons.content_copy,
            size: rSize(16),
          ),
          height: rSize(30),
          title: "复制文字",
          direction: Direction.horizontal,
          color: Colors.black,
          fontSize: 12 * 2.sp,
          backgroundColor: Color(0xFFF3F3F3),
          contentSpacing: 8,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          padding: EdgeInsets.symmetric(horizontal: 12),
          onPressed: () {
            widget.copyListener!();
          },
        ),
        Expanded(child: Container()),
        // IconButton(
        //     icon: Icon(
        //       AppIcons.icon_ellipsis,
        //       size: 20,
        //       color: Colors.grey[700],
        //     ),
        //     onPressed: () {
        //       DPrint.printf("obj");
        //     })
      ],
    );
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
      width: 370.rw,
      height: 500.rw,
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
          PostBigImage(
            url: _bigImageUrl,
            imageSize: Size(truePhotoWidth, truePhotoHeight),
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
