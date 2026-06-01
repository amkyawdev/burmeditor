import 'api_client.dart';

class UpdateApi {
  static Future<Map<String, dynamic>> checkForUpdate(String currentVersion) async {
    try {
      final response = await ApiClient.get('/api/update/check?version=$currentVersion');
      if (response.statusCode == 200) {
        return {'success': true, 'data': response.body};
      }
      return {'success': false, 'error': response.reasonPhrase};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getLatestVersion() async {
    try {
      final response = await ApiClient.get('/api/update/latest');
      if (response.statusCode == 200) {
        return {'success': true, 'data': response.body};
      }
      return {'success': false, 'error': response.reasonPhrase};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getChangelog() async {
    try {
      final response = await ApiClient.get('/api/update/changelog');
      if (response.statusCode == 200) {
        return {'success': true, 'data': response.body};
      }
      return {'success': false, 'error': response.reasonPhrase};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}