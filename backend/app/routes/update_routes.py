"""
Update checking routes
"""

from flask import Blueprint, request, jsonify, current_app, send_file
import os
import json
from datetime import datetime

bp = Blueprint('update', __name__, url_prefix='/api/update')


@bp.route('/check', methods=['GET'])
def check_update():
    """Check for app updates"""
    current_version = request.args.get('version', '1.0.0')
    
    # Read version.json
    base_dir = current_app.config.get('BASE_DIR', os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
    version_file = os.path.join(base_dir, 'version.json')
    
    if os.path.exists(version_file):
        with open(version_file, 'r') as f:
            version_data = json.load(f)
    else:
        version_data = {
            'version': '1.0.0',
            'build': 1,
            'build_date': '2026-05-31'
        }
    
    # Compare versions
    update_available = False
    latest_version = version_data.get('version', '1.0.0')
    
    if compare_versions(current_version, latest_version) < 0:
        update_available = True
    
    return jsonify({
        'update_available': update_available,
        'current_version': current_version,
        'latest_version': latest_version,
        'build': version_data.get('build', 1),
        'build_date': version_data.get('build_date'),
        'download_url': version_data.get('download_url', ''),
        'changelog': version_data.get('changelog', [])
    })


@bp.route('/latest', methods=['GET'])
def get_latest():
    """Get latest version information"""
    base_dir = current_app.config.get('BASE_DIR', os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
    version_file = os.path.join(base_dir, 'version.json')
    
    if os.path.exists(version_file):
        with open(version_file, 'r') as f:
            version_data = json.load(f)
    else:
        version_data = {
            'version': '1.0.0',
            'build': 1,
            'build_date': '2026-05-31',
            'features': []
        }
    
    return jsonify(version_data)


@bp.route('/version', methods=['GET'])
def get_version():
    """Get current version info"""
    return jsonify({
        'app_name': 'Burme Editor',
        'version': '1.0.0',
        'build': 101,
        'channel': 'stable',
        'timestamp': datetime.now().isoformat()
    })


@bp.route('/changelog', methods=['GET'])
def get_changelog():
    """Get changelog"""
    base_dir = current_app.config.get('BASE_DIR', os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
    version_file = os.path.join(base_dir, 'version.json')
    
    if os.path.exists(version_file):
        with open(version_file, 'r') as f:
            version_data = json.load(f)
        
        return jsonify({
            'version': version_data.get('version', '1.0.0'),
            'changelog': version_data.get('changelog', []),
            'build_date': version_data.get('build_date')
        })
    
    return jsonify({
        'version': '1.0.0',
        'changelog': ['Initial release'],
        'build_date': '2026-05-31'
    })


@bp.route('/download', methods=['GET'])
def download_update():
    """Download latest APK"""
    base_dir = current_app.config.get('BASE_DIR', os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
    apk_path = os.path.join(base_dir, 'storage', 'apks', 'latest.apk')
    
    if os.path.exists(apk_path):
        return send_file(apk_path, as_attachment=True)
    
    return jsonify({'error': 'No update available'}), 404


def compare_versions(v1, v2):
    """
    Compare two version strings.
    Returns:
        -1 if v1 < v2
         0 if v1 == v2
         1 if v1 > v2
    """
    def parse_version(v):
        return [int(x) for x in v.split('.')]
    
    try:
        v1_parts = parse_version(v1)
        v2_parts = parse_version(v2)
        
        # Pad shorter version with zeros
        while len(v1_parts) < len(v2_parts):
            v1_parts.append(0)
        while len(v2_parts) < len(v1_parts):
            v2_parts.append(0)
        
        for p1, p2 in zip(v1_parts, v2_parts):
            if p1 < p2:
                return -1
            elif p1 > p2:
                return 1
        
        return 0
    except Exception:
        return 0