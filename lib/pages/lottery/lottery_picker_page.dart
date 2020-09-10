import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/lottery/lottery_cart_model.dart';
import 'package:recook/pages/lottery/redeem_lottery_page.dart';
import 'package:recook/pages/lottery/widget/lottery_ball.dart';
import 'package:recook/pages/lottery/widget/lottery_result_boxes.dart';
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
  List<int> _focusedRedBalls = [];
  List<int> _focusedBlueBalls = [];

  bool _random1ShotSelected = false;
  bool _randomAllBlueSelected = false;

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
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: rSize(16),
                  right: rSize(12),
                ),
                child: Text(
                  '2020077期',
                  style: TextStyle(
                    color: Color(0xFFE02020),
                    fontSize: rSP(12),
                  ),
                ),
              ),
              Expanded(
                child: LotteryResultBoxes(
                  type: LotteryType.DOUBLE_LOTTERY,
                  small: true,
                  redBalls: [1, 2, 3, 4, 5, 6],
                  blueBalls: [1],
                ),
              ),
              SizedBox(width: rSize(80)),
            ],
          ),
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
        SizedBox(
          width: rSize(20 + 15.0),
          child: FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () => AppRouter.push(
              context,
              RouteName.LOTTERY_HELP_PAGE,
              arguments: {'type': widget.arguments['type']},
            ),
            child: Image.asset(
              R.ASSETS_LOTTERY_REDEEM_LOTTERY_DETAIL_PNG,
              width: rSize(20),
              height: rSize(20),
            ),
          ),
        ),
        SizedBox(
          width: rSize(20 + 15.0),
          child: FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () => AppRouter.push(
              context,
              RouteName.LOTTERY_HISTORY_PAGE,
              arguments: {'type': widget.arguments['type']},
            ),
            child: Image.asset(
              R.ASSETS_LOTTERY_REDEEM_LOTTERY_HISTORY_PNG,
              width: rSize(20),
              height: rSize(20),
            ),
          ),
        ),
        SizedBox(width: rSize(7.5)),
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
                  onSelect: (selected, focused) {
                    _redBalls = selected;
                    _focusedRedBalls = focused;
                    _countLotteryShot();
                  },
                ),
                SizedBox(height: rSize(15)),
                LotteryView(
                  onSelect: (selected, focused) {
                    _blueBalls = selected;
                    _focusedBlueBalls = focused;
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
                _buildFastCard(
                  '机选1注',
                  () {
                    _clearAllSelect();
                    _random1ShotSelected = true;
                    _redLotteryViewKey.currentState.random1Shot();
                    _blueLotteryViewKey.currentState.random1Shot();
                  },
                  selected: _random1ShotSelected,
                  imagePath: R.ASSETS_LOTTERY_REDEEM_RANDOM_PNG,
                ),
                SizedBox(width: rSize(16)),
                _buildFastCard(
                  '机选5注',
                  () {
                    _clearAllSelect();
                  },
                ),
                SizedBox(width: rSize(16)),
                _buildFastCard(
                  '后区全包',
                  () {
                    _clearAllSelect();
                    _randomAllBlueSelected = true;
                    _redLotteryViewKey.currentState.random1Shot();
                    _blueLotteryViewKey.currentState.selectAllBlue();
                  },
                  selected: _randomAllBlueSelected,
                  imagePath: R.ASSETS_LOTTERY_REDEEM_WIN_PNG,
                ),
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
                SizedBox(
                  width: rSize(115),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      lotteryShots == 0
                          ? Text(
                              widget.arguments['type']
                                  ? '至少选6红球1蓝球'
                                  : '至少选5红球2蓝球',
                              style: TextStyle(
                                height: 1,
                                fontSize: rSP(12),
                                color: Color(0xFF666666),
                              ),
                            )
                          : SizedBox(),
                      lotteryShots == 0
                          ? SizedBox()
                          : Text(
                              '${lotteryShots * 2}瑞币或$lotteryShots\彩票券',
                              maxLines: 2,
                              style: TextStyle(
                                height: 1,
                                fontSize: rSP(12),
                                color: Color(0xFF666666),
                              ),
                            ),
                      lotteryShots == 0
                          ? SizedBox()
                          : Text(
                              '$lotteryShots\注',
                              style: TextStyle(
                                fontSize: rSP(12),
                                color: Color(0xFF666666),
                              ),
                            ),
                    ],
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: _addShot,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(rSize(20)),
                      ),
                    ),
                    color: Color(0xFFFF8534),
                    child: Text(
                      '加入选号',
                      style: TextStyle(
                        fontSize: rSP(14),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: _complateShot,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(rSize(20)),
                      ),
                    ),
                    color: Color(0xFFE02020),
                    child: Builder(
                      builder: (context) {
                        final storeSize = widget.arguments['type']
                            ? LotteryCartStore.doubleLotteryModels.length
                            : LotteryCartStore.bigLotteryModels.length;
                        return Text(
                          '完成选号($storeSize)',
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontSize: rSP(14),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: rSize(15)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addShot() {
    if (lotteryShots == 0) {
      showToast(widget.arguments['type'] ? '至少选6红球1蓝球' : '至少选5红球2蓝球');
    } else {
      _addOneShot();
      _clearAllSelect();
      setState(() {});
    }
  }

  _complateShot() {
    final bool isDoubleLottery = widget.arguments['type'];

    ///空购物车
    final bool emptyCart = isDoubleLottery
        ? LotteryCartStore.doubleLotteryModels.isEmpty
        : LotteryCartStore.bigLotteryModels.isEmpty;

    ///未选择
    final bool emptySelect = _redBalls.isEmpty && _blueBalls.isEmpty;

    ///注数为0
    final bool shotZero = lotteryShots == 0;

    if (emptySelect && emptyCart) {
      _helpRandom1Shot();
      _addOneShot();
      _clearAllSelect();
      AppRouter.push(context, RouteName.LOTTERY_CART_PAGE,
              arguments: {'type': widget.arguments['type']})
          .then((value) => setState(() {}));
    } else if (emptySelect && !emptyCart) {
      AppRouter.push(context, RouteName.LOTTERY_CART_PAGE,
              arguments: {'type': widget.arguments['type']})
          .then((value) => setState(() {}));
    } else if (shotZero) {
      showToast(widget.arguments['type'] ? '至少选6红球1蓝球' : '至少选5红球2蓝球');
    } else {
      _addOneShot();
      _clearAllSelect();
      AppRouter.push(context, RouteName.LOTTERY_CART_PAGE,
              arguments: {'type': widget.arguments['type']})
          .then((value) => setState(() {}));
    }
  }

  _helpRandom1Shot() {
    _redLotteryViewKey.currentState.random1Shot();
    _blueLotteryViewKey.currentState.random1Shot();
    Future.delayed(Duration(milliseconds: 500), () {
      showToast('已帮您机选一注');
    });
  }

  _addOneShot() {
    LotteryCartStore.add1Shot(
      widget.arguments['type']
          ? LotteryType.DOUBLE_LOTTERY
          : LotteryType.BIG_LOTTERY,
      LotteryCartModel(
        type: LotteryType.DOUBLE_LOTTERY,
        redBalls: _redBalls,
        blueBalls: _blueBalls,
        focusedRedBalls: _focusedRedBalls,
        focusedBlueBalls: _focusedBlueBalls,
      ),
    );
  }

  _countLotteryShot() {
    lotteryShots = LotteryCartStore.countLotteryBalls(
      widget.arguments['type']
          ? LotteryType.DOUBLE_LOTTERY
          : LotteryType.BIG_LOTTERY,
      redBalls: _redBalls,
      blueBalls: _blueBalls,
      focusedRedBalls: _focusedRedBalls,
      focusedBlueBalls: _focusedBlueBalls,
    );

    setState(() {});
  }

  _clearAllSelect() {
    _redLotteryViewKey.currentState.clear();
    _blueLotteryViewKey.currentState.clear();
    _focusedBlueBalls.clear();
    _focusedRedBalls.clear();
    _random1ShotSelected = false;
    _randomAllBlueSelected = false;
  }

  _buildFastCard(String title, VoidCallback onTap,
      {bool selected = false, String imagePath}) {
    return Expanded(
      child: CustomImageButton(
        onPressed: onTap,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? Color(0xFFE02020) : Color(0xFFFFF4F4),
                borderRadius: BorderRadius.circular(rSize(4)),
              ),
              height: rSize(36),
              child: Text(
                title,
                style: TextStyle(
                  color: selected ? Colors.white : Color(0xFFE02020),
                  fontSize: rSP(14),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: selected
                  ? Image.asset(
                      imagePath,
                      width: rSize(38),
                      height: rSize(27),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
