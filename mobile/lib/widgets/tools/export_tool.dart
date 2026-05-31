import 'package:flutter/material.dart';

class ExportTool extends StatelessWidget {
  final Function(Map<String, dynamic>) onExportChanged;

  const ExportTool({super.key, required this.onExportChanged});

  @override
  Widget build(BuildContext context) {
    String selectedFormat = 'mp4';
    String selectedQuality = 'high';
    
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
            _FormatOption(label: 'MP4', selected: selectedFormat == 'mp4', onTap: () {}),
            _FormatOption(label: 'WebM', selected: selectedFormat == 'webm', onTap: () {}),
            _FormatOption(label: 'AVI', selected: selectedFormat == 'avi', onTap: () {}),
          ],
        ),
        
        const SizedBox(height: 24),
        const Text('Quality', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FormatOption(label: 'Low (480p)', selected: selectedQuality == 'low', onTap: () {}),
            _FormatOption(label: 'Medium (720p)', selected: selectedQuality == 'medium', onTap: () {}),
            _FormatOption(label: 'High (1080p)', selected: selectedQuality == 'high', onTap: () {}),
            _FormatOption(label: 'Ultra (4K)', selected: selectedQuality == 'ultra', onTap: () {}),
          ],
        ),
        
        const SizedBox(height: 24),
        const Text('Estimated File Size', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        const Text('~250 MB', style: TextStyle(color: Colors.grey)),
        
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () {
            // Start export
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
