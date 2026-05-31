import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  static CacheService get instance => _instance;

  CacheService._internal();

  Box? _cacheBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _cacheBox = await Hive.openBox('burme_cache');
  }

  // Cache operations
  dynamic get(String key) => _cacheBox?.get(key);
  
  Future<void> set(String key, dynamic value) async {
    await _cacheBox?.put(key, value);
  }

  Future<void> remove(String key) async {
    await _cacheBox?.delete(key);
  }

  Future<void> clear() async {
    await _cacheBox?.clear();
  }

  // Check if key exists
  bool containsKey(String key) => _cacheBox?.containsKey(key) ?? false;

  // Get all keys
  List<dynamic>? getKeys() => _cacheBox?.keys.toList();
}