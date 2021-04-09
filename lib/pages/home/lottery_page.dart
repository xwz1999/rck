import 'package:flutter/material.dart';

import 'package:recook/widgets/bingo_card_widget.dart';

class LotteryPage extends StatefulWidget {
  final num cardIndex;
  LotteryPage({Key key, this.cardIndex}) : super(key: key);

  @override
  _LotteryPageState createState() => _LotteryPageState();
}

class _LotteryPageState extends State<LotteryPage> {
  BingoCardController _controller = BingoCardController();
  @override
  Widget build(BuildContext context) {
    final cardFace = Image.asset('assets/lottery/face.png');
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(100),
      body: Center(
        child: BingoCardWidget(
          controller: _controller,
          bingoType: widget.cardIndex,
          bingoCardModels: <BingoCardModel>[
            //未中奖
            BingoCardModel(
              isBingo: 0 == widget.cardIndex,
              cardFaceBack: Image.asset('assets/lottery/fail.png'),
              cardFaceFront: cardFace,
            ),
            //保障卡
            BingoCardModel(
              isBingo: 1 == widget.cardIndex,
              cardFaceBack: Image.asset('assets/lottery/keep_level.png'),
              cardFaceFront: cardFace,
            ),
            //晋升卡
            BingoCardModel(
              isBingo: 2 == widget.cardIndex,
              cardFaceBack: Image.asset('assets/lottery/upgrade.png'),
              cardFaceFront: cardFace,
            ),
          ],
        ),
      ),
    );
  }
}
