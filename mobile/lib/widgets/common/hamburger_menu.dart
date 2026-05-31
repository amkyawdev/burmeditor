import 'package:flutter/material.dart';

import '../../app/routes.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.video_settings_rounded,
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Burme Editor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Professional Video Editor',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          const SizedBox(height: 8),
          _MenuItem(
            icon: Icons.home_outlined,
            label: 'Home',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, Routes.home);
            },
          ),
          _MenuItem(
            icon: Icons.video_library_outlined,
            label: 'My Projects',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _MenuItem(
            icon: Icons.add_box_outlined,
            label: 'Create New',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          _MenuItem(
            icon: Icons.folder_outlined,
            label: 'Import Media',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _MenuItem(
            icon: Icons.save_outlined,
            label: 'Saved Drafts',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          _MenuItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.settings);
            },
          ),
          _MenuItem(
            icon: Icons.info_outline,
            label: 'About',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.about);
            },
          ),
          _MenuItem(
            icon: Icons.help_outline,
            label: 'Help & Support',
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Spacer(),

          // Footer
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade700),
      title: Text(label),
      onTap: onTap,
    );
  }
}