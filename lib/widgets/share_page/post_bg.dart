import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jingyaoyun/constants/app_image_resources.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/share_page/share_image_tool.dart';

class PostTimeBannerInfo {
  String timeInfo;
  PostTimeBannerInfo({this.timeInfo = ""});
  init() async {
    leftBannerImage =
        await ShareImageTool.getImageWithAsset("assets/post_left_banner.png");
    rightBannerImage =
        await ShareImageTool.getImageWithAsset("assets/post_right_banner.png");
  }

  ui.Image leftBannerImage;
  ui.Image rightBannerImage;
  double bannerHeight = 45;
  double rightBannerWidth = 100;
  paint(Canvas canvas, Size size) {
    canvas.save();
    Offset leftOffSet = Offset(15, size.height - 130);
    Offset rightOffSet = Offset(
        ScreenUtil().screenWidth - 80 - rightBannerWidth + 15,
        size.height - 130);
    Paint paint = new Paint();
    // 结束时间
    if (!TextUtils.isEmpty(timeInfo)) {
      // 右边灰色
      canvas.drawImageRect(
          rightBannerImage,
          Offset(0.0, 0.0) &
              Size(rightBannerImage.width.toDouble(),
                  rightBannerImage.height.toDouble()),
          rightOffSet & Size(rightBannerWidth, 45),
          paint);
      ui.ParagraphBuilder endTimeParagraphBuilder = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          textAlign: TextAlign.center,
          fontSize: 10.0,
          textDirection: TextDirection.ltr,
          maxLines: 2,
        ),
      )
        ..pushStyle(
          ui.TextStyle(
              color: Colors.white, textBaseline: ui.TextBaseline.alphabetic),
        )
        ..addText("$timeInfo");
      ui.Paragraph endTimeParagraph = endTimeParagraphBuilder.build()
        ..layout(ui.ParagraphConstraints(
          width: rightBannerWidth,
        ));
      canvas.drawParagraph(
          endTimeParagraph, Offset(rightOffSet.dx + 5, leftOffSet.dy + 9.5));
      // 左边红色
      canvas.drawImageRect(
          leftBannerImage,
          Offset(0.0, 0.0) &
              Size(leftBannerImage.width.toDouble(),
                  leftBannerImage.height.toDouble()),
          leftOffSet &
              Size(ScreenUtil().screenWidth - 80 - rightBannerWidth + 15, 45),
          paint);
      // 红色文字
      ui.ParagraphBuilder infoParagraphBuilder = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          textAlign: TextAlign.left,
          fontSize: 14 * 2.sp,
          textDirection: TextDirection.ltr,
          maxLines: 1,
        ),
      )
        ..pushStyle(
          ui.TextStyle(
              color: Colors.white, textBaseline: ui.TextBaseline.alphabetic),
        )
        ..addText("全球精品 正品保障 售后无忧");
      ui.Paragraph infoParagraph = infoParagraphBuilder.build()
        ..layout(ui.ParagraphConstraints(
          width: ScreenUtil().screenWidth - 80 - rightBannerWidth + 15,
        ));
      canvas.drawParagraph(
          infoParagraph, Offset(leftOffSet.dx + 10, leftOffSet.dy + 12));
    } else {
      // 左边红色
      canvas.drawImageRect(
          leftBannerImage,
          Offset(0.0, 0.0) &
              Size(leftBannerImage.width.toDouble(),
                  leftBannerImage.height.toDouble()),
          leftOffSet & Size(ScreenUtil().screenWidth - 80 + 3, 45),
          paint);
      // 红色文字
      ui.ParagraphBuilder infoParagraphBuilder = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          textAlign: TextAlign.center,
          fontSize: 14 * 2.sp,
          textDirection: TextDirection.ltr,
          maxLines: 1,
        ),
      )
        ..pushStyle(
          ui.TextStyle(
              color: Colors.white, textBaseline: ui.TextBaseline.alphabetic),
        )
        ..addText("全球精品 | 正品保障 | 售后无忧");
      ui.Paragraph infoParagraph = infoParagraphBuilder.build()
        ..layout(ui.ParagraphConstraints(
          width: ScreenUtil().screenWidth - 80 + 3 - 20,
        ));
      canvas.drawParagraph(
          infoParagraph, Offset(leftOffSet.dx + 10, leftOffSet.dy + 12));
    }
    canvas.restore();
  }
}

class PostBottomInfo {
  String price;
  String crossedPrice;
  String info;
  String qrCode;
  PostBottomInfo({
    this.price = "",
    this.crossedPrice = "",
    this.info = "",
    this.qrCode = "",
  });
  init() async {
    image = await ShareImageTool.getImageWithQRCode(
        qrCode: this.qrCode, size: qrSize.width);
  }

  Size qrSize = Size(300, 300);
  ui.Image image;
  paint(Canvas canvas, Size size) {
    canvas.save();
    // 价格
    double textLeft = 15;
    ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.left,
        fontSize: 18.0,
        textDirection: TextDirection.ltr,
        maxLines: 1,
      ),
    )
      ..pushStyle(
        ui.TextStyle(
            fontSize: 12,
            color: Color(0xffff0000),
            textBaseline: ui.TextBaseline.alphabetic),
      )
      ..addText("¥")
      ..pushStyle(
        ui.TextStyle(
            color: Color(0xffff0000),
            fontSize: 18,
            textBaseline: ui.TextBaseline.alphabetic),
      )
      ..addText(price + " ")
      ..pushStyle(
        ui.TextStyle(
            fontSize: 10,
            color: Color(0xff999999),
            textBaseline: ui.TextBaseline.alphabetic),
      )
      ..addText("¥")
      ..pushStyle(
        ui.TextStyle(
            fontSize: 14,
            decoration: TextDecoration.lineThrough,
            color: Color(0xff999999),
            textBaseline: ui.TextBaseline.alphabetic),
      )
      ..addText(crossedPrice);
    ui.Paragraph paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: ScreenUtil().screenWidth - 140));
    canvas.drawParagraph(paragraph, Offset(textLeft, size.height - 75));
    // canvas.restore();

    // 商品信息
    ui.ParagraphBuilder infoParagraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.left,
        fontSize: 14.0,
        textDirection: TextDirection.ltr,
        maxLines: 2,
      ),
    )
      ..pushStyle(
        ui.TextStyle(
            color: Color(0xff333333), textBaseline: ui.TextBaseline.alphabetic),
      )
      ..addText(info);
    ui.Paragraph infoParagraph = infoParagraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: ScreenUtil().screenWidth - 150));
    canvas.drawParagraph(infoParagraph, Offset(textLeft, size.height - 50));
    //
    // 二维码
    Offset qrOffset =
        Offset(ScreenUtil().screenWidth - 90 - 25, size.height - 75);
    ui.ParagraphBuilder qrTextParagraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 8,
        textDirection: TextDirection.ltr,
        maxLines: 1,
      ),
    )
      ..pushStyle(
        ui.TextStyle(
            fontSize: 8,
            color: Color(0xff333333),
            textBaseline: ui.TextBaseline.alphabetic),
      )
      ..addText("长按二维码立购");
    ui.Paragraph qrTextParagraph = qrTextParagraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: 70));
    canvas.drawParagraph(
        qrTextParagraph, Offset(qrOffset.dx - 10, size.height - 20));
    Rect qrCodeWrap = qrOffset & Size(50, 50);
    Paint paint = new Paint();
    canvas.drawImageRect(image, Offset(0.0, 0.0) & qrSize, qrCodeWrap, paint);
    canvas.restore();
  }
}

class PostUserImage {
  String name;
  PostUserImage({this.name = "左家右厨"});
  init() async {
    image =
        await ShareImageTool.getImageWithAsset(AppImageName.recook_icon_120);
  }

  String title = "跟着英子去开店";
  ui.Image image;
  Offset offset = Offset(15, 10);
  Size size = Size(50, 50);
  // 绘图函数
  paint(Canvas canvas) async {
    canvas.save();
    // 头像
    Rect screenWrap = offset & size;
    Paint screenWrapPainter = new Paint();
    screenWrapPainter.color = Colors.white;
    screenWrapPainter.style = PaintingStyle.fill;
    canvas.drawRect(screenWrap, screenWrapPainter);
    // canvas.scale(0.4, 0.4);

    // 名字
    var textLeft = offset.dx * 2 + size.width;
    ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.left,
        fontSize: 14.0,
        textDirection: TextDirection.ltr,
        maxLines: 1,
      ),
    )
      ..pushStyle(
        ui.TextStyle(
            color: Colors.black, textBaseline: ui.TextBaseline.alphabetic),
      )
      ..addText(name);
    ui.Paragraph paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: ScreenUtil().screenWidth - 140));
    canvas.drawParagraph(paragraph, Offset(textLeft, 16));

    // title
    ui.ParagraphBuilder titleParagraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.left,
        fontSize: 10.0,
        textDirection: TextDirection.ltr,
        maxLines: 1,
      ),
    )
      ..pushStyle(
        ui.TextStyle(
            color: Color(0xff666666), textBaseline: ui.TextBaseline.alphabetic),
      )
      ..addText(title);
    ui.Paragraph titleParagraph = titleParagraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: ScreenUtil().screenWidth - 140));
    canvas.drawParagraph(titleParagraph, Offset(textLeft, 41));
    //
    Paint paint = new Paint();
    canvas.clipRRect(
        RRect.fromRectXY(
            Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height),
            10,
            10),
        doAntiAlias: false);
    canvas.drawImageRect(
        image,
        Offset(0.0, 0.0) &
            Size(image.width.toDouble(), image.height.toDouble()),
        screenWrap,
        paint);
    canvas.restore();
  }
}

class PostBackground {
  String url;
  Size imageSize;
  PostBackground({this.url, this.imageSize});
  init() async {
    image = await ShareImageTool.getImageWithNetwork(url);
  }

  ui.Image image;
  // 绘图函数
  paint(Canvas canvas) async {
    canvas.save();
    Rect screenWrap = Offset(15, 70) & Size(imageSize.width, imageSize.height);
    Paint screenWrapPainter = new Paint();
    screenWrapPainter.color = Colors.white;
    screenWrapPainter.style = PaintingStyle.fill;
    canvas.drawRect(screenWrap, screenWrapPainter);
    Paint paint = new Paint();
    canvas.drawImageRect(
        image,
        Offset(0.0, 0.0) &
            Size(image.width.toDouble(), image.height.toDouble()),
        Offset(15, 70) & Size(imageSize.width, imageSize.height),
        paint);
    canvas.restore();
  }
}
