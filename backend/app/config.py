"""
Configuration for Burme Editor Backend
"""

import os
from datetime import timedelta


class Config:
    """Base configuration"""
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'burme-editor-secret-key-2026'
    
    # Storage paths
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    STORAGE_PATH = os.environ.get('STORAGE_PATH', os.path.join(BASE_DIR, 'storage'))
    VIDEO_PATH = os.path.join(STORAGE_PATH, 'videos')
    AUDIO_PATH = os.path.join(STORAGE_PATH, 'audio')
    SUBTITLE_PATH = os.path.join(STORAGE_PATH, 'subtitles')
    
    # File size limits
    MAX_CONTENT_LENGTH = 2 * 1024 * 1024 * 1024  # 2GB
    MAX_VIDEO_SIZE = 2 * 1024 * 1024 * 1024  # 2GB
    MAX_AUDIO_SIZE = 100 * 1024 * 1024  # 100MB
    
    # Allowed extensions
    ALLOWED_VIDEO_EXTENSIONS = {'mp4', 'avi', 'mov', 'mkv', 'webm', 'flv', 'wmv'}
    ALLOWED_AUDIO_EXTENSIONS = {'mp3', 'wav', 'aac', 'flac', 'ogg', 'm4a'}
    ALLOWED_SUBTITLE_EXTENSIONS = {'srt', 'vtt', 'ass', 'ssa'}
    
    # FFmpeg settings
    FFMPEG_PATH = os.environ.get('FFMPEG_PATH', 'ffmpeg')
    FFMPEG_THREADS = int(os.environ.get('FFMPEG_THREADS', '4'))
    
    # Redis settings
    REDIS_HOST = os.environ.get('REDIS_HOST', 'localhost')
    REDIS_PORT = int(os.environ.get('REDIS_PORT', 6379))
    REDIS_DB = int(os.environ.get('REDIS_DB', 0))
    
    # Session settings
    PERMANENT_SESSION_LIFETIME = timedelta(hours=24)
    
    # Upload settings
    UPLOAD_FOLDER = STORAGE_PATH
    TEMP_FOLDER = os.path.join(STORAGE_PATH, 'temp')
    
    # Cache settings
    CACHE_TYPE = 'simple'
    CACHE_DEFAULT_TIMEOUT = 300


class DevelopmentConfig(Config):
    """Development configuration"""
    DEBUG = True
    TESTING = False


class ProductionConfig(Config):
    """Production configuration"""
    DEBUG = False
    TESTING = False


class TestingConfig(Config):
    """Testing configuration"""
    DEBUG = True
    TESTING = True
    STORAGE_PATH = '/tmp/burme-test-storage'


config_by_name = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'testing': TestingConfig,
    'default': DevelopmentConfig
}