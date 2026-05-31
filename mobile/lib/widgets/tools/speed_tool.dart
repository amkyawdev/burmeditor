import 'package:flutter/material.dart';

class SpeedTool extends StatefulWidget {
  final Function(Map<String, dynamic>) onSpeedChanged;

  const SpeedTool({super.key, required this.onSpeedChanged});

  @override
  State<SpeedTool> createState() => _SpeedToolState();
}

class _SpeedToolState extends State<SpeedTool> {
  double _speed = 1.0;
  bool _maintainPitch = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('Speed Control', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 24),
        
        Center(
          child: Text(
            '${_speed.toStringAsFixed(2)}x',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            _getSpeedLabel(),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ),
        
        const SizedBox(height: 24),
        Slider(
          value: _speed,
          min: 0.25,
          max: 4.0,
          divisions: 15,
          label: '${_speed.toStringAsFixed(2)}x',
          onChanged: (value) => setState(() {
            _speed = value;
            _updateSpeed();
          }),
        ),
        
        const SizedBox(height: 24),
        const Text('Presets', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _SpeedPreset(label: '0.25x', onTap: () => _setSpeed(0.25)),
            _SpeedPreset(label: '0.5x', onTap: () => _setSpeed(0.5)),
            _SpeedPreset(label: '0.75x', onTap: () => _setSpeed(0.75)),
            _SpeedPreset(label: '1x', onTap: () => _setSpeed(1.0)),
            _SpeedPreset(label: '1.5x', onTap: () => _setSpeed(1.5)),
            _SpeedPreset(label: '2x', onTap: () => _setSpeed(2.0)),
            _SpeedPreset(label: '4x', onTap: () => _setSpeed(4.0)),
          ],
        ),
        
        const SizedBox(height: 24),
        SwitchListTile(
          title: const Text('Maintain Pitch'),
          subtitle: const Text('Keep audio pitch when changing speed'),
          value: _maintainPitch,
          onChanged: (value) => setState(() {
            _maintainPitch = value;
            _updateSpeed();
          }),
        ),
        
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _setSpeed(1.0),
                child: const Text('Reset'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getSpeedLabel() {
    if (_speed < 0.5) return 'Very Slow';
    if (_speed < 0.75) return 'Slow';
    if (_speed < 1.25) return 'Normal';
    if (_speed < 1.75) return 'Fast';
    if (_speed < 2.5) return 'Very Fast';
    return 'Ultra Fast';
  }

  void _setSpeed(double speed) {
    setState(() {
      _speed = speed;
      _updateSpeed();
    });
  }

  void _updateSpeed() {
    widget.onSpeedChanged({
      'speed': _speed,
      'maintainPitch': _maintainPitch,
    });
  }
}

class _SpeedPreset extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SpeedPreset({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
    );
  }
}