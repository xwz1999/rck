import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flip_card/flip_card.dart';

import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/header.dart';

class BingoCardModel {
  dynamic cardFaceFront;
  dynamic cardFaceBack;
  bool isBingo;
  BingoCardModel({
    this.cardFaceBack,
    this.cardFaceFront,
    this.isBingo,
  });
}

class BingoCardController {
  Function stopAnimation;
  Function startAnimation;
}

class BingoCardWidget extends StatefulWidget {
  final List<BingoCardModel> bingoCardModels;
  final BingoCardController controller;
  final VoidCallback beforeBack;
  final bool inkWell;
  final Duration switchDuration;
  final Duration animationDuration;
  final Duration flipDuration;

  final double aspectRatio;
  final num rowSize;
  final double spacing;

  final num bingoType;

  ///抽奖组件
  ///
  ///beforeBack:VoidCallBack 返回事件回调
  ///
  ///inkWll:bool 背景InkWell化
  ///
  ///controller:BingoCardController 卡片控制器
  ///
  ///aspectRatio:double 卡片长宽比
  ///
  ///rowSize:卡片水平数量
  ///
  ///spacing:卡片间距
  ///
  ///bingoCardModels:BingoCardModel 抽奖卡片模型
  ///
  ///switchDuration 切换动画速度
  ///
  ///animationDuration 卡片遮罩层速度
  ///
  ///flipAnimation 卡片翻转速度
  BingoCardWidget({
    Key key,
    this.beforeBack,
    this.inkWell = true,
    this.controller,
    this.aspectRatio = 3 / 4,
    this.rowSize = 3,
    this.spacing = 10.0,
    @required this.bingoCardModels,
    this.switchDuration = const Duration(milliseconds: 300),
    this.animationDuration = const Duration(milliseconds: 300),
    this.flipDuration = const Duration(milliseconds: 1000),
    this.bingoType,
  })  : assert(bingoCardModels.length >= rowSize, "bingoCard小于rowSize"),
        assert(bingoCardModels.length % rowSize == 0),
        super(key: key);

  @override
  _BingoCardWidgetState createState() => _BingoCardWidgetState();
}

class _BingoCardWidgetState extends State<BingoCardWidget> {
  bool _backgroundDarkMask = false;
  Timer _timer;
  List<bool> _cardState = [];
  List<GlobalKey<FlipCardState>> _cardKeys = [];
  List<BingoCardModel> result = [];
  bool _isShowResult = false;
  //当前选中卡片Index
  num _nowChooseIndex;
  @override
  void initState() {
    super.initState();
    result = widget.bingoCardModels;
    //打乱卡片顺序
    result.shuffle();

    //初始化卡片Key
    for (int i = 0; i < result.length; i++) {
      _cardState.add(false);
      _cardKeys.add(GlobalKey<FlipCardState>());
    }

    widget.controller?.startAnimation = () {
      setState(() {
        _backgroundDarkMask = true;
      });
      num _nowCardIndex;
      _nowCardIndex = result.length - 1;
      num preCardIndex;
      _timer = Timer.periodic(widget.switchDuration, (timer) {
        _nowChooseIndex = _nowCardIndex;
        _cardState[_nowCardIndex] = true;
        if (preCardIndex != null) {
          _cardState[preCardIndex] = false;
        }
        preCardIndex = _nowCardIndex;
        if (_nowCardIndex == 0) {
          _nowCardIndex = result.length - 1;
        } else
          _nowCardIndex--;
        setState(() {});
      });
    };

    widget.controller?.stopAnimation = () {
      _timer?.cancel();

      for (int i = 0; i < result.length; i++) {
        if (result[i].isBingo) {
          BingoCardModel temp = result[_nowChooseIndex];
          result[_nowChooseIndex] = result[i];
          result[i] = temp;
          break;
        }
      }
      setState(() {});
      _cardKeys.forEach((element) {
        element.currentState.toggleCard();
      });
    };
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          _buildBackLayer(),
          Center(
            child: Stack(
              children: <Widget>[
                _buildBackground(),
                Positioned(
                  left: 50,
                  right: 50,
                  top: 80,
                  child: _buildChild(),
                ),
                Positioned(
                  bottom: 60 * 2.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _buildButton(),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 105 * 2.h,
                  child: Center(
                    child: _isShowResult
                        ? Text(
                            widget.bingoType == 0
                                ? '抱歉未抽中任何奖项'
                                : '可在“我的”-“卡包”中查看',
                            style: TextStyle(
                              fontSize: 12 * 2.sp,
                              color: Color(0xFFFFF7DF),
                            ),
                          )
                        : SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildBackground() {
    return Image.asset(R.ASSETS_LOTTERY_BACKGROUND_PNG_WEBP);
  }

  _buildButton() {
    return GestureDetector(
      onTap: _isShowResult
          ? () {
              Navigator.pop(context);
            }
          : () {
              widget.controller.startAnimation();
              Future.delayed(
                Duration(milliseconds: 1000 + Random().nextInt(2000)),
                () {
                  widget.controller.stopAnimation();
                  setState(() {
                    _isShowResult = true;
                  });
                },
              );
            },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              offset: Offset(0, 3),
              color: Color(0xFFF24160),
            )
          ],
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFEAA8),
              Color(0xFFFFD67A),
              Color(0xFFFFD16F),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        height: 40 * 2.h,
        width: rSize(265),
        child: Center(
          child: Text(
            _isShowResult
                ? widget.bingoType == 0
                    ? '好遗憾 没中奖'
                    : '立即领取'
                : '天天好运',
            style: TextStyle(
              color: Color(0xFFCE1F3D),
              fontSize: 16 * 2.sp,
            ),
          ),
        ),
      ),
    );
  }

  _buildBackLayer() {
    VoidCallback _onTap = () {
      if (widget.beforeBack != null) widget.beforeBack();
      Navigator.pop(context);
    };
    return widget.inkWell
        ? InkWell(onTap: _onTap)
        : GestureDetector(onTap: _onTap);
  }

  _buildChild() {
    var mediaWidth = MediaQuery.of(context).size.width;
    return Center(
      child: AnimatedContainer(
        width: mediaWidth - 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          // color: _backgroundDarkMask ? Colors.black26 : Colors.transparent,
        ),
        duration: Duration(milliseconds: 300),
        child: GridView.builder(
          padding: EdgeInsets.only(
            top: 35,
            left: 8,
            right: 8,
            bottom: 35,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.rowSize,
            crossAxisSpacing: widget.spacing,
            childAspectRatio: widget.aspectRatio,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.only(bottom: 10),
              child: _buildCard(index),
            );
          },
          itemCount: result.length,
        ),
      ),
    );
  }

  _buildCard(int index) {
    return Stack(
      children: <Widget>[
        FlipCard(
          speed: widget.flipDuration.inMilliseconds,
          key: _cardKeys[index],
          front: result[index].cardFaceFront,
          back: result[index].cardFaceBack,
        ),
        Positioned(
          right: 0,
          left: 0,
          top: 0,
          bottom: 0,
          child: AnimatedContainer(
            duration: widget.animationDuration,
            color: _cardState[index] ? Colors.transparent : Colors.black54,
          ),
        ),
      ],
    );
  }
}
