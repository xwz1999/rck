import 'package:flutter/material.dart';

import 'condition_picker.dart';

class RangeDate {
  DateTime start;
  DateTime end;
  RangeDate({
    this.start,
    this.end,
  });
}

///返回值为`bool`且为`true`时,为一小时内
///
///否则返回`RangeDate`
Future<dynamic> show2DatePicker(BuildContext context, {DateTime date}) async {
  return await showModalBottomSheet(
    context: context,
    builder: (context) {
      return AS2DatePicker(date: date);
    },
  );
}
