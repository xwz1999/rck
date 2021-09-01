import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:recook/constants/header.dart';

class CutDownTimeWidget extends StatefulWidget {
  CutDownTimeWidget({
    Key key,
  }) : super(key: key);

  @override
  _CutDownTimeWidgetState createState() => _CutDownTimeWidgetState();
}

class _CutDownTimeWidgetState extends State<CutDownTimeWidget> {
  CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 600;

  void onEnd() {
    print('onEnd');
  }

  @override
  void initState() {
    super.initState();
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.rw,
      height: 20.rw,
      child: CountdownTimer(
        controller: controller,
        onEnd: onEnd,
        endTime: endTime,
        widgetBuilder: (_, CurrentRemainingTime time) {
          if (time == null) {
            return Container(
              width: 70.rw,
              height: 20.rw,
              child: Row(
                children: [
                  _time('00'),
                  Text(
                    ':',
                    style:
                        TextStyle(color: Color(0xFFC92219), fontSize: 14.rsp),
                  ),
                  _time('00'),
                  Text(
                    ':',
                    style:
                        TextStyle(color: Color(0xFFC92219), fontSize: 14.rsp),
                  ),
                  _time('00'),
                ],
              ),
            );
          } else
            return Container(
              width: 70.rw,
              height: 20.rw,
              child: Row(
                children: [
                  _time(time.hours != null ? time.hours.toString() : '00'),
                  Text(
                    ':',
                    style:
                        TextStyle(color: Color(0xFFC92219), fontSize: 14.rsp),
                  ),
                  _time(time.min != null ? time.min.toString() : '00'),
                  Text(
                    ':',
                    style:
                        TextStyle(color: Color(0xFFC92219), fontSize: 14.rsp),
                  ),
                  _time(time.sec != null ? time.sec.toString() : '00'),
                ],
              ),
            );
        },
      ),
    );
  }

  _time(String time) {
    return Container(
      alignment: Alignment.center,
      width: 20.rw,
      height: 20.rw,
      decoration: BoxDecoration(
        color: Color(0xFFC92219),
        borderRadius: BorderRadius.all(Radius.circular(1.rw)),
      ),
      child: Text(
        time.length == 1 ? '0' + time : time,
        style: TextStyle(color: Colors.white, fontSize: 14.rsp),
      ),
    );
  }
}
