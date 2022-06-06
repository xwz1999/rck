import 'package:flutter/material.dart';

import 'live_animate_Icon.dart';

class LiveAnimate extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final int place;
  final Duration delay;
  final Duration duration;

  const LiveAnimate(
      {Key? key,
      required this.size,
      required this.strokeWidth,
      required this.place,
      required this.delay,
      required this.duration})
      : super(key: key);

  @override
  _LiveAnimateState createState() => _LiveAnimateState();
}

class _LiveAnimateState extends State<LiveAnimate>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = CurveTween(curve: Curves.easeInOut).animate(_controller);
    Future.delayed(widget.delay, () async {
      try {
        await _controller.forward().orCancel;
        await _controller.reverse().orCancel;
        await _controller.repeat(reverse: true).orCancel;
      } on TickerCanceled {
        print('animate stopped ${widget.place}');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: LiveAnimateIcon(
                _animation.value, widget.strokeWidth, widget.place),
            size: Size(widget.size / 3, widget.size * 0.5),
          );
        });
  }
}
