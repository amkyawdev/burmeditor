import 'package:flutter/material.dart';

class EffectsTool extends StatefulWidget {
  final Function(Map<String, dynamic>) onEffectChanged;

  const EffectsTool({super.key, required this.onEffectChanged});

  @override
  State<EffectsTool> createState() => _EffectsToolState();
}

class _EffectsToolState extends State<EffectsTool> {
  String? _selectedEffect;
  double _intensity = 50.0;

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
            final isSelected = _selectedEffect == e['id'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedEffect = e['id'] as String?;
                });
              },
              child: Container(
                width: 100,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected ? Border.all(color: Theme.of(context).primaryColor, width: 2) : null,
                ),
                child: Column(
                  children: [
                    Icon(e['icon'] as IconData, size: 32, color: isSelected ? Colors.white : Colors.grey.shade700),
                    const SizedBox(height: 8),
                    Text(
                      e['name'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
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
          value: _intensity,
          min: 0,
          max: 100,
          label: '${_intensity.toInt()}%',
          onChanged: (value) {
            setState(() {
              _intensity = value;
            });
          },
        ),
        
        if (_selectedEffect != null) ...[
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              widget.onEffectChanged({
                'effect': _selectedEffect,
                'intensity': _intensity,
              });
            },
            child: const Text('Apply Effect'),
          ),
        ],
      ],
    );
  }
}