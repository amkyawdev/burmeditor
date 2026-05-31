import '../../models/project.dart';
import 'storage_service.dart';
import 'cache_service.dart';

class ProjectService {
  static final ProjectService _instance = ProjectService._internal();
  static ProjectService get instance => _instance;

  ProjectService._internal();

  static const String _recentProjectsKey = 'recent_projects';
  static const String _projectsCacheKey = 'projects_cache';

  Future<List<Project>> getRecentProjects() async {
    try {
      // Try to get from cache first
      final cached = CacheService.instance.get(_recentProjectsKey);
      if (cached != null) {
        final List<dynamic> jsonList = cached as List<dynamic>;
        return jsonList.map((json) => Project.fromJson(json)).toList();
      }

      // Get from storage
      final stored = StorageService.instance.getStringList(_recentProjectsKey);
      if (stored != null && stored.isNotEmpty) {
        // For now, return empty list as we don't have actual project files
        return [];
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Project?> createProject(String name) async {
    try {
      final project = Project(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to cache
      final projects = await getRecentProjects();
      projects.insert(0, project);
      
      // Keep only last 20 projects
      if (projects.length > 20) {
        projects.removeRange(20, projects.length);
      }

      // Save to storage
      await CacheService.instance.set(
        _recentProjectsKey,
        projects.map((p) => p.toJson()).toList(),
      );

      return project;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      final projects = await getRecentProjects();
      projects.removeWhere((p) => p.id == projectId);
      
      await CacheService.instance.set(
        _recentProjectsKey,
        projects.map((p) => p.toJson()).toList(),
      );
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateProject(Project project) async {
    try {
      final projects = await getRecentProjects();
      final index = projects.indexWhere((p) => p.id == project.id);
      
      if (index >= 0) {
        project.updatedAt = DateTime.now();
        projects[index] = project;
        
        await CacheService.instance.set(
          _recentProjectsKey,
          projects.map((p) => p.toJson()).toList(),
        );
      }
    } catch (e) {
      // Handle error
    }
  }
}