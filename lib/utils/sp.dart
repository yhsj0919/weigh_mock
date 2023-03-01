import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// 本地存储
class Sp {
  static final Sp _instance = Sp._();

  factory Sp() => _instance;
  static Box? _prefs;

  Sp._();

  static Future<void> init() async {
    ///为了一套软件能在一台电脑上运行不串数据
    if (Platform.isWindows) {
      var appDir = "./";
      print(appDir);
      Hive.init(appDir);
    }
    if (Platform.isAndroid) {
      var appDir = await getApplicationSupportDirectory();
      print(appDir);
      Hive.init(appDir.path);
    } else {
      Hive.initFlutter();
    }

    _prefs ??= await Hive.openBox("yhManager", compactionStrategy: (entries, deletedEntries) {
      return deletedEntries > 10;
    });
  }

  static Future<void>? set(String key, dynamic jsonVal) {
    if (_prefs == null) {
      init();
    }
    return _prefs?.put(key, jsonVal);
  }

  static T get<T>(String key) {
    if (_prefs == null) {
      init();
    }
    return _prefs?.get(key);
  }

  static Future<void>? remove(String key) {
    if (_prefs == null) {
      init();
    }
    _prefs?.delete(key);
    return _prefs?.compact();
  }
}
