
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.person_outline,
                  size: 48,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'BookNest',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A personal book discovery application',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 28),
              const ListTile(
                leading: Icon(Icons.code),
                title: Text('Built with Flutter'),
              ),
              const ListTile(
                leading: Icon(Icons.cloud_outlined),
                title: Text('Open Library REST API'),
              ),
              const ListTile(
                leading: Icon(Icons.storage_outlined),
                title: Text('Supabase database integration'),
                subtitle: Text('Planned for the next development stage'),
              ),
              const Divider(height: 32),
              const Text(
                'Developed by I Ketut Guntur Putra Dangin',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text('NIM: 2415051056'),
            ],
          ),
        ),
      ),
    );
  }
}

