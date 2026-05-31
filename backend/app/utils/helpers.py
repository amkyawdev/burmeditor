"""
Helper utilities
"""

import re
from typing import List, Dict, Tuple


def parse_subtitle_content(content: str) -> List[Dict]:
    """Parse subtitle content and extract entries"""
    entries = []
    
    # SRT format parsing
    pattern = r'(\d+)\s*\n(\d{2}:\d{2}:\d{2},\d{3})\s*-->\s*(\d{2}:\d{2}:\d{2},\d{3})\s*\n([\s\S]*?)(?=\n\n\d+\s*\n|\Z)'
    
    matches = re.findall(pattern, content)
    
    for match in matches:
        index = int(match[0])
        start_time = _parse_time(match[1])
        end_time = _parse_time(match[2])
        text = match[3].strip()
        
        entries.append({
            'index': index,
            'start': start_time,
            'end': end_time,
            'text': text
        })
    
    return entries


def _parse_time(time_str: str) -> float:
    """Parse time string to seconds"""
    # Format: HH:MM:SS,mmm
    time_str = time_str.replace(',', '.')
    parts = time_str.split(':')
    
    if len(parts) == 3:
        hours = int(parts[0])
        minutes = int(parts[1])
        seconds = float(parts[2])
        return hours * 3600 + minutes * 60 + seconds
    return 0.0


def format_time(seconds: float) -> str:
    """Format seconds to time string"""
    hours = int(seconds // 3600)
    minutes = int((seconds % 3600) // 60)
    secs = seconds % 60
    
    return f'{hours:02d}:{minutes:02d}:{secs:06.3f}'


def sync_subtitle_timing(file_path: str, offset: float = 0.0, scale: float = 1.0) -> Dict:
    """Sync subtitle timing by offset and scale"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Parse and adjust timing
        def adjust_time(match):
            time_str = match.group(0)
            time_val = _parse_time(time_str)
            if scale != 1.0:
                time_val = time_val * scale
            time_val = max(0, time_val + offset)
            return format_time(time_val)
        
        # Pattern for time codes
        pattern = r'\d{2}:\d{2}:\d{2},\d{3}'
        
        new_content = re.sub(pattern, adjust_time, content)
        
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        
        return {'success': True, 'message': 'Subtitle timing synchronized'}
    except Exception as e:
        return {'success': False, 'error': str(e)}


def get_file_extension(filename: str) -> str:
    """Get file extension without dot"""
    if '.' in filename:
        return filename.rsplit('.', 1)[1].lower()
    return ''


def sanitize_filename(filename: str) -> str:
    """Sanitize filename by removing invalid characters"""
    invalid_chars = '<>:"/\\|?*'
    for char in invalid_chars:
        filename = filename.replace(char, '_')
    return filename


def format_file_size(size_bytes: int) -> str:
    """Format file size to human readable string"""
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if size_bytes < 1024.0:
            return f'{size_bytes:.2f} {unit}'
        size_bytes /= 1024.0
    return f'{size_bytes:.2f} PB'


def generate_unique_id() -> str:
    """Generate unique identifier"""
    import uuid
    return uuid.uuid4().hex[:16]