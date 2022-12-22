
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:recook/utils/date/date_models.dart';

class DateUtilss {

  static bool? isCapture;
  static StreamSubscription<void>? subscription;

  static initForbid(BuildContext context) async {
    isCapture = await DateUtilss.iosIsCaptured;
    _deal(context);
    if (Platform.isIOS) {
      subscription = DateUtilss.iosShotChange!.listen((event) {
        isCapture = !isCapture!;
        _deal(context);
      });
    }
    DateUtilss.setAndroidForbidOn();
  }

  static _deal(BuildContext context) {
    if (isCapture == true) {
      Navigator.pop(context);
    }
  }

  static disposeForbid() {
    subscription?.cancel();
    subscription = null;
    DateUtilss.setAndroidForbidOff();
  }


  static const MethodChannel _methodChannel =
  const MethodChannel('flutter_forbidshot');
  static const EventChannel _eventChannel =
  const EventChannel('flutter_forbidshot_change');


  // 录屏相关
  static Future<bool?> get iosIsCaptured async {
    if (Platform.isIOS) {
      final bool? isCaptured = await _methodChannel.invokeMethod('isCaptured') as bool?;
      return isCaptured;
    }
    return null;
  }

  static Stream<String>? get iosShotChange {
    if (Platform.isIOS) {
      return _eventChannel.receiveBroadcastStream().map((dynamic event) {
        return event;
      },
      );
    }else{
      return null;
    }
  }

  static setAndroidForbidOn() {
    if (Platform.isAndroid) {
      _methodChannel.invokeMethod('setOn');
    }
  }

  static setAndroidForbidOff() {
    if (Platform.isAndroid) {
      _methodChannel.invokeMethod('setOff');
    }
  }

  //声音相关
  static Future<double?> get volume async => (await _methodChannel.invokeMethod('volume')) as double?;
  static Future setVolume(double volume) => _methodChannel.invokeMethod('setVolume', {"volume" : volume});


  static Rect? findGlobalRect(GlobalKey key) {
    RenderBox? renderObject = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderObject == null) {
      return null;
    }

    var globalOffset = renderObject.localToGlobal(Offset.zero);

    // if (globalOffset == null) {
    //   return null;
    // }

    var bounds = renderObject.paintBounds;
    bounds = bounds.translate(globalOffset.dx, globalOffset.dy);
    return bounds;
  }

  static Offset? globalOffsetToLocal(GlobalKey key, Offset offsetGlobal) {
    RenderBox? renderObject = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderObject == null) {
      return null;
    }
    return renderObject.globalToLocal(offsetGlobal);
  }
  // 防抖函数: eg:输入框连续输入，用户停止操作300ms才执行访问接口
  static const deFaultDurationTime = 300;
  static Timer? timer;

  static antiShake(Function doSomething, {durationTime = deFaultDurationTime}) {
    timer!.cancel();
    timer = new Timer(Duration(milliseconds: durationTime), () {
      doSomething.call();
      timer = null;
    });
  }

  // 节流函数: eg:300ms内，只会触发一次
  static int startTime = 0;

  static throttle(Function doSomething, {durationTime = deFaultDurationTime}) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - startTime > durationTime) {
      doSomething.call();
      startTime = DateTime.now().millisecondsSinceEpoch;
    }
  }

  static String formatDuration(Duration position) {
    final ms = position.inMilliseconds;

    int seconds = ms ~/ 1000;
    final int hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    var minutes = seconds ~/ 60;
    seconds = seconds % 60;

    final hoursString = hours >= 10 ? '$hours' : hours == 0 ? '00' : '0$hours';

    final minutesString =
    minutes >= 10 ? '$minutes' : minutes == 0 ? '00' : '0$minutes';

    final secondsString =
    seconds >= 10 ? '$seconds' : seconds == 0 ? '00' : '0$seconds';

    final formattedTime =
        '${hoursString == '00' ? '' : hoursString + ':'}$minutesString:$secondsString';

    return formattedTime;
  }

  //获取 10：00 -8：00的时间差
  static String getTimeReduce(String timeE, String timeL) {
    int hourL = int.parse(timeL.substring(0, 2)); //晚的时间的小时
    int hourE = int.parse(timeE.substring(0, 2));
    //早的时间的小时
    int minL = int.parse(timeL.substring(3, 5)); //晚的时间的小时
    int minE = int.parse(timeE.substring(3, 5)); //早的时间的小时

    int hourDifference = hourL - hourE; //时间差
    int minDifference = minL - minE;

    if (hourDifference < 0) {
      hourDifference = hourL - hourE + 24;
    }
    if (minDifference < 0) {
      hourDifference = hourDifference - 1;
      minDifference = minDifference.abs();
    }
    return hourDifference.toString() + 'h' + minDifference.toString() + 'm';
  }

  static bool sameDay(DateTime day, DateTime diffDay) {
    return (day.year == diffDay.year &&
        day.month == diffDay.month &&
        day.day == diffDay.day);
  }

  static bool sameYear(DateTime day, DateTime diffDay) {
    return (day.year == diffDay.year);
  }

  static int monthBetween(DateTime day, DateTime diffDay) {
    return (diffDay.month + 12 - day.month) % 12;
  }

  static int countDays(DateTime day, DateTime diffDay) {
    return DateTime.fromMillisecondsSinceEpoch(
                (diffDay.millisecondsSinceEpoch - day.millisecondsSinceEpoch))
            .day -
        1;
  }

  static List<Month> extractWeeks(DateTime minDate, DateTime maxDate) {
    DateTime weekMinDate = _findDayOfWeekInMonth(minDate, DateTime.monday);
    DateTime weekMaxDate = _findDayOfWeekInMonth(maxDate, DateTime.sunday);

    DateTime firstDayOfWeek = weekMinDate;
    DateTime lastDayOfWeek = _lastDayOfWeek(weekMinDate);

    if (!lastDayOfWeek.isBefore(weekMaxDate)) {
      return <Month>[
        Month(<Week>[Week(firstDayOfWeek, lastDayOfWeek)])
      ];
    } else {
      List<Month> months =[];
      List<Week> weeks = [];

      while (lastDayOfWeek.isBefore(weekMaxDate)) {
        Week week = Week(firstDayOfWeek, lastDayOfWeek);
        weeks.add(week);

        if (week.isLastWeekOfMonth) {
          if (lastDayOfWeek.isSameDayOrAfter(minDate)) {
            months.add(Month(weeks));
          }

          weeks = [];

          firstDayOfWeek = firstDayOfWeek.toFirstDayOfNextMonth();
          lastDayOfWeek = _lastDayOfWeek(firstDayOfWeek);

          weeks.add(Week(firstDayOfWeek, lastDayOfWeek));
        }

        firstDayOfWeek = lastDayOfWeek.nextDay;
        lastDayOfWeek = _lastDayOfWeek(firstDayOfWeek);
      }

      if (!lastDayOfWeek.isBefore(weekMaxDate)) {
        weeks.add(Week(firstDayOfWeek, lastDayOfWeek));
      }

      months.add(Month(weeks));

      return months;
    }
  }

  static DateTime _lastDayOfWeek(DateTime firstDayOfWeek) {
    int daysInMonth = firstDayOfWeek.daysInMonth;

    if (firstDayOfWeek.day + 6 > daysInMonth) {
      return DateTime(firstDayOfWeek.year, firstDayOfWeek.month, daysInMonth);
    } else {
      return firstDayOfWeek
          .add(Duration(days: DateTime.sunday - firstDayOfWeek.weekday));
    }
  }

  static DateTime _findDayOfWeekInMonth(DateTime date, int dayOfWeek) {
    date = DateTime(date.year, date.month, date.day);

    if (date.weekday == DateTime.monday) {
      return date;
    } else {
      return date.subtract(Duration(days: date.weekday - dayOfWeek));
    }
  }

  static List<int> daysPerMonth(int year) => <int>[
        31,
        isLeapYear(year) ? 29 : 28,
        31,
        30,
        31,
        30,
        31,
        31,
        30,
        31,
        30,
        31,
      ];

  static bool isLeapYear(int year) {
    bool leapYear = false;

    bool leap = ((year % 100 == 0) && (year % 400 != 0));
    if (leap == true) {
      return false;
    } else if (year % 4 == 0) {
      return true;
    }

    return leapYear;
  }
}

extension DateUtilsExtensions on DateTime {
  bool get isLeapYear {
    bool leapYear = false;

    bool leap = ((year % 100 == 0) && (year % 400 != 0));
    if (leap == true) {
      return false;
    } else if (year % 4 == 0) {
      return true;
    }

    return leapYear;
  }

  int get daysInMonth => DateUtilss.daysPerMonth(year)[month - 1];

  DateTime toFirstDayOfNextMonth() => DateTime(
        year,
        month + 1,
      );

  DateTime get nextDay => DateTime(year, month, day + 1);

  bool isSameDayOrAfter(DateTime other) => isAfter(other) || isSameDay(other);

  bool isSameDayOrBefore(DateTime other) => isBefore(other) || isSameDay(other);

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  DateTime removeTime() => DateTime(year, month, day);
}
