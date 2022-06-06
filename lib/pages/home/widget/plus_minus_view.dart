/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-11  09:45 
 * remark    : 
 * ====================================================
 */

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/input_view.dart';
import 'package:oktoast/oktoast.dart';

typedef PlusMinusViewCallback = Function(int num);

class PlusMinusView extends StatefulWidget {
  final int minValue;
  final int? maxValue;
  final int? initialValue;
  final TextInputChangeCallBack? onBeginInput;
  final PlusMinusViewCallback onValueChanged;
  final TextInputChangeCallBack? onInputComplete;

  const PlusMinusView(
      {Key? key, this.minValue = 1,
      this.maxValue = 9999,
      required this.onValueChanged,
      this.onInputComplete,
      this.initialValue,
      this.onBeginInput});

  @override
  State<StatefulWidget> createState() {
    return _PlusMinusViewState();
  }
}

class _PlusMinusViewState extends State<PlusMinusView> {
  TextEditingController? _controller;

  int lastValue = 1;

  @override
  void initState() {
    super.initState();
    int initial = widget.initialValue ?? widget.minValue;
    _controller = TextEditingController(text: initial.toString());

  }


  // @override
  // void didUpdateWidget(covariant PlusMinusView oldWidget) {
  //   _controller.text=widget.initialValue.toString();
  //   super.didUpdateWidget(oldWidget);
  // }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller!.dispose();
  }




  @override
  Widget build(BuildContext context) {
    // if (widget.initialValue != null) {
    //   _controller.text = widget.initialValue.toString();
    // }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Spacer(),
            CustomImageButton(
              height: 25,
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 0),
              backgroundColor: Color.fromARGB(255, 241, 242, 244),
              icon: Icon(
                AppIcons.icon_minus,
                color: Colors.grey[500],
                size: 10,
              ),
              disabledColor: Colors.red,
              onPressed: _controller!.text == ''
                  ? (){

              }
                  : int.parse(_controller!.text) <= widget.minValue
                      ? () {
                BotToast.showText(text: '已是最低数量');

              }
                      : () {
                          int num = int.parse(_controller!.text);
                          num--;
                          if (num <= widget.minValue) {
                            num = widget.minValue;
                          }
                          _controller!.text = "$num";
                          DPrint.printf("${_controller!.text}, $lastValue");
                          if ((num == widget.minValue &&
                                  lastValue != widget.minValue) ||
                              (lastValue == widget.maxValue)) {
                            setState(() {});
                          }
                          lastValue = num;
                          widget.onInputComplete!(num.toString());
                        },
            ),
            Container(
              height: 25,
              width: 40,
              color: Color.fromARGB(255, 241, 242, 244),
              margin: EdgeInsets.symmetric(horizontal: 2),
              child: InputView(
                textStyle: AppTextStyle.generate(13, color: Colors.black),
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1.2),
                showClear: false,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onBeginInput: widget.onBeginInput,
                onInputComplete: (value) {
                  if (TextUtils.isEmpty(value, whiteSpace: true)) {
                    _controller!.text = lastValue.toString();
                    // value = lastValue.toString();
                  } else {
                    if (int.parse(value) <= widget.minValue) {
                      _controller!.text = "${widget.minValue}";
                    } else if (int.parse(value) >= widget.maxValue!) {
                      showToast("已经达到最大购买数量!",
                          textStyle: TextStyle(fontSize: 14 * 2.sp),
                          textPadding: EdgeInsets.only(
                              left: 15, right: 15, top: 5, bottom: 5),
                          backgroundColor: Colors.red,
                          duration: Duration(milliseconds: 2500),
                          position: ToastPosition(
                              align: Alignment.topCenter,
                              offset: MediaQuery.of(context).size.height / 2),
                          dismissOtherToast: true);
                      // Toast.showError("已经达到最大购买数量!", offset: -50.0);
                      _controller!.text = "${widget.maxValue}";
                    }
                    lastValue = int.parse(_controller!.text);
                    setState(() {});
                  }
                  widget.onInputComplete!(lastValue.toString());
                },
                controller: _controller,
                onValueChanged: (string) {
                  if(string==null){
                    widget.onValueChanged(0);
                    _controller!.text = '0';
                  } else {
                    widget.onValueChanged(int.parse(_controller!.text));
                  }
                },
              ),
            ),
            CustomImageButton(
              height: 25,
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 0),
              backgroundColor: Color.fromARGB(255, 241, 242, 244),
              icon: Icon(
                AppIcons.icon_plus,
                color: Colors.grey[500],
                size: 10,
              ),
              onPressed: _controller!.text == ''
                  ? null
                  : int.parse(_controller!.text) >= widget.maxValue!
                      ? () {
                          showToast("已经达到最大购买数量!",
                              textStyle: TextStyle(fontSize: 14 * 2.sp),
                              textPadding: EdgeInsets.only(
                                  left: 15, right: 15, top: 5, bottom: 5),
                              backgroundColor: Colors.red,
                              duration: Duration(milliseconds: 2500),
                              position: ToastPosition(
                                  align: Alignment.topCenter,
                                  offset:
                                      MediaQuery.of(context).size.height / 2),
                              dismissOtherToast: true);
                        }
                      : () {
                          int num = int.parse(_controller!.text);
                          num++;
                          _controller!.text = "$num";
                          if (lastValue == widget.minValue ||
                              (num == widget.maxValue &&
                                  lastValue != widget.maxValue)) {
                            setState(() {});
                          }
                          lastValue = num;
                          widget.onInputComplete!(num.toString());
                        },
            ),
            20.wb,
          ],
        ),
      ),
    );
  }
}
