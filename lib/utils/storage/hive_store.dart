import 'package:hive/hive.dart';

class HiveStore {
  static Box? _appBox;
  static Box? get appBox => _appBox;
  static Future initBox() async {
    _appBox = await Hive.openBox('app');
  }
}
