import 'package:flutter/material.dart';
import 'package:recook/constants/app_image_resources.dart';
import 'package:recook/constants/styles.dart';

class RecookBackButton extends StatelessWidget {
  final bool white;
  const RecookBackButton({Key key, this.white = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Navigator.canPop(context)) {
      return IconButton(
          icon: Icon(
            AppIcons.icon_back,
            size: 17,
            color: white ? Colors.white : AppColor.blackColor,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          });
    } else
      return SizedBox();
  }
}
