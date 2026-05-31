import 'package:flutter/material.dart';

class TransitionTool extends StatefulWidget {
  final Function(Map<String, dynamic>) onTransitionChanged;

  const TransitionTool({super.key, required this.onTransitionChanged});

  @override
  State<TransitionTool> createState() => _TransitionToolState();
}

class _TransitionToolState extends State<TransitionTool> {
  String? _selectedTransition;
  double _duration = 1.0;

  @override
  Widget build(BuildContext context) {
    final transitions = [
      {'id': 'fade', 'name': 'Fade', 'icon': Icons.blur_on},
      {'id': 'dissolve', 'name': 'Dissolve', 'icon': Icons.auto_awesome},
      {'id': 'wipe', 'name': 'Wipe', 'icon': Icons.drag_handle},
      {'id': 'slide', 'name': 'Slide', 'icon': Icons.slideshow},
      {'id': 'zoom', 'name': 'Zoom', 'icon': Icons.zoom_in},
      {'id': 'flip', 'name': 'Flip', 'icon': Icons.flip},
    ];

    return ListView(
      children: [
        const Text('Transitions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: transitions.map((t) {
            final isSelected = _selectedTransition == t['id'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTransition = t['id'] as String?;
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
                    Icon(t['icon'] as IconData, size: 32, color: isSelected ? Colors.white : Colors.grey.shade700),
                    const SizedBox(height: 8),
                    Text(
                      t['name'] as String,
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
        const Text('Duration', style: TextStyle(fontWeight: FontWeight.w500)),
        Slider(
          value: _duration,
          min: 0.1,
          max: 3.0,
          divisions: 29,
          label: '${_duration.toStringAsFixed(1)}s',
          onChanged: (value) {
            setState(() {
              _duration = value;
            });
          },
        ),
        
        const SizedBox(height: 16),
        if (_selectedTransition != null)
          Text(
            'Selected: $_selectedTransition (${_duration.toStringAsFixed(1)}s)',
            style: const TextStyle(color: Colors.grey),
          ),
      ],
    );
  }
}