import 'package:flutter/material.dart';

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
    double fabY = contentBottom;
    return fabY;
  }
}
