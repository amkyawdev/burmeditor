"""
Audio processing routes
"""

from flask import Blueprint, request, jsonify, current_app
from werkzeug.utils import secure_filename
import os
import uuid
from datetime import datetime

from app.services.ffmpeg_service import FFmpegService
from app.services.storage_service import StorageService

bp = Blueprint('audio', __name__, url_prefix='/api/audio')


@bp.route('', methods=['GET'])
def list_audio():
    """List all audio files"""
    storage = StorageService(current_app.config)
    audio_files = storage.list_files('audio')
    return jsonify({
        'audio': audio_files,
        'count': len(audio_files)
    })


@bp.route('', methods=['POST'])
def upload_audio():
    """Upload a new audio file"""
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400
    
    # Validate file
    allowed_extensions = current_app.config.get('ALLOWED_AUDIO_EXTENSIONS', set())
    if '.' not in file.filename or \
       file.filename.rsplit('.', 1)[1].lower() not in allowed_extensions:
        return jsonify({'error': 'Invalid file type'}), 400
    
    # Save file
    storage = StorageService(current_app.config)
    filename = secure_filename(file.filename)
    unique_filename = f"{uuid.uuid4().hex}_{filename}"
    file_path = storage.save_file(file, 'audio', unique_filename)
    
    # Get audio info
    ffmpeg = FFmpegService(current_app.config)
    info = ffmpeg.get_audio_info(file_path)
    
    return jsonify({
        'id': unique_filename,
        'filename': filename,
        'path': file_path,
        'info': info,
        'uploaded_at': datetime.now().isoformat()
    }), 201


@bp.route('/<audio_id>', methods=['GET'])
def get_audio(audio_id):
    """Get audio file details"""
    storage = StorageService(current_app.config)
    file_path = storage.get_file_path('audio', audio_id)
    
    if not file_path or not os.path.exists(file_path):
        return jsonify({'error': 'Audio not found'}), 404
    
    ffmpeg = FFmpegService(current_app.config)
    info = ffmpeg.get_audio_info(file_path)
    
    return jsonify({
        'id': audio_id,
        'path': file_path,
        'info': info
    })


@bp.route('/<audio_id>', methods=['DELETE'])
def delete_audio(audio_id):
    """Delete an audio file"""
    storage = StorageService(current_app.config)
    success = storage.delete_file('audio', audio_id)
    
    if success:
        return jsonify({'message': 'Audio deleted successfully'})
    return jsonify({'error': 'Failed to delete audio'}), 500


@bp.route('/<audio_id>/waveform', methods=['GET'])
def get_waveform(audio_id):
    """Get audio waveform data"""
    storage = StorageService(current_app.config)
    file_path = storage.get_file_path('audio', audio_id)
    
    if not file_path or not os.path.exists(file_path):
        return jsonify({'error': 'Audio not found'}), 404
    
    ffmpeg = FFmpegService(current_app.config)
    waveform = ffmpeg.get_waveform(file_path)
    
    return jsonify({
        'waveform': waveform
    })


@bp.route('/process', methods=['POST'])
def process_audio():
    """Process audio with FFmpeg"""
    data = request.get_json()
    
    if not data or 'audio_id' not in data:
        return jsonify({'error': 'Audio ID required'}), 400
    
    audio_id = data['audio_id']
    operation = data.get('operation', 'info')
    params = data.get('params', {})
    
    storage = StorageService(current_app.config)
    file_path = storage.get_file_path('audio', audio_id)
    
    if not file_path or not os.path.exists(file_path):
        return jsonify({'error': 'Audio not found'}), 404
    
    ffmpeg = FFmpegService(current_app.config)
    
    if operation == 'trim':
        result = ffmpeg.trim_audio(
            file_path,
            params.get('start', 0),
            params.get('duration', 10),
            params.get('output', None)
        )
    elif operation == 'normalize':
        result = ffmpeg.normalize_audio(file_path, params.get('output', None))
    elif operation == 'change_speed':
        result = ffmpeg.change_audio_speed(
            file_path,
            params.get('speed', 1.0),
            params.get('output', None)
        )
    elif operation == 'add_fade':
        result = ffmpeg.add_audio_fade(
            file_path,
            params.get('fade_in', 0),
            params.get('fade_out', 0),
            params.get('output', None)
        )
    else:
        return jsonify({'error': 'Invalid operation'}), 400
    
    return jsonify(result)


@bp.route('/mix', methods=['POST'])
def mix_audio():
    """Mix multiple audio tracks"""
    data = request.get_json()
    
    if not data or 'audio_ids' not in data:
        return jsonify({'error': 'Audio IDs required'}), 400
    
    audio_ids = data['audio_ids']
    params = data.get('params', {})
    
    storage = StorageService(current_app.config)
    file_paths = []
    
    for audio_id in audio_ids:
        file_path = storage.get_file_path('audio', audio_id)
        if file_path and os.path.exists(file_path):
            file_paths.append(file_path)
    
    if not file_paths:
        return jsonify({'error': 'No valid audio files found'}), 404
    
    ffmpeg = FFmpegService(current_app.config)
    result = ffmpeg.mix_audio_tracks(file_paths, params.get('output', None))
    
    return jsonify(result)