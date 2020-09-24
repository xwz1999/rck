import 'package:recook/constants/header.dart';

///解析球
///
///example:
///
///parseBalls('01,02,03,04,05,06#07')
///
///01,02,03,04,05,06#07 => [1,2,3,4,5,6] or [7]
List<int> parseBalls(String balls, {bool red: true}) {
  if (TextUtils.isEmpty(balls)) {
    return [];
  } else {
    return balls
        .split('#')[red ? 0 : 1]
        .split(',')
        .map(
          (e) => int.parse(e),
        )
        .toList();
  }
}
