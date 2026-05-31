"""
Burme Editor Backend API
Professional Video Editor with FFmpeg Integration
"""

from flask import Flask, jsonify, request
from flask_cors import CORS
import os

from app.config import Config
from app.routes import video_routes, audio_routes, subtitle_routes, update_routes

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)
    
    # Enable CORS
    CORS(app, resources={r"/api/*": {"origins": "*"}})
    
    # Initialize routes
    app.register_blueprint(video_routes.bp)
    app.register_blueprint(audio_routes.bp)
    app.register_blueprint(subtitle_routes.bp)
    app.register_blueprint(update_routes.bp)
    
    # Health check endpoint
    @app.route('/health')
    def health():
        return jsonify({
            'status': 'healthy',
            'version': '1.0.0',
            'service': 'Burme Editor API'
        })
    
    # API info endpoint
    @app.route('/api')
    def api_info():
        return jsonify({
            'name': 'Burme Editor API',
            'version': '1.0.0',
            'description': 'Professional Video Editor Backend',
            'endpoints': {
                'videos': '/api/videos',
                'audio': '/api/audio',
                'subtitles': '/api/subtitles',
                'update': '/api/update'
            }
        })
    
    # Error handlers
    @app.errorhandler(404)
    def not_found(error):
        return jsonify({'error': 'Not found'}), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        return jsonify({'error': 'Internal server error'}), 500
    
    return app

app = create_app()

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)