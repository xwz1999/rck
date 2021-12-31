/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-17  17:40 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/input_view.dart';

typedef StringCallback = Function(String text);

class EditTile extends StatefulWidget {
  final String title;
  final String value;
  final String hint;
  final int maxLength;
  final int maxLines;
  final TextStyle titleStyle;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final StringCallback textChanged;
  final Axis direction;
  final BoxConstraints constraints;

  const EditTile({
    Key key,
    this.title,
    this.textChanged,
    this.value,
    this.hint,
    this.titleStyle = const TextStyle(
        color: Colors.black, fontWeight: FontWeight.w300, fontSize: 15),
    this.textStyle = const TextStyle(
        color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
    this.hintStyle = const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
    this.direction = Axis.horizontal,
    this.constraints,
    this.maxLength = 100,
    this.maxLines = 1,
  }) : assert(textChanged != null);

  @override
  _EditTileState createState() => _EditTileState();
}

class _EditTileState extends State<EditTile> {
  TextEditingController _controller;
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Container(
        constraints: widget.constraints,
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(color: Colors.grey[200], width: 0.5))),
        child:
            widget.direction == Axis.horizontal ? _horizontal() : _vertical(),
      ),
    );
  }

  Row _horizontal() {
    return Row(
      children: <Widget>[
        Container(
          width: rSize(80),
          child: Text(
            widget.title,
            style: widget.titleStyle,
          ),
        ),
        Expanded(
            child: InputView(
          focusNode: _focusNode,
          controller: _controller,
          maxLength: widget.maxLength,
          hintStyle: widget.hintStyle,
          textStyle: widget.textStyle,
          onValueChanged: (string) {
            widget.textChanged(string);
          },
          hint: widget.hint,
        )),
      ],
    );
  }

  _vertical() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          height: rSize(40),
          child: Text(
            widget.title,
            style: widget.titleStyle,
          ),
        ),
        Expanded(
            child: InputView(
          focusNode: _focusNode,
          padding: EdgeInsets.symmetric(horizontal: 3),
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          controller: _controller,
          hintStyle: widget.hintStyle,
          textStyle: widget.textStyle,
          onValueChanged: (string) {
            widget.textChanged(string);
          },
          hint: widget.hint,
        )),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
