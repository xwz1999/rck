import 'package:common_utils/common_utils.dart';

class RecookDateUtil {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(0);

  ///字符串获取日期
  RecookDateUtil.fromString(String rawData) {
    dateTime = DateUtil.getDateTime(rawData);
  }

  ///日期设置
  RecookDateUtil(this.dateTime);

  String get prefixDay {
    if (isToday)
      return '今天';
    else if (isYesterday)
      return '昨天';
    else
      return DateUtil.formatDate(dateTime, format: 'M/d');
  }

  String get detailDate => DateUtil.formatDate(dateTime, format: 'HH:mm');

  /// 判断今天
  bool get isToday {
    DateTime now = DateTime.now();
    return now.month == dateTime.month &&
        now.year == dateTime.year &&
        now.day == dateTime.day;
  }

  ///判断昨天
  bool get isYesterday {
    DateTime now = DateTime.now();
    return now.month == dateTime.month &&
        now.year == dateTime.year &&
        now.day == (dateTime.day + 1);
  }
}
