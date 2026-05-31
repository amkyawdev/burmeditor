import '../api/update_api.dart';

class UpdateService {
  Future<Map<String, dynamic>> checkForUpdate() async {
    try {
      final result = await UpdateApi.checkForUpdate('1.0.0');
      if (result['success']) {
        // Parse response and return update info
        return {
          'update_available': false,
          'latest_version': '1.0.0',
          'download_url': '',
        };
      }
      return result;
    } catch (e) {
      return {
        'update_available': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> getLatestVersion() async {
    try {
      return await UpdateApi.getLatestVersion();
    } catch (e) {
      return {
        'version': '1.0.0',
        'build': 101,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> getChangelog() async {
    try {
      return await UpdateApi.getChangelog();
    } catch (e) {
      return {
        'changelog': [],
        'error': e.toString(),
      };
    }
  }
}