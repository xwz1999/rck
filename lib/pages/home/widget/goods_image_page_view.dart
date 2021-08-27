/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/3  3:19 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/models/goods_simple_list_model.dart';
import 'package:recook/pages/live/live_stream/live_stream_view_page.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/pic_swiper.dart';
import 'package:recook/widgets/seckill_activity_widget/live_animate_widget.dart';
import 'package:recook/widgets/toast.dart';
import 'package:recook/widgets/video_view.dart';

typedef OnScrolledListener = Function(int index);

class ImagePageView extends StatefulWidget {
  final OnScrolledListener onScrolled;
  final List<dynamic> images;

  final Living living;

  // final Video video;

  ImagePageView({
    Key key,
    this.onScrolled,
    this.images,
    this.living,
  }) : assert(images != null && images.length > 0, "images 不能为空");

  @override
  State<StatefulWidget> createState() {
    return _ImagePageViewState();
  }
}

class _ImagePageViewState extends State<ImagePageView> {
  double _width = DeviceInfo.screenWidth;
  int _imageIndex = 1;
  List<dynamic> photoList = [];
  List<PicSwiperItem> picSwiperItem = [];
  @override
  void initState() {
    for (dynamic photo in widget.images) {
      if (photo is MainPhotos) {
        photoList.add(photo);
        // picSwiperItem.add(PicSwiperItem(Api.getResizeImgUrl(photo.url, DeviceInfo.screenWidth.toInt()*2)));
        picSwiperItem.add(PicSwiperItem(Api.getImgUrl(photo.url)));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _headPageView();
  }

  _headPageView() {
    return Container(
      width: double.infinity,
      height: _width,
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          return true;
        },
        child: Stack(children: [
          PageView(
              onPageChanged: (index) {
                setState(() {
                  _imageIndex = index + 1;
                });
              },
              children: widget.images.map<Widget>((image) {
                if (image is MainPhotos) {
                  return CustomCacheImage(
                      imageClick: () {
                        AppRouter.fade(
                          context,
                          RouteName.PIC_SWIPER,
                          arguments: PicSwiper.setArguments(
                            index: photoList.indexOf(image),
                            pics: picSwiperItem,
                          ),
                        );
                      },
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: AppImageName.placeholder_1x1,
                      imageUrl: Api.getImgUrl(image.url));
                  // imageUrl: Api.getResizeImgUrl(image.url, DeviceInfo.screenWidth.toInt() * 2));
                } else if (image is Video) {
                  // return Container(height: double.infinity, width: double.infinity,);
                  return VideoView(
                    videoUrl: Api.getImgUrl(image.url),
                  );
                } else {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                  );
                }
                // imageUrl: Api.getImgUrl(image.url),);
              }).toList()),
          Positioned(
              bottom: 35,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                decoration: BoxDecoration(
                    color: Color.fromARGB(100, 0, 0, 0),
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(20))),
                child: _imageCount(),
              )),
          widget.living.status == 1
              ? Positioned(
                  top: 60.rw,
                  right: 35.rw,
                  child: InkWell(
                    onTap: widget.living.roomId != 0
                        ? () {
                            Get.to(
                                LiveStreamViewPage(id: widget.living.roomId));
                          }
                        : () {
                            Toast.showError('找不到该直播间！');
                            print('1');
                          },
                    child: Container(
                      width: 50.rw,
                      height: 69.rw,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7.rw)),
                          color: Colors.white),
                      child: Column(
                        children: [
                          10.hb,
                          Container(
                            width: 35.rw,
                            height: 35.rw,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(0xFFFF0000),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.rw))),
                            child: LiveAnimateWidget(
                              size: 50.w,
                            ),
                          ),
                          10.hb,
                          Text(
                            '直播中',
                            style: TextStyle(
                                fontSize: 10.rsp, color: Color(0xFF333333)),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          widget.living.status == 1
              ? Positioned(
                  top: 50.rw,
                  right: 35.rw,
                  child: InkWell(
                    onTap: widget.living.roomId != 0
                        ? () {
                            Get.to(
                                LiveStreamViewPage(id: widget.living.roomId));
                          }
                        : () {
                            Toast.showError('找不到该直播间！');
                            print('2');
                          },
                    child: Container(
                      width: 60.rw,
                      height: 70.rw,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7.rw)),
                          color: Colors.transparent),
                    ),
                  ),
                )
              : SizedBox(),
        ]),
      ),
    );
  }

  _imageCount() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: _imageIndex.toString(),
        style: TextStyle(
            color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w700),
        children: <TextSpan>[
          TextSpan(
              text: ' / ${widget.images.length}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
