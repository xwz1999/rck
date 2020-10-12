import 'package:flutter/material.dart';
import 'package:recook/constants/app_image_resources.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';

class RecookBackButton extends StatelessWidget {
  final bool white;
  final bool text;
  const RecookBackButton({Key key, this.white = false, this.text = false})
      : super(key: key);

  const RecookBackButton.text({Key key, this.white = false, this.text = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Navigator.canPop(context)) {
      return text
          ? MaterialButton(
              minWidth: rSize(30 + 28.0),
              padding: EdgeInsets.zero,
              child: Text(
                '取消',
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: rSP(14),
                  color: white ? Colors.white : Color(0xFF333333),
                ),
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            )
          : IconButton(
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
