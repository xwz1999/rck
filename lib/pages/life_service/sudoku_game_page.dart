import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/life_service/sudoku_start_game_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';

///数独游戏生成器
class SudokuGamePage extends StatefulWidget {
  const SudokuGamePage({Key? key}) : super(key: key);

  @override
  _SudokuGamePageState createState() => _SudokuGamePageState();
}

class _SudokuGamePageState extends State<SudokuGamePage> {
  String type = 'easy';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      extendBody: true,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        themeData: AppThemes.themeDataGrey.appBarTheme,
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
    return Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            48.wb,
            Text('选择难度级别',
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontWeight: FontWeight.bold,
                  fontSize: 14.rsp,
                )),
          ],
        ),
        24.hb,
        GestureDetector(
          onTap: (){
            type = 'easy';
            Get.to(()=>SudokuStartGamePage(type: '简单',));
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.rw),
            padding: EdgeInsets.only(left: 24.rw,right: 24.rw),
            height: 92.rw,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.rw),
              border: Border.all(color: Color(0xFFE8E8E8), width: 0.5.rw),
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('简单',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.rsp,
                        )),
                    5.hb,
                    Text('EASY',
                        style: TextStyle(
                          color: Color(0xFFDB2D2D),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.rsp,
                        )),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black38,
                  size: 28 * 2.sp,
                ),


              ],
            ),
          ),
        ),
        64.hb,
        GestureDetector(
          onTap: (){
            type = 'normal';
            Get.to(()=>SudokuStartGamePage(type: '普通',));
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.rw),
            padding: EdgeInsets.only(left: 24.rw,right: 24.rw),
            height: 92.rw,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.rw),
              border: Border.all(color: Color(0xFFE8E8E8), width: 0.5.rw),
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('普通',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.rsp,
                        )),
                    5.hb,
                    Text('NORMAL',
                        style: TextStyle(
                          color: Color(0xFFDB2D2D),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.rsp,
                        )),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black38,
                  size: 28 * 2.sp,
                ),


              ],
            ),
          ),
        ),
        64.hb,
        GestureDetector(
          onTap: (){
            type = 'hard';
            Get.to(()=>SudokuStartGamePage(type: '困难',));
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.rw),
            padding: EdgeInsets.only(left: 24.rw,right: 24.rw),
            height: 92.rw,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.rw),
              border: Border.all(color: Color(0xFFE8E8E8), width: 0.5.rw),
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('困难',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.rsp,
                        )),
                    5.hb,
                    Text('DIFFICULTY',
                        style: TextStyle(
                          color: Color(0xFFDB2D2D),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.rsp,
                        )),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black38,
                  size: 28 * 2.sp,
                ),


              ],
            ),
          ),
        ),
        64.hb,
        GestureDetector(
            onTap: (){
              type = 'veryhard';
              Get.to(()=>SudokuStartGamePage(type: '非常困难',));
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.rw),
            padding: EdgeInsets.only(left: 24.rw,right: 24.rw),
            height: 92.rw,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.rw),
              border: Border.all(color: Color(0xFFE8E8E8), width: 0.5.rw),
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('非常困难',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.rsp,
                        )),
                    5.hb,
                    Text('VERY DIFFICULTY',
                        style: TextStyle(
                          color: Color(0xFFDB2D2D),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.rsp,
                        )),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black38,
                  size: 28 * 2.sp,
                ),


              ],
            ),
          ),
        ),
      ],

    );
  }
}
