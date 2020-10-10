import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';

class RecookLikeButton extends StatefulWidget {
  final bool initValue;
  final Function(bool oldState) onChange;
  final double size;
  RecookLikeButton({
    Key key,
    @required this.initValue,
    @required this.onChange,
    this.size = 14,
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
        _likeState ? R.ASSETS_LIVE_LIKE_ON_PNG : R.ASSETS_LIVE_LIKE_PNG,
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
