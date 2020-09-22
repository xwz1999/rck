import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

class FabLocation {
  ///copy from material/floating_action_button_location.dart
  ///
  ///相对centerDocked模式向下移 4pt
  ///
  static const recook = _RecookFabLocation();
}

class _RecookFabLocation extends StandardFabLocation
    with FabCenterOffsetX, CustomDockedOffsetY {
  const _RecookFabLocation();

  @override
  String toString() => 'FabLocation.Recook';
}

mixin CustomDockedOffsetY on StandardFabLocation {
  @override
  double getOffsetY(
      ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double contentMargin =
        scaffoldGeometry.scaffoldSize.height - contentBottom;
    final double bottomViewPadding = scaffoldGeometry.minViewPadding.bottom;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double safeMargin =
        bottomViewPadding > contentMargin ? bottomViewPadding : 0.0;

    double fabY = contentBottom;
    return fabY;
  }
}
