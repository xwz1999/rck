
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/rectIndicator.dart';

typedef BannerBuilder = Widget Function(BuildContext context, dynamic item);

class BannerListView<T> extends StatefulWidget {
  final int delayTime; //间隔时间秒
  final int scrollTime; //滑动耗时毫秒
  final double height; //banner高度
  final List<T> data; //banner内容
  final BannerBuilder builder;
  final Color backgroundColor;
  final double radius;
  final EdgeInsets margin;
  final Function(int) onPageChanged;
  BannerListView(
      {Key key,
      @required this.data,
      this.delayTime = 4,
      this.scrollTime = 400,
      this.height = 200.0,
      this.margin = const EdgeInsets.all(8),
      this.radius = 0,
      this.backgroundColor = Colors.transparent,
      this.onPageChanged,
      @required this.builder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new BannerListViewState<T>(builder);
  }
}

class BannerListViewState<T> extends State<BannerListView> {

  final BannerBuilder builder;

  BannerListViewState(this.builder);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      height: widget.height,
      color: widget.backgroundColor,
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          child: widget.data == null || widget.data.length == 0
              ? Container()
              :
          _homeSwiper()
      ),
    );
  }

  List<Widget> _buildBanners(BuildContext context) {
    List<Widget> banners = [];
    widget.data.forEach((data) {
      banners.add(widget.builder(context, data));
    });
    return banners;
  }


  Widget _homeSwiper() {
    return Container(
      width: double.infinity,
      height: 320.w,
      child: AspectRatio(
        aspectRatio: 375 / 160,
        child: Swiper(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            return _buildBanners(context)[index];
          },
          index: 1,
          duration: 2,
          onIndexChanged: (int index){
            if (widget.onPageChanged != null) {
              widget.onPageChanged(index);
            }
          },
          pagination: SwiperPagination(
              alignment: Alignment.bottomRight,
              builder: SwiperCustomPagination(
                  builder: (BuildContext context, SwiperPluginConfig config) {
                    return RectIndicator(
                      position: config.activeIndex,
                      count:  widget.data.length,
                      activeColor: Color(0x99FFFFFF),
                      color: Color(0xD9FFFFFF),
                      //未选中 指示器颜色，选中的颜色key为Color
                      width: 4,
                      //指示器宽度
                      activeWidth: 14,
                      //选中的指示器宽度
                      radius: 4,
                      //指示器圆角角度
                      height: 4,
                    ); //指示器高度
                  })),
          scrollDirection: Axis.horizontal,
          // control: new SwiperControl(),
          autoplay: true,

          onTap: (index) {
            // Get.to(() =>
            //     PublicInformationDetailPage(id: _swiperModels[index].newsId!));
          },
          itemCount: widget.data.length,
        ),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
  }
}
