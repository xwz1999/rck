import 'package:lunar_calendar_converter/lunar_solar_converter.dart';

class RecookLunar {
  Lunar lunar;
  RecookLunar(this.lunar);

  ///RecookLunar 不显示年份
  @override
  String toString() {
    return lunar.toString().replaceAll(RegExp('[0-9]|[\(\)]'), '');
  }
}
