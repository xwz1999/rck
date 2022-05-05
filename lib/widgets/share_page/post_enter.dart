import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/pages/home/promotion_time_tool.dart';
import 'package:recook/widgets/share_page/post_bg.dart';

enum Status { loading, complete }

class MainPainter extends CustomPainter {
  final PostBackground background;
  final PostUserImage userImage;
  final PostBottomInfo postBottomInfo;
  final PostTimeBannerInfo timeBannerInfo;
  // final MainQR hero;
  // final PostAvatar postAvatar;

  MainPainter({this.userImage,this.background,this.postBottomInfo, this.timeBannerInfo});
  
  // MainPainter(
  //     {this.background, this.hero, this.url, this.size, this.postAvatar});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    Rect screenWrap =
        Offset(0.0, 0.0) & size;
    Paint screenWrapPainter = new Paint();
    screenWrapPainter.color = Colors.white;
    screenWrapPainter.style = PaintingStyle.fill;
    canvas.drawRect(screenWrap, screenWrapPainter);
    canvas.restore();

    background.paint(canvas,);
    userImage.paint(canvas);
    postBottomInfo.paint(canvas, size);
    timeBannerInfo.paint(canvas, size);
    // postAvatar.paint(canvas, size);
    // hero.paint(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}


class EnterPostPage extends StatefulWidget {
  final GoodsDetailModel goodsDetail;
  final Size size;
  EnterPostPage({Key key, this.goodsDetail, this.size,}) : super(key: key);

  @override
  _EnterPostPageState createState() => _EnterPostPageState();
}

class _EnterPostPageState extends State<EnterPostPage> {
  GoodsDetailModel _goodsDetail;
  Status gameStatus = Status.loading;
  // paint
  PostUserImage userImage;
  PostBackground background;
  PostTimeBannerInfo timeBannerInfo;
  PostBottomInfo postBottomInfo;
  String _goodsUrl = "";
  @override
  void initState() {
    _goodsDetail = widget.goodsDetail;
    _goodsUrl = "${AppConfig.debug?WebApi.testGoodsDetail:WebApi.goodsDetail}${_goodsDetail.data.id}/${UserManager.instance.user.info.invitationNo}";
    initPost();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (gameStatus == Status.loading) {
      return Container();
    }
    return CustomPaint(
      painter: MainPainter(
        background: background,
        userImage: userImage,
        postBottomInfo: postBottomInfo,
        timeBannerInfo: timeBannerInfo,
      ),
      size: widget.size
    );
  }
  initPost() async{
    MainPhotos photo = _goodsDetail.data.mainPhotos[0];
    if (_goodsDetail.data.mainPhotos.length>=2) {
      photo = _goodsDetail.data.mainPhotos[1];
    }
    double imageWidth = widget.size.width - 30;
    double imageHeight = imageWidth/photo.width*photo.height;
    background = PostBackground(url: Api.getImgUrl(photo.url), imageSize: Size(imageWidth, imageHeight));
    await background.init();
    userImage = PostUserImage(name: UserManager.instance.user.info.nickname+"的店铺");
    await userImage.init();
    postBottomInfo = PostBottomInfo(
      qrCode: _goodsUrl,
      info: _goodsDetail.data.goodsName ,
      crossedPrice: _goodsDetail.data.price.max.originalPrice.toStringAsFixed(2),
      price: _goodsDetail.data.getPriceString(),);
    await postBottomInfo.init();
    timeBannerInfo = PostTimeBannerInfo(timeInfo: _getTimeInfo());
    await timeBannerInfo.init();
    setState(() {
      gameStatus = Status.complete;
    });
  }
  String _getTimeInfo(){
    DateFormat dateFormat = DateFormat('M月d日 HH:mm');
    if (_goodsDetail.data.promotion!=null && _goodsDetail.data.promotion.id > 0) {
      if (PromotionTimeTool.getPromotionStatusWithGoodDetailModel(_goodsDetail) == PromotionStatus.start){  
        //活动中
        DateTime endTime = DateTime.parse(_goodsDetail.data.promotion.endTime);
        return "结束时间\n${dateFormat.format(endTime)}";
      }
      if (PromotionTimeTool.getPromotionStatusWithGoodDetailModel(_goodsDetail) == PromotionStatus.ready) {  
        DateTime startTime = DateTime.parse(_goodsDetail.data.promotion.startTime);
        return "开始时间\n${dateFormat.format(startTime)}";
      }
    }
    return "";
  }
}
