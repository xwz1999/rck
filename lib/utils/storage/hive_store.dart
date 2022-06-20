import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recook/models/media_model_hv.dart';

class HiveStore {
  static Box? _appBox;
  static Box? get appBox => _appBox;

  static Box? _modelBox;
  static Box? get modelBox => _modelBox;


  static Future initBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(MediaModelHvAdapter());
    _appBox = await Hive.openBox('app');
    _modelBox = await Hive.openBox('modelBox');
  }
}
