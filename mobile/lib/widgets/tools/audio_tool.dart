import 'package:flutter/material.dart';

class AudioTool extends StatefulWidget {
  final Function(Map<String, dynamic>) onAudioChanged;

  const AudioTool({super.key, required this.onAudioChanged});

  @override
  State<AudioTool> createState() => _AudioToolState();
}

class _AudioToolState extends State<AudioTool> {
  double _volume = 100;
  double _fadeIn = 0;
  double _fadeOut = 0;
  bool _mute = false;

  void _updateAudio() {
    widget.onAudioChanged({
      'volume': _volume / 100,
      'fadeIn': _fadeIn,
      'fadeOut': _fadeOut,
      'mute': _mute,
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('Audio Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 24),
        
        // Mute Toggle
        SwitchListTile(
          title: const Text('Mute Audio'),
          value: _mute,
          onChanged: (value) => setState(() {
            _mute = value;
            _updateAudio();
          }),
        ),
        
        // Volume
        ListTile(
          title: const Text('Volume'),
          subtitle: Slider(
            value: _volume,
            min: 0,
            max: 200,
            divisions: 20,
            label: '${_volume.toInt()}%',
            onChanged: _mute ? null : (value) => setState(() {
              _volume = value;
              _updateAudio();
            }),
          ),
          trailing: Text('${_volume.toInt()}%'),
        ),
        
        // Fade In
        ListTile(
          title: const Text('Fade In'),
          subtitle: Slider(
            value: _fadeIn,
            min: 0,
            max: 10,
            divisions: 10,
            label: '${_fadeIn.toInt()}s',
            onChanged: (value) => setState(() {
              _fadeIn = value;
              _updateAudio();
            }),
          ),
          trailing: Text('${_fadeIn.toInt()}s'),
        ),
        
        // Fade Out
        ListTile(
          title: const Text('Fade Out'),
          subtitle: Slider(
            value: _fadeOut,
            min: 0,
            max: 10,
            divisions: 10,
            label: '${_fadeOut.toInt()}s',
            onChanged: (value) => setState(() {
              _fadeOut = value;
              _updateAudio();
            }),
          ),
          trailing: Text('${_fadeOut.toInt()}s'),
        ),
        
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() {
                  _volume = 100;
                  _fadeIn = 0;
                  _fadeOut = 0;
                  _mute = false;
                  _updateAudio();
                }),
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Apply audio changes
                },
                icon: const Icon(Icons.check),
                label: const Text('Apply'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}