import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/sudoku_model.dart';
import 'package:recook/pages/life_service/sudoku_start_game_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:velocity_x/velocity_x.dart';

///数独游戏生成器
class SudokuGameResultPage extends StatefulWidget {
  final String type;
  final SudokuDealModel sudokuDealModel;

  const SudokuGameResultPage({Key? key, required this.type, required this.sudokuDealModel}) : super(key: key);

  @override
  _SudokuGameResultPageState createState() => _SudokuGameResultPageState();
}

class _SudokuGameResultPageState extends State<SudokuGameResultPage> {

  late SudokuDealModel sudokuDealModel;

  @override
  void initState() {
    super.initState();
    sudokuDealModel = widget.sudokuDealModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text('数独答案',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 17.rsp,
            )),
      ),
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.rw),
          child: RichText(
            text: TextSpan(
                text: '难度级别：',
                style: TextStyle(
                    fontSize: 14.rsp,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: widget.type,
                      style: TextStyle(
                        fontSize: 12.rsp,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                      ))
                ]),
          ),
        ),
        Container(
          width: 355.rw,
          height: 355.rw,
          margin: EdgeInsets.all(12.rw),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.rw),
              border: Border.all(color: Color(0xFF666666), width: 2.rw)),
          child: Column(
            children: [
              ...sudokuDealModel.puzzle
                  .mapIndexed((rowValue, i) => Row(
                        children: [
                          ...rowValue.list
                              .mapIndexed((columnValue, j) =>
                                  Expanded(child: _box(columnValue, i, j)))
                              .toList()
                        ],
                      ))
                  .toList()
            ],
          ),
        ),
        40.hb,
        Row(
          children: [

            40.wb,
            Expanded(
              child: CustomImageButton(
                height: 42.rw,
                title: "返回",
                backgroundColor: AppColor.themeColor,
                color: Colors.white,
                fontSize: 14.rsp,
                borderRadius: BorderRadius.all(Radius.circular(21.rw)),
                onPressed: () {
                    Get.back();
                },
              ),
            ),
            40.wb,
          ],
        ),
      ],
    );
  }

  _box(OneModel model, int row, int column) {
    return Container(
      height: 39.rw,
      decoration: BoxDecoration(
        color: _getValue(model.value)
                ? model.needCheck!=null&& model.needCheck!?Color(0xFFE6F3FF): Colors.white
                :  Color(0xFFE6F3FF),
        border: Border(
          right: column == 8
              ? BorderSide.none
              : column == 2 || column == 5
                  ? BorderSide(color: Color(0xFF666666), width: 2.rw)
                  : BorderSide(color: Color(0xFFE8E8E8), width: 0.5.rw),
          bottom: row == 8
              ? BorderSide.none
              : row == 2 || row == 5
                  ? BorderSide(color: Color(0xFF666666), width: 2.rw)
                  : BorderSide(color: Color(0xFFE8E8E8), width: 0.5.rw),
          top: row == 0
              ? BorderSide.none
              : BorderSide(color: Color(0xFFE8E8E8), width: 0.5.rw),
          left: row == 0
              ? BorderSide.none
              : BorderSide(color: Color(0xFFE8E8E8), width: 0.5.rw),
        ),
      ), // Border.all(color: Color(0xFFE8E8E8), width: 0.5.rw)),
      alignment: Alignment.center,
      child: Text(
        _getValue(model.key) ? model.key.toString() : '',
        style: TextStyle(color: Color(0xFF333333), fontSize: 20.rsp),
      ),
    );
  }
}

_getValue(num? value) {
  return value != null && value != 0;
}
