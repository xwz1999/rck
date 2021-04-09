import 'package:flutter/material.dart';

import 'package:oktoast/oktoast.dart';

import 'package:recook/const/resource.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/lottery/lottery_cart_model.dart';
import 'package:recook/pages/lottery/lottery_cart_page.dart';
import 'package:recook/pages/lottery/lottery_history_page.dart';
import 'package:recook/pages/lottery/models/lottery_list_model.dart';
import 'package:recook/pages/lottery/redeem_lottery_page.dart';
import 'package:recook/pages/lottery/tools/lottery_tool.dart';
import 'package:recook/pages/lottery/widget/lottery_ball.dart';
import 'package:recook/pages/lottery/widget/lottery_result_boxes.dart';
import 'package:recook/pages/lottery/widget/lottery_scaffold.dart';
import 'package:recook/pages/lottery/widget/lottery_view.dart';
import 'package:recook/pages/user/user_verify.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_image_button.dart';

class LotteryPickerPage extends StatefulWidget {
  final bool isDouble;
  final LotteryListModel lotteryListModel;
  LotteryPickerPage({
    Key key,
    @required this.isDouble,
    @required this.lotteryListModel,
  }) : super(key: key);

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
                  '${widget.lotteryListModel.last.number}期',
                  style: TextStyle(
                    color: Color(0xFFE02020),
                    fontSize: rSP(12),
                  ),
                ),
              ),
              Expanded(
                child: LotteryResultBoxes(
                  small: true,
                  redBalls: parseBalls(widget.lotteryListModel.last.bonusCode),
                  blueBalls: parseBalls(
                    widget.lotteryListModel.last.bonusCode,
                    red: false,
                  ),
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
            '${widget.isDouble ? '双色球' : '大乐透'}${widget.lotteryListModel.now.number.substring(
              widget.lotteryListModel.now.number.length - 3,
            )}期',
            style: TextStyle(
              color: Colors.white,
              fontSize: rSP(18),
            ),
          ),
          Text(
            lotteryDisplayDay(widget.lotteryListModel.now.stopTime),
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
              arguments: {'type': widget.isDouble},
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
            onPressed: () {
              CRoute.push(
                context,
                LotteryHistoryPage(id: widget.lotteryListModel.id),
              );
            },
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
                  type: widget.isDouble
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
                  type: widget.isDouble
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
                    _checkVerify(() {
                      for (int i = 0; i < 5; i++) {
                        _clearAllSelect();
                        _redLotteryViewKey.currentState.random1Shot();
                        _blueLotteryViewKey.currentState.random1Shot();
                        _addShot();
                      }
                      _complateShot();
                    });
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
                              widget.isDouble ? '至少选6红球1蓝球' : '至少选5红球2蓝球',
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
                              '${lotteryShots * 2}瑞币',
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
                  child: Builder(
                    builder: (context) {
                      int doubleShots = 0;
                      int bigShots = 0;
                      LotteryCartStore.doubleLotteryModels.forEach((element) {
                        doubleShots += element.shots;
                      });
                      LotteryCartStore.bigLotteryModels.forEach((element) {
                        bigShots += element.shots;
                      });
                      final storeSize =
                          widget.isDouble ? doubleShots : bigShots;
                      return Stack(
                        overflow: Overflow.visible,
                        children: [
                          FlatButton(
                            onPressed: _complateShot,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(rSize(20)),
                              ),
                            ),
                            color: Color(0xFFE02020),
                            child: Text(
                              '完成选号',
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: rSP(14),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -rSize(8),
                            right: rSize(8),
                            child: storeSize == 0
                                ? SizedBox()
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE02020),
                                      border: Border.all(
                                        width: rSize(1),
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 5,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '$storeSize',
                                      style: TextStyle(
                                        fontSize: rSP(12),
                                        color: Colors.white,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: rSize(5),
                                      vertical: rSize(2),
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
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
    _checkVerify(() {
      if (lotteryShots == 0) {
        showToast(widget.isDouble ? '至少选6红球1蓝球' : '至少选5红球2蓝球');
      } else {
        _addOneShot();
        _clearAllSelect();
        setState(() {});
      }
    });
  }

  _complateShot() {
    _checkVerify(() {
      final bool isDoubleLottery = widget.isDouble;

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
        CRoute.push(context, LotteryCartPage(isDouble: widget.isDouble))
            .then((value) => setState(() {}));
      } else if (emptySelect && !emptyCart) {
        CRoute.push(context, LotteryCartPage(isDouble: widget.isDouble))
            .then((value) => setState(() {}));
      } else if (shotZero) {
        showToast(widget.isDouble ? '至少选6红球1蓝球' : '至少选5红球2蓝球');
      } else {
        _addOneShot();
        _clearAllSelect();
        CRoute.push(context, LotteryCartPage(isDouble: widget.isDouble))
            .then((value) => setState(() {}));
      }
    });
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
      widget.isDouble ? LotteryType.DOUBLE_LOTTERY : LotteryType.BIG_LOTTERY,
      LotteryCartModel(
        type: widget.isDouble
            ? LotteryType.DOUBLE_LOTTERY
            : LotteryType.BIG_LOTTERY,
        redBalls: _redBalls..sort(),
        blueBalls: _blueBalls..sort(),
        focusedRedBalls: _focusedRedBalls..sort(),
        focusedBlueBalls: _focusedBlueBalls..sort(),
      ),
    );
  }

  _countLotteryShot() {
    lotteryShots = LotteryCartStore.countLotteryBalls(
      widget.isDouble ? LotteryType.DOUBLE_LOTTERY : LotteryType.BIG_LOTTERY,
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

  _checkVerify(VoidCallback onCallBack) {
    if (UserManager.instance.user.info.realInfoStatus) {
      onCallBack();
    } else {
      showDialog(
        context: context,
        builder: (context) => NormalTextDialog(
          title: '请先完成实名认证',
          content: '',
          items: ['取消', '去认证'],
          listener: (index) {
            switch (index) {
              case 0:
                Navigator.pop(context);
                break;
              case 1:
                Navigator.pop(context);
                CRoute.push(context, VerifyPage());
                break;
            }
          },
        ),
      );
    }
  }
}
