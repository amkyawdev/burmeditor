class Settings {
  final String themeMode;
  final String language;
  final bool autoSave;
  final String videoQuality;
  final bool showTutorial;
  final Map<String, dynamic>? toolSettings;

  Settings({
    this.themeMode = 'system',
    this.language = 'en',
    this.autoSave = true,
    this.videoQuality = 'high',
    this.showTutorial = true,
    this.toolSettings,
  });

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode,
      'language': language,
      'autoSave': autoSave,
      'videoQuality': videoQuality,
      'showTutorial': showTutorial,
      'toolSettings': toolSettings,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      themeMode: json['themeMode'] ?? 'system',
      language: json['language'] ?? 'en',
      autoSave: json['autoSave'] ?? true,
      videoQuality: json['videoQuality'] ?? 'high',
      showTutorial: json['showTutorial'] ?? true,
      toolSettings: json['toolSettings'],
    );
  }

  Settings copyWith({
    String? themeMode,
    String? language,
    bool? autoSave,
    String? videoQuality,
    bool? showTutorial,
    Map<String, dynamic>? toolSettings,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      autoSave: autoSave ?? this.autoSave,
      videoQuality: videoQuality ?? this.videoQuality,
      showTutorial: showTutorial ?? this.showTutorial,
      toolSettings: toolSettings ?? this.toolSettings,
    );
  }

  static Settings defaultSettings() {
    return Settings();
  }
}