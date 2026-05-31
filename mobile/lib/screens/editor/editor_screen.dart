import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/routes.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/preview/preview_player.dart';
import '../../widgets/tools/tool_card.dart';

final editorControllerProvider = ChangeNotifierProvider((ref) => EditorController());

class EditorController extends ChangeNotifier {
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  double _duration = 0.0;
  String? _selectedTool;

  bool get isPlaying => _isPlaying;
  double get currentPosition => _currentPosition;
  double get duration => _duration;
  String? get selectedTool => _selectedTool;

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void seekTo(double position) {
    _currentPosition = position;
    notifyListeners();
  }

  void selectTool(String toolId) {
    _selectedTool = toolId;
    notifyListeners();
  }

  void clearTool() {
    _selectedTool = null;
    notifyListeners();
  }
}

class EditorScreen extends ConsumerStatefulWidget {
  final String? projectId;

  const EditorScreen({super.key, this.projectId});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.projectId != null) {
      // Load project
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(editorControllerProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Editor',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () {
              // Save project
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // Share project
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Preview Player
          Expanded(
            flex: 3,
            child: PreviewPlayer(
              isPlaying: controller.isPlaying,
              currentPosition: controller.currentPosition,
              duration: controller.duration,
              onPlayPause: controller.togglePlayPause,
              onSeek: controller.seekTo,
            ),
          ),

          // Timeline Widget
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey.shade900,
              child: _TimelineWidget(
                currentPosition: controller.currentPosition,
                duration: controller.duration,
                onSeek: controller.seekTo,
              ),
            ),
          ),

          // Tools Panel
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade100,
              child: _ToolsPanel(
                selectedTool: controller.selectedTool,
                onToolSelected: (toolId) {
                  Navigator.pushNamed(
                    context,
                    Routes.toolbox,
                    arguments: {'toolId': toolId},
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineWidget extends StatelessWidget {
  final double currentPosition;
  final double duration;
  final ValueChanged<double> onSeek;

  const _TimelineWidget({
    required this.currentPosition,
    required this.duration,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Timeline controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () => onSeek(0),
              ),
              IconButton(
                icon: const Icon(Icons.fast_rewind, color: Colors.white),
                onPressed: () => onSeek((currentPosition - 5).clamp(0, duration)),
              ),
              IconButton(
                icon: const Icon(Icons.fast_forward, color: Colors.white),
                onPressed: () => onSeek((currentPosition + 5).clamp(0, duration)),
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: () => onSeek(duration),
              ),
              const Spacer(),
              Text(
                '${_formatTime(currentPosition)} / ${_formatTime(duration)}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        // Timeline track
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade700,
              thumbColor: Colors.white,
              trackHeight: 4,
            ),
            child: Slider(
              value: currentPosition.clamp(0, duration > 0 ? duration : 1),
              min: 0,
              max: duration > 0 ? duration : 1,
              onChanged: onSeek,
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    final minutes = duration.inMinutes;
    final secs = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

class _ToolsPanel extends StatelessWidget {
  final String? selectedTool;
  final ValueChanged<String> onToolSelected;

  const _ToolsPanel({
    required this.selectedTool,
    required this.onToolSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tools = [
      {'id': 'crop', 'icon': Icons.crop, 'label': 'Crop'},
      {'id': 'audio', 'icon': Icons.music_note, 'label': 'Audio'},
      {'id': 'color', 'icon': Icons.color_lens, 'label': 'Color'},
      {'id': 'text', 'icon': Icons.text_fields, 'label': 'Text'},
      {'id': 'title', 'icon': Icons.title, 'label': 'Title'},
      {'id': 'speed', 'icon': Icons.speed, 'label': 'Speed'},
      {'id': 'effects', 'icon': Icons.auto_awesome, 'label': 'Effects'},
      {'id': 'export', 'icon': Icons.file_download, 'label': 'Export'},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        final isSelected = selectedTool == tool['id'];

        return _ToolButton(
          icon: tool['icon'] as IconData,
          label: tool['label'] as String,
          isSelected: isSelected,
          onTap: () => onToolSelected(tool['id'] as String),
        );
      },
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Theme.of(context).primaryColor : Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}