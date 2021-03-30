import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';

class CustomBubblePopPainter extends CustomPainter {
  final double startX;
  final String text;
  CustomBubblePopPainter(this.startX, {this.text = ""});
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = new Paint();
    p.color = Colors.white; //画笔颜色
    // p.color = Colors.red;
    p.strokeWidth = 1;
    p.isAntiAlias = true; //是否抗锯齿
    p.style = PaintingStyle.fill; //画笔样式:填充
    // canvas.drawCircle(size.center(Offset(0.0, 0.0)), size.width / 2, p);
    Path path = Path()..moveTo(0, 10);
    //  左上角
    Rect rectLeftTop = Rect.fromCircle(center: Offset(5, 10), radius: 5);
    path.arcTo(rectLeftTop, 3.14, 3.14 * 0.5, false);
    //
    path.lineTo(startX - 5, 5);
    path.lineTo(startX, 0);
    path.lineTo(startX + 5, 5);
    path.lineTo(size.width - 5, 5);
    // 右上角
    Rect rectRightTop =
        Rect.fromCircle(center: Offset(size.width - 5, 10), radius: 5);
    path.arcTo(rectRightTop, 3.14 * 1, 3.14 * 1, false);
    path.lineTo(size.width, size.height - 5);
    // 右下角
    Rect rectRightBottom = Rect.fromCircle(
        center: Offset(size.width - 5, size.height - 5), radius: 5);
    path.arcTo(rectRightBottom, 3.14 * 1.5, 3.14 * 1, false);
    path.lineTo(5, size.height);
    // 左下角
    Rect rectLeftBottom =
        Rect.fromCircle(center: Offset(5, size.height - 5), radius: 5);
    path.arcTo(rectLeftBottom, 3.14 * .5, 3.14 * .5, false);
    canvas.drawPath(path, p);

    TextPainter textPainter = TextPainter(
        textAlign: TextAlign.start,
        maxLines: 2,
        textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(children: [
      TextSpan(text: text, style: TextStyle(color: Colors.black, fontSize: 10)),
    ]);
    textPainter.layout(
      maxWidth: size.width,
    );
    textPainter.paint(canvas, Offset(10, 8));
  }

  @override
  bool shouldRepaint(CustomBubblePopPainter oldDelegate) => true;
}

class CustomBubbleArrowPopPainter extends CustomPainter {
  final double startX;
  CustomBubbleArrowPopPainter(
    this.startX,
  );
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = new Paint();
    p.color = Colors.white; //画笔颜色
    // p.color = Colors.red;
    p.strokeWidth = 1;
    p.isAntiAlias = true; //是否抗锯齿
    p.style = PaintingStyle.fill; //画笔样式:填充
    // canvas.drawCircle(size.center(Offset(0.0, 0.0)), size.width / 2, p);
    Path path = Path()..moveTo(startX, 0);
    path.lineTo(startX + 5, 10);
    path.lineTo(startX - 5, 10);
    path.lineTo(startX, 0);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(CustomBubbleArrowPopPainter oldDelegate) => true;
}

class CustomBubbleWidget extends StatefulWidget {
  final double arrowLeftPadding;
  final Widget child;
  CustomBubbleWidget({Key key, this.arrowLeftPadding = 10, this.child})
      : super(key: key);

  @override
  _CustomBubbleWidgetState createState() => _CustomBubbleWidgetState();
}

class _CustomBubbleWidgetState extends State<CustomBubbleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomPaint(
            painter: CustomBubbleArrowPopPainter(
              widget.arrowLeftPadding,
            ),
            size: Size(widget.arrowLeftPadding + 10, 10),
          ),
          Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: rSize(10),
                  vertical: ScreenAdapterUtils.setHeight(10)),
              child: widget.child == null ? Container() : widget.child)
        ],
      ),
    );
  }
}
