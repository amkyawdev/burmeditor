import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';
import 'services/local/storage_service.dart';
import 'services/local/cache_service.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // Initialize services
    await StorageService.instance.init();
    
    try {
      await CacheService.instance.init();
    } catch (e) {
      debugPrint('CacheService init error: $e');
    }

    runApp(const BurmeEditorApp());
  } catch (e) {
    debugPrint('App initialization error: $e');
    runApp(const BurmeEditorApp());
  }
}
