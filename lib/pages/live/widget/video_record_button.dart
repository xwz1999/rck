import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

class VideoRecordButton extends StatefulWidget {
  VideoRecordButton({Key key}) : super(key: key);

  @override
  _VideoRecordButtonState createState() => _VideoRecordButtonState();
}

class _VideoRecordButtonState extends State<VideoRecordButton> {
  bool _isOnTap = false;
  Timer _timer;
  int _seconds = 0;
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
                  '00:00',
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
        GestureDetector(
          onTapDown: (details) {
            setState(() {
              _isOnTap = true;
            });
          },
          onTapUp: (details) {
            setState(() {
              _isOnTap = false;
            });
          },
          onTapCancel: () {
            setState(() {
              _isOnTap = false;
            });
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

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _second
      });
    });
  }
}
