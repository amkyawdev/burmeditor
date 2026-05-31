import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/constants.dart';
import '../../services/local/storage_service.dart';
import '../../services/update/update_service.dart';
import '../../widgets/common/custom_app_bar.dart';

final settingsControllerProvider = ChangeNotifierProvider((ref) => SettingsController());

class SettingsController extends ChangeNotifier {
  String _themeMode = 'system';
  String _language = 'en';
  bool _autoSave = true;
  String _videoQuality = 'high';
  bool _isCheckingUpdate = false;
  String? _latestVersion;

  String get themeMode => _themeMode;
  String get language => _language;
  bool get autoSave => _autoSave;
  String get videoQuality => _videoQuality;
  bool get isCheckingUpdate => _isCheckingUpdate;
  String? get latestVersion => _latestVersion;

  Future<void> loadSettings() async {
    _themeMode = StorageService.instance.getString('theme_mode') ?? 'system';
    _language = StorageService.instance.getString('language') ?? 'en';
    _autoSave = StorageService.instance.getBool('auto_save') ?? true;
    _videoQuality = StorageService.instance.getString('video_quality') ?? 'high';
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
    await StorageService.instance.setString('theme_mode', mode);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    await StorageService.instance.setString('language', lang);
    notifyListeners();
  }

  Future<void> setAutoSave(bool value) async {
    _autoSave = value;
    await StorageService.instance.setBool('auto_save', value);
    notifyListeners();
  }

  Future<void> setVideoQuality(String quality) async {
    _videoQuality = quality;
    await StorageService.instance.setString('video_quality', quality);
    notifyListeners();
  }

  Future<void> checkForUpdate() async {
    _isCheckingUpdate = true;
    notifyListeners();

    try {
      final updateService = UpdateService();
      final result = await updateService.checkForUpdate();
      _latestVersion = result['latest_version'];
    } catch (e) {
      // Handle error
    } finally {
      _isCheckingUpdate = false;
      notifyListeners();
    }
  }
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsControllerProvider.notifier).loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Appearance Section
          _SectionHeader(title: 'Appearance'),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Theme'),
            subtitle: Text(_getThemeLabel(controller.themeMode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context, controller),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(AppConstants.SUPPORTED_LANGUAGES[controller.language] ?? 'English'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, controller),
          ),

          // Editor Section
          _SectionHeader(title: 'Editor'),
          SwitchListTile(
            secondary: const Icon(Icons.save),
            title: const Text('Auto Save'),
            subtitle: const Text('Automatically save your projects'),
            value: controller.autoSave,
            onChanged: (value) => controller.setAutoSave(value),
          ),
          ListTile(
            leading: const Icon(Icons.high_quality),
            title: const Text('Default Video Quality'),
            subtitle: Text(_getQualityLabel(controller.videoQuality)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showQualityDialog(context, controller),
          ),

          // Updates Section
          _SectionHeader(title: 'Updates'),
          ListTile(
            leading: const Icon(Icons.system_update),
            title: const Text('Check for Updates'),
            subtitle: Text(controller.latestVersion ?? 'Tap to check'),
            trailing: controller.isCheckingUpdate
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.chevron_right),
            onTap: controller.isCheckingUpdate
                ? null
                : () => controller.checkForUpdate(),
          ),

          // About Section
          _SectionHeader(title: 'About'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('App Version'),
            subtitle: Text('${AppConstants.APP_VERSION} (${AppConstants.APP_BUILD})'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Open terms
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Open privacy policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Open Source Licenses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: AppConstants.APP_NAME,
                applicationVersion: AppConstants.APP_VERSION,
              );
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _getThemeLabel(String mode) {
    switch (mode) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'System';
    }
  }

  String _getQualityLabel(String quality) {
    switch (quality) {
      case 'low':
        return 'Low (480p)';
      case 'medium':
        return 'Medium (720p)';
      case 'high':
        return 'High (1080p)';
      case 'ultra':
        return 'Ultra (4K)';
      default:
        return 'High (1080p)';
    }
  }

  void _showThemeDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOption(
              title: 'System',
              value: 'system',
              groupValue: controller.themeMode,
              onChanged: (value) {
                controller.setThemeMode(value);
                Navigator.pop(context);
              },
            ),
            _ThemeOption(
              title: 'Light',
              value: 'light',
              groupValue: controller.themeMode,
              onChanged: (value) {
                controller.setThemeMode(value);
                Navigator.pop(context);
              },
            ),
            _ThemeOption(
              title: 'Dark',
              value: 'dark',
              groupValue: controller.themeMode,
              onChanged: (value) {
                controller.setThemeMode(value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.SUPPORTED_LANGUAGES.entries.map((entry) {
            return _ThemeOption(
              title: entry.value,
              value: entry.key,
              groupValue: controller.language,
              onChanged: (value) {
                controller.setLanguage(value);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showQualityDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Video Quality'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.VIDEO_QUALITIES.map((quality) {
            return _ThemeOption(
              title: _getQualityLabel(quality),
              value: quality,
              groupValue: controller.videoQuality,
              onChanged: (value) {
                controller.setVideoQuality(value);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _ThemeOption({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: (newValue) {
        if (newValue != null) onChanged(newValue);
      },
    );
  }
}