import 'package:flutter/material.dart';

class CropTool extends StatefulWidget {
  final Function(Map<String, double>) onCropChanged;

  const CropTool({super.key, required this.onCropChanged});

  @override
  State<CropTool> createState() => _CropToolState();
}

class _CropToolState extends State<CropTool> {
  double _left = 0;
  double _top = 0;
  double _right = 100;
  double _bottom = 100;

  void _updateCrop() {
    widget.onCropChanged({
      'left': _left,
      'top': _top,
      'right': _right,
      'bottom': _bottom,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Crop Area', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _CropSlider(
          label: 'Left',
          value: _left,
          max: 100 - _right,
          onChanged: (value) => setState(() {
            _left = value;
            _updateCrop();
          }),
        ),
        _CropSlider(
          label: 'Top',
          value: _top,
          max: 100 - _bottom,
          onChanged: (value) => setState(() {
            _top = value;
            _updateCrop();
          }),
        ),
        _CropSlider(
          label: 'Right',
          value: _right,
          max: 100 - _left,
          onChanged: (value) => setState(() {
            _right = value;
            _updateCrop();
          }),
        ),
        _CropSlider(
          label: 'Bottom',
          value: _bottom,
          max: 100 - _top,
          onChanged: (value) => setState(() {
            _bottom = value;
            _updateCrop();
          }),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _left = 0;
              _top = 0;
              _right = 100;
              _bottom = 100;
              _updateCrop();
            });
          },
          child: const Text('Reset'),
        ),
      ],
    );
  }
}

class _CropSlider extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final ValueChanged<double> onChanged;

  const _CropSlider({
    required this.label,
    required this.value,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 60, child: Text(label)),
        Expanded(
          child: Slider(
            value: value,
            min: 0,
            max: max,
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 50, child: Text('${value.toInt()}%')),
      ],
    );
  }
}