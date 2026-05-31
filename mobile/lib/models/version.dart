class Version {
  final String version;
  final int build;
  final String channel;
  final String? downloadUrl;
  final List<String>? changelog;
  final bool updateAvailable;

  Version({
    required this.version,
    required this.build,
    this.channel = 'stable',
    this.downloadUrl,
    this.changelog,
    this.updateAvailable = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'build': build,
      'channel': channel,
      'downloadUrl': downloadUrl,
      'changelog': changelog,
      'updateAvailable': updateAvailable,
    };
  }

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      version: json['version'] ?? '1.0.0',
      build: json['build'] ?? 1,
      channel: json['channel'] ?? 'stable',
      downloadUrl: json['downloadUrl'],
      changelog: json['changelog'] != null 
          ? List<String>.from(json['changelog']) 
          : null,
      updateAvailable: json['updateAvailable'] ?? false,
    );
  }

  factory Version.current() {
    return Version(
      version: '1.0.0',
      build: 101,
      channel: 'stable',
    );
  }

  int compareTo(Version other) {
    final thisParts = version.split('.').map(int.parse).toList();
    final otherParts = other.version.split('.').map(int.parse).toList();
    
    for (int i = 0; i < thisParts.length; i++) {
      if (i >= otherParts.length) return 1;
      if (thisParts[i] < otherParts[i]) return -1;
      if (thisParts[i] > otherParts[i]) return 1;
    }
    
    return 0;
  }
}