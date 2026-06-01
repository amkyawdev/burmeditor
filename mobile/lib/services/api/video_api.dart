import 'api_client.dart';

class VideoApi {
  static Future<Map<String, dynamic>> getVideos() async {
    try {
      final response = await ApiClient.get('/api/videos');
      if (response.statusCode == 200) {
        return {'success': true, 'data': response.body};
      }
      return {'success': false, 'error': response.reasonPhrase};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getVideoInfo(String videoId) async {
    try {
      final response = await ApiClient.get('/api/videos/$videoId/info');
      if (response.statusCode == 200) {
        return {'success': true, 'data': response.body};
      }
      return {'success': false, 'error': response.reasonPhrase};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> processVideo(
    String videoId,
    String operation,
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await ApiClient.post(
        '/api/videos/process',
        {
          'video_id': videoId,
          'operation': operation,
          'params': params,
        },
      );
      if (response.statusCode == 200) {
        return {'success': true, 'data': response.body};
      }
      return {'success': false, 'error': response.reasonPhrase};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}