import 'package:flutter/material.dart';

class ColorTool extends StatefulWidget {
  final Function(Map<String, double>) onColorChanged;

  const ColorTool({super.key, required this.onColorChanged});

  @override
  State<ColorTool> createState() => _ColorToolState();
}

class _ColorToolState extends State<ColorTool> {
  double _brightness = 50;
  double _contrast = 50;
  double _saturation = 50;
  double _hue = 0;
  double _exposure = 50;

  void _updateColor() {
    widget.onColorChanged({
      'brightness': _brightness,
      'contrast': _contrast,
      'saturation': _saturation,
      'hue': _hue,
      'exposure': _exposure,
    });
  }

  void _reset() {
    setState(() {
      _brightness = 50;
      _contrast = 50;
      _saturation = 50;
      _hue = 0;
      _exposure = 50;
      _updateColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('Color Adjustments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 24),
        
        _ColorSlider(
          label: 'Brightness',
          value: _brightness,
          min: 0,
          max: 100,
          onChanged: (value) => setState(() {
            _brightness = value;
            _updateColor();
          }),
        ),
        _ColorSlider(
          label: 'Contrast',
          value: _contrast,
          min: 0,
          max: 100,
          onChanged: (value) => setState(() {
            _contrast = value;
            _updateColor();
          }),
        ),
        _ColorSlider(
          label: 'Saturation',
          value: _saturation,
          min: 0,
          max: 100,
          onChanged: (value) => setState(() {
            _saturation = value;
            _updateColor();
          }),
        ),
        _ColorSlider(
          label: 'Hue',
          value: _hue,
          min: -180,
          max: 180,
          onChanged: (value) => setState(() {
            _hue = value;
            _updateColor();
          }),
        ),
        _ColorSlider(
          label: 'Exposure',
          value: _exposure,
          min: 0,
          max: 100,
          onChanged: (value) => setState(() {
            _exposure = value;
            _updateColor();
          }),
        ),
        
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ColorSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _ColorSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1),
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}