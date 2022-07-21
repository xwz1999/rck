import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:recook/widgets/pick/year_pick_body.dart';
import 'package:velocity_x/velocity_x.dart';

import 'calender_pick_body.dart';
import 'car_month_pick_body.dart';
import 'picker_box.dart';

class CarDatePicker {
  static Future<DateTime?> pick(
    DateTime initDate, {
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
    DateTime? min,
    DateTime? max,
  }) async {
    return await Get.bottomSheet(_CarDatePicker(
      date: initDate,
      mode: mode,
      min: min ?? DateTime.now().subtract(const Duration(days: 1)),
      max: max,
    ));
  }

  static Future<DateTime?> timePicker(DateTime initDate) async {
    return await Get.bottomSheet(_CarDatePicker(
      date: initDate,
      min: initDate,
      max: initDate.add(const Duration(days: 7)),
      mode: CupertinoDatePickerMode.dateAndTime,
    ));
  }

  static Future<DateTime?> monthPicker(DateTime initDate) async {
    return await Get.bottomSheet(CarMonthPickBody(initTime: initDate));
  }

  static Future<DateTime?> yearPicker(DateTime initDate) async {
    return await Get.bottomSheet(YearPickBody(initTime: initDate));
  }



  ///选择年月日
  static Future<DateTime?> calenderPicker(DateTime initDate,DateTime lastDate) async {
    return await Get.bottomSheet(CalenderPickBody(initDate: initDate,lastDate: lastDate,));
  }
}

class _CarDatePicker extends StatefulWidget {
  final DateTime date;
  final bool use24H;
  final DateTime? max;
  final DateTime? min;
  final CupertinoDatePickerMode? mode;

  const _CarDatePicker({
     Key? key,
    required this.date,
    this.use24H = false,
    this.max,
    this.min,
    this.mode,
  });

  @override
  __CarDatePickerState createState() => __CarDatePickerState();
}

class __CarDatePickerState extends State<_CarDatePicker> {
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _date = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    return PickerBox(
      onPressed: () => Get.back(result: _date),
      child: CupertinoDatePicker(
        use24hFormat: widget.use24H,
        maximumDate: widget.max,
        minimumDate: widget.min,
        initialDateTime: _date,
        onDateTimeChanged: (date) => _date = date,
        mode: widget.mode ?? CupertinoDatePickerMode.date,
      ).expand(),
    );
  }
}
