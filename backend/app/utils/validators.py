"""
Validation utilities
"""

import os
import re
from typing import Dict, List, Optional


def validate_subtitle_file(file_path: str) -> Dict:
    """Validate subtitle file format and content"""
    result = {
        'valid': False,
        'format': None,
        'entries': 0,
        'errors': []
    }
    
    if not os.path.exists(file_path):
        result['errors'].append('File not found')
        return result
    
    # Check file extension
    ext = os.path.splitext(file_path)[1].lower()
    if ext == '.srt':
        result['format'] = 'srt'
    elif ext == '.vtt':
        result['format'] = 'vtt'
    elif ext in ['.ass', '.ssa']:
        result['format'] = 'ass'
    else:
        result['errors'].append(f'Unknown format: {ext}')
        return result
    
    # Parse and validate content
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        if result['format'] == 'srt':
            is_valid, count = _validate_srt(content)
            result['valid'] = is_valid
            result['entries'] = count
        elif result['format'] == 'vtt':
            is_valid, count = _validate_vtt(content)
            result['valid'] = is_valid
            result['entries'] = count
        else:
            result['valid'] = True
            result['entries'] = content.count('\n\n') + 1
        
        if result['entries'] == 0:
            result['errors'].append('No subtitle entries found')
            result['valid'] = False
    
    except Exception as e:
        result['errors'].append(str(e))
    
    return result


def _validate_srt(content: str) -> tuple:
    """Validate SRT format"""
    # Pattern for SRT entries
    pattern = r'\d+\s*\n\d{2}:\d{2}:\d{2},\d{3}\s*-->\s*\d{2}:\d{2}:\d{2},\d{3}'
    
    matches = re.findall(pattern, content)
    
    # Check for sequence numbers
    numbers = re.findall(r'^\d+$', content, re.MULTILINE)
    
    if len(matches) > 0 and len(numbers) >= len(matches):
        return True, len(matches)
    
    return False, 0


def _validate_vtt(content: str) -> tuple:
    """Validate WebVTT format"""
    if not content.startswith('WEBVTT'):
        return False, 0
    
    # Pattern for VTT cues
    pattern = r'\d{2}:\d{2}:\d{2}\.\d{3}\s*-->\s*\d{2}:\d{2}:\d{2}\.\d{3}'
    
    matches = re.findall(pattern, content)
    
    return True, len(matches)


def validate_video_file(file_path: str, max_size: int = 2 * 1024 * 1024 * 1024) -> Dict:
    """Validate video file"""
    result = {
        'valid': False,
        'errors': []
    }
    
    if not os.path.exists(file_path):
        result['errors'].append('File not found')
        return result
    
    # Check file size
    size = os.path.getsize(file_path)
    if size > max_size:
        result['errors'].append(f'File too large: {size} bytes (max: {max_size})')
        return result
    
    # Check extension
    ext = os.path.splitext(file_path)[1].lower()
    allowed_extensions = {'.mp4', '.avi', '.mov', '.mkv', '.webm', '.flv', '.wmv'}
    
    if ext not in allowed_extensions:
        result['errors'].append(f'Invalid format: {ext}')
        return result
    
    result['valid'] = True
    return result


def validate_audio_file(file_path: str) -> Dict:
    """Validate audio file"""
    result = {
        'valid': False,
        'errors': []
    }
    
    if not os.path.exists(file_path):
        result['errors'].append('File not found')
        return result
    
    # Check extension
    ext = os.path.splitext(file_path)[1].lower()
    allowed_extensions = {'.mp3', '.wav', '.aac', '.flac', '.ogg', '.m4a'}
    
    if ext not in allowed_extensions:
        result['errors'].append(f'Invalid format: {ext}')
        return result
    
    result['valid'] = True
    return result


def validate_time_range(start: float, end: float) -> Optional[str]:
    """Validate time range"""
    if start < 0:
        return 'Start time cannot be negative'
    if end <= start:
        return 'End time must be greater than start time'
    if end - start > 3600:
        return 'Duration cannot exceed 1 hour'
    return None


def validate_resolution(width: int, height: int) -> Optional[str]:
    """Validate video resolution"""
    if width <= 0 or height <= 0:
        return 'Invalid resolution dimensions'
    if width > 7680 or height > 4320:
        return 'Resolution exceeds maximum (8K)'
    if width % 2 != 0 or height % 2 != 0:
        return 'Resolution dimensions must be even'
    return None


def validate_fps(fps: float) -> Optional[str]:
    """Validate frame rate"""
    if fps < 1 or fps > 240:
        return 'Frame rate must be between 1 and 240'
    return None


def sanitize_subtitle_text(text: str) -> str:
    """Sanitize subtitle text"""
    # Remove HTML tags
    text = re.sub(r'<[^>]+>', '', text)
    # Remove control characters
    text = re.sub(r'[\x00-\x08\x0b\x0c\x0e-\x1f]', '', text)
    # Limit line length
    lines = text.split('\n')
    sanitized = []
    for line in lines:
        if len(line) > 80:
            line = line[:80] + '...'
        sanitized.append(line)
    return '\n'.join(sanitized)