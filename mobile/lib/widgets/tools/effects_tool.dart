import 'package:flutter/material.dart';

class EffectsTool extends StatelessWidget {
  final Function(Map<String, dynamic>) onEffectChanged;

  const EffectsTool({super.key, required this.onEffectChanged});

  @override
  Widget build(BuildContext context) {
    final effects = [
      {'id': 'blur', 'name': 'Blur', 'icon': Icons.blur_on},
      {'id': 'sharpen', 'name': 'Sharpen', 'icon': Icons.filter_hdr},
      {'id': 'vignette', 'name': 'Vignette', 'icon': Icons.vignette},
      {'id': 'noise', 'name': 'Noise', 'icon': Icons.grain},
      {'id': 'glow', 'name': 'Glow', 'icon': Icons.brightness_7},
      {'id': 'pixelate', 'name': 'Pixelate', 'icon': Icons.grid_on},
    ];

    return ListView(
      children: [
        const Text('Visual Effects', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: effects.map((e) {
            return GestureDetector(
              onTap: () {
                // Apply effect
              },
              child: Container(
                width: 100,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(e['icon'] as IconData, size: 32, color: Colors.grey.shade700),
                    const SizedBox(height: 8),
                    Text(
                      e['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 24),
        const Text('Effect Intensity', style: TextStyle(fontWeight: FontWeight.w500)),
        Slider(
          value: 50,
          min: 0,
          max: 100,
          label: '50%',
          onChanged: (value) {
            // Update intensity
          },
        ),
      ],
    );
  }
}