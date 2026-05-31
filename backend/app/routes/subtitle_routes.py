"""
Subtitle processing routes
"""

from flask import Blueprint, request, jsonify, current_app
from werkzeug.utils import secure_filename
import os
import uuid
from datetime import datetime

from app.services.storage_service import StorageService
from app.utils.validators import validate_subtitle_file

bp = Blueprint('subtitles', __name__, url_prefix='/api/subtitles')


@bp.route('', methods=['GET'])
def list_subtitles():
    """List all subtitle files"""
    storage = StorageService(current_app.config)
    subtitles = storage.list_files('subtitles')
    return jsonify({
        'subtitles': subtitles,
        'count': len(subtitles)
    })


@bp.route('', methods=['POST'])
def upload_subtitle():
    """Upload a new subtitle file"""
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400
    
    # Validate file
    allowed_extensions = current_app.config.get('ALLOWED_SUBTITLE_EXTENSIONS', set())
    if '.' not in file.filename or \
       file.filename.rsplit('.', 1)[1].lower() not in allowed_extensions:
        return jsonify({'error': 'Invalid file type'}), 400
    
    # Save file
    storage = StorageService(current_app.config)
    filename = secure_filename(file.filename)
    unique_filename = f"{uuid.uuid4().hex}_{filename}"
    file_path = storage.save_file(file, 'subtitles', unique_filename)
    
    # Validate subtitle content
    validation = validate_subtitle_file(file_path)
    
    return jsonify({
        'id': unique_filename,
        'filename': filename,
        'path': file_path,
        'validation': validation,
        'uploaded_at': datetime.now().isoformat()
    }), 201


@bp.route('/<subtitle_id>', methods=['GET'])
def get_subtitle(subtitle_id):
    """Get subtitle file details"""
    storage = StorageService(current_app.config)
    file_path = storage.get_file_path('subtitles', subtitle_id)
    
    if not file_path or not os.path.exists(file_path):
        return jsonify({'error': 'Subtitle not found'}), 404
    
    # Parse subtitle content
    content = storage.read_file('subtitles', subtitle_id)
    
    return jsonify({
        'id': subtitle_id,
        'path': file_path,
        'content': content
    })


@bp.route('/<subtitle_id>', methods=['PUT'])
def update_subtitle(subtitle_id):
    """Update subtitle content"""
    storage = StorageService(current_app.config)
    file_path = storage.get_file_path('subtitles', subtitle_id)
    
    if not file_path or not os.path.exists(file_path):
        return jsonify({'error': 'Subtitle not found'}), 404
    
    data = request.get_json()
    if not data or 'content' not in data:
        return jsonify({'error': 'Content required'}), 400
    
    success = storage.write_file('subtitles', subtitle_id, data['content'])
    
    if success:
        return jsonify({'message': 'Subtitle updated successfully'})
    return jsonify({'error': 'Failed to update subtitle'}), 500


@bp.route('/<subtitle_id>', methods=['DELETE'])
def delete_subtitle(subtitle_id):
    """Delete a subtitle file"""
    storage = StorageService(current_app.config)
    success = storage.delete_file('subtitles', subtitle_id)
    
    if success:
        return jsonify({'message': 'Subtitle deleted successfully'})
    return jsonify({'error': 'Failed to delete subtitle'}), 500


@bp.route('/<subtitle_id>/convert', methods=['POST'])
def convert_subtitle(subtitle_id):
    """Convert subtitle format"""
    storage = StorageService(current_app.config)
    file_path = storage.get_file_path('subtitles', subtitle_id)
    
    if not file_path or not os.path.exists(file_path):
        return jsonify({'error': 'Subtitle not found'}), 404
    
    data = request.get_json()
    target_format = data.get('format', 'srt')
    
    if target_format not in ['srt', 'vtt', 'ass']:
        return jsonify({'error': 'Invalid format'}), 400
    
    from app.services.ffmpeg_service import FFmpegService
    ffmpeg = FFmpegService(current_app.config)
    
    result = ffmpeg.convert_subtitle_format(file_path, target_format)
    
    return jsonify(result)


@bp.route('/parse', methods=['POST'])
def parse_subtitle():
    """Parse subtitle content"""
    data = request.get_json()
    
    if not data or 'content' not in data:
        return jsonify({'error': 'Content required'}), 400
    
    from app.utils.helpers import parse_subtitle_content
    
    parsed = parse_subtitle_content(data['content'])
    
    return jsonify({
        'entries': parsed,
        'count': len(parsed)
    })


@bp.route('/sync', methods=['POST'])
def sync_subtitle():
    """Sync subtitle timing"""
    data = request.get_json()
    
    if not data or 'subtitle_id' not in data:
        return jsonify({'error': 'Subtitle ID required'}), 400
    
    subtitle_id = data['subtitle_id']
    offset = data.get('offset', 0.0)
    scale = data.get('scale', 1.0)
    
    storage = StorageService(current_app.config)
    file_path = storage.get_file_path('subtitles', subtitle_id)
    
    if not file_path or not os.path.exists(file_path):
        return jsonify({'error': 'Subtitle not found'}), 404
    
    from app.utils.helpers import sync_subtitle_timing
    
    result = sync_subtitle_timing(file_path, offset, scale)
    
    return jsonify(result)