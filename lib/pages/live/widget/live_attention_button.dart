import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

///关注按钮
class LiveAttentionButton extends StatefulWidget {
  ///填充按钮
  final bool filled;

  /// 高度 默认 28pt
  final double height;

  ///宽度 默认 72pt
  final double width;

  ///初始关注值 true/false
  final bool initAttention;

  ///点击关注回调
  final Function(bool oldAttentionState) onAttention;
  LiveAttentionButton({
    Key key,
    this.filled = false,
    this.height,
    this.width,
    @required this.initAttention,
    @required this.onAttention,
  }) : super(key: key);

  @override
  _LiveAttentionButtonState createState() => _LiveAttentionButtonState();
}

class _LiveAttentionButtonState extends State<LiveAttentionButton> {
  double _height = rSize(28);
  double _width = rSize(72);
  bool _isAttention = false;

  @override
  void initState() {
    super.initState();
    if (widget.height != null) _height = widget.height;
    if (widget.width != null) _width = widget.width;
    _isAttention = widget.initAttention;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: _width,
      child: widget.filled
          ? MaterialButton(
              child: Text('关注'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_height / 2),
              ),
              color: _widgetColor,
              onPressed: () {
                widget.onAttention(_isAttention);
                setState(() {
                  _isAttention = !_isAttention;
                });
              },
            )
          : OutlineButton(
              padding: EdgeInsets.zero,
              child: _isAttention
                  ? Text(
                      '已关注',
                      style: _textStyle,
                    )
                  : Text(
                      '+ 关注',
                      style: _textStyle,
                    ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_height / 2),
              ),
              borderSide: BorderSide(
                color: _widgetColor,
                width: rSize(1),
              ),
              textColor: _widgetColor,
              onPressed: () {
                widget.onAttention(_isAttention);
                setState(() {
                  _isAttention = !_isAttention;
                });
              },
            ),
    );
  }

  TextStyle get _textStyle => TextStyle(
        fontSize: rSP(14),
      );
  Color get _widgetColor =>
      _isAttention ? Color(0xFF666666) : Color(0xFFDB2D2D);
}