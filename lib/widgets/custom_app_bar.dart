/*
 * ====================================================
 * package   : widgets
 * author    : Created by nansi.
 * time      : 2019/5/15  9:44 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final title;
  final double titleSpacing;
  final double elevation;
  final AppBarTheme? themeData;
  final Color? appBackground;
  final Color? background;
  final List<Widget>? actions;
  final Widget? leading;
  final VoidCallback? backEvent;

  // 可用于设置背景渐变色
  final Widget? flexibleSpace;

  /// This widget appears across the bottom of the app bar.
  ///
  /// Typically a [TabBar]. Only widgets that implement [PreferredSizeWidget] can
  /// be used at the bottom of an app bar.
  ///
  /// See also:
  ///
  ///  * [PreferredSize], which can be used to give an arbitrary widget a preferred size.
  final PreferredSizeWidget? bottom;

  CustomAppBar(
      {this.title,
      this.titleSpacing = 0,
      this.elevation = 2,
      this.themeData,
      this.appBackground,
      this.background,
      this.actions,
      this.leading,
      this.bottom,
      this.flexibleSpace,
      this.backEvent})
      : preferredSize = Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        child: AppBar(
          title: title is String
              ? Text(
                  title,
                  style: TextStyle(fontSize: rSize(18),color: Color(0xFF333333)),
                )
              : title,
          leading: _backButton(context),
          actions: actions,
          flexibleSpace: flexibleSpace,
          titleSpacing: titleSpacing,
          brightness:
              themeData == null ? Brightness.dark : themeData!.brightness,
          backgroundColor:
              appBackground ?? (themeData == null ? null : themeData!.color),
          iconTheme: themeData == null ? null : themeData!.iconTheme,
          textTheme: themeData == null ? null : themeData!.textTheme,
          elevation: elevation,
          toolbarOpacity: 1,
          centerTitle: true,
          bottom: bottom,
        ),
        preferredSize: Size.fromHeight(30));
  }

  _backButton(context) {
    Widget? lead = this.leading;
    if (lead == null) {
      if (Navigator.canPop(context)) {
        lead = IconButton(
            icon: Icon(
              AppIcons.icon_back,
              size: 17,
              color: themeData == null
                  ? Colors.white
                  : themeData!.textTheme!.headline6!.color,
            ),
            onPressed: backEvent ??
                () {
                  Navigator.maybePop(context);
                });
      }
    }
    return lead;
  }

  @override
  final Size preferredSize;
}
