import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class MyCacheManager extends BaseCacheManager {
  static const key = "customCache";

  static MyCacheManager _instance;

  factory MyCacheManager() {
    if (_instance == null) {
      _instance = new MyCacheManager._();
    }
    return _instance;
  }

  MyCacheManager._() : super(key,
      maxAgeCacheObject: Duration(days: 7),
      maxNrOfCacheObjects: 20);

  Future<String> getFilePath() async {
    var directory = await getApplicationDocumentsDirectory();
    return path.join(directory.path, key);
  }
}