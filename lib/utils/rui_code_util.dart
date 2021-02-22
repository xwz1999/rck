import 'dart:math';

class RUICodeModel {
  int goodsId;
  int userId;
  RUICodeModel({
    this.goodsId,
    this.userId,
  });
}

class RUICodeUtil {
  static String secureStr =
      'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKL1234567890';

  ///瑞口令加密
  static String encrypt(int goodsId, int userId) {
    return '¥¥${_num2String(goodsId)}${split()}${_num2String(userId)}¥¥';
  }

  static bool isCode(String value) {
    return value.contains(RegExp('¥¥[a-zA-z0-9]*¥¥'));
  }

  ///瑞口令解密
  static RUICodeModel decrypt(String value) {
    String temp = value.split('¥¥')[1];
    List<String> raw = temp.split(RegExp('(Z|X|C|V|B|N|M)'));
    int goodsId = _string2Num(raw[0]);
    int userId = _string2Num(raw[1]);
    return RUICodeModel(goodsId: goodsId, userId: userId);
  }

  static String _num2String(int value) {
    int secureLen = secureStr.length;
    int tag = -1;
    String result = '';
    int tempValue = value;
    do {
      if (tempValue < secureLen)
        tag = tempValue;
      else
        tag = tempValue % secureLen;
      tempValue = tempValue ~/ secureLen;
      result += secureStr[tag];
    } while (tempValue > 0);

    result = result.split('').reversed.join('');
    return result;
  }

  static int _string2Num(String value) {
    int result = 0;
    List<String> tempList = value.split('');
    int count = 0;
    while (tempList.isNotEmpty) {
      result += secureStr.indexOf(tempList.last) * pow(secureStr.length, count);
      count++;
      tempList.removeLast();
    }
    return result;
  }

  static String split() {
    String randomSplit = 'ZXCVBNM';
    return randomSplit[Random().nextInt(randomSplit.length)];
  }
}
