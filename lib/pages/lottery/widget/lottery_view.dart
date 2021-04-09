import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/pages/lottery/redeem_lottery_page.dart';
import 'package:recook/pages/lottery/widget/lottery_ball.dart';
import 'package:recook/widgets/custom_image_button.dart';

class LotteryView extends StatefulWidget {
  final LotteryType type;
  final LotteryColorType colorType;
  final Function(List<int> selected, List<int> focused) onSelect;
  LotteryView({
    Key key,
    this.type = LotteryType.DOUBLE_LOTTERY,
    this.colorType = LotteryColorType.RED,
    this.onSelect,
  }) : super(key: key);

  @override
  LotteryViewState createState() => LotteryViewState();
}

class LotteryViewState extends State<LotteryView> {
  int lotterySize;
  List<SingleBox> _lotteryBoxes = [];
  List<SingleBox> _selectedBoxes = [];
  List<SingleBox> _focusedBoxes = [];
  @override
  void initState() {
    super.initState();
    lotterySize = widget.type == LotteryType.DOUBLE_LOTTERY
        ? widget.colorType == LotteryColorType.RED ? 33 : 16
        : widget.colorType == LotteryColorType.RED ? 35 : 12;
    for (int i = 1; i <= lotterySize; i++) {
      _lotteryBoxes.add(SingleBox(i));
    }
  }

  selectAllBlue() {
    _selectedBoxes.clear();
    _lotteryBoxes.forEach((element) {
      _selectedBoxes.add(element);
    });

    setState(() {});
    widget.onSelect(
      _selectedBoxes.map((e) => e.value).toList(),
      _focusedBoxes.map((e) => e.value).toList(),
    );
  }

  clear() {
    _selectedBoxes.clear();
    _focusedBoxes.clear();
    setState(() {});
    widget.onSelect([], []);
  }

  random1Shot() {
    _selectedBoxes.clear();
    _focusedBoxes.clear();
    List<SingleBox> temp = [];
    _lotteryBoxes.forEach((element) => temp.add(element));

    int randomShotsSize = widget.type == LotteryType.DOUBLE_LOTTERY
        ? widget.colorType == LotteryColorType.RED ? 6 : 1
        : widget.colorType == LotteryColorType.RED ? 5 : 2;
    for (int i = 0; i < randomShotsSize; i++) {
      temp.shuffle();
      _selectedBoxes.add(temp[0]);
      temp.removeAt(0);
    }
    widget.onSelect(
      _selectedBoxes.map((e) => e.value).toList(),
      _focusedBoxes.map((e) => e.value).toList(),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      shrinkWrap: true,
      crossAxisSpacing: rSize(16),
      mainAxisSpacing: rSize(16),
      childAspectRatio: 1,
      padding: EdgeInsets.symmetric(
        horizontal: rSize(16),
      ),
      children: _lotteryBoxes.map((e) => _buildLotteryBox(e)).toList(),
    );
  }

  Widget _buildLotteryBox(SingleBox box) {
    bool selected = _selectedBoxes.indexOf(box) != -1;
    bool focused = _focusedBoxes.indexOf(box) != -1;
    return CustomImageButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (!selected) {
          _selectedBoxes.add(box);
        } else if (selected && !focused) {
          //添加胆球
          //双色球胆球不能超过5，大乐透胆球不能超过4
          //双色球蓝球没有胆球，大乐透蓝色胆球数不能超过1
          switch (widget.type) {
            case LotteryType.DOUBLE_LOTTERY:
              switch (widget.colorType) {
                case LotteryColorType.RED:
                  if (_focusedBoxes.length == 5)
                    _selectedBoxes.remove(box);
                  else
                    _focusedBoxes.add(box);
                  break;
                case LotteryColorType.BLUE:
                  _selectedBoxes.remove(box);
                  break;
              }
              break;
            case LotteryType.BIG_LOTTERY:
              switch (widget.colorType) {
                case LotteryColorType.RED:
                  if (_focusedBoxes.length == 4)
                    _selectedBoxes.remove(box);
                  else
                    _focusedBoxes.add(box);
                  break;
                case LotteryColorType.BLUE:
                  if (_focusedBoxes.length == 1)
                    _selectedBoxes.remove(box);
                  else
                    _focusedBoxes.add(box);
                  break;
              }
              break;
          }
        } else {
          _selectedBoxes.remove(box);
          _focusedBoxes.remove(box);
        }
        widget.onSelect(
          _selectedBoxes.map((e) => e.value).toList(),
          _focusedBoxes.map((e) => e.value).toList(),
        );
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? widget.colorType == LotteryColorType.RED
                  ? Color(0xFFE02020)
                  : Color(0xFF0E89E7)
              : Colors.white,
          borderRadius: BorderRadius.circular(rSize(18)),
          border: Border.all(
            width: rSize(1),
            color: widget.colorType == LotteryColorType.RED
                ? Color(0xFFE02020)
                : Color(0xFF0E89E7),
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              box.displayStr,
              style: TextStyle(
                fontSize: rSP(16),
                height: 1,
                color: selected
                    ? Colors.white
                    : widget.colorType == LotteryColorType.RED
                        ? Color(0xFFE02020)
                        : Color(0xFF0E89E7),
              ),
            ),
            focused
                ? Text(
                    '胆',
                    style: TextStyle(
                      height: 1,
                      color: Colors.white,
                      fontSize: rSP(14),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class SingleBox {
  int value;
  String get displayStr => (value < 10) ? "0$value" : "$value";
  SingleBox(this.value);
}
