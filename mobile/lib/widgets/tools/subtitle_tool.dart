import 'package:flutter/material.dart';

class SubtitleTool extends StatelessWidget {
  final Function(Map<String, dynamic>) onSubtitleChanged;

  const SubtitleTool({super.key, required this.onSubtitleChanged});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('Subtitles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 24),
        
        ElevatedButton.icon(
          onPressed: () {
            // Import subtitles
          },
          icon: const Icon(Icons.subtitles),
          label: const Text('Import Subtitles'),
        ),
        
        const SizedBox(height: 24),
        const Text('Subtitle Style', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        
        // Font
        Wrap(
          spacing: 8,
          children: ['Roboto', 'Pyidaungsu', 'Poppins'].map((font) {
            return ChoiceChip(label: Text(font), selected: font == 'Roboto', onSelected: (s) {});
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        const Text('Font Size', style: TextStyle(fontWeight: FontWeight.w500)),
        Slider(
          value: 24,
          min: 12,
          max: 48,
          label: '24px',
          onChanged: (value) {
            // Update font size
          },
        ),
        
        const SizedBox(height: 16),
        const Text('Text Color', style: TextStyle(fontWeight: FontWeight.w500)),
        Wrap(
          spacing: 8,
          children: [Colors.white, Colors.black, Colors.yellow, Colors.cyan].map((color) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        const Text('Background Color', style: TextStyle(fontWeight: FontWeight.w500)),
        SwitchListTile(
          title: const Text('Enable Background'),
          value: false,
          onChanged: (value) {
            // Toggle background
          },
        ),
        
        const SizedBox(height: 24),
        const Text('Position', style: TextStyle(fontWeight: FontWeight.w500)),
        Wrap(
          spacing: 8,
          children: ['Top', 'Center', 'Bottom'].map((pos) {
            return ChoiceChip(label: Text(pos), selected: pos == 'Bottom', onSelected: (s) {});
          }).toList(),
        ),
      ],
    );
  }
}
