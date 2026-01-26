import 'package:flutter/material.dart';
import '../core/utils/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = ThemeProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(radius: 40),
          const SizedBox(height: 16),
          const Center(child: Text('Masaid Fairus Trimarsongko')),
          const Divider(height: 32),
          SwitchListTile(
            value: provider.isDark,
            onChanged: (_) => provider.toggleTheme(),
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              provider.logout();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Logged out')));
            },
          ),
        ],
      ),
    );
  }
}
