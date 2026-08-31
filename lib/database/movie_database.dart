import 'package:hive_flutter/hive_flutter.dart';

class MovieDatabase {
  static const String boxName = 'cartoonflix';

  static const String favoritesKey = 'favorites';
  static const String watchingKey = 'watching';
  static const String watchedKey = 'watched';
  static const String wantToWatchKey = 'wantToWatch';

  // ==================== Initialize ====================

  static Future<void> init() async {
    await Hive.initFlutter();

    await Hive.openBox(boxName);
  }

  // ==================== Box ====================

  static Box get box => Hive.box(boxName);

  // ==================== Favorites ====================

  static List<dynamic> getFavorites() {
    final data = box.get(favoritesKey, defaultValue: []);

    return List<dynamic>.from(data);
  }

  static Future<void> saveFavorites(List<dynamic> movies) async {
    await box.put(favoritesKey, movies);
  }

  // ==================== Watching ====================

  static List<dynamic> getWatching() {
    final data = box.get(watchingKey, defaultValue: []);

    return List<dynamic>.from(data);
  }

  static Future<void> saveWatching(List<dynamic> movies) async {
    await box.put(watchingKey, movies);
  }

  // ==================== Watched ====================

  static List<dynamic> getWatched() {
    final data = box.get(watchedKey, defaultValue: []);

    return List<dynamic>.from(data);
  }

  static Future<void> saveWatched(List<dynamic> movies) async {
    await box.put(watchedKey, movies);
  }

  // ==================== Want To Watch ====================

  static List<dynamic> getWantToWatch() {
    final data = box.get(wantToWatchKey, defaultValue: []);

    return List<dynamic>.from(data);
  }

  static Future<void> saveWantToWatch(List<dynamic> movies) async {
    await box.put(wantToWatchKey, movies);
  }
}
