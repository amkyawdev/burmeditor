class Project {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double duration;
  final String? thumbnailPath;
  final Map<String, dynamic>? settings;

  Project({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.duration = 0.0,
    this.thumbnailPath,
    this.settings,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'duration': duration,
      'thumbnailPath': thumbnailPath,
      'settings': settings,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      duration: (json['duration'] ?? 0.0).toDouble(),
      thumbnailPath: json['thumbnailPath'],
      settings: json['settings'],
    );
  }

  Project copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? duration,
    String? thumbnailPath,
    Map<String, dynamic>? settings,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      duration: duration ?? this.duration,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      settings: settings ?? this.settings,
    );
  }
}