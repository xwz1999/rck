/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/3  9:32 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';

class DetailAppBar extends StatefulWidget {
  final TabBar tabBar;

  final AppBarController controller;

  final Function() onShareClick;

  DetailAppBar({this.tabBar, this.controller, this.onShareClick});

  @override
  State<StatefulWidget> createState() {
    return _DetailAppBarState();
  }
}

class _DetailAppBarState extends State<DetailAppBar> {
  // appbar背景色
  Color _appBarBgColor = Colors.transparent;

  // appBar上 item 的颜色
  Color _itemColor = Colors.white;

  // appbar item 背景色
  Color _itemBgColor = Color.fromARGB(100, 0, 0, 0);

  double _tabBarOpacity = 0;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.scale.addListener(() {
      double scale = widget.controller.scale.value;
      _appBarBgColor = Color.fromARGB((255 * scale).toInt(), 251, 251, 251);
      if (scale < 0.5) {
        _itemColor =
            Color.fromARGB((255 * (1 - scale * 2)).toInt(), 255, 255, 255);
      } else {
        _itemColor = Color.fromARGB((255 * scale * 2).toInt(), 0, 0, 0);
      }
      _itemBgColor = Color.fromARGB((80 * (1 - scale)).toInt(), 0, 0, 0);
      _tabBarOpacity = scale;

      setState(() {});
    });

    widget.tabBar.controller.addListener(() {
      bool refresh = false;
      if (_selectedIndex == 0) {
        refresh = true;
      } else {
        refresh = widget.tabBar.controller.index == 0;
      }

      if (refresh) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildCustomAppBar(context);
  }

  _buildCustomAppBar(BuildContext context) {
    bool selectedOne = widget.tabBar.controller.index == 0;
    return CustomAppBar(
      appBackground: selectedOne ? _appBarBgColor : Colors.white,
      elevation: 0,
      titleSpacing: 20,
      themeData: AppThemes.themeDataGrey.appBarTheme,
      title: Opacity(
        opacity: selectedOne ? _tabBarOpacity : 1,
        child: Container(
          child: widget.tabBar,
        ),
      ),
      leading: Center(
        child: CustomImageButton(
          icon: Icon(
            AppIcons.icon_back,
            size: 16 * 2.sp,
            color: selectedOne ? _itemColor : Colors.black,
          ),
          buttonSize: rSize(30),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          backgroundColor: selectedOne ? _itemBgColor : Colors.transparent,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 10),
          child: Center(
            child: CustomImageButton(
              // icon: Icon(
              //   AppIcons.icon_ellipsis,
              //   size: 16*2.sp,
              //   color: selectedOne ? _itemColor : Colors.black,
              // ),
              buttonSize: rSize(30),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              // backgroundColor: selectedOne ? _itemBgColor : Colors.transparent,
              // onPressed: widget.onShareClick,
            ),
          ),
        )
      ],
    );
  }
}

class AppBarController {
  ValueNotifier<double> scale = ValueNotifier(0);

  void dispose() {
    scale?.dispose();
  }
}
