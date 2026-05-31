class Tool {
  final String id;
  final String name;
  final String icon;
  final String description;
  final bool isEnabled;
  final Map<String, dynamic>? settings;

  Tool({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    this.isEnabled = true,
    this.settings,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'isEnabled': isEnabled,
      'settings': settings,
    };
  }

  factory Tool.fromJson(Map<String, dynamic> json) {
    return Tool(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      description: json['description'] ?? '',
      isEnabled: json['isEnabled'] ?? true,
      settings: json['settings'],
    );
  }

  static List<Tool> defaultTools() {
    return [
      Tool(id: 'crop', name: 'Crop', icon: 'crop', description: 'Crop and resize video'),
      Tool(id: 'audio', name: 'Audio', icon: 'music_note', description: 'Edit audio tracks'),
      Tool(id: 'color', name: 'Color', icon: 'color_lens', description: 'Adjust colors and filters'),
      Tool(id: 'text', name: 'Text', icon: 'text_fields', description: 'Add text overlays'),
      Tool(id: 'title', name: 'Title', icon: 'title', description: 'Create title sequences'),
      Tool(id: 'layering', name: 'Layering', icon: 'layers', description: 'Manage video layers'),
      Tool(id: 'transform', name: 'Transform', icon: 'transform', description: 'Transform and scale'),
      Tool(id: 'speed', name: 'Speed', icon: 'speed', description: 'Adjust playback speed'),
      Tool(id: 'transition', name: 'Transition', icon: 'swap_horiz', description: 'Add transitions'),
      Tool(id: 'effects', name: 'Effects', icon: 'auto_awesome', description: 'Apply visual effects'),
      Tool(id: 'masking', name: 'Masking', icon: 'crop_square', description: 'Create masks'),
      Tool(id: 'stabilize', name: 'Stabilize', icon: 'stabilizationization', description: 'Stabilize footage'),
      Tool(id: 'image_overlay', name: 'Image Overlay', icon: 'image', description: 'Overlay images'),
      Tool(id: 'subtitles', name: 'Subtitles', icon: 'subtitles', description: 'Add subtitles'),
      Tool(id: 'export', name: 'Export', icon: 'file_download', description: 'Export your video'),
    ];
  }
}