import 'package:flutter/material.dart';

class TransformTool extends StatefulWidget {
  final Function(Map<String, dynamic>) onTransformChanged;

  const TransformTool({super.key, required this.onTransformChanged});

  @override
  State<TransformTool> createState() => _TransformToolState();
}

class _TransformToolState extends State<TransformTool> {
  double _scaleX = 100;
  double _scaleY = 100;
  double _rotation = 0;
  double _positionX = 0;
  double _positionY = 0;

  void _updateTransform() {
    widget.onTransformChanged({
      'scaleX': _scaleX / 100,
      'scaleY': _scaleY / 100,
      'rotation': _rotation,
      'positionX': _positionX,
      'positionY': _positionY,
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('Transform Controls', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 24),
        
        _TransformSlider(
          label: 'Scale X',
          value: _scaleX,
          min: 10,
          max: 200,
          onChanged: (value) => setState(() {
            _scaleX = value;
            _updateTransform();
          }),
        ),
        _TransformSlider(
          label: 'Scale Y',
          value: _scaleY,
          min: 10,
          max: 200,
          onChanged: (value) => setState(() {
            _scaleY = value;
            _updateTransform();
          }),
        ),
        _TransformSlider(
          label: 'Rotation',
          value: _rotation,
          min: -180,
          max: 180,
          onChanged: (value) => setState(() {
            _rotation = value;
            _updateTransform();
          }),
        ),
        _TransformSlider(
          label: 'Position X',
          value: _positionX,
          min: -100,
          max: 100,
          onChanged: (value) => setState(() {
            _positionX = value;
            _updateTransform();
          }),
        ),
        _TransformSlider(
          label: 'Position Y',
          value: _positionY,
          min: -100,
          max: 100,
          onChanged: (value) => setState(() {
            _positionY = value;
            _updateTransform();
          }),
        ),
        
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _scaleX = 100;
              _scaleY = 100;
              _rotation = 0;
              _positionX = 0;
              _positionY = 0;
              _updateTransform();
            });
          },
          child: const Text('Reset Transform'),
        ),
      ],
    );
  }
}

class _TransformSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _TransformSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text('${value.toInt()}', style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
        const SizedBox(height: 8),
      ],
    );
  }
}