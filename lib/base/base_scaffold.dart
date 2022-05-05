/*
 * ====================================================
 * package   : base
 * author    : Created by nansi.
 * time      : 2019/5/5  3:23 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/widgets/custom_app_bar.dart';

class BaseScaffold extends Scaffold {
  BaseScaffold(
      {this.title,
      this.titleSpacing = 0,
      this.themeData,
      this.customAppBar,
      this.appBackground,
      this.background,
      this.actions,
      this.leading,
      this.body,
      this.bottomNavigationBar,
      this.bottomSheet,
      this.elevation = 4})
      : super(
          appBar: customAppBar != null
              ? customAppBar
              : CustomAppBar(
                  title: title is String ? Text(title) : title,
                  leading: leading,
                  actions: actions,
                  titleSpacing: titleSpacing,
                  themeData: themeData.appBarTheme,
                  elevation: elevation,
                  appBackground: appBackground,
                ),
          body: body,
          backgroundColor: background == null
              ? (themeData == null ? null : themeData.scaffoldBackgroundColor)
              : background,
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
        );

  final title;
  final double titleSpacing;
  final double elevation;
  final ThemeData themeData;
  final Color appBackground;
  final Color background;
  final Widget customAppBar;
  final List<Widget> actions;
  final Widget leading;
  final Widget body;
  final Widget bottomNavigationBar;
  final Widget bottomSheet;

}
