import 'package:characters/characters.dart';

class Strings {
  ///防止文字自动换行
  static String autoLineString(String str){
    if(str.isNotEmpty){
      return str.fixAutoLines();
    }
    return "";
  }
}

/// 防止文字自动换行
/// 当中英文混合，或者中文与数字或者特殊符号，或则英文单词时，文本会被自动换行，
/// 这样会导致，换行时上一行可能会留很大的空白区域
/// 把每个字符插入一个0宽的字符， \u{200B}
extension _FixAutoLines on String {
  String fixAutoLines() {
    return Characters(this).join('\u{200B}');
  }
}
