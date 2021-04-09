/*
 * ====================================================
 * package   : widgets
 * author    : Created by nansi.
 * time      : 2019/5/15  3:33 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';

class TextButton extends StatefulWidget {
  final String title;
  final double width;
  final double height;
  final GestureTapCallback onTap;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color textColor;
  final Color highlightTextColor;
  final Color backgroundColor;
  final Color highlightBackgroundColor;
  final Border border;
  final BorderRadius radius;
  final bool enable;
  final Color unableTextColor;
  final Color unableBackgroundColor;
  final double font;
  final FontWeight fontWeight;

  TextButton(
      {this.title,
      this.onTap,
      this.margin = const EdgeInsets.all(0),
      this.padding = const EdgeInsets.only(left: 8, right: 8),
      this.textColor = Colors.black,
      this.highlightTextColor,
      this.backgroundColor = Colors.white,
      this.highlightBackgroundColor,
      this.unableTextColor,
      this.unableBackgroundColor,
      this.border = const Border(),
      this.radius,
      this.enable = true,
      this.width,
      this.height,
        this.font,
        this.fontWeight})
      : assert(!TextUtils.isEmpty(title), "title不能为空");

  @override
  State<StatefulWidget> createState() {
    return _TextButtonState();
  }
}

class _TextButtonState extends State<TextButton> {
  Color _textColor;
  Color _backgroundColor;
  double _opacity = 1;

  @override
  void initState() {
    _backgroundColor = widget.backgroundColor;
    _textColor = widget.textColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: !_enable()
          ? null
          : (detail) {
              setState(() {
                _backgroundColor = widget.backgroundColor;
                _textColor = widget.textColor;
                _opacity = 1;
              });
            },
      onTapDown: !_enable()
          ? null
          : (detail) {
              setState(() {
                _backgroundColor =
                    widget.highlightBackgroundColor ?? _backgroundColor;
                _textColor = widget.highlightTextColor ?? _textColor;
                _opacity = 0.8;
              });
            },
      onTapCancel: !_enable()
          ? null
          : () {
              setState(() {
                _backgroundColor = widget.backgroundColor;
                _textColor = widget.textColor;
                _opacity = 1;
              });
            },
      onTap: widget.enable ? widget.onTap : null,
      child: Opacity(
        opacity: _opacity,
        child: Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          padding: widget.padding,
          decoration: BoxDecoration(
              color: !_enable()
                  ? widget.unableBackgroundColor ?? _backgroundColor
                  : _backgroundColor,
              borderRadius: widget.radius,
              border: widget.border),
          child: Center(
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: widget.font,
                  fontWeight: widget.fontWeight,
                  color: !_enable()
                      ? widget.unableTextColor ?? Colors.white
                      : _textColor),
            ),
          ),
        ),
      ),
    );
  }

  _enable() {
    return widget.enable && widget.onTap != null;
  }
}
