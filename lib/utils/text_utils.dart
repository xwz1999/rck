/*
 * ====================================================
 * package   : utils
 * author    : Created by nansi.
 * time      : 2019/5/14  10:45 AM 
 * remark    : 
 * ====================================================
 */

class TextUtils {
  ///判断空字符串
  ///
  ///white 全空格是否算空字符串
  static bool isEmpty(String str, {bool whiteSpace = false}) {
    if (whiteSpace) {
      return str == null || str.trim().length == 0;
    }
    return str == null || str.length == 0;
  }

  static bool isNotEmpty(String str, {bool whiteSpace = false}) {
    return !isEmpty(str, whiteSpace: whiteSpace);
  }

  static bool verifyPhone(phone) {
    return new RegExp(
            "^^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}\$")
        .hasMatch(phone);
  }
}
