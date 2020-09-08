/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/20  10:11 AM 
 * remark    : 
 * ====================================================
 */

import 'package:encrypt/encrypt.dart';


mixin TestMixin on BaseClass {
  void init() {
    print('TestMixin init start');
    super.init();
    print('TestMixin init end');
  }
}

mixin TestMixin2 on BaseClass {
  void init() {
    print('TestMixin2 init start');
    super.init();
    print('TestMixin2 init end');
  }
}

class BaseClass {
  void init() {
    print('Base init');
  }

  BaseClass() {
    init();
  }
}

class TestClass extends BaseClass with TestMixin, TestMixin2 {

  @override
  void init() {
    print('TestClass init start');

    print('TestClass init end');
  }
}


final parser = RSAKeyParser();

void main() async {


//  List<int> ints = [1,2,3,4,5,6];
//  for(int value in ints) {
//    if (value == 3) {
//      continue;
//    }
//    print("----- $value");
//  }
//  for (int i = 1; i <= 9; ++i) {
//    StringBuffer stringBuffer = StringBuffer();
//    for (int j = 1; j <= i; ++j) {
//      stringBuffer.write("$j * $i = ${i*j}  ");
//    }
//    print("$stringBuffer \n");
//  }
//
//  var arr = [1, 2, 3,4];
//// 临时变量，用于输出
//
//  print(DateTime.now());
//  for (int m = 0; m < 100; m++) {
//    n(arr);
//  }
//  print(result);
//  print(DateTime.now());

//  TestClass();
  /// TestClass init start
  /// TestMixin2 init start
  /// TestMixin init start
  /// Base init
  /// TestMixin init end
  /// TestMixin2 init end
  /// TestClass init end
}

var result = [];
var temp = [];

n(List arr) {
  for (var i = 0; i < arr.length; i++) {
    // 插入第i个值
    temp.add(arr[i]);
    // 复制数组
    var copy = [];
    copy.addAll(arr);
    // 删除复制数组中的第i个值，用于递归
    copy.removeAt(i);
    if (copy.length == 0) {
      // 如果复制数组长度为0了，则打印变量
      temp.sort();
      if (!result.contains(temp.join("-"))) {
        result.add(temp.join("-"));
      }
    } else {
      // 否则进行递归
      n(copy);
    }
    // 递归完了之后删除最后一个元素，保证下一次插入的时候没有上一次的元素
    temp.clear();
  }
}