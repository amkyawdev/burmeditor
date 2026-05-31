import 'package:flutter/material.dart';

class ExportTool extends StatefulWidget {
  final Function(Map<String, dynamic>) onExportChanged;

  const ExportTool({super.key, required this.onExportChanged});

  @override
  State<ExportTool> createState() => _ExportToolState();
}

class _ExportToolState extends State<ExportTool> {
  String _selectedFormat = 'mp4';
  String _selectedQuality = 'high';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('Export Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 24),
        
        const Text('Format', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FormatOption(label: 'MP4', selected: _selectedFormat == 'mp4', onTap: () => setState(() => _selectedFormat = 'mp4')),
            _FormatOption(label: 'WebM', selected: _selectedFormat == 'webm', onTap: () => setState(() => _selectedFormat = 'webm')),
            _FormatOption(label: 'AVI', selected: _selectedFormat == 'avi', onTap: () => setState(() => _selectedFormat = 'avi')),
          ],
        ),
        
        const SizedBox(height: 24),
        const Text('Quality', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FormatOption(label: 'Low (480p)', selected: _selectedQuality == 'low', onTap: () => setState(() => _selectedQuality = 'low')),
            _FormatOption(label: 'Medium (720p)', selected: _selectedQuality == 'medium', onTap: () => setState(() => _selectedQuality = 'medium')),
            _FormatOption(label: 'High (1080p)', selected: _selectedQuality == 'high', onTap: () => setState(() => _selectedQuality = 'high')),
            _FormatOption(label: 'Ultra (4K)', selected: _selectedQuality == 'ultra', onTap: () => setState(() => _selectedQuality = 'ultra')),
          ],
        ),
        
        const SizedBox(height: 24),
        const Text('Selected Settings', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Text('Format: $_selectedFormat | Quality: $_selectedQuality', style: const TextStyle(color: Colors.grey)),
        
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () {
            widget.onExportChanged({
              'format': _selectedFormat,
              'quality': _selectedQuality,
            });
          },
          icon: const Icon(Icons.file_download),
          label: const Text('Export Video'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
          ),
        ),
        
        const SizedBox(height: 16),
        const Text(
          'Note: Export time depends on video length and quality settings.',
          style: TextStyle(color: Colors.grey, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FormatOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FormatOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
