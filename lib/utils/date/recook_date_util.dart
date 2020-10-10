import 'package:common_utils/common_utils.dart';

class RecookDateUtil {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(0);

  ///字符串获取日期
  RecookDateUtil.fromString(String rawData) {
    dateTime = DateUtil.getDateTime(rawData);
  }

  ///日期设置
  RecookDateUtil(this.dateTime);

  ///获取前置日期
  ///
  ///返回 今天、昨天、 月/日
  String get prefixDay {
    if (isToday)
      return '今天';
    else if (isYesterday)
      return '昨天';
    else
      return DateUtil.formatDate(dateTime, format: 'M/d');
  }

  String get detailDate => DateUtil.formatDate(dateTime, format: 'HH:mm');

  DateTime get now => DateTime.now();

  ///相同小时
  bool get isSameHour => isToday && now.hour == dateTime.hour;

  ///相同分钟
  bool get isSameMinute =>
      isToday && isSameHour && now.minute == dateTime.minute;

  /// 相同年份
  bool get isSameYear => now.year == dateTime.year;

  /// 相同月
  bool get isSameMonth => isSameYear && now.month == dateTime.month;

  /// 判断今天
  bool get isToday => isSameMonth && now.day == dateTime.day;

  ///判断昨天
  bool get isYesterday => isSameMonth && now.day == (dateTime.day + 1);

  String get humanDate {
    if (isSameMinute)
      return '${now.second - dateTime.second}秒前';
    else if (isSameHour)
      return '${now.minute - dateTime.minute}分钟前';
    else if (isToday)
      return '${now.hour - dateTime.hour}小时前';
    else if (isYesterday)
      return '昨天${DateUtil.formatDate(dateTime, format: 'HH:mm')}';
    else if (isSameYear)
      return DateUtil.formatDate(dateTime, format: 'MM.dd HH:mm');
    else
      return DateUtil.formatDate(dateTime, format: 'yyyy.MM.dd HH:mm');
  }
}
