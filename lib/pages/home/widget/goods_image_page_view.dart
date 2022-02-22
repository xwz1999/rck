
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/models/goods_detail_model.dart';
import 'package:jingyaoyun/models/goods_simple_list_model.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/pic_swiper.dart';
import 'package:jingyaoyun/widgets/video_view.dart';

typedef OnScrolledListener = Function(int index);

class ImagePageView extends StatefulWidget {
  final OnScrolledListener onScrolled;
  final List<dynamic> images;


  // final Video video;

  ImagePageView({
    Key key,
    this.onScrolled,
    this.images,
  });
  //: assert(images != null && images.length > 0, "images 不能为空");

  @override
  State<StatefulWidget> createState() {
    return _ImagePageViewState();
  }
}

class _ImagePageViewState extends State<ImagePageView> with TickerProviderStateMixin {
  double _width = DeviceInfo.screenWidth;
  int _imageIndex = 1;
  List<dynamic> photoList = [];
  List<PicSwiperItem> picSwiperItem = [];
  GifController _gifController;
  @override
  void initState() {
    _gifController= GifController(vsync: this)
      ..repeat(
        min: 0,
        max: 20,
        period: Duration(milliseconds: 700),
      );
    for (dynamic photo in widget.images) {
      if (photo is MainPhotos) {
        photoList.add(photo);
        // picSwiperItem.add(PicSwiperItem(Api.getResizeImgUrl(photo.url, DeviceInfo.screenWidth.toInt()*2)));
        picSwiperItem.add(PicSwiperItem(Api.getImgUrl(photo.url,print: true),));
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
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
