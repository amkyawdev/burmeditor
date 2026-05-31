import 'package:flutter/material.dart';

import '../../app/constants.dart';
import '../../widgets/common/custom_app_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'About',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // App Logo
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.video_settings_rounded,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // App Name
          Center(
            child: Text(
              AppConstants.APP_NAME,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Version ${AppConstants.APP_VERSION}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Stable',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Description
          Text(
            'Professional Video Editor',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'Burme Editor is a powerful, user-friendly video editing application designed for creators of all levels. With 15 professional tools and an intuitive interface, you can transform your footage into stunning videos.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),

          // Features
          Text(
            'Features',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _FeatureItem(
            icon: Icons.crop,
            title: '15 Professional Tools',
            description: 'Crop, Audio, Color, Text, Title, and more',
          ),
          _FeatureItem(
            icon: Icons.language,
            title: 'Multi-language Support',
            description: 'English, Myanmar, Thai, Vietnamese, Russian',
          ),
          _FeatureItem(
            icon: Icons.speed,
            title: 'FFmpeg Powered',
            description: 'Fast and efficient video processing',
          ),
          _FeatureItem(
            icon: Icons.phone_android,
            title: 'Cross-platform',
            description: 'Android, iOS, and Web support',
          ),
          _FeatureItem(
            icon: Icons.cloud_upload,
            title: 'Cloud Sync',
            description: 'Access your projects anywhere',
          ),
          const SizedBox(height: 32),

          // Developer Info
          Text(
            'Developer',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Text(
                      'AM',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Aung Myo Kyaw',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Full Stack Developer',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Contact & Links
          Text(
            'Connect',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _LinkItem(
            icon: Icons.code,
            title: 'GitHub',
            subtitle: 'View source code',
            onTap: () {
              // TODO: Open GitHub
            },
          ),
          _LinkItem(
            icon: Icons.bug_report,
            title: 'Report Issues',
            subtitle: 'Help us improve',
            onTap: () {
              // TODO: Open issue tracker
            },
          ),
          _LinkItem(
            icon: Icons.star,
            title: 'Rate App',
            subtitle: 'Share your feedback',
            onTap: () {
              // TODO: Open app store
            },
          ),
          _LinkItem(
            icon: Icons.email,
            title: 'Contact Developer',
            subtitle: 'amkyawdev@example.com',
            onTap: () {
              // TODO: Open email
            },
          ),
          const SizedBox(height: 48),

          // Copyright
          Center(
            child: Column(
              children: [
                Text(
                  '© 2026 ${AppConstants.APP_NAME}',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                const SizedBox(height: 4),
                Text(
                  'Made with ❤️ for video creators',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LinkItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}