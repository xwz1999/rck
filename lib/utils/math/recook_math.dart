class RecookMath {
  ///组合数算法
  ///
  ///传统算法会出现溢出
  ///
  ///
  ///[Stackoverflow](https://stackoverflow.com/questions/12130094/optimizing-calculating-combination-and-avoiding-overflows)
  ///
  ///[blog](https://blog.plover.com/math/choose.html)
  static int combination(int k, int n) {
    int r = 1;
    int d;
    if (k > n) return 0;
    for (d = 1; d <= k; d++) {
      r *= n--;
      r = (r / d).floor();
    }
    return r;
  }
}
