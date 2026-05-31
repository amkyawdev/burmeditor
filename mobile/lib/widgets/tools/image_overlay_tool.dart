import 'package:flutter/material.dart';

class ImageOverlayTool extends StatelessWidget {
  final Function(Map<String, dynamic>) onOverlayChanged;

  const ImageOverlayTool({super.key, required this.onOverlayChanged});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('Image Overlay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 24),
        
        ElevatedButton.icon(
          onPressed: () {
            // Pick image
          },
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Select Image'),
        ),
        
        const SizedBox(height: 24),
        const Text('Position', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            _PositionButton(label: 'TL', position: 'topLeft'),
            _PositionButton(label: 'TC', position: 'topCenter'),
            _PositionButton(label: 'TR', position: 'topRight'),
            _PositionButton(label: 'ML', position: 'middleLeft'),
            _PositionButton(label: 'C', position: 'center'),
            _PositionButton(label: 'MR', position: 'middleRight'),
            _PositionButton(label: 'BL', position: 'bottomLeft'),
            _PositionButton(label: 'BC', position: 'bottomCenter'),
            _PositionButton(label: 'BR', position: 'bottomRight'),
          ],
        ),
        
        const SizedBox(height: 24),
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
        
        const SizedBox(height: 16),
        const Text('Scale', style: TextStyle(fontWeight: FontWeight.w500)),
        Slider(
          value: 100,
          min: 10,
          max: 200,
          label: '100%',
          onChanged: (value) {
            // Update scale
          },
        ),
      ],
    );
  }
}

class _PositionButton extends StatelessWidget {
  final String label;
  final String position;

  const _PositionButton({required this.label, required this.position});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        // Set position
      },
      child: Text(label),
    );
  }
}
