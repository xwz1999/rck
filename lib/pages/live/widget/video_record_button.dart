import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class VideoRecordButton extends StatefulWidget {
  final VoidCallback onStart;
  final VoidCallback onEnd;
  final bool disabled;
  VideoRecordButton({
    Key key,
    @required this.onStart,
    @required this.onEnd,
    this.disabled = false,
  }) : super(key: key);

  @override
  _VideoRecordButtonState createState() => _VideoRecordButtonState();
}

class _VideoRecordButtonState extends State<VideoRecordButton> {
  bool _isOnTap = false;
  Timer _timer;
  int _seconds = 0;
  Timer _timer60;

  @override
  void dispose() {
    _timer?.cancel();
    _timer60?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.center,
      children: [
        Positioned(
          top: -rSize(34 + 20.0),
          child: _isOnTap
              ? Text(
                  getDateStr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: rSP(14),
                  ),
                )
              : SizedBox(),
        ),
        Positioned(
          left: -20,
          right: -20,
          top: -20,
          bottom: -20,
          child: Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: rSize(_isOnTap ? 104 : 80),
              width: rSize(_isOnTap ? 104 : 80),
              decoration: BoxDecoration(
                color: Color(0xFF898989),
                borderRadius: BorderRadius.circular(rSize(_isOnTap ? 52 : 40)),
              ),
              alignment: Alignment.center,
            ),
          ),
        ),
        Positioned(
          left: -25,
          right: -25,
          top: -25,
          bottom: -25,
          child: Center(
            child: CircularPercentIndicator(
              radius: rSize(104),
              lineWidth: rSize(4),
              percent: _seconds >= 60 ? 1 : (_seconds / 60.0),
              addAutomaticKeepAlive: false,
              animation: true,
              animateFromLastPercent: true,
              progressColor: Colors.white,
              backgroundColor: Colors.transparent,
              circularStrokeCap: CircularStrokeCap.round,
              curve: Curves.linear,
              animationDuration: 1000,
            ),
          ),
        ),
        GestureDetector(
          onTapDown: widget.disabled
              ? null
              : (details) {
                  setState(() {
                    _isOnTap = true;
                  });
                  _startTimer();
                  _timer60 = Timer(Duration(seconds: 60), () {
                    widget.onEnd();
                  });
                  widget.onStart();
                },
          onTapUp: widget.disabled
              ? null
              : (details) {
                  setState(() {
                    _isOnTap = false;
                  });
                  _cancelTimer();
                  widget.onEnd();
                },
          onTapCancel: widget.disabled
              ? null
              : () {
                  setState(() {
                    _isOnTap = false;
                  });
                  _cancelTimer();
                  widget.onEnd();
                },
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFA3B3E),
              borderRadius: BorderRadius.circular(32),
            ),
            height: rSize(64),
            width: rSize(64),
          ),
        ),
      ],
    );
  }

  String getDateStr() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(_seconds * 1000);
    return DateUtil.formatDate(dateTime, format: 'mm:ss');
  }

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  _cancelTimer() {
    _timer?.cancel();
    _timer60?.cancel();
    _seconds = 0;
  }
}
