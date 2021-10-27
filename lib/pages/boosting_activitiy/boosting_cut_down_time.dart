import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:recook/constants/header.dart';

class BoostingCutDownTime extends StatefulWidget {
  final String time;//格式为00:00:00
  BoostingCutDownTime({
    Key key, this.time,
  }) : super(key: key);

  @override
  _BoostingCutDownTimeState createState() => _BoostingCutDownTimeState();
}

class _BoostingCutDownTimeState extends State<BoostingCutDownTime> {
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
      width: 75.rw,
      height: 20.rw,
      child: CountdownTimer(
        controller: controller,
        onEnd: onEnd,
        endTime: _endTime,
        widgetBuilder: (_, CurrentRemainingTime time) {
          if (time == null) {
            return Container(

              width: 75.rw,
              height: 20.rw,
              child: Row(
                children: [
                  30.hb,
                  _time('00',Color(0xFF333333)),
                  Text(
                    ':',
                    style:
                        TextStyle(color: Color(0xFFC92219), fontSize: 14.rsp),
                  ),
                  _time('00',Color(0xFF333333)),
                  Text(
                    ':',
                    style:
                        TextStyle(color: Color(0xFFC92219), fontSize: 14.rsp),
                  ),
                  _time('00',Color(0xFFFE4839)),
                ],
              ),
            );
          } else
            return Container(

              width: 75.rw,
              height: 20.rw,
              child: Row(
                children: [
                  _time(time.hours != null ? time.hours.toString() : '00',Color(0xFF333333)),
                  Text(
                    ':',
                    style:
                        TextStyle(color:Color(0xFF333333), fontSize: 14.rsp),
                  ),
                  _time(time.min != null ? time.min.toString() : '00',Color(0xFF333333)),
                  Text(
                    ':',
                    style:
                        TextStyle(color: Color(0xFF333333), fontSize: 14.rsp),
                  ),
                  _time(time.sec != null ? time.sec.toString() : '00',Color(0xFFFE4839)),
                  30.hb,
                ],
              ),
            );
        },
      ),
    );
  }

  _time(String time,Color color) {
    return Container(
      alignment: Alignment.center,
      width: 22.rw,
      height: 22.rw,
      decoration: BoxDecoration(
        color: color,//Color(0xFFC92219),
        borderRadius: BorderRadius.all(Radius.circular(1.rw)),
      ),
      child: Text(
        time.length == 1 ? '0' + time : time,
        style: TextStyle(color: Colors.white, fontSize: 14.rsp),
      ),
    );
  }
}
