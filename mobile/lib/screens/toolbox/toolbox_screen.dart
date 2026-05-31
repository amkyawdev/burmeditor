import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/constants.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/tools/tool_card.dart';

final toolboxControllerProvider = ChangeNotifierProvider((ref) => ToolboxController());

class ToolboxController extends ChangeNotifier {
  String? _toolId;
  Map<String, dynamic> _toolSettings = {};

  String? get toolId => _toolId;
  Map<String, dynamic> get toolSettings => _toolSettings;

  void setToolId(String? id) {
    _toolId = id;
    notifyListeners();
  }

  void updateSetting(String key, dynamic value) {
    _toolSettings[key] = value;
    notifyListeners();
  }

  void resetSettings() {
    _toolSettings = {};
    notifyListeners();
  }
}

class ToolboxScreen extends ConsumerStatefulWidget {
  final String? toolId;

  const ToolboxScreen({super.key, this.toolId});

  @override
  ConsumerState<ToolboxScreen> createState() => _ToolboxScreenState();
}

class _ToolboxScreenState extends ConsumerState<ToolboxScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.toolId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(toolboxControllerProvider.notifier).setToolId(widget.toolId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(toolboxControllerProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: _getToolTitle(controller.toolId),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (controller.toolId != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => controller.resetSettings(),
            ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Apply settings and go back
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: controller.toolId != null
          ? _ToolSettingsView(
              toolId: controller.toolId!,
              settings: controller.toolSettings,
              onSettingChanged: controller.updateSetting,
            )
          : _AllToolsView(
              onToolSelected: (toolId) {
                controller.setToolId(toolId);
              },
            ),
    );
  }

  String _getToolTitle(String? toolId) {
    if (toolId == null) return 'Toolbox';
    
    final titles = {
      'crop': 'Crop Tool',
      'audio': 'Audio Tool',
      'color': 'Color Tool',
      'text': 'Text Tool',
      'title': 'Title Tool',
      'layering': 'Layering Tool',
      'transform': 'Transform Tool',
      'speed': 'Speed Tool',
      'transition': 'Transition Tool',
      'effects': 'Effects Tool',
      'masking': 'Masking Tool',
      'stabilize': 'Stabilize Tool',
      'image_overlay': 'Image Overlay',
      'subtitles': 'Subtitles Tool',
      'export': 'Export Tool',
    };
    
    return titles[toolId] ?? 'Tool';
  }
}

class _AllToolsView extends StatelessWidget {
  final ValueChanged<String> onToolSelected;

  const _AllToolsView({required this.onToolSelected});

  @override
  Widget build(BuildContext context) {
    final tools = [
      {'id': 'crop', 'icon': Icons.crop, 'label': 'Crop', 'description': 'Crop and resize video'},
      {'id': 'audio', 'icon': Icons.music_note, 'label': 'Audio', 'description': 'Edit audio tracks'},
      {'id': 'color', 'icon': Icons.color_lens, 'label': 'Color', 'description': 'Adjust colors and filters'},
      {'id': 'text', 'icon': Icons.text_fields, 'label': 'Text', 'description': 'Add text overlays'},
      {'id': 'title', 'icon': Icons.title, 'label': 'Title', 'description': 'Create title sequences'},
      {'id': 'layering', 'icon': Icons.layers, 'label': 'Layering', 'description': 'Manage video layers'},
      {'id': 'transform', 'icon': Icons.transform, 'label': 'Transform', 'description': 'Transform and scale'},
      {'id': 'speed', 'icon': Icons.speed, 'label': 'Speed', 'description': 'Adjust playback speed'},
      {'id': 'transition', 'icon': Icons.swap_horiz, 'label': 'Transition', 'description': 'Add transitions'},
      {'id': 'effects', 'icon': Icons.auto_awesome, 'label': 'Effects', 'description': 'Apply visual effects'},
      {'id': 'masking', 'icon': Icons.crop_square, 'label': 'Masking', 'description': 'Create masks'},
      {'id': 'stabilize', 'icon': Icons.stabilizationization, 'label': 'Stabilize', 'description': 'Stabilize footage'},
      {'id': 'image_overlay', 'icon': Icons.image, 'label': 'Image Overlay', 'description': 'Overlay images'},
      {'id': 'subtitles', 'icon': Icons.subtitles, 'label': 'Subtitles', 'description': 'Add subtitles'},
      {'id': 'export', 'icon': Icons.file_download, 'label': 'Export', 'description': 'Export your video'},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return ToolCard(
          icon: tool['icon'] as IconData,
          label: tool['label'] as String,
          description: tool['description'] as String,
          onTap: () => onToolSelected(tool['id'] as String),
        );
      },
    );
  }
}

class _ToolSettingsView extends StatelessWidget {
  final String toolId;
  final Map<String, dynamic> settings;
  final Function(String, dynamic) onSettingChanged;

  const _ToolSettingsView({
    required this.toolId,
    required this.settings,
    required this.onSettingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: _getToolWidgets(toolId),
    );
  }

  List<Widget> _getToolWidgets(String toolId) {
    switch (toolId) {
      case 'crop':
        return [
          _SettingSection(title: 'Crop Area'),
          _SliderSetting(
            label: 'Left',
            value: (settings['left'] ?? 0.0) as double,
            min: 0,
            max: 100,
            onChanged: (value) => onSettingChanged('left', value),
          ),
          _SliderSetting(
            label: 'Top',
            value: (settings['top'] ?? 0.0) as double,
            min: 0,
            max: 100,
            onChanged: (value) => onSettingChanged('top', value),
          ),
          _SliderSetting(
            label: 'Right',
            value: (settings['right'] ?? 100.0) as double,
            min: 0,
            max: 100,
            onChanged: (value) => onSettingChanged('right', value),
          ),
          _SliderSetting(
            label: 'Bottom',
            value: (settings['bottom'] ?? 100.0) as double,
            min: 0,
            max: 100,
            onChanged: (value) => onSettingChanged('bottom', value),
          ),
          const SizedBox(height: 16),
          _ActionButton(label: 'Reset Crop', onTap: () {}),
        ];

      case 'color':
        return [
          _SettingSection(title: 'Color Adjustments'),
          _SliderSetting(
            label: 'Brightness',
            value: (settings['brightness'] ?? 50.0) as double,
            min: 0,
            max: 100,
            onChanged: (value) => onSettingChanged('brightness', value),
          ),
          _SliderSetting(
            label: 'Contrast',
            value: (settings['contrast'] ?? 50.0) as double,
            min: 0,
            max: 100,
            onChanged: (value) => onSettingChanged('contrast', value),
          ),
          _SliderSetting(
            label: 'Saturation',
            value: (settings['saturation'] ?? 50.0) as double,
            min: 0,
            max: 100,
            onChanged: (value) => onSettingChanged('saturation', value),
          ),
          _SliderSetting(
            label: 'Hue',
            value: (settings['hue'] ?? 0.0) as double,
            min: -180,
            max: 180,
            onChanged: (value) => onSettingChanged('hue', value),
          ),
        ];

      case 'speed':
        return [
          _SettingSection(title: 'Speed Control'),
          _SliderSetting(
            label: 'Speed',
            value: (settings['speed'] ?? 1.0) as double,
            min: 0.25,
            max: 4.0,
            divisions: 15,
            onChanged: (value) => onSettingChanged('speed', value),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Current: ${((settings['speed'] ?? 1.0) as double).toStringAsFixed(2)}x',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              _SpeedPreset(label: '0.5x', onTap: () => onSettingChanged('speed', 0.5)),
              _SpeedPreset(label: '1x', onTap: () => onSettingChanged('speed', 1.0)),
              _SpeedPreset(label: '1.5x', onTap: () => onSettingChanged('speed', 1.5)),
              _SpeedPreset(label: '2x', onTap: () => onSettingChanged('speed', 2.0)),
            ],
          ),
        ];

      default:
        return [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getToolIcon(toolId),
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Configure $_getToolTitle(toolId) settings',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ];
    }
  }

  IconData _getToolIcon(String toolId) {
    final icons = {
      'crop': Icons.crop,
      'audio': Icons.music_note,
      'color': Icons.color_lens,
      'text': Icons.text_fields,
      'title': Icons.title,
      'layering': Icons.layers,
      'transform': Icons.transform,
      'speed': Icons.speed,
      'transition': Icons.swap_horiz,
      'effects': Icons.auto_awesome,
      'masking': Icons.crop_square,
      'stabilize': Icons.stabilizationization,
      'image_overlay': Icons.image,
      'subtitles': Icons.subtitles,
      'export': Icons.file_download,
    };
    return icons[toolId] ?? Icons.build;
  }

  String _getToolTitle(String toolId) {
    final titles = {
      'crop': 'Crop',
      'audio': 'Audio',
      'color': 'Color',
      'text': 'Text',
      'title': 'Title',
      'layering': 'Layering',
      'transform': 'Transform',
      'speed': 'Speed',
      'transition': 'Transition',
      'effects': 'Effects',
      'masking': 'Masking',
      'stabilize': 'Stabilize',
      'image_overlay': 'Image Overlay',
      'subtitles': 'Subtitles',
      'export': 'Export',
    };
    return titles[toolId] ?? 'Tool';
  }
}

class _SettingSection extends StatelessWidget {
  final String title;

  const _SettingSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SliderSetting extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  const _SliderSetting({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(
                value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1),
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(label),
    );
  }
}

class _SpeedPreset extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SpeedPreset({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
    );
  }
}