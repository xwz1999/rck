import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recook/constants/header.dart';

class ShopPagePopPainter extends CustomPainter {
  final double startX;
  final String text;
  ShopPagePopPainter(this.startX, {this.text = ""});
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = new Paint();
    p.color = Colors.black38.withAlpha(60); //画笔颜色
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
      TextSpan(
          text: text, style: TextStyle(color: Color(0xfffbffff), fontSize: 10)),
    ]);
    textPainter.layout(
      maxWidth: size.width,
    );
    textPainter.paint(canvas, Offset(10, 8));
  }

  @override
  bool shouldRepaint(ShopPagePopPainter oldDelegate) => true;
}

class ShopPopViewModel {
  int nodeIndex;
  double startX;
  double left;
  double top;
  double width;
  double height;
  bool offstage;
  bool leftOrRight;
  String popTitle;
  ShopPopViewModel(
      this.startX, this.left, this.top, this.width, this.height, this.offstage,
      {this.leftOrRight = true, this.popTitle = "", this.nodeIndex = -1});
}

class ShopPageLineProgressWidget extends StatefulWidget {
  final String camelTitle;
  final String camelPopTitle;
  final double percent;
  final double width;
  final double height;
  final int nodeCount; // 是否有节点
  final List<String> nodeTitleList;
  ShopPageLineProgressWidget(
      {Key key,
      this.camelTitle = "",
      this.percent = 0,
      this.width = 100,
      this.height = 50,
      this.nodeCount = 5,
      this.camelPopTitle = "",
      this.nodeTitleList})
      : super(key: key);

  @override
  ShopPageLineProgressWidgetState createState() =>
      ShopPageLineProgressWidgetState();
}

class ShopPageLineProgressWidgetState
    extends State<ShopPageLineProgressWidget> {
  // double _widthPercent = 0;
  double _percent = 0;
  // double _left = 0;
  ShopPopViewModel _popViewModel = ShopPopViewModel(0, 0, 0, 120, 0, true);
  ShopPopViewModel _normalPopViewModel;
  ShopPopViewModel _camelPopViewModel;
  ShopPopViewModel _camelTextPopViewModel;

  GlobalKey _node0Key = GlobalKey();
  GlobalKey _node1Key = GlobalKey();
  GlobalKey _node2Key = GlobalKey();
  GlobalKey _node3Key = GlobalKey();
  GlobalKey _node4Key = GlobalKey();
  List _keyList;
  GlobalKey _nodeAllKey = GlobalKey();
  GlobalKey _lineKey = GlobalKey();
  bool _hasPostFrameCallBack = false;

  Size _allBoxSize;
  Offset _lineBoxOffset;
  @override
  void initState() {
    _percent = widget.percent;
    _keyList = [_node0Key, _node1Key, _node2Key, _node3Key, _node4Key];
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      RenderBox allBox = _nodeAllKey.currentContext.findRenderObject();
      _allBoxSize = allBox.size;
      RenderBox lineBox = _lineKey.currentContext.findRenderObject();
      _lineBoxOffset = lineBox.localToGlobal(Offset.zero, ancestor: allBox);
      _hasPostFrameCallBack = true;
      updateView(percent: _percent);
    });
    super.initState();
  }

  updateView({percent}) {
    if (!mounted || !_hasPostFrameCallBack || _allBoxSize.isEmpty) {
      return;
    }
    _percent = percent;
    // 如果之前是打开下面气泡  就先隐藏
    _popViewModel.offstage = true;

    double start = _percent * widget.width;
    start =
        start < 10 ? 10 : start > widget.width - 10 ? widget.width - 10 : start;
    double normalLeft = start;
    if (start < 60) {
      normalLeft = 0;
    } else if ((_allBoxSize.width - start) < 60) {
      normalLeft = _allBoxSize.width - 120;
    } else {
      normalLeft = start - 60;
      // normalLeft = start;
    }
    _normalPopViewModel = ShopPopViewModel(start - normalLeft, normalLeft,
        _allBoxSize.height - 40, 120, 40, false);
    double camelLeft = start;
    if (start < 15) {
      camelLeft = 0;
    } else if ((_allBoxSize.width - start) < 20) {
      camelLeft = _allBoxSize.width - 40;
    } else {
      camelLeft = start - 15;
    }
    _camelPopViewModel =
        ShopPopViewModel(0, camelLeft, _lineBoxOffset.dy - 32, 40, 36, false);
    double textLeft = 0;
    bool leftOrRight = false;
    if ((_allBoxSize.width - camelLeft - 40) < 110) {
      leftOrRight = true;
      textLeft = camelLeft - 110;
    } else {
      textLeft = camelLeft + 40;
    }
    _camelTextPopViewModel = ShopPopViewModel(0, textLeft, 0, 110, 50, false,
        leftOrRight: leftOrRight);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _nodeAllKey,
      child: Stack(
        children: <Widget>[
          Positioned(
              left: _popViewModel.left,
              top: _popViewModel.top,
              width: _popViewModel.width,
              height: _popViewModel.height,
              child: Offstage(
                offstage: _popViewModel.offstage,
                child: Container(
                  child: CustomPaint(
                    painter: ShopPagePopPainter(
                      _popViewModel.startX,
                      text: _popViewModel.popTitle,
                    ),
                    size: Size(_popViewModel.width, _popViewModel.height),
                  ),
                ),
              )),
          _normalPopViewModel == null
              ? Container()
              : Positioned(
                  left: _normalPopViewModel.left,
                  top: _normalPopViewModel.top - rSize(15),
                  width: _normalPopViewModel.width,
                  height: _normalPopViewModel.height,
                  child: Offstage(
                    offstage: _normalPopViewModel.offstage,
                    child: Container(
                      child: CustomPaint(
                        painter: ShopPagePopPainter(
                          _normalPopViewModel.startX,
                          text: widget.camelPopTitle,
                        ),
                        size: Size(_normalPopViewModel.width,
                            _normalPopViewModel.height),
                      ),
                    ),
                  )),
          _camelPopViewModel == null
              ? Container()
              : Positioned(
                  left: _camelPopViewModel.left,
                  top: _camelPopViewModel.top - rSize(20),
                  width: _camelPopViewModel.width,
                  height: _camelPopViewModel.height,
                  child: Offstage(
                    offstage: _camelPopViewModel.offstage,
                    child: Image.asset(
                      R.ASSETS_SHOP_CAMEL_PNG,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
          _camelTextPopViewModel == null
              ? Container()
              : Positioned(
                  left: _camelTextPopViewModel.left,
                  top: _camelTextPopViewModel.top + rSize(15),
                  width: _camelTextPopViewModel.width,
                  height: _camelTextPopViewModel.height,
                  child: Offstage(
                      offstage: _camelTextPopViewModel.offstage,
                      child: Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          // Image.asset(_camelTextPopViewModel.leftOrRight
                          //     ? "assets/camel_pop_left.png"
                          //     : "assets/camel_pop_right.png"),
                          Center(
                              child: Container(
                            width: rSize(80),
                            padding: EdgeInsets.symmetric(horizontal: rSize(8)),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(rSize(6)),
                            ),
                            // padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(widget.camelTitle,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10)),
                          )),
                          Positioned(
                            bottom: rSize(-5),
                            left: _camelTextPopViewModel.leftOrRight ? null : 0,
                            right:
                                _camelTextPopViewModel.leftOrRight ? 0 : null,
                            child: ClipOval(
                              child: Container(
                                height: rSize(7),
                                width: rSize(13.5),
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: rSize(-10),
                            left: _camelTextPopViewModel.leftOrRight
                                ? null
                                : rSize(-5),
                            right: _camelTextPopViewModel.leftOrRight
                                ? rSize(5)
                                : null,
                            child: ClipOval(
                              child: Container(
                                height: rSize(3),
                                width: rSize(6),
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
          // safawfawe
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 41,
          //   height: 3,
          //   child: _progressWidget(),
          // ),
          // Positioned(
          //     // left: 0, right: 0, bottom: 40, height: 5,
          //     left: 0,
          //     right: 0,
          //     bottom: 22.5,
          //     height: 40,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: _progressNodeListWidget(),
          //     )),
        ],
      ),
    );
  }

  _progressWidget() {
    return Container(
      key: _lineKey,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: widget.width * _percent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _progressNodeListWidget() {
    List<Widget> list = [];

    while (list.length < widget.nodeCount) {
      list.add(_progressNodeWidget(_keyList[list.length]));
    }
    return list;
  }

  _progressNodeWidget(nodeKey) {
    return GestureDetector(
      onTap: () {
        if (widget.nodeCount <= 0) {
          return;
        }
        int index = _keyList.indexOf(nodeKey);
        if (widget.nodeTitleList != null &&
            widget.nodeTitleList.length == widget.nodeCount) {
          _popViewModel.popTitle =
              widget.nodeTitleList[_keyList.indexOf(nodeKey)];
        }
        if (_popViewModel.nodeIndex == index) {
          _popViewModel.nodeIndex = -1;
          _popViewModel.offstage = true;
          _camelTextPopViewModel.offstage = false;
          _normalPopViewModel.offstage = false;
        } else {
          _popViewModel.nodeIndex = index;
          _popViewModel.offstage = false;
          _normalPopViewModel.offstage = true;
          // _camelPopViewModel.offstage = !_camelPopViewModel.offstage;
          _camelTextPopViewModel.offstage = true;
        }

        DPrint.printf("obj");
        RenderBox allBox = _nodeAllKey.currentContext.findRenderObject();
        RenderBox box = nodeKey.currentContext.findRenderObject();
        Offset offset = box.localToGlobal(Offset.zero, ancestor: allBox);
        //获取size
        DPrint.printf('box' + box.size.toString());
        DPrint.printf('box' + offset.toString());
        DPrint.printf('allbox' + allBox.size.toString());
        if ((allBox.size.width - offset.dx) < _popViewModel.width / 2) {
          _popViewModel.left = allBox.size.width - _popViewModel.width;
        } else if (offset.dx > _popViewModel.width / 2) {
          _popViewModel.left = offset.dx - _popViewModel.width / 2;
        } else {
          _popViewModel.left = 0;
        }
        _popViewModel.startX = offset.dx - _popViewModel.left + 2.5;
        _popViewModel.top = offset.dy + 5;
        _popViewModel.height = allBox.size.height - offset.dy - 5;
        //

        setState(() {});
      },
      child: Container(
          color: Colors.black.withOpacity(0.0),
          width: 40,
          height: 40,
          child: Center(
            child: Container(
              key: nodeKey,
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  )),
            ),
          )),
    );
  }
}
