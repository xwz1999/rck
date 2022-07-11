
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:recook/constants/header.dart';
import 'car_picker_box.dart';

class CalenderPickBody extends StatefulWidget {
  final DateTime initDate;
  final DateTime lastDate;

  const CalenderPickBody(
      {key, required this.initDate, required this.lastDate});

  @override
  _CalenderPickBodyState createState() => _CalenderPickBodyState();
}

class _CalenderPickBodyState extends State<CalenderPickBody> {
  DateTime _focusDay = DateTime.now();
  DateTime? _selectDay;
  DateTime? _startDay;
  DateTime? _endDay;
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return CarPickerBox(
      height: 800.rw,
      child: TableCalendar(
        locale: 'zh',
        firstDay: widget.initDate,
        lastDay: widget.lastDate,
        focusedDay: _focusDay,
        // currentDay: DateTime.now(),
        rangeStartDay: _startDay,
        rangeEndDay: _endDay,
        shouldFillViewport: true,
        availableCalendarFormats: const {
          CalendarFormat.month: '月份',
          CalendarFormat.twoWeeks: '2'
        },
        onRangeSelected: (starDay, endDay, day) {
          _startDay = starDay;
          _endDay = endDay;
          setState(() {});
        },
        // onDaySelected: (selectDay, focusDay) {
        //   setState(() {
        //     _selectDay = selectDay;
        //     _focusDay = focusDay;
        //   });
        // },
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectDay, day);
        },
        onPageChanged: (focusedDay) {
          _focusDay = focusedDay;
        },
      ),
    );
  }
}
