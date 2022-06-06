/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/27  10:47 AM 
 * remark    : 
 * ====================================================
 */

class DPrint {
  static printf(Object? obj) {
    // if (AppConfig.debug) {
      print(obj);
    // }
  }

  static printLongJson(String str) {
    str = str.trim();
    int index = 0;
    int maxLength = 2100;
    String sub;
    print("|---- ${str.length} -----------------------------|");
    while (index < str.length) {
      // java的字符不允许指定超过总的长度end
      if (str.length <= index + maxLength) {
        sub = str.substring(index);
      } else {
        sub = str.substring(index, maxLength);
      }

      index += maxLength;
      print("|-" + sub.trim());
    }
    print("|---------------------------------|");
  }
}
