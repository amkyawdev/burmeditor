import 'package:flutter/material.dart';

class StabilizeTool extends StatelessWidget {
  final Function(Map<String, dynamic>) onStabilizeChanged;

  const StabilizeTool({super.key, required this.onStabilizeChanged});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('Video Stabilization', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        
        SwitchListTile(
          title: const Text('Enable Stabilization'),
          subtitle: const Text('Smooth out shaky footage'),
          value: true,
          onChanged: (value) {
            // Toggle stabilization
          },
        ),
        
        const SizedBox(height: 16),
        const Text('Stabilization Level', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(label: const Text('Light'), selected: true, onSelected: (s) {}),
            ChoiceChip(label: const Text('Medium'), selected: false, onSelected: (s) {}),
            ChoiceChip(label: const Text('Strong'), selected: false, onSelected: (s) {}),
          ],
        ),
        
        const SizedBox(height: 24),
        const Text('Smoothing', style: TextStyle(fontWeight: FontWeight.w500)),
        Slider(
          value: 50,
          min: 0,
          max: 100,
          label: '50%',
          onChanged: (value) {
            // Update smoothing
          },
        ),
        
        const SizedBox(height: 16),
        const Text(
          'Note: Stabilization may take some time to process and may slightly crop the video edges.',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
