class AppConstants {
  // App Info
  static const String APP_NAME = 'Burme Editor';
  static const String APP_VERSION = '1.0.0';
  static const int APP_BUILD = 101;
  
  // API Configuration
  static const String API_BASE_URL = 'https://api.burmeeditor.app';
  static const int API_TIMEOUT = 30000;
  static const int API_MAX_RETRIES = 3;
  
  // Storage Keys
  static const String KEY_THEME_MODE = 'theme_mode';
  static const String KEY_LANGUAGE = 'language';
  static const String KEY_FIRST_LAUNCH = 'first_launch';
  static const String KEY_RECENT_PROJECTS = 'recent_projects';
  static const String KEY_AUTO_SAVE = 'auto_save';
  static const String KEY_VIDEO_QUALITY = 'video_quality';
  
  // Default Settings
  static const String DEFAULT_LANGUAGE = 'en';
  static const bool DEFAULT_AUTO_SAVE = true;
  static const String DEFAULT_VIDEO_QUALITY = 'high';
  
  // Video Export Settings
  static const List<String> VIDEO_QUALITIES = ['low', 'medium', 'high', 'ultra'];
  static const List<String> VIDEO_FORMATS = ['mp4', 'webm', 'avi'];
  
  // Tool IDs
  static const String TOOL_CROP = 'crop';
  static const String TOOL_AUDIO = 'audio';
  static const String TOOL_COLOR = 'color';
  static const String TOOL_TEXT = 'text';
  static const String TOOL_TITLE = 'title';
  static const String TOOL_LAYERING = 'layering';
  static const String TOOL_TRANSFORM = 'transform';
  static const String TOOL_SPEED = 'speed';
  static const String TOOL_TRANSITION = 'transition';
  static const String TOOL_EFFECTS = 'effects';
  static const String TOOL_MASKING = 'masking';
  static const String TOOL_STABILIZE = 'stabilize';
  static const String TOOL_IMAGE_OVERLAY = 'image_overlay';
  static const String TOOL_SUBTITLES = 'subtitles';
  static const String TOOL_EXPORT = 'export';
  
  // Animation Durations
  static const Duration ANIMATION_SHORT = Duration(milliseconds: 200);
  static const Duration ANIMATION_MEDIUM = Duration(milliseconds: 350);
  static const Duration ANIMATION_LONG = Duration(milliseconds: 500);
  
  // UI Constants
  static const double BORDER_RADIUS = 16.0;
  static const double CARD_ELEVATION = 4.0;
  static const double PADDING_SMALL = 8.0;
  static const double PADDING_MEDIUM = 16.0;
  static const double PADDING_LARGE = 24.0;
  
  // Supported Languages
  static const Map<String, String> SUPPORTED_LANGUAGES = {
    'en': 'English',
    'my': 'Myanmar',
    'th': 'Thai',
    'vi': 'Vietnamese',
    'ru': 'Russian',
  };
  
  // Features
  static const List<String> FEATURES = [
    'crop',
    'audio',
    'color',
    'text',
    'title',
    'layering',
    'transform',
    'speed',
    'transition',
    'effects',
    'masking',
    'stabilize',
    'image_overlay',
    'subtitles',
    'export',
  ];
}