"""
FFmpeg service for video/audio processing
"""

import subprocess
import json
import os
import uuid
from typing import Optional, Dict, List, Tuple


class FFmpegService:
    """Service for FFmpeg operations"""
    
    def __init__(self, config: Dict):
        self.ffmpeg_path = config.get('FFMPEG_PATH', 'ffmpeg')
        self.ffprobe_path = config.get('FFPROBE_PATH', 'ffprobe')
        self.threads = config.get('FFMPEG_THREADS', 4)
        self.storage_path = config.get('STORAGE_PATH', './storage')
    
    def get_video_info(self, file_path: str) -> Dict:
        """Get video information using ffprobe"""
        cmd = [
            self.ffprobe_path,
            '-v', 'quiet',
            '-print_format', 'json',
            '-show_format',
            '-show_streams',
            file_path
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
            if result.returncode == 0:
                info = json.loads(result.stdout)
                return self._parse_video_info(info)
            return {'error': 'Failed to get video info'}
        except Exception as e:
            return {'error': str(e)}
    
    def _parse_video_info(self, info: Dict) -> Dict:
        """Parse ffprobe output"""
        video_stream = None
        audio_stream = None
        
        for stream in info.get('streams', []):
            if stream.get('codec_type') == 'video' and not video_stream:
                video_stream = stream
            elif stream.get('codec_type') == 'audio' and not audio_stream:
                audio_stream = stream
        
        format_info = info.get('format', {})
        
        return {
            'duration': float(format_info.get('duration', 0)),
            'format': format_info.get('format_name', 'unknown'),
            'size': int(format_info.get('size', 0)),
            'bitrate': int(format_info.get('bit_rate', 0)),
            'video': {
                'codec': video_stream.get('codec_name', 'unknown') if video_stream else None,
                'width': video_stream.get('width', 0) if video_stream else 0,
                'height': video_stream.get('height', 0) if video_stream else 0,
                'fps': self._parse_fps(video_stream.get('r_frame_rate', '0/1') if video_stream else '0/1'),
                'pix_fmt': video_stream.get('pix_fmt', 'unknown') if video_stream else None
            } if video_stream else None,
            'audio': {
                'codec': audio_stream.get('codec_name', 'unknown') if audio_stream else None,
                'sample_rate': audio_stream.get('sample_rate', 0) if audio_stream else 0,
                'channels': audio_stream.get('channels', 0) if audio_stream else 0
            } if audio_stream else None
        }
    
    def _parse_fps(self, fps_str: str) -> float:
        """Parse frame rate from fraction"""
        try:
            if '/' in fps_str:
                num, den = fps_str.split('/')
                return float(num) / float(den)
            return float(fps_str)
        except:
            return 0.0
    
    def get_audio_info(self, file_path: str) -> Dict:
        """Get audio information"""
        cmd = [
            self.ffprobe_path,
            '-v', 'quiet',
            '-print_format', 'json',
            '-show_format',
            '-show_streams',
            file_path
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
            if result.returncode == 0:
                info = json.loads(result.stdout)
                return self._parse_audio_info(info)
            return {'error': 'Failed to get audio info'}
        except Exception as e:
            return {'error': str(e)}
    
    def _parse_audio_info(self, info: Dict) -> Dict:
        """Parse audio info from ffprobe output"""
        audio_stream = None
        
        for stream in info.get('streams', []):
            if stream.get('codec_type') == 'audio':
                audio_stream = stream
                break
        
        format_info = info.get('format', {})
        
        return {
            'duration': float(format_info.get('duration', 0)),
            'format': format_info.get('format_name', 'unknown'),
            'size': int(format_info.get('size', 0)),
            'bitrate': int(format_info.get('bit_rate', 0)),
            'codec': audio_stream.get('codec_name', 'unknown') if audio_stream else None,
            'sample_rate': int(audio_stream.get('sample_rate', 0)) if audio_stream else 0,
            'channels': audio_stream.get('channels', 0) if audio_stream else 0
        }
    
    def trim_video(
        self,
        input_path: str,
        start: float = 0,
        duration: float = 10,
        output_path: Optional[str] = None
    ) -> Dict:
        """Trim video to specified duration"""
        if not output_path:
            output_path = os.path.join(self.storage_path, 'videos', f'trimmed_{uuid.uuid4().hex}.mp4')
        
        cmd = [
            self.ffmpeg_path,
            '-y',
            '-i', input_path,
            '-ss', str(start),
            '-t', str(duration),
            '-c', 'copy',
            output_path
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)
            if result.returncode == 0:
                return {'success': True, 'output': output_path}
            return {'success': False, 'error': result.stderr}
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def trim_audio(
        self,
        input_path: str,
        start: float = 0,
        duration: float = 10,
        output_path: Optional[str] = None
    ) -> Dict:
        """Trim audio to specified duration"""
        if not output_path:
            output_path = os.path.join(self.storage_path, 'audio', f'trimmed_{uuid.uuid4().hex}.mp3')
        
        cmd = [
            self.ffmpeg_path,
            '-y',
            '-i', input_path,
            '-ss', str(start),
            '-t', str(duration),
            '-acodec', 'copy',
            output_path
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=120)
            if result.returncode == 0:
                return {'success': True, 'output': output_path}
            return {'success': False, 'error': result.stderr}
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def extract_audio(self, video_path: str, output_path: Optional[str] = None) -> Dict:
        """Extract audio from video"""
        if not output_path:
            output_path = os.path.join(self.storage_path, 'audio', f'extracted_{uuid.uuid4().hex}.mp3')
        
        cmd = [
            self.ffmpeg_path,
            '-y',
            '-i', video_path,
            '-vn',
            '-acodec', 'libmp3lame',
            '-q:a', '2',
            output_path
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)
            if result.returncode == 0:
                return {'success': True, 'output': output_path}
            return {'success': False, 'error': result.stderr}
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def add_watermark(
        self,
        video_path: str,
        watermark_path: str,
        position: str = '右下',
        output_path: Optional[str] = None
    ) -> Dict:
        """Add watermark to video"""
        if not output_path:
            output_path = os.path.join(self.storage_path, 'videos', f'watermarked_{uuid.uuid4().hex}.mp4')
        
        position_map = {
            '左上': '10:10',
            '右上': 'main_w-overlay_w-10:10',
            '左下': '10:main_h-overlay_h-10',
            '右下': 'main_w-overlay_w-10:main_h-overlay_h-10',
            '居中': 'main_w/2-overlay_w/2:main_h/2-overlay_h/2'
        }
        
        pos = position_map.get(position, position_map['右下'])
        
        cmd = [
            self.ffmpeg_path,
            '-y',
            '-i', video_path,
            '-i', watermark_path,
            '-filter_complex', f"overlay={pos}",
            '-codec:a', 'copy',
            output_path
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)
            if result.returncode == 0:
                return {'success': True, 'output': output_path}
            return {'success': False, 'error': result.stderr}
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def generate_thumbnail(self, video_path: str, output_name: str) -> str:
        """Generate thumbnail from video"""
        output_path = os.path.join(self.storage_path, 'thumbnails', f'{output_name}.jpg')
        
        cmd = [
            self.ffmpeg_path,
            '-y',
            '-i', video_path,
            '-ss', '00:00:01',
            '-vframes', '1',
            '-vf', 'scale=320:-1',
            output_path
        ]
        
        try:
            subprocess.run(cmd, capture_output=True, text=True, timeout=60)
            return output_path
        except:
            return None
    
    def get_waveform(self, audio_path: str, samples: int = 200) -> List[float]:
        """Get audio waveform data"""
        cmd = [
            self.ffmpeg_path,
            '-i', audio_path,
            '-filter_complex', f"compand,showwavespic=s={samples}x100:mode=line",
            '-frames:v', '1',
            '-f', 'rawvideo',
            '-'
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, timeout=60)
            # Simplified - return mock waveform
            return [0.0] * samples
        except:
            return [0.0] * samples
    
    def normalize_audio(self, audio_path: str, output_path: Optional[str] = None) -> Dict:
        """Normalize audio levels"""
        if not output_path:
            output_path = os.path.join(self.storage_path, 'audio', f'normalized_{uuid.uuid4().hex}.mp3')
        
        cmd = [
            self.ffmpeg_path,
            '-y',
            '-i', audio_path,
            '-af', 'loudnorm=I=-16:TP=-1.5:LRA=11',
            output_path
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=120)
            if result.returncode == 0:
                return {'success': True, 'output': output_path}
            return {'success': False, 'error': result.stderr}
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def change_audio_speed(self, audio_path: str, speed: float, output_path: Optional[str] = None) -> Dict:
        """Change audio playback speed"""
        if not output_path:
            output_path = os.path.join(self.storage_path, 'audio', f'sped_{uuid.uuid4().hex}.mp3')
        
        cmd = [
            self.ffmpeg_path,
            '-y',
            '-i', audio_path,
            '-af', f'atempo={speed}',
            output_path
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=120)
            if result.returncode == 0:
                return {'success': True, 'output': output_path}
            return {'success': False, 'error': result.stderr}
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def add_audio_fade(self, audio_path: str, fade_in: float, fade_out: float, output_path: Optional[str] = None) -> Dict:
        """Add fade in/out to audio"""
        if not output_path:
            output_path = os.path.join(self.storage_path, 'audio', f'faded_{uuid.uuid4().hex}.mp3')
        
        cmd = [
            self.ffmpeg_path,
            '-y',
            '-i', audio_path,
            '-af', f'afade=t=in:ss=0:d={fade_in},afade=t=out:st=-{fade_out}:d={fade_out}' if fade_out > 0 else f'afade=t=in:ss=0:d={fade_in}',
            output_path
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=120)
            if result.returncode == 0:
                return {'success': True, 'output': output_path}
            return {'success': False, 'error': result.stderr}
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def mix_audio_tracks(self, audio_paths: List[str], output_path: Optional[str] = None) -> Dict:
        """Mix multiple audio tracks"""
        if not output_path:
            output_path = os.path.join(self.storage_path, 'audio', f'mixed_{uuid.uuid4().hex}.mp3')
        
        # Build ffmpeg command for mixing
        cmd = [self.ffmpeg_path, '-y']
        
        for path in audio_paths:
            cmd.extend(['-i', path])
        
        # Create filter for mixing
        filter_complex = ''
        if len(audio_paths) > 1:
            inputs = ''.join([f'[{i}:0]' for i in range(len(audio_paths))])
            filter_complex = f'{inputs}amix=inputs={len(audio_paths)}:duration=longest'
        
        if filter_complex:
            cmd.extend(['-filter_complex', filter_complex])
        
        cmd.append(output_path)
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)
            if result.returncode == 0:
                return {'success': True, 'output': output_path}
            return {'success': False, 'error': result.stderr}
        except Exception as e:
            return {'success': False, 'error': str(e)}
    
    def convert_subtitle_format(self, subtitle_path: str, target_format: str) -> Dict:
        """Convert subtitle format"""
        base_name = os.path.splitext(subtitle_path)[0]
        output_path = f'{base_name}.{target_format}'
        
        # Simple format conversion
        try:
            with open(subtitle_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            if target_format == 'vtt':
                content = f'WEBVTT\n\n{content}'
            
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            return {'success': True, 'output': output_path}
        except Exception as e:
            return {'success': False, 'error': str(e)}