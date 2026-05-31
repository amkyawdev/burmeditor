import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../models/project.dart';
import '../../services/local/storage_service.dart';
import '../../services/local/project_service.dart';
import '../../widgets/common/hamburger_menu.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/loading_widget.dart';

final homeControllerProvider = ChangeNotifierProvider((ref) => HomeController());

class HomeController extends ChangeNotifier {
  bool _isLoading = true;
  List<Project> _recentProjects = [];
  String _error = '';

  bool get isLoading => _isLoading;
  List<Project> get recentProjects => _recentProjects;
  String get error => _error;

  Future<void> loadProjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      _recentProjects = await ProjectService.instance.getRecentProjects();
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createNewProject() async {
    final project = await ProjectService.instance.createProject('Untitled Project');
    if (project != null) {
      _recentProjects.insert(0, project);
      notifyListeners();
    }
  }

  Future<void> deleteProject(String projectId) async {
    await ProjectService.instance.deleteProject(projectId);
    _recentProjects.removeWhere((p) => p.id == projectId);
    notifyListeners();
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeControllerProvider.notifier).loadProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(homeControllerProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Burme Editor',
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      drawer: const HamburgerMenu(),
      body: RefreshIndicator(
        onRefresh: () => controller.loadProjects(),
        child: CustomScrollView(
          slivers: [
            // Welcome Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create and edit your videos with ease',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quick Actions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.add_rounded,
                        title: 'New Project',
                        color: AppTheme.primaryColor,
                        onTap: () async {
                          await controller.createNewProject();
                          if (mounted) {
                            Navigator.pushNamed(
                              context,
                              Routes.editor,
                              arguments: {'projectId': controller.recentProjects.first.id},
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.folder_open_rounded,
                        title: 'Open File',
                        color: AppTheme.secondaryColor,
                        onTap: () {
                          // TODO: Implement file picker
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Recent Projects Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Projects',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (controller.recentProjects.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to all projects
                        },
                        child: const Text('See All'),
                      ),
                  ],
                ),
              ),
            ),

            // Recent Projects List
            if (controller.isLoading)
              const SliverFillRemaining(
                child: Center(child: LoadingWidget()),
              )
            else if (controller.recentProjects.isEmpty)
              SliverFillRemaining(
                child: _EmptyProjectsView(
                  onCreateProject: () => controller.createNewProject(),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final project = controller.recentProjects[index];
                      return _ProjectCard(
                        project: project,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.editor,
                            arguments: {'projectId': project.id},
                          );
                        },
                        onDelete: () => controller.deleteProject(project.id),
                      );
                    },
                    childCount: controller.recentProjects.length,
                  ),
                ),
              ),

            // Tools Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Tools',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _ToolChip(
                          icon: Icons.crop,
                          label: 'Crop',
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.toolbox,
                            arguments: {'toolId': 'crop'},
                          ),
                        ),
                        _ToolChip(
                          icon: Icons.music_note,
                          label: 'Audio',
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.toolbox,
                            arguments: {'toolId': 'audio'},
                          ),
                        ),
                        _ToolChip(
                          icon: Icons.text_fields,
                          label: 'Text',
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.toolbox,
                            arguments: {'toolId': 'text'},
                          ),
                        ),
                        _ToolChip(
                          icon: Icons.color_lens,
                          label: 'Color',
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.toolbox,
                            arguments: {'toolId': 'color'},
                          ),
                        ),
                        _ToolChip(
                          icon: Icons.speed,
                          label: 'Speed',
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.toolbox,
                            arguments: {'toolId': 'speed'},
                          ),
                        ),
                        _ToolChip(
                          icon: Icons.subscriptions,
                          label: 'Subtitles',
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.toolbox,
                            arguments: {'toolId': 'subtitles'},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProjectCard({
    required this.project,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade200,
                child: project.thumbnailPath != null
                    ? Image.asset(project.thumbnailPath!, fit: BoxFit.cover)
                    : const Center(
                        child: Icon(
                          Icons.video_library_rounded,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          _formatDuration(project.duration),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: onDelete,
                          child: Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    final minutes = duration.inMinutes;
    final secs = duration.inSeconds % 60;
    return '${minutes}m ${secs}s';
  }
}

class _ToolChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ToolChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyProjectsView extends StatelessWidget {
  final VoidCallback onCreateProject;

  const _EmptyProjectsView({required this.onCreateProject});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No projects yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first video project',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onCreateProject,
            icon: const Icon(Icons.add),
            label: const Text('Create Project'),
          ),
        ],
      ),
    );
  }
}