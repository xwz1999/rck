/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-08  11:01 
 * remark    : 
 * ====================================================
 */

class TimeTransitionUtil {
  static int stringToInterval(String timeString) {
    DateTime dateTime = DateTime.parse(timeString);
    return dateTime.millisecondsSinceEpoch;
  }

  static String timeToFormatString(String separator, {int interval, String timeString,bool showHour = false,bool isUtc = false}) {
    assert(interval != null || timeString != null, "必须传时间 interval 或者 timeString");
    DateTime dateTime;
    StringBuffer stringBuffer = StringBuffer();
    if (interval == null) {
      dateTime = DateTime.tryParse(timeString);
    }else {
      dateTime = DateTime.fromMicrosecondsSinceEpoch(interval, isUtc: isUtc);
    }

    stringBuffer.write(dateTime.year);
    stringBuffer.write(separator);
    stringBuffer.write(dateTime.month);
    stringBuffer.write(separator);
    stringBuffer.write(dateTime.day);

    if (showHour) {
      stringBuffer.write(" ");
      stringBuffer.write(dateTime.hour);
      stringBuffer.write(separator);
      stringBuffer.write(dateTime.minute);
      stringBuffer.write(separator);
      stringBuffer.write(dateTime.second);
    }
    return stringBuffer.toString();
  }
}
