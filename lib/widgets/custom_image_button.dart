/*
 * ====================================================
 * package   : widgets
 * author    : Created by nansi.
 * time      : 2019/5/6  2:52 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';

enum Direction { vertical, horizontal }

class CustomImageButton extends StatefulWidget {
  CustomImageButton(
      {this.padding = const EdgeInsets.all(3),
      this.buttonSize,
      this.color = Colors.black,
      this.disabledColor = const Color(0xFF616161),
      this.backgroundColor,
      this.boxDecoration,
      this.onPressed,
      this.title,
      this.icon,
      this.fontSize = 14,
      this.width,
      this.height,
      this.borderRadius = const BorderRadius.all(Radius.circular(0)),
      this.direction = Direction.vertical,
      this.contentSpacing = 0,
      this.border,
      this.style,
      this.disableStyle,
      this.pureDisplay = false,
      this.child,
      this.dotNum = "",
      this.dotColor = Colors.red,
      this.dotPosition = const DotPosition(
        top: 0,
        left: null,
        right: 0,
        bottom: null,
      ),
      this.dotSize = 20,
      this.dotFontSize = 12,
      this.greyWhenTapped = false});

  final EdgeInsetsGeometry padding;
  final double contentSpacing;
  final double buttonSize;
  final double width;
  final double height;
  final Color color;
  final Color disabledColor;
  final Color backgroundColor;
  final BoxDecoration boxDecoration;
  final VoidCallback onPressed;
  final String title;
  final Widget icon;
  final double fontSize;
  final TextStyle style;
  final TextStyle disableStyle;
  final BorderRadius borderRadius;
  final Direction direction;
  final BoxBorder border;
  final pureDisplay;
  final Widget child;
  final String dotNum;
  final Color dotColor;
  final DotPosition dotPosition;
  final double dotSize;
  final double dotFontSize;
  final bool greyWhenTapped;

  @override
  State<StatefulWidget> createState() {
    return _CustomImageButtonState();
  }
}

class _CustomImageButtonState extends State<CustomImageButton> {
  bool _isTapping = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color currentColor;
    if (widget.onPressed != null || widget.pureDisplay)
      currentColor = widget.color;
    else
      currentColor = widget.disabledColor;

    return _buildGestureDetector(currentColor);
  }

  GestureDetector _buildGestureDetector(Color currentColor) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.pureDisplay ? null : widget.onPressed,
      onTapDown: widget.pureDisplay
          ? null
          : (detail) {
              setState(() {
                _isTapping = true;
              });
            },
      onTapUp: widget.pureDisplay
          ? null
          : (detail) {
              setState(() {
                _isTapping = false;
              });
            },
      onTapCancel: widget.pureDisplay
          ? null
          : () {
              setState(() {
                _isTapping = false;
              });
            },
      child: Opacity(
        opacity: !widget.pureDisplay &&
                (widget.onPressed == null ||
                    (_isTapping && widget.onPressed != null))
            ? 0.4
            : 1,
        child: Container(
          width: widget.width ?? widget.buttonSize,
          height: widget.height ?? widget.buttonSize,
          decoration: widget.boxDecoration != null
              ? widget.boxDecoration
              : BoxDecoration(
                  borderRadius: widget.borderRadius,
                  color: !widget.greyWhenTapped
                      ? widget.backgroundColor
                      : (_isTapping && widget.backgroundColor == null
                          ? Colors.grey[500]
                          : widget.backgroundColor),
                  border: widget.border),
          child: Stack(alignment: Alignment.center, children: [
            Container(
              padding: widget.padding,
              child: widget.child != null
                  ? widget.child
                  : (widget.direction == Direction.vertical
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: _content(context, currentColor),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: _content(context, currentColor),
                        )),
            ),
            Positioned(
                bottom: widget.dotPosition.bottom,
                top: widget.dotPosition.top,
                left: widget.dotPosition.left,
                right: widget.dotPosition.right,
                child: TextUtils.isEmpty(widget.dotNum)
                    ? Container()
                    : Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: rSize(2),
                          // vertical: rSize(2)
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(widget.dotSize)),
                            color: widget.dotColor),
                        constraints: BoxConstraints(
                          minWidth: ScreenAdapterUtils.setWidth(
                            widget.dotSize,
                          ),
                          minHeight: ScreenAdapterUtils.setWidth(
                            widget.dotSize,
                          ),
                        ),
                        child: Text(
                          widget.dotNum,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.generate(
                              ScreenAdapterUtils.setSp(widget.dotFontSize),
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ))
          ]),
        ),
      ),
    );
  }

  List<Widget> _content(context, Color currentColor) {
    return <Widget>[
      widget.icon != null
          ? IconTheme.merge(
              data: IconThemeData(color: currentColor, opacity: 1),
              child: widget.icon)
          // ? widget.icon
          : Container(),
      widget.title != null && widget.icon != null
          ? Container(
              width: widget.direction == Direction.horizontal
                  ? widget.contentSpacing
                  : 0,
              height: widget.direction == Direction.vertical
                  ? widget.contentSpacing
                  : 0,
            )
          : Container(),
      widget.title != null
          ? Text(
              widget.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: getTitleStyle(currentColor),
            )
          : Container(),
    ];
  }

  getTitleStyle(Color currentColor) {
    TextStyle style;
    if (widget.onPressed == null && !widget.pureDisplay) {
      style = widget.disableStyle ??
          TextStyle(color: currentColor, fontSize: widget.fontSize);
    } else {
      style = widget.style ??
          TextStyle(color: currentColor, fontSize: widget.fontSize);
    }
    return style;
  }
}

class DotPosition {
  final double left;
  final double right;
  final double top;
  final double bottom;

  const DotPosition({
    this.left,
    this.right,
    this.top,
    this.bottom,
  })  : assert(left == null || right == null),
        assert(top == null || bottom == null);
}
