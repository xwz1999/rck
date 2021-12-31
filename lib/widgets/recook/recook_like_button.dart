import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

class RecookLikeButton extends StatefulWidget {
  final bool initValue;
  final Function(bool oldState) onChange;
  final double size;
  final String likePath;
  final String likeOnPath;
  RecookLikeButton({
    Key key,
    @required this.initValue,
    @required this.onChange,
    this.size = 14,
    this.likePath,
    this.likeOnPath,
  }) : super(key: key);

  @override
  _RecookLikeButtonState createState() => _RecookLikeButtonState();
}

class _RecookLikeButtonState extends State<RecookLikeButton> {
  bool _likeState = false;
  @override
  void initState() {
    super.initState();
    _likeState = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return CustomImageButton(
      child: Image.asset(
        _likeState
            ? widget.likeOnPath ?? R.ASSETS_LIVE_LIKE_ON_PNG
            : widget.likePath ?? R.ASSETS_LIVE_LIKE_PNG,
        height: rSize(widget.size),
        width: rSize(widget.size),
      ),
      onPressed: () {
        setState(() {
          widget.onChange(_likeState);
          _likeState = !_likeState;
        });
      },
    );
  }
}
