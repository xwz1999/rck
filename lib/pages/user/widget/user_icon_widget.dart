import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';

class UserIconWidget {
  static levelWidget(level) {
    return CustomImageButton(
      onPressed: () {},
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      backgroundColor: Color(0xFFF6CB88),
      fontSize: ScreenAdapterUtils.setSp(10),
      color: Color(0xFFAE5930),
      borderRadius: BorderRadius.all(Radius.circular(20)),
      direction: Direction.horizontal,
      contentSpacing: 2,
      icon: Icon(
        Icons.star_border,
        size: rSize(13),
      ),
      title: _level(level),
    );
  }

  static _level(role) {
    String level;
    switch (role) {
      case 1:
        level = "店主";
        break;
      case 2:
        level = "实体店";
        break;
      case 3:
        level = "合伙人";
        break;
      default:
        level = "会员";
    }
    return level;
  }
}
