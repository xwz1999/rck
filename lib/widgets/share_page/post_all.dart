import 'package:extended_image/extended_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/app_image_resources.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/models/home_weather_model.dart';
import 'package:recook/models/missing_children_model.dart';
import 'package:recook/pages/home/promotion_time_tool.dart';
import 'package:lunar_calendar_converter/lunar_solar_converter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../custom_cache_image.dart';

// 天气信息
class PostWeatherWidget extends StatelessWidget {
  final HomeWeatherModel homeWeatherModel;
  const PostWeatherWidget({Key key, this.homeWeatherModel}) : super(key: key);

  static final TextStyle textStyle =
      TextStyle(color: Colors.black, fontSize: 10 * 2.sp);
  _normalText(str) {
    if (TextUtils.isEmpty(str)) {
      return "";
    }
    return str;
  }

  // _getWeatherImage(weaImg) {
  //   return "assets/weatherCake/$weaImg.png";
  // }

  @override
  Widget build(BuildContext context) {
    DateTime nowDateTime = DateTime.now();
    Solar solar = Solar(
        solarYear: nowDateTime.year,
        solarDay: nowDateTime.day,
        solarMonth: nowDateTime.month);
    Lunar lunar = LunarSolarConverter.solarToLunar(solar);
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "[${_normalText(homeWeatherModel.city)}]" +
                    "天气:" +
                    _normalText(homeWeatherModel.wea),
                style: textStyle,
              ),
              Container(width: 2),
              // ColorFiltered(
              //   colorFilter: ColorFilter.mode(Colors.black, BlendMode.screen),
              //   child: Container(
              //     color: Colors.black,
              //     child: Image.asset(_getWeatherImage(_normalText(homeWeatherModel.weaImg)), height: 10, width: 10,),
              //   ),
              // ),
              Spacer(),
              Text(
                lunar.toString(),
                style: textStyle,
              ),
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                child: ExtendedText.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text:
                              "湿度:${_normalText(homeWeatherModel.humidity)} 温度:${_normalText(homeWeatherModel.tem2)}-${_normalText(homeWeatherModel.tem1)}℃",
                          style: textStyle),
                      // TextSpan(text:"  温度:${_normalText(widget.homeWeatherModel.tem2)}-${_normalText(widget.homeWeatherModel.tem1)}℃", style: textStyle),
                      // WidgetSpan(
                      //   child: Container(
                      //     margin: EdgeInsets.only(left: 5, right: 2),
                      //     child: Image.asset("assets/weatherCake/airquality.png", height: 11, width: 11,),
                      //   ),
                      // ),
                      // TextSpan(text:"${_normalText(homeWeatherModel.air)}${_normalText(homeWeatherModel.airLevel)}", style: textStyle),
                      TextSpan(
                          text:
                              " 空气质量:${_normalText(homeWeatherModel.airLevel)}",
                          style: textStyle),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                    "${nowDateTime.year}.${nowDateTime.month}.${nowDateTime.day}${_normalText(homeWeatherModel.week)}",
                    style: textStyle),
              )
              // Expanded(
              //   child: Container(
              //     alignment: Alignment.centerRight,
              //     child: Text("${nowDateTime.year}.${nowDateTime.month}.${nowDateTime.day}${_normalText(homeWeatherModel.week)}", style: textStyle),
              //   )
              // ),
            ],
          ),
        ],
      ),
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: <Widget>[
      //     Flex(
      //       direction: Axis.horizontal,
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: <Widget>[
      //         Container(
      //           alignment: Alignment.centerLeft,
      //           child: Text(topLeftString, style: style,),
      //         ),
      //         Text("data"),
      //         Text("data"),
      //       ],
      //     )
      //   ],
      // ),
    );
  }
}

// 用户信息
class PostUserInfo extends StatelessWidget {
  final String name;
  final int gysId;
  const PostUserInfo({Key key, this.name = "瑞库客", this.gysId}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    String title = "数字化批发零售服务平台";
    return Container(
      height: gysId==1800||gysId==2000?50:40,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(Assets.icon.icLauncherPlaystore.path),
            ),
            Container(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  gysId==1800||gysId==2000?
                  Container(
                      padding: EdgeInsets.only(right: 5.rw),
                      child:
                      Container(
                        width: 46.rw,
                        height: 14.rw,
                        padding: EdgeInsets.only(left: 1.rw),

                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xFFC92219),
                          borderRadius: BorderRadius.all(Radius.circular(2.rw)),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFFE54A32),Color(0xFFBD3320)]
                          )

                        ),

                        child: Text(
                          gysId==1800?'京东自营':gysId==2000?'京东优选':'',
                          maxLines: 1,
                          style: TextStyle(fontSize: 10.rsp,height:1.05),
                        ),
                      )
                  ):SizedBox(),
                  Text(
                    name,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                  Spacer(),
                  Text(
                    title,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff666666),
                      fontSize: 10.rw,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PostBigImage extends StatefulWidget {
  final Size imageSize;
  final String url;
  PostBigImage({
    Key key,
    this.imageSize = const Size(0, 0),
    this.url = "",
  }) : super(key: key);

  @override
  _PostBigImageState createState() => _PostBigImageState();
}

class _PostBigImageState extends State<PostBigImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        color: AppColor.frenchColor,
        width: widget.imageSize.width,
        height: widget.imageSize.height,
        child: ExtendedImage.network(
          widget.url,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}

class PostBannerInfo extends StatelessWidget {
  final String timeInfo;
  const PostBannerInfo({Key key, this.timeInfo = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: _body(),
    );
  }

  _body() {
    List<Widget> widgetList = [];
    double bannerHeight = 45.rw;
    double rightBannerWidth = 100.rw;
    String rightBannerImage = "assets/post_right_banner.png";
    String leftBannerImage = "assets/post_left_banner.png";
    if (!TextUtils.isEmpty(timeInfo)) {
      widgetList.add(Positioned(
        right: 0,
        top: 0,
        bottom: 0,
        width: rightBannerWidth,
        child: Image.asset(
          rightBannerImage,
          width: rightBannerWidth,
          fit: BoxFit.fill,
        ),
      ));
      widgetList.add(Positioned(
        right: 0,
        top: 0,
        bottom: 0,
        width: rightBannerWidth,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            timeInfo,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: Colors.white,
              textBaseline: TextBaseline.alphabetic,
              fontSize: 10.0,
            ),
          ),
        ),
      ));
      widgetList.add(Positioned(
        width: ScreenUtil().screenWidth - 80 - rightBannerWidth + 15,
        left: 0,
        top: 0,
        bottom: 0,
        child: Image.asset(
          leftBannerImage,
          fit: BoxFit.fill,
        ),
      ));
      widgetList.add(Positioned(
          width: ScreenUtil().screenWidth - 80 - rightBannerWidth + 15,
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "全球精品 正品保障 售后无忧",
              textAlign: TextAlign.left,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 14 * 2.sp,
                  color: Colors.white,
                  textBaseline: TextBaseline.alphabetic),
            ),
          )));
    } else {
      widgetList.add(
        Image.asset(
          leftBannerImage,
          fit: BoxFit.fill,
          width: double.infinity,
        ),
      );
      widgetList.add(Container(
        alignment: Alignment.center,
        child: Text(
          "全球精品 | 正品保障 | 售后无忧",
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
              fontSize: 14 * 2.sp,
              color: Colors.white,
              textBaseline: TextBaseline.alphabetic),
        ),
      ));
    }
    return Container(
      width: double.infinity,
      height: bannerHeight,
      child: Stack(
        children: widgetList,
      ),
    );
  }
}

class PostBottomWidget extends StatelessWidget {
  final GoodsDetailModel goodsDetailModel;
  const PostBottomWidget({Key key, this.goodsDetailModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(AppConfig.debug);
    String qrCode =
        "${AppConfig.debug ? WebApi.testGoodsDetail : WebApi.goodsDetail}${goodsDetailModel.data.id}/${UserManager.instance.user.info.invitationNo}";
    print(qrCode);
    String info = goodsDetailModel.data.goodsName;
    String crossedPrice =
        goodsDetailModel.data.price.max.originalPrice.toStringAsFixed(2);
    String price = goodsDetailModel.data.getPriceString();

    return Container(
      height: 95.rw,
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "¥$price ",
                            style: TextStyle(
                              color: Color(0xffff0000),
                              fontSize: 18,
                            )),
                        TextSpan(
                            text: "¥$crossedPrice",
                            style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              color: Color(0xff999999),
                            ))
                      ])),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    info,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xff333333),
                    ),
                  ),
                )
              ],
            ),
          )),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                QrImage(
                  padding: EdgeInsets.all(0),
                  data: qrCode,
                  size: 60,
                  gapless: true,
                ),
                10.hb,
                Container(
                    // margin: EdgeInsets.only(top: 5),
                    child: Text(
                  "长按二维码立购",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8,
                    color: Color(0xff333333),
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PostBottomImagesController {
  Function(List<MainPhotos>) changeImage;
}

class PostBottomImages extends StatefulWidget {
  final List<MainPhotos> selectPhotos;
  final double width;
  final PostBottomImagesController controller;
  PostBottomImages({
    Key key,
    this.selectPhotos,
    this.width = 0,
    this.controller,
  }) : super(key: key);
  @override
  _PostBottomImagesState createState() => _PostBottomImagesState();
}

class _PostBottomImagesState extends State<PostBottomImages> {
  List<String> photos = [];
  @override
  void initState() {
    super.initState();
    // for (int i = 0; i < widget.selectPhotos.length; i++) {
    //   if (i>0) photos.add(Api.getImgUrl(widget.selectPhotos[i].url));
    // }
    if (widget.controller != null) {
      widget.controller.changeImage = (list) {
        photos = [];
        for (int i = 0; i < list.length; i++) {
          if (i > 0) photos.add(Api.getImgUrl(list[i].url));
        }
        setState(() {});
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: _imageWidget(),
    );
  }

  _imageWidget() {
    if (photos.length == 0) {
      return Container();
    }
    if (photos.length == 1) {
      return Container(
        color: AppColor.frenchColor,
        height: widget.width,
        child: ExtendedImage.network(photos[0]),
      );
    }
    if (photos.length == 4) {
      return Container(
        width: widget.width,
        height: widget.width,
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          //水平子Widget之间间距
          crossAxisSpacing: 0.0,
          //垂直子Widget之间间距
          mainAxisSpacing: 0.0,
          //GridView内边距
          padding: EdgeInsets.all(00.0),
          //一行的Widget数量
          crossAxisCount: 2,
          //子Widget宽高比例
          childAspectRatio: 1.0,
          //子Widget列表
          children: _imagesRow(),
        ),
      );
    }
    return Container(
      width: widget.width,
      height: widget.width / photos.length,
      child: Row(
        children: _imagesRow(),
      ),
    );
  }

  _imagesRow() {
    List<Widget> list = [];
    for (String url in photos) {
      list.add(Container(
        color: AppColor.frenchColor,
        child: ExtendedImage.network(url),
      ));
    }
    return list;
  }
}

class PostAllWidgetController {
  Function(List<MainPhotos>) refreshWidget;
}

class PostAllWidget extends StatefulWidget {
  final PostAllWidgetController controller;
  final GoodsDetailModel goodsDetailModel;
  final String bigImageUrl;
  final List<MainPhotos> selectImagePhotos;
  final MissingChildrenModel missingChildrenModel;
  PostAllWidget(
      {Key key,
      this.goodsDetailModel,
      this.bigImageUrl = "",
      this.selectImagePhotos,
      this.controller,
      this.missingChildrenModel})
      : super(key: key);

  @override
  _PostAllWidgetState createState() => _PostAllWidgetState();
}

class _PostAllWidgetState extends State<PostAllWidget> {
  double postImageHorizontalMargin = 30;
  double postHorizontalMargin = 50;
  PostBottomImagesController _postBottomImagesController =
      PostBottomImagesController();
  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller.refreshWidget = (list) {
        _postBottomImagesController.changeImage(list);
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    double postWidth = MediaQuery.of(context).size.width - postHorizontalMargin;
    double truePhotoWidth = postWidth - postImageHorizontalMargin;
    double truePhotoHeight = truePhotoWidth;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: postImageHorizontalMargin / 2),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          UserManager.instance.homeWeatherModel != null
              ? Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    top: postImageHorizontalMargin / 2,
                  ),
                  height: 43.rw,
                  child: PostWeatherWidget(
                    homeWeatherModel: UserManager.instance.homeWeatherModel,
                  ),
                )
              : Container(),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: PostUserInfo(
              name: UserManager.instance.user.info.nickname + "的店铺",
              gysId: widget.goodsDetailModel.data.vendorId,
            ),
          ),
          PostBigImage(
            url: widget.bigImageUrl,
            imageSize: Size(truePhotoWidth, truePhotoHeight),
          ),
          PostBannerInfo(
            timeInfo: _getTimeInfo(),
          ),
          PostBottomWidget(
            goodsDetailModel: widget.goodsDetailModel,
          ),
          PostBottomImages(
            controller: _postBottomImagesController,
            width: truePhotoWidth,
            selectPhotos: widget.selectImagePhotos,
          ),
          Container(
            height: postImageHorizontalMargin / 2,
          ),
          widget.missingChildrenModel !=null? Container(
            //padding: EdgeInsets.all(postImageHorizontalMargin / 2),
            height: 229.rw,
            width: 355.rw,
            color: Color(0xFFFFF6F6),
            child: Row(
              children: [
                Container(
                  width: 160.rw,
                  height: 229.rw,
                  child: CustomCacheImage(
                      height: 229.rw,
                      fit: BoxFit.fitHeight,
                      width: 160.rw,
                      imageUrl: Api.getImgUrl(widget.missingChildrenModel.pic)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        '#儿童失踪紧急发布#',
                        style: TextStyle(
                          fontSize: 14.rsp,
                          color: Color(0xFFEA455B),
                        ),
                      ),
                    ),
                    40.hb,
                    Container(
                      width: 160.rw,
                      padding: EdgeInsets.only(left: 5.rw,right: 2.rw),
                      child: Text(
                        widget.missingChildrenModel.text
                            .replaceAll('#儿童失踪紧急发布#', ''),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                        style: TextStyle(
                          fontSize: 12.rsp,
                          color: Color(0xFF333333),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ):SizedBox(),
        ],
      ),
    );
  }

  String _getTimeInfo() {
    GoodsDetailModel _goodsDetail = widget.goodsDetailModel;
    DateFormat dateFormat = DateFormat('M月d日 HH:mm');
    if (_goodsDetail.data.promotion != null &&
        _goodsDetail.data.promotion.id > 0) {
      if (PromotionTimeTool.getPromotionStatusWithGoodDetailModel(
              _goodsDetail) ==
          PromotionStatus.start) {
        //活动中
        DateTime endTime = DateTime.parse(_goodsDetail.data.promotion.endTime);
        return "结束时间\n${dateFormat.format(endTime)}";
      }
      if (PromotionTimeTool.getPromotionStatusWithGoodDetailModel(
              _goodsDetail) ==
          PromotionStatus.ready) {
        DateTime startTime =
            DateTime.parse(_goodsDetail.data.promotion.startTime);
        return "开始时间\n${dateFormat.format(startTime)}";
      }
    }
    return "";
  }
}
