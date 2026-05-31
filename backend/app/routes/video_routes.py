"""
Video processing routes
"""

from flask import Blueprint, request, jsonify, current_app
from werkzeug.utils import secure_filename
import os
import uuid
from datetime import datetime

from app.services.ffmpeg_service import FFmpegService
from app.services.storage_service import StorageService

bp = Blueprint('videos', __name__, url_prefix='/api/videos')


@bp.route('', methods=['GET'])
def list_videos():
    """List all videos"""
    storage = StorageService(current_app.config)
    videos = storage.list_files('videos')
    return jsonify({
        'videos': videos,
        'count': len(videos)
    })


@bp.route('', methods=['POST'])
def upload_video():
    """Upload a new video"""
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400
    
    # Validate file
    allowed_extensions = current_app.config.get('ALLOWED_VIDEO_EXTENSIONS', set())
    if '.' not in file.filename or \
       file.filename.rsplit('.', 1)[1].lower() not in allowed_extensions:
        return jsonify({'error': 'Invalid file type'}), 400
    
    # Save file
    storage = StorageService(current_app.config)
    filename = secure_filename(file.filename)
    unique_filename = f"{uuid.uuid4().hex}_{filename}"
    file_path = storage.save_file(file, 'videos', unique_filename)
    
    # Get video info
    ffmpeg = FFmpegService(current_app.config)
    info = ffmpeg.get_video_info(file_path)
    
    return jsonify({
        'id': unique_filename,
        'filename': filename,
        'path': file_path,
        'info': info,
        'uploaded_at': datetime.now().isoformat()
    }), 201


@bp.route('/<video_id>', methods=['GET'])
def get_video(video_id):
    """Get video details"""
    storage = StorageService(current_app.config)
    file_path = storage.get_file_path('videos', video_id)
    
    if not file_path or not os.path.exists(file_path):
        return jsonify({'error': 'Video not found'}), 404
    
    ffmpeg = FFmpegService(current_app.config)
    info = ffmpeg.get_video_info(file_path)
    
    return jsonify({
        'id': video_id,
        'path': file_path,
        'info': info
    })


@bp.route('/<video_id>', methods=['DELETE'])
def delete_video(video_id):
    """Delete a video"""
    storage = StorageService(current_app.config)
    success = storage.delete_file('videos', video_id)
    
    if success:
        return jsonify({'message': 'Video deleted successfully'})
    return jsonify({'error': 'Failed to delete video'}), 500


@bp.route('/<video_id>/info', methods=['GET'])
def video_info(video_id):
    """Get detailed video information"""
    storage = StorageService(current_app.config)
    file_path = storage.get_file_path('videos', video_id)
    
    if not file_path or not os.path.exists(file_path):
        return jsonify({'error': 'Video not found'}), 404
    
    ffmpeg = FFmpegService(current_app.config)
    info = ffmpeg.get_video_info(file_path)
    
    return jsonify(info)


@bp.route('/<video_id>/thumbnail', methods=['GET'])
def generate_thumbnail(video_id):
    """Generate thumbnail for video"""
    storage = StorageService(current_app.config)
    file_path = storage.get_file_path('videos', video_id)
    
    if not file_path or not os.path.exists(file_path):
        return jsonify({'error': 'Video not found'}), 404
    
    ffmpeg = FFmpegService(current_app.config)
    thumbnail_path = ffmpeg.generate_thumbnail(file_path, video_id)
    
    return jsonify({
        'thumbnail': thumbnail_path
    })


@bp.route('/process', methods=['POST'])
def process_video():
    """Process video with FFmpeg"""
    data = request.get_json()
    
    if not data or 'video_id' not in data:
        return jsonify({'error': 'Video ID required'}), 400
    
    video_id = data['video_id']
    operation = data.get('operation', 'info')
    params = data.get('params', {})
    
    storage = StorageService(current_app.config)
    file_path = storage.get_file_path('videos', video_id)
    
    if not file_path or not os.path.exists(file_path):
        return jsonify({'error': 'Video not found'}), 404
    
    ffmpeg = FFmpegService(current_app.config)
    
    if operation == 'trim':
        result = ffmpeg.trim_video(
            file_path,
            params.get('start', 0),
            params.get('duration', 10),
            params.get('output', None)
        )
    elif operation == 'extract_audio':
        result = ffmpeg.extract_audio(file_path, params.get('output', None))
    elif operation == 'add_watermark':
        result = ffmpeg.add_watermark(
            file_path,
            params.get('watermark_path'),
            params.get('position', '右下'),
            params.get('output', None)
        )
    else:
        return jsonify({'error': 'Invalid operation'}), 400
    
    return jsonify(result)