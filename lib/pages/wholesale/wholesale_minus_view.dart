import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/input_view.dart';
import 'package:recook/widgets/toast.dart';

typedef PlusMinusViewCallback = Function(int num);

class WholesaleMinusView extends StatefulWidget {
  final int minValue;

  ///起批量
  final int initialValue;

  ///每手量（每次加减的量）
  final int limit;

  final TextInputChangeCallBack onBeginInput;
  final PlusMinusViewCallback onValueChanged;
  final TextInputChangeCallBack onInputComplete;

  const WholesaleMinusView(
      {this.minValue = 0,
      @required this.onValueChanged,
      this.onInputComplete,
      this.initialValue = 0,
      this.onBeginInput,
      this.limit = 1})
      : assert(onValueChanged != null);

  @override
  State<StatefulWidget> createState() {
    return _WholesaleMinusViewState();
  }
}

class _WholesaleMinusViewState extends State<WholesaleMinusView> {
  TextEditingController _controller;
  String textValue = '';
  int lastValue = 0;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {

      });
      if (!_focusNode.hasFocus) {
        if( _controller.text==null||_controller.text=='')
          _controller.text = widget.minValue.toString();

      } else {
        _controller.text = '';
        setState(() {

        });
      }
    });
    int initial = widget.initialValue ?? widget.minValue;
    _controller = TextEditingController(text: initial.toString());
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
        width: 95.rw,
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Spacer(),
            GestureDetector(
              onTap: int.parse(_controller.text==''?widget.minValue.toString():_controller.text) <= widget.minValue
                  ? (){
                BotToast.showText(text: '已是最低数量');
              }
                  : () {
                int num = int.parse(_controller.text==''?widget.minValue.toString():_controller.text);
                num = num - widget.limit;

                if (num <= widget.minValue) {
                  num = widget.minValue;
                }



                _controller.text = "$num";
                //DPrint.printf("${_controller.text}, ${lastValue}");

                if ((num == widget.minValue &&
                    lastValue != widget.minValue)) {
                  setState(() {});
                }
                lastValue = num;
                widget.onInputComplete(num.toString());
              },
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4.rw),bottomLeft:Radius.circular(4.rw), ),
                  border: Border(
                      left: BorderSide(
                          color: int.parse(_controller.text==''?widget.minValue.toString():_controller.text) <= widget.minValue
                              ? Color(
                            0xFFDDDDDD,
                          )
                              : Color(
                            0xFFBBBBBB,
                          ),
                          width: 1.rw),
                      top: BorderSide(
                          color: int.parse(_controller.text==''?widget.minValue.toString():_controller.text) <= widget.minValue
                              ? Color(
                            0xFFDDDDDD,
                          )
                              : Color(
                            0xFFBBBBBB,
                          ),
                          width: 1.rw),
                      bottom: BorderSide(
                          color: int.parse(_controller.text==''?widget.minValue.toString():_controller.text) <= widget.minValue
                              ? Color(
                            0xFFDDDDDD,
                          )
                              : Color(
                            0xFFBBBBBB,
                          ),
                          width: 1.rw),
                      right: BorderSide(
                          color: int.parse(_controller.text==''?widget.minValue.toString():_controller.text) <= widget.minValue
                              ? Color(
                            0xFFDDDDDD,
                          )
                              : Color(
                            0xFFBBBBBB,
                          ),
                          width: 1.rw),),
                ),

                height: 27.rw,
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 0),
                child: Icon(
                AppIcons.icon_minus,
                color: Colors.grey[500],
                size: 10,
              ),
              ),
            ),
            Container(
              height: 27.rw,
              width: 40.rw,

              decoration: BoxDecoration(
                color: Color(0xFFF6F6F6),
                border: Border(

                  top: BorderSide(
                      color: Color(
                        0xFFBBBBBB,
                      ),
                      width: 1.rw),
                  bottom: BorderSide(
                      color: Color(
                        0xFFBBBBBB,
                      ),
                      width: 1.rw),
                  // right: BorderSide(
                  //     color: Color(
                  //       0xFFBBBBBB,
                  //     ),
                  //     width: 1.rw),
                ),
              ),
              child: InputView(
                textStyle: AppTextStyle.generate(13.rsp, color: Color(0xFF333333)),
                padding: EdgeInsets.symmetric(horizontal: 1.rw, vertical: 1.2.rw),
                showClear: false,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onBeginInput: widget.onBeginInput,
                focusNode: _focusNode,
                onInputComplete: (value) {
                  if (TextUtils.isEmpty(value, whiteSpace: true)) {
                    _controller.text = lastValue.toString();
                    // value = lastValue.toString();
                  } else {
                    if (int.parse(value) <= widget.minValue) {
                      _controller.text = "${widget.minValue}";
                    }else{
                      if(int.parse(value)%widget.limit>0){
                        Toast.showInfo('请输入装箱率${widget.limit}的倍数');
                        _controller.text = (((int.parse(value))~/(widget.limit))*(widget.limit)).toString();
                      }

                    }
                    lastValue = int.parse(_controller.text==''?widget.minValue.toString():_controller.text);
                    setState(() {});

                  }
                  widget.onInputComplete(lastValue.toString());

                },
                controller: _controller,
                // onValueChanged: (string) {
                //
                // },
              ),
            ),
            GestureDetector(
              onTap: (){
                int num = int.parse(_controller.text);
                num = num + widget.limit;
                _controller.text = "$num";
                if (lastValue == widget.minValue) {
                  setState(() {});
                }
                lastValue = num;
                widget.onInputComplete(num.toString());
              },
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(4.rw),bottomRight:Radius.circular(4.rw), ),
                  border: Border(
                    top: BorderSide(
                        color: Color(
                          0xFFBBBBBB,
                        ),
                        width: 1.rw),
                    bottom: BorderSide(
                        color: Color(
                          0xFFBBBBBB,
                        ),
                        width: 1.rw),
                    right: BorderSide(
                        color: Color(
                          0xFFBBBBBB,
                        ),
                        width: 1.rw),
                    left: BorderSide(
                        color: Color(
                          0xFFBBBBBB,
                        ),
                        width: 1.rw),
                  ),
                  color: Color(0xFFF6F6F6),
                ),
                height: 27.rw,
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 0),
                child: Icon(
                  AppIcons.icon_plus,
                  color: Colors.grey[500],
                  size: 10,
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
