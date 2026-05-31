import 'package:flutter/material.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/editor/editor_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/toolbox/toolbox_screen.dart';
import '../screens/about/about_screen.dart';

class Routes {
  static const String splash = '/';
  static const String home = '/home';
  static const String editor = '/editor';
  static const String settings = '/settings';
  static const String toolbox = '/toolbox';
  static const String about = '/about';
  
  static const String cropTool = '/tools/crop';
  static const String audioTool = '/tools/audio';
  static const String colorTool = '/tools/color';
  static const String textTool = '/tools/text';
  static const String titleTool = '/tools/title';
  static const String layeringTool = '/tools/layering';
  static const String transformTool = '/tools/transform';
  static const String speedTool = '/tools/speed';
  static const String transitionTool = '/tools/transition';
  static const String effectsTool = '/tools/effects';
  static const String maskingTool = '/tools/masking';
  static const String stabilizeTool = '/tools/stabilize';
  static const String imageOverlayTool = '/tools/image_overlay';
  static const String subtitleTool = '/tools/subtitles';
  static const String exportTool = '/tools/export';
}

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _buildRoute(const SplashScreen(), settings);
      
      case Routes.home:
        return _buildRoute(const HomeScreen(), settings);
      
      case Routes.editor:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          EditorScreen(projectId: args?['projectId']),
          settings,
        );
      
      case Routes.settings:
        return _buildRoute(const SettingsScreen(), settings);
      
      case Routes.toolbox:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          ToolboxScreen(toolId: args?['toolId']),
          settings,
        );
      
      case Routes.about:
        return _buildRoute(const AboutScreen(), settings);
      
      default:
        return _buildRoute(
          const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
          settings,
        );
    }
  }
  
  static MaterialPageRoute<dynamic> _buildRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}