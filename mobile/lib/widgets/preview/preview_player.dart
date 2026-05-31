import 'package:flutter/material.dart';

class PreviewPlayer extends StatelessWidget {
  final bool isPlaying;
  final double currentPosition;
  final double duration;
  final VoidCallback onPlayPause;
  final ValueChanged<double> onSeek;

  const PreviewPlayer({
    super.key,
    required this.isPlaying,
    required this.currentPosition,
    required this.duration,
    required this.onPlayPause,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video preview placeholder
          const Center(
            child: Icon(
              Icons.videocam,
              size: 80,
              color: Colors.white24,
            ),
          ),
          
          // Play/Pause overlay
          Center(
            child: GestureDetector(
              onTap: onPlayPause,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Text(
                    _formatTime(currentPosition),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Expanded(
                    child: Slider(
                      value: currentPosition.clamp(0, duration > 0 ? duration : 1),
                      min: 0,
                      max: duration > 0 ? duration : 1,
                      onChanged: onSeek,
                      activeColor: Theme.of(context).primaryColor,
                      inactiveColor: Colors.white24,
                    ),
                  ),
                  Text(
                    _formatTime(duration),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    final minutes = duration.inMinutes;
    final secs = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}