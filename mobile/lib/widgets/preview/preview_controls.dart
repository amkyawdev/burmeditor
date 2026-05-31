import 'package:flutter/material.dart';

class PreviewControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onSkipBack;
  final VoidCallback onSkipForward;
  final VoidCallback onNextFrame;
  final VoidCallback onPreviousFrame;
  final double playbackSpeed;

  const PreviewControls({
    super.key,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onSkipBack,
    required this.onSkipForward,
    required this.onNextFrame,
    required this.onPreviousFrame,
    required this.playbackSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Skip back
          IconButton(
            icon: const Icon(Icons.replay_10),
            color: Colors.white,
            onPressed: onSkipBack,
          ),
          
          // Previous frame
          IconButton(
            icon: const Icon(Icons.skip_previous),
            color: Colors.white70,
            onPressed: onPreviousFrame,
          ),
          
          // Play/Pause
          IconButton(
            icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
            color: Colors.white,
            iconSize: 48,
            onPressed: onPlayPause,
          ),
          
          // Next frame
          IconButton(
            icon: const Icon(Icons.skip_next),
            color: Colors.white70,
            onPressed: onNextFrame,
          ),
          
          // Skip forward
          IconButton(
            icon: const Icon(Icons.forward_10),
            color: Colors.white,
            onPressed: onSkipForward,
          ),
          
          const SizedBox(width: 16),
          
          // Playback speed
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${playbackSpeed}x',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}