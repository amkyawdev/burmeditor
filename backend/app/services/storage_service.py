"""
Storage service for file management
"""

import os
import shutil
from typing import Optional, List
from werkzeug.datastructures import FileStorage


class StorageService:
    """Service for file storage operations"""
    
    def __init__(self, config: dict):
        self.base_path = config.get('STORAGE_PATH', './storage')
        self.video_path = config.get('VIDEO_PATH', os.path.join(self.base_path, 'videos'))
        self.audio_path = config.get('AUDIO_PATH', os.path.join(self.base_path, 'audio'))
        self.subtitle_path = config.get('SUBTITLE_PATH', os.path.join(self.base_path, 'subtitles'))
        self.temp_path = config.get('TEMP_FOLDER', os.path.join(self.base_path, 'temp'))
        
        # Ensure directories exist
        self._ensure_directories()
    
    def _ensure_directories(self):
        """Create storage directories if they don't exist"""
        for path in [self.video_path, self.audio_path, self.subtitle_path, self.temp_path]:
            os.makedirs(path, exist_ok=True)
    
    def _get_path(self, storage_type: str) -> str:
        """Get path for storage type"""
        path_map = {
            'videos': self.video_path,
            'audio': self.audio_path,
            'subtitles': self.subtitle_path,
            'temp': self.temp_path
        }
        return path_map.get(storage_type, self.base_path)
    
    def save_file(self, file: FileStorage, storage_type: str, filename: str) -> str:
        """Save uploaded file"""
        storage_path = self._get_path(storage_type)
        file_path = os.path.join(storage_path, filename)
        file.save(file_path)
        return file_path
    
    def get_file_path(self, storage_type: str, filename: str) -> Optional[str]:
        """Get full path for file"""
        storage_path = self._get_path(storage_type)
        file_path = os.path.join(storage_path, filename)
        if os.path.exists(file_path):
            return file_path
        return None
    
    def delete_file(self, storage_type: str, filename: str) -> bool:
        """Delete file"""
        file_path = self.get_file_path(storage_type, filename)
        if file_path:
            try:
                os.remove(file_path)
                return True
            except OSError:
                return False
        return False
    
    def list_files(self, storage_type: str) -> List[dict]:
        """List files in storage type"""
        storage_path = self._get_path(storage_type)
        files = []
        
        if os.path.exists(storage_path):
            for filename in os.listdir(storage_path):
                file_path = os.path.join(storage_path, filename)
                if os.path.isfile(file_path):
                    stat = os.stat(file_path)
                    files.append({
                        'name': filename,
                        'size': stat.st_size,
                        'modified': stat.st_mtime,
                        'path': file_path
                    })
        
        return files
    
    def read_file(self, storage_type: str, filename: str) -> Optional[str]:
        """Read file content"""
        file_path = self.get_file_path(storage_type, filename)
        if file_path:
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    return f.read()
            except UnicodeDecodeError:
                with open(file_path, 'r', encoding='latin-1') as f:
                    return f.read()
        return None
    
    def write_file(self, storage_type: str, filename: str, content: str) -> bool:
        """Write content to file"""
        file_path = self.get_file_path(storage_type, filename)
        if file_path:
            try:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                return True
            except IOError:
                return False
        return False
    
    def get_storage_stats(self) -> dict:
        """Get storage statistics"""
        stats = {
            'videos': {'count': 0, 'size': 0},
            'audio': {'count': 0, 'size': 0},
            'subtitles': {'count': 0, 'size': 0},
            'temp': {'count': 0, 'size': 0}
        }
        
        for storage_type in stats.keys():
            path = self._get_path(storage_type)
            if os.path.exists(path):
                for filename in os.listdir(path):
                    file_path = os.path.join(path, filename)
                    if os.path.isfile(file_path):
                        stats[storage_type]['count'] += 1
                        stats[storage_type]['size'] += os.path.getsize(file_path)
        
        return stats
    
    def cleanup_temp(self) -> int:
        """Clean up temporary files"""
        count = 0
        if os.path.exists(self.temp_path):
            for filename in os.listdir(self.temp_path):
                file_path = os.path.join(self.temp_path, filename)
                if os.path.isfile(file_path):
                    try:
                        os.remove(file_path)
                        count += 1
                    except OSError:
                        pass
        return count