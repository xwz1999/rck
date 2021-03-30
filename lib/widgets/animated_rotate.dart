import 'package:flutter/material.dart';

///动态旋转
class AnimatedRotate extends ImplicitlyAnimatedWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double angle;

  AnimatedRotate({
    Key key,
    @required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeInOutCubic,
    @required this.angle,
  }) : super(
          key: key,
          duration: duration,
          curve: curve,
        );
  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedRoateState();
}

class _AnimatedRoateState extends AnimatedWidgetBaseState<AnimatedRotate> {
  Tween<double> _rotateTween;
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _rotateTween.evaluate(animation),
      child: widget.child,
    );
  }

  @override
  void forEachTween(visitor) {
    _rotateTween = visitor(
      _rotateTween,
      widget.angle,
      (dynamic value) => Tween<double>(begin: value),
    );
  }
}
