import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';

import '../profile/profile_screen.dart';
import '../settings/settings_model.dart';
import '../settings/settings_screen.dart';

import 'new_user_screen.dart';
import 'user.dart';
import 'user_detail_screen.dart';
import 'users_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UsersModel>();
    final city = context.watch<SettingsModel>().city;

    final filtered = city == null
        ? model.items
        : model.items.where((user) => user.address.city == city).toList();

    final Widget content;

    if (model.loading && model.items.isEmpty) {
      content = const LoadingView();
    } else {
      content = switch (model.error) {
        null => Column(
          children: <Widget>[
            if (model.fromCache)
              MaterialBanner(
                content: const Text('Saved data - no connection - Retry'),
                leading: const Icon(Icons.offline_bolt_outlined),
                actions: <Widget>[
                  TextButton(
                    onPressed: model.loading
                        ? null
                        : () {
                            unawaited(model.load());
                          },
                    child: const Text('Retry'),
                  ),
                ],
              ),

            if (model.loading) const LinearProgressIndicator(),

            Expanded(
              child: UserList(items: filtered, onRefresh: model.load),
            ),
          ],
        ),

        NoConnectionException() => OfflineView(onRetry: model.load),

        NotFoundException() => ErrorView(
          message: 'Users not found (404)',
          onRetry: model.load,
        ),

        UnauthorizedException() => ErrorView(
          message: 'Unauthorized (401)',
          onRetry: model.load,
        ),

        ServerException(:final status) => ErrorView(
          message: 'Server error ($status)',
          onRetry: model.load,
        ),

        BadResponseException(:final detail) => GenericErrorView(detail: detail),
      };
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(city == null ? 'Users' : 'Users - $city'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
              );
            },
          ),

          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),

      body: content,

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const NewUserScreen()),
          );
        },
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('New user'),
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(),

          SizedBox(height: 12),

          Text('Loading users...'),
        ],
      ),
    );
  }
}

class OfflineView extends StatelessWidget {
  const OfflineView({super.key, required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return _MessageView(
      icon: Icons.wifi_off,
      title: 'No connection',
      subtitle: 'No internet and no saved list. Try again.',
      onRetry: onRetry,
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return _MessageView(
      icon: Icons.error_outline,
      title: message,
      subtitle: 'Please try again.',
      onRetry: onRetry,
    );
  }
}

class GenericErrorView extends StatelessWidget {
  const GenericErrorView({super.key, this.detail});

  final String? detail;

  @override
  Widget build(BuildContext context) {
    return _MessageView(
      icon: Icons.warning_amber_outlined,
      title: 'Unexpected response',
      subtitle: detail ?? 'The server returned invalid data.',
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 58),

            const SizedBox(height: 12),

            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(subtitle, textAlign: TextAlign.center),

            if (onRetry != null) ...<Widget>[
              const SizedBox(height: 18),

              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  const UserList({super.key, required this.items, required this.onRefresh});

  final List<User> items;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: items.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const <Widget>[
                SizedBox(height: 160),
                Center(child: Text('No users in this city')),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),

              itemCount: items.length,

              separatorBuilder: (_, _) => const Divider(height: 1),

              itemBuilder: (context, index) {
                final user = items[index];

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(user.name.isEmpty ? '?' : user.name[0]),
                  ),

                  title: Text(user.name),

                  subtitle: Text(
                    '${user.email}\n'
                    '${user.address.city}',
                  ),

                  isThreeLine: true,

                  trailing: const Icon(Icons.chevron_right),

                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => UserDetailScreen(user: user),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
