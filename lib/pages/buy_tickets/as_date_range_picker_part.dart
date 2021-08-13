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
Future<dynamic> show2DatePicker(BuildContext context,
    {List<String> fromNameList, List<String> endNameList}) async {
  return await showModalBottomSheet(
    context: context,
    builder: (context) {
      return AS2DatePicker(
          fromNameList: fromNameList, endNameList: endNameList);
    },
  );
}
