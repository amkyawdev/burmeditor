import 'package:flutter/material.dart';

class MaskingTool extends StatelessWidget {
  final Function(Map<String, dynamic>) onMaskingChanged;

  const MaskingTool({super.key, required this.onMaskingChanged});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('Masking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 24),
        
        const Text('Mask Type', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _MaskOption(label: 'Rectangle', icon: Icons.crop_square, selected: false),
            _MaskOption(label: 'Circle', icon: Icons.circle_outlined, selected: false),
            _MaskOption(label: 'Polygon', icon: Icons.hexagon_outlined, selected: false),
            _MaskOption(label: 'Brush', icon: Icons.brush, selected: false),
          ],
        ),
        
        const SizedBox(height: 24),
        const Text('Feather', style: TextStyle(fontWeight: FontWeight.w500)),
        Slider(
          value: 10,
          min: 0,
          max: 50,
          label: '10px',
          onChanged: (value) {
            // Update feather
          },
        ),
        
        const SizedBox(height: 16),
        const Text('Opacity', style: TextStyle(fontWeight: FontWeight.w500)),
        Slider(
          value: 100,
          min: 0,
          max: 100,
          label: '100%',
          onChanged: (value) {
            // Update opacity
          },
        ),
      ],
    );
  }
}

class _MaskOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;

  const _MaskOption({
    required this.label,
    required this.icon,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Theme.of(context).primaryColor : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: selected ? Colors.white : Colors.black87),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
