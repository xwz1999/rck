import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:recook/constants/header.dart';

class CutDownWidget extends StatefulWidget {
  final String time;//格式为00:00:00
  final int type;//1为 活动未开始 传的开始时间 2为活动中 传结束时间
  final bool white;
  CutDownWidget({
    Key key, this.time, this.type, this.white,
  }) : super(key: key);

  @override
  _CutDownWidgetState createState() => _CutDownWidgetState();
}

class _CutDownWidgetState extends State<CutDownWidget> {
  CountdownTimerController controller;
  int _endTime;
  DateTime _dateNow ;
  void onEnd() {
    print('onEnd');

  }

  @override
  void initState() {
    super.initState();
    print(widget.time);
    if(widget.time.length>7){

      int hour = int.parse(widget.time.substring(0,2));
      int minute = int.parse(widget.time.substring(3,5));
      int second = int.parse(widget.time.substring(6,8));
      print(hour);
      print(minute);
      print(second);
      _dateNow = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day,hour, minute,second);
      print(_dateNow);

      num difference = _dateNow.difference(DateTime.now()).inSeconds;
      print(difference);
      _endTime =  DateTime.now().millisecondsSinceEpoch + difference*1000;
    }

    controller = CountdownTimerController(endTime: _endTime, onEnd: onEnd);
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
      height: 17.rw,
      child: CountdownTimer(
        controller: controller,
        onEnd: onEnd,
        endTime: _endTime,
        widgetBuilder: (_, CurrentRemainingTime time) {
          if (time == null) {
            return Container(

              width: 70.rw,
              height: 17.rw,
              child: Row(
                children: [
                  30.hb,
                  _time('00'),
                  Text(
                    ':',
                    style:
                        TextStyle(color: widget.white?Colors.white:Color(0xFFC92219), fontSize: 12.rsp),
                  ),
                  _time('00'),
                  Text(
                    ':',
                    style:
                        TextStyle(color: widget.white?Colors.white:Color(0xFFC92219), fontSize: 12.rsp),
                  ),
                  _time('00'),
                ],
              ),
            );
          } else
            return Container(
              width: 70.rw,
              height: 17.rw,
              child: Row(
                children: [
                  _time(time.hours != null ? time.hours.toString() : '00'),
                  Text(
                    ':',
                    style:
                        TextStyle(color: widget.white?Colors.white:Color(0xFFC92219), fontSize: 12.rsp),
                  ),
                  _time(time.min != null ? time.min.toString() : '00'),
                  Text(
                    ':',
                    style:
                        TextStyle(color: widget.white?Colors.white:Color(0xFFC92219), fontSize: 12.rsp),
                  ),
                  _time(time.sec != null ? time.sec.toString() : '00'),
                  30.hb,
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
      width: 15.rw,
      height: 17.rw,
      decoration: BoxDecoration(
        color: widget.white?Colors.white:Color(0xFFC92219),
        borderRadius: BorderRadius.all(Radius.circular(4.rw)),
      ),
      child: Text(
        time.length == 1 ? '0' + time : time,
        style: TextStyle(color: widget.white?Color(0xFFC92219):Colors.white, fontSize: 12.rsp),
      ),
    );
  }
}
