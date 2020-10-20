///获取解析后的字符串
String getParseNum(num number) {
  if (number < 999)
    return '$number';
  else if (number < 9999)
    return '${number ~/ 1000}千';
  else
    return '${number ~/ 10000}万';
}
