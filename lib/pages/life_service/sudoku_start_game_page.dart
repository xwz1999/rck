import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/sudoku_model.dart';
import 'package:recook/pages/life_service/sudoku_game_result_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:velocity_x/velocity_x.dart';

///数独游戏生成器
class SudokuStartGamePage extends StatefulWidget {
  final String type;

  const SudokuStartGamePage({Key? key, required this.type}) : super(key: key);

  @override
  _SudokuStartGamePageState createState() => _SudokuStartGamePageState();
}

class _SudokuStartGamePageState extends State<SudokuStartGamePage> {
  late SudokuModel sudokuModel;
  late SudokuDealModel sudokuDealModel;
  List<IntModel> puzzleList = [];
  List<IntModel> solutionList = [];

  int chooseX = -1;
  int chooseY = -1;

  bool checkAnswer = true;

  bool allRight = true;


  @override
  void initState() {
    super.initState();
    sudokuModel = SudokuModel(solution: [
      IntModel(puzzle: [9, 3, 8, 7, 6, 2, 4, 5, 1]),
      IntModel(puzzle: [1, 5, 6, 3, 8, 4, 9, 7, 2]),
      IntModel(puzzle: [4, 7, 2, 1, 9, 5, 3, 8, 6]),
      IntModel(puzzle: [5, 1, 9, 6, 3, 7, 8, 2, 4]),
      IntModel(puzzle: [3, 8, 7, 2, 4, 1, 5, 6, 9]),
      IntModel(puzzle: [6, 2, 4, 8, 5, 9, 1, 3, 7]),
      IntModel(puzzle: [2, 4, 1, 5, 7, 3, 6, 9, 8]),
      IntModel(puzzle: [8, 9, 5, 4, 2, 6, 7, 1, 3]),
      IntModel(puzzle: [7, 6, 3, 9, 1, 8, 2, 4, 5]),
    ], puzzle: [
      IntModel(puzzle: [0, 3, 8, 7, 6, 2, 0, 5, 1]),
      IntModel(puzzle: [1, 0, 0, 3, 8, 4, 9, 0, 2]),
      IntModel(puzzle: [4, 7, 2, 1, 9, 5, 0, 0, 6]),
      IntModel(puzzle: [0, 1, 0, 0, 0, 0, 8, 0, 0]),
      IntModel(puzzle: [0, 0, 0, 0, 0, 1, 0, 0, 9]),
      IntModel(puzzle: [6, 2, 0, 8, 0, 0, 1, 3, 7]),
      IntModel(puzzle: [2, 4, 1, 0, 7, 3, 6, 9, 0]),
      IntModel(puzzle: [8, 9, 5, 4, 2, 6, 7, 1, 3]),
      IntModel(puzzle: [0, 6, 3, 9, 1, 8, 2, 0, 5]),
    ]);

    puzzleList = sudokuModel.puzzle;
    solutionList = sudokuModel.solution;
    sudokuDealModel = SudokuDealModel(
        puzzle: sudokuModel.puzzle
            .map((e) => IntDealModel(list: [
                  ...e.puzzle
                      .map((e) => OneModel(value: e, needCheck: e == 0))
                      .toList()
                ]))
            .toList());

    // sudokuDealModel =  SudokuDealModel(puzzle: sudokuModel.solution.map((e) => IntDealModel(list: [
    //   ...e.puzzle.map((e) => OneModel(key: e,)).toList()
    // ]
    // )).toList(),);

    sudokuModel.solution.forEachIndexed((i, element) {
      element.puzzle.forEachIndexed((j, e) {
        sudokuDealModel.puzzle[i].list[j].key = e;
      });
    });
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
        title: Text('数独游戏生成器',
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
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 40.rw),
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              mainAxisSpacing: 14,
              crossAxisSpacing: 57),
          itemCount: 9,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                if(chooseY!=-1&&chooseX!=-1){
                  sudokuDealModel.puzzle[chooseX].list[chooseY].value = index+1;
                }
                setState(() {

                });
              },
              child: Container(
                constraints: BoxConstraints(maxWidth: 60.rw, maxHeight: 60.rw),
                width: 60.rw,
                height: 60.rw,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFE8E8E8), width: 0.5.rw),
                    borderRadius: BorderRadius.circular(30.rw)),
                child:Text(
                  '${index+1}',
                  style: TextStyle(color: Color(0xFF666666), fontSize: 32.rsp),
                ),
              ),
            );
          },
        ),
        40.hb,
        Row(
          children: [
            24.wb,
            Expanded(
              child: CustomImageButton(
                border: Border.all(color: AppColor.themeColor,width: 1.rw),
                height: 42.rw,
                title: "查看答案",
                backgroundColor: Colors.white,
                color: AppColor.themeColor,
                fontSize: 14.rsp,
                borderRadius: BorderRadius.all(Radius.circular(21.rw)),
                onPressed: () {
                    Get.to(()=>SudokuGameResultPage(sudokuDealModel: sudokuDealModel, type: widget.type,));
                },
              ),
            ),
            40.wb,
            Expanded(
              child: CustomImageButton(
                height: 42.rw,
                title: "检查答案",
                backgroundColor: AppColor.themeColor,
                color: Colors.white,
                fontSize: 14.rsp,
                borderRadius: BorderRadius.all(Radius.circular(21.rw)),
                onPressed: () {
                  sudokuDealModel.puzzle.forEachIndexed((i, element) {
                    element.list.forEachIndexed((j, e) {
                      if(e.needCheck!=null&&e.needCheck!){
                        if(e.value == e.key){
                          e.correct = 1;
                        }else{
                          e.correct = 0;
                          allRight = false;
                        }
                      }
                    });
                  });
                  checkAnswer = false;
                  Future.delayed(Duration(milliseconds:200),(){
                    checkAnswer = true;
                  });

                  setState(() {

                  });
                  if(allRight){
                    BotToast.showText(text: '恭喜你，全部回答正确');
                  }
                },
              ),
            ),
            24.wb,
          ],
        ),
      ],
    );
  }

  _box(OneModel model, int row, int column) {
    return GestureDetector(
      onTap: () {
        if (model.needCheck != null && model.needCheck!) {
          if (chooseX == row && chooseY == column) {
            chooseX = -1;
            chooseY = -1;
          } else {
            chooseX = row;
            chooseY = column;
          }
          setState(() {});
        }
      },
      child: Container(
        height: 39.rw,
        decoration: BoxDecoration(
          color:


          (chooseX == row && chooseY == column&&checkAnswer)
              ? Color(0xFF8CC8FF)
              :    model.correct!=-1?model.correct==1?Color(0xFF92daae):Color(0xFFFFE5E5):_getValue(model.value)
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
          _getValue(model.value) ? model.value.toString() : '',
          style: TextStyle(color: Color(0xFF333333), fontSize: 20.rsp),
        ),
      ),
    );
  }
}

_getValue(num? value) {
  return value != null && value != 0;
}

class OneModel {
  num? value;
  num? key;
  bool? needCheck;
  int correct;///默认为-1 0为不正确 1为正确

  OneModel({this.value, this.key, this.needCheck,this.correct =-1});
}
