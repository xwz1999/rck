
import 'package:flutter_custom_calendar/utils/date_util.dart';
import 'package:recook/utils/date/date_models.dart';
import 'package:recook/utils/date/date_utils.dart';
class DateUtilss {



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
      List<Month> months = List<Month>();
      List<Week> weeks = List<Week>();

      while (lastDayOfWeek.isBefore(weekMaxDate)) {
        Week week = Week(firstDayOfWeek, lastDayOfWeek);
        weeks.add(week);

        if (week.isLastWeekOfMonth) {
          if (lastDayOfWeek.isSameDayOrAfter(minDate)) {
            months.add(Month(weeks));
          }

          weeks = List<Week>();

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
