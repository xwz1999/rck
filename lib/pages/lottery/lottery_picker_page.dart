import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/lottery/redeem_lottery_page.dart';
import 'package:recook/pages/lottery/widget/lottery_ball.dart';
import 'package:recook/pages/lottery/widget/lottery_scaffold.dart';
import 'package:recook/pages/lottery/widget/lottery_view.dart';
import 'package:recook/utils/math/recook_math.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/const/resource.dart';

class LotteryPickerPage extends StatefulWidget {
  final dynamic arguments;
  LotteryPickerPage({Key key, @required this.arguments}) : super(key: key);

  @override
  _LotteryPickerPageState createState() => _LotteryPickerPageState();
}

class _LotteryPickerPageState extends State<LotteryPickerPage> {
  int lotteryShots = 0;
  GlobalKey<LotteryViewState> _redLotteryViewKey =
      GlobalKey<LotteryViewState>();
  GlobalKey<LotteryViewState> _blueLotteryViewKey =
      GlobalKey<LotteryViewState>();

  List<int> _redBalls = [];
  List<int> _blueBalls = [];

  @override
  Widget build(BuildContext context) {
    return LotteryScaffold(
      red: true,
      whiteBg: true,
      appBarBottom: PreferredSize(
        child: Container(
          color: Color(0xFFFEF8E2),
          height: rSize(36),
          width: double.infinity,
        ),
        preferredSize: Size.fromHeight(rSize(36)),
      ),
      title: Column(
        children: [
          Text(
            widget.arguments['type'] ? '双色球' : '大乐透',
            style: TextStyle(
              color: Colors.white,
              fontSize: rSP(18),
            ),
          ),
          Text(
            '明日',
            style: TextStyle(
              color: Colors.white,
              fontSize: rSP(12),
            ),
          ),
        ],
      ),
      actions: [
        MaterialButton(
          minWidth: rSize(20),
          onPressed: () {},
          child: Image.asset(
            R.ASSETS_LOTTERY_REDEEM_LOTTERY_DETAIL_PNG,
            width: rSize(20),
            height: rSize(20),
          ),
        ),
        MaterialButton(
          minWidth: rSize(20),
          onPressed: () {},
          child: Image.asset(
            R.ASSETS_LOTTERY_REDEEM_LOTTERY_HISTORY_PNG,
            width: rSize(20),
            height: rSize(20),
          ),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: rSize(10),
              horizontal: rSize(16),
            ),
            child: Text(
              '选中号码两次设胆',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: rSP(12),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                LotteryView(
                  colorType: LotteryColorType.RED,
                  key: _redLotteryViewKey,
                  type: widget.arguments['type']
                      ? LotteryType.DOUBLE_LOTTERY
                      : LotteryType.BIG_LOTTERY,
                  onSelect: (selected) {
                    _redBalls = selected;

                    _countLotteryShot();
                  },
                ),
                SizedBox(height: rSize(15)),
                LotteryView(
                  onSelect: (selected) {
                    _blueBalls = selected;
                    _countLotteryShot();
                  },
                  key: _blueLotteryViewKey,
                  colorType: LotteryColorType.BLUE,
                  type: widget.arguments['type']
                      ? LotteryType.DOUBLE_LOTTERY
                      : LotteryType.BIG_LOTTERY,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: rSize(16)),
            child: Text(
              '快速选择',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: rSP(12),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: rSize(16),
              right: rSize(16),
              bottom: rSize(24),
              top: rSize(10),
            ),
            child: Row(
              children: [
                _buildFastCard('机选1注', () {
                  _redLotteryViewKey.currentState.random1Shot();
                  _blueLotteryViewKey.currentState.random1Shot();
                }),
                SizedBox(width: rSize(16)),
                _buildFastCard('机选5注', () {}),
                SizedBox(width: rSize(16)),
                _buildFastCard('后区全包', () {
                  _blueLotteryViewKey.currentState.selectAllBlue();
                }),
              ],
            ),
          ),
        ],
      ),
      bottomNavi: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: rSize(4),
              offset: Offset(0, rSize(2)),
            )
          ],
        ),
        child: SafeArea(
          bottom: true,
          top: false,
          child: Container(
            height: rSize(48),
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(width: 5),
                CustomImageButton(
                  padding: EdgeInsets.symmetric(
                    horizontal: rSize(10),
                  ),
                  onPressed: () {
                    _redLotteryViewKey.currentState.clear();
                    _blueLotteryViewKey.currentState.clear();
                  },
                  child: Image.asset(
                    R.ASSETS_LOTTERY_REDEEM_LOTTERY_DELETE_PNG,
                    width: rSize(16),
                    height: rSize(16),
                  ),
                ),
                VerticalDivider(
                  indent: rSize(16),
                  endIndent: rSize(16),
                  width: 1,
                  thickness: 1,
                  color: Color(0xFFCCCCCC),
                ),
                SizedBox(width: rSize(10)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${lotteryShots * 2}瑞币或$lotteryShots\彩票券',
                      style: TextStyle(
                        fontSize: rSP(12),
                        color: Color(0xFF666666),
                      ),
                    ),
                    Text(
                      '$lotteryShots\注',
                      style: TextStyle(
                        fontSize: rSP(12),
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _countLotteryShot() {
    if (widget.arguments['type']) {
      lotteryShots = RecookMath.combination(6, _redBalls.length) *
          RecookMath.combination(1, _blueBalls.length);
    } else {
      lotteryShots = RecookMath.combination(5, _redBalls.length) *
          RecookMath.combination(2, _blueBalls.length);
    }
    setState(() {});
  }

  _buildFastCard(String title, VoidCallback onTap) {
    return Expanded(
      child: CustomImageButton(
        onPressed: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFFFFF4F4),
            borderRadius: BorderRadius.circular(rSize(4)),
          ),
          height: rSize(36),
          child: Text(
            title,
            style: TextStyle(
              color: Color(0xFFE02020),
              fontSize: rSP(14),
            ),
          ),
        ),
      ),
    );
  }
}
