import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_model.dart';
import '../users/users_model.dart';
import 'settings_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();
    final users = context.watch<UsersModel>();

    final cities = users.items.map((user) => user.address.city).toSet().toList()
      ..sort();

    final selected = settings.city;

    if (selected != null && !cities.contains(selected)) {
      cities.add(selected);
      cities.sort();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          SwitchListTile(
            title: const Text('Dark mode'),
            subtitle: const Text('Saved after restart'),
            value: settings.dark,
            secondary: const Icon(Icons.dark_mode_outlined),
            onChanged: (value) {
              unawaited(settings.setDark(value));
            },
          ),

          const Divider(),

          const SizedBox(height: 12),

          const Text(
            'City filter',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            key: ValueKey<String?>(selected),
            initialValue: selected,
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Show users from city',
            ),
            items: <DropdownMenuItem<String>>[
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All cities'),
              ),
              ...cities.map(
                (city) =>
                    DropdownMenuItem<String>(value: city, child: Text(city)),
              ),
            ],
            onChanged: (value) {
              unawaited(settings.setCity(value));
            },
          ),

          const SizedBox(height: 20),

          const Text(
            'Dark mode and city are stored '
            'in shared_preferences.',
          ),

          const Divider(height: 36),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            subtitle: const Text('Delete the saved secure token'),
            onTap: () async {
              try {
                await context.read<AuthModel>().logout();

                if (!context.mounted) {
                  return;
                }

                Navigator.of(context).popUntil((route) => route.isFirst);
              } catch (error) {
                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sign out failed: $error')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
